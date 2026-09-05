<div align="center">

# Subject Library

**A Flutter study-notes application backed by a small REST API.**

<img src="https://img.shields.io/badge/Cross--platform_learning_project-4F86FF?style=flat-square&labelColor=0B1224" alt="Cross-platform learning project" /> <img src="https://img.shields.io/badge/Public_repository-4F86FF?style=flat-square&labelColor=0B1224" alt="Public repository" />

[Portfolio](https://kavindudamsith.tech/) &nbsp;|&nbsp; [LinkedIn](https://www.linkedin.com/in/kavindu-damsith-86696722a/) &nbsp;|&nbsp; [Email](mailto:kavindudamsith65@gmail.com)

</div>

---

## Overview

Subject Library organises study material as authenticated user notes and subject-oriented content. The repository contains a cross-platform Flutter client plus a Node.js and MongoDB backend for accounts and note persistence.

## What it does

| Area | Details |
| --- | --- |
| **Cross-platform client** | Flutter targets Android, iOS, web, Windows, macOS, and Linux. |
| **Authentication** | Registration, login, JWT handling, and protected requests. |
| **Notes** | Create and manage user-owned study notes through a REST API. |
| **Persistence** | MongoDB models for users and note content. |

## Repository map

| Path | Purpose |
| --- | --- |
| `lib/` | Flutter screens, widgets, models, services, and application entry point. |
| `backend/controllers/` | Authentication and note behaviour. |
| `backend/models/` | MongoDB user and note schemas. |
| `backend/routes/` | Authentication and note endpoints. |
| `android/, ios/, web/, windows/, macos/, linux/` | Flutter platform projects. |

## Technology

- **Flutter**
- **Dart**
- **Node.js**
- **Express**
- **MongoDB**
- **JWT**

## Local setup

```bash
cd backend && npm install
npm run dev
# In another terminal from the repository root
flutter pub get
flutter run
```

### Configuration notes

Configure the backend MongoDB connection and JWT secret, then point the Flutter API service at your local backend.

## Status

Cross-platform learning project.

---

Questions about this repository? [Email me](mailto:kavindudamsith65@gmail.com) or connect on [LinkedIn](https://www.linkedin.com/in/kavindu-damsith-86696722a/).
