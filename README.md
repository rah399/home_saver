# Home Aver App

## Overview
Home Aver is a smart home automation app that allows users to control IoT devices, manage schedules, and monitor home security remotely.

## Features
- Device control (Lights, Thermostats, Cameras, etc.)
- Voice command integration
- Scheduling and automation
- Security monitoring and alerts
- User authentication and multi-user support

## Tech Stack
- **Frontend:** React, Tailwind CSS
- **Backend:** Node.js, Express.js
- **Database:** Firebase / MongoDB
- **Authentication:** Firebase Auth / OAuth
- **IoT Integration:** MQTT, WebSockets

## Installation

### Prerequisites
- Node.js & npm installed
- Firebase or MongoDB setup

### Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/home-aver.git
   cd home-aver
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Setup environment variables:
   Create a `.env` file in the root directory and add:
   ```env
   REACT_APP_FIREBASE_API_KEY=your_api_key
   REACT_APP_FIREBASE_AUTH_DOMAIN=your_auth_domain
   REACT_APP_FIREBASE_PROJECT_ID=your_project_id
   ```
4. Start the development server:
   ```sh
   npm start
   ```

## Usage
- Register/Login to access the dashboard
- Add smart devices from the settings
- Configure schedules and automation
- Monitor security alerts in real-time

## Deployment
To deploy on Firebase Hosting or Vercel:
```sh
npm run build
firebase deploy
```
OR
```sh
vercel --prod
```

## Contributing
1. Fork the repo
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature-name`)
5. Open a Pull Request

## License
This project is licensed under the MIT License.

---
Happy coding! 🚀
