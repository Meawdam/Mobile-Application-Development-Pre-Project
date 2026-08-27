# Mobile Application Development - Week 3

A simple **Dart TODO Console Application** developed for the Mobile Application Development course.

This project consists of a Dart frontend application and a JSON Server backend. The frontend communicates with the backend through a REST API, while task data is stored in `db.json`.

## How to Clone and Run

### Requirements

Make sure the following are installed:

* Git
* Dart SDK
* Node.js
* npm

Check your installations:

```bash
git --version
dart --version
node --version
npm --version
```

### 1. Clone the Repository

```bash
git clone https://github.com/Meawdam/Mobile-Application-Development-Pre-Project.git
cd Mobile-Application-Development-Pre-Project
```

### 2. Setup the Backend

Open a terminal and run:

```bash
cd backend
npm install
npx json-server db.json
```

The backend will run at:

```text
http://localhost:3000
```

The TODO API is available at:

```text
http://localhost:3000/todo
```

**Keep this terminal running.**

### 3. Setup the Frontend

Open a **new terminal** and run:

```bash
cd frontend
dart pub get
dart run
```

Alternatively:

```bash
dart run bin/frontend.dart
```

### Quick Setup

If you have already cloned the repository, you can run the project using two terminals.

**Terminal 1 - Backend**

```bash
cd backend
npm install
npx json-server db.json
```

**Terminal 2 - Frontend**

```bash
cd frontend
dart pub get
dart run
```

Both terminals need to remain open while using the application.