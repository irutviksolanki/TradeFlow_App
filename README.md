# 📈 TradeFlow

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-success">
  <img src="https://img.shields.io/badge/State%20Management-Riverpod-orange">
  <img src="https://img.shields.io/badge/Database-Hive-yellow">
</p>

TradeFlow is a **Flutter-based stock trading simulator** developed for the **021 Trading App Flutter Assignment**.

The application simulates a real-time stock trading experience using a **mock market feed**, allowing users to create watchlists, monitor live stock prices, execute simulated buy/sell orders, and track portfolio performance.

> **Note:** This application is built for learning and evaluation purposes. It does not connect to any real stock exchange or execute real financial transactions.

---

# ✨ Features

## 🔐 Authentication

- Splash Screen
- Login using Password
- Login using OTP (Demo)
- Continue with Google (Mock)
- Continue with Facebook (Mock)
- Persistent Login using Hive
- Logout

---

## 📊 Live Market

- Live simulated market feed
- 10 predefined NSE stocks
- Real-time LTP updates
- Live price movement animation
- Price Change & Change %
- Interactive stock charts
- Stock Details screen
- Market Open / Market Closed logic

### Market Hours

- Monday – Friday
- 09:15 AM – 03:30 PM IST

---

## ⭐ Watchlists

- Create multiple watchlists
- Rename watchlists
- Delete watchlists
- Add stocks
- Remove stocks
- Drag & Drop stock ordering
- Live synchronized prices
- Persistent storage using Hive

---

## 📈 Stock Details

- Interactive stock chart
- Live LTP
- Previous Close
- Open
- High
- Low
- Market statistics
- Quick Buy / Sell actions

---

## 💰 Buy & Sell Orders

- Buy stocks
- Sell stocks
- Live order value calculation
- Wallet balance validation
- Quantity validation
- Holdings validation
- Order confirmation screen

---

## 💼 Portfolio

- Live Holdings
- Live Portfolio Value
- Live Profit & Loss
- Invested Amount
- Current Value
- Average Cost
- Quantity Held

### Sorting

- P&L
- Symbol
- Current Value

---

## 🎨 User Interface

- Material 3 Design
- Light Theme
- Dark Theme
- Theme Persistence
- Navigation Drawer
- Responsive Layout
- Smooth Animations

---

# 📦 Available Stocks

The application currently includes the following NSE stocks:

- RELIANCE
- TCS
- INFY
- HDFCBANK
- ICICIBANK
- SBIN
- ITC
- LT
- BHARTIARTL
- AXISBANK

---

# 🛠 Tech Stack

| Technology | Usage |
|------------|------|
| Flutter | Cross-platform Development |
| Dart | Programming Language |
| Riverpod | State Management |
| Hive | Local Database |
| FL Chart | Interactive Charts |
| Material 3 | UI Design |

---

# 📂 Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── data/
│   ├── models/
│   └── services/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── holdings/
│   ├── market/
│   ├── ticket/
│   └── watchlist/
│
├── providers/
│
└── main.dart
```

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- Android Emulator / Physical Device
- Xcode (for iOS)

Verify Flutter installation:

```bash
flutter doctor
```

---

## Clone Repository

```bash
git clone https://github.com/irutviksolanki/TradeFlow_App.git
```

Move into the project:

```bash
cd TradeFlow_App
```

Install dependencies:

```bash
flutter pub get
```

Run the project:

```bash
flutter run
```

---

# 💾 Local Persistence

TradeFlow uses **Hive** to store application data locally.

Persisted data includes:

- User Login
- Theme Preference
- Watchlists
- Holdings
- Wallet Balance
- Order History

All important application data remains available after restarting the application.

---

# 📱 Supported Platforms

- ✅ Android
- ✅ iOS

---

# 📸 Application Screens

- Splash Screen
- Login Screen
- OTP Login
- Market Dashboard
- Stock Details
- Watchlists
- Buy/Sell Screen
- Holdings
- Portfolio
- Order Confirmation
- Navigation Drawer
- Profile Dialog

---

# 📋 Assignment Coverage

| Feature | Status |
|----------|--------|
| Authentication | ✅ |
| Live Market Feed | ✅ |
| Multiple Watchlists | ✅ |
| Buy / Sell Orders | ✅ |
| Portfolio | ✅ |
| Holdings | ✅ |
| Live P&L | ✅ |
| Interactive Charts | ✅ |
| Market Open / Close Logic | ✅ |
| Theme Switching | ✅ |
| Local Persistence | ✅ |
| Responsive UI | ✅ |

---

# 🎥 App Walkthrough

A complete walkthrough video demonstrating the application's features is available on Google Drive.

## ▶️ Watch the Demo

**Google Drive Video**

https://drive.google.com/file/d/1x7ssjr9amW_9eBg9ldi1T54R02TkY_r-/view?usp=drivesdk

The walkthrough covers:

- Authentication Flow
- Live Market Dashboard
- Real-time Price Simulation
- Stock Details
- Interactive Charts
- Watchlist Management
- Buy/Sell Order Execution
- Wallet Validation
- Holdings & Portfolio
- Live P&L Updates
- Theme Switching
- Navigation
- Local Data Persistence

---

# 🔄 Application Flow

```text
Splash Screen
      │
      ▼
Authentication
      │
      ▼
Market Dashboard
      │
 ┌────┼──────────────┐
 ▼    ▼              ▼
Watchlist      Stock Details      Holdings
 │                 │                 │
 ▼                 ▼                 ▼
Manage         Buy / Sell       Portfolio
Stocks         Orders           Performance
 │                 │
 ▼                 ▼
Live Prices   Confirmation
      │
      ▼
Local Persistence
```

---

# 🧪 Mock Trading Environment

TradeFlow is a simulated trading platform created for assignment and demonstration purposes.

- No real stock exchange integration
- No real money involved
- No live trading
- Prices are generated using a mock market engine

---

# 👨‍💻 Author

**Rutvik Solanki**

Flutter Developer

🔗 GitHub: https://github.com/irutviksolanki

---

# 📄 License

This project was developed as part of the **021 Trading App Flutter Assignment** for evaluation purposes.
