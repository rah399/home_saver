import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'total_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedName;
  String searchQuery = "";

  double _calculateTotal(List<QueryDocumentSnapshot> docs) {
    double total = 0.0;
    for (var doc in docs) {
      total += double.tryParse(doc['amount'].toString()) ?? 0.0;
    }
    return total;
  }

  void _openInputDialog({DocumentSnapshot? itemToEdit}) {
    TextEditingController amountController = TextEditingController(
        text: itemToEdit != null ? itemToEdit['amount'] : '');
    DateTime? selectedDate = itemToEdit != null
        ? DateFormat.yMMMd().parse(itemToEdit['date'])
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(itemToEdit != null ? 'Edit Entry' : 'Add New Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedName ?? itemToEdit?['name'],
                hint: Text('Select Name'),
                onChanged: (newValue) {
                  setState(() {
                    selectedName = newValue;
                  });
                },
                items: [
                  'Rahul',
                  'Mageshwarie',
                  'Raghu',
                  'Ramakrishnam',
                  'Nanushiya',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedDate == null
                      ? 'Select Date'
                      : DateFormat.yMMMd().format(selectedDate!)),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedName != null &&
                    amountController.text.isNotEmpty &&
                    selectedDate != null) {
                  if (itemToEdit != null) {
                    await _firestore
                        .collection('transactions')
                        .doc(itemToEdit.id)
                        .update({
                      'name': selectedName,
                      'amount': amountController.text,
                      'date': DateFormat.yMMMd().format(selectedDate!),
                    });
                  } else {
                    await _firestore.collection('transactions').add({
                      'name': selectedName,
                      'amount': amountController.text,
                      'date': DateFormat.yMMMd().format(selectedDate!),
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(itemToEdit != null ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String docId) async {
    await _firestore.collection('transactions').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('transactions').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var docs = snapshot.data!.docs.where((doc) {
                  String name = doc['name'].toString().toLowerCase();
                  String amount = doc['amount'].toString().toLowerCase();
                  return name.contains(searchQuery) ||
                      amount.contains(searchQuery);
                }).toList();

                double totalAmount = _calculateTotal(docs);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Map<String, double> nameTotals = {};

                              for (var doc in docs) {
                                String name = doc['name'];
                                double amount =
                                    double.tryParse(doc['amount'].toString()) ??
                                        0.0;
                                if (nameTotals.containsKey(name)) {
                                  nameTotals[name] = nameTotals[name]! + amount;
                                } else {
                                  nameTotals[name] = amount;
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TotalScreen(nameTotals: nameTotals),
                                ),
                              );
                            },
                            child: Text("View Totals"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var doc = docs[index];
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(doc['name']),
                            subtitle: Text(
                                'Amount: \$${doc['amount']} | Date: ${doc['date']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _openInputDialog(itemToEdit: doc);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteItem(doc.id);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openInputDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 0, 247, 255),
        shape: CircleBorder(),
      ),
    );
  }
}
