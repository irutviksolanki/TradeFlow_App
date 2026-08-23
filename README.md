# 📈 TradeFlow

TradeFlow is a Flutter-based stock trading simulator developed for the **021 Trading App Flutter Assignment**. The application simulates a real-time trading experience with live market data, customizable watchlists, portfolio management, and buy/sell order execution using a mock market feed.

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
- Price Change & Change %
- Green/Red flash animation on price updates
- Interactive stock chart
- Stock Detail screen
- Market Open / Market Closed logic
- Market Hours:
    - Monday – Friday
    - 09:15 AM – 03:30 PM (IST)

---

## ⭐ Watchlists
- Create Multiple Watchlists
- Rename Watchlists
- Delete Watchlists
- Add Stocks
- Remove Stocks
- Drag & Drop Reordering
- Live price synchronization
- Persistent Watchlists

---

## 📈 Stock Details
- Interactive price chart
- Live LTP
- Previous Close
- Open / High / Low
- Market Statistics
- Buy/Sell Shortcut

---

## 💰 Buy / Sell Orders
- Live price updates
- Buy Orders
- Sell Orders
- Wallet Balance Validation
- Quantity Validation
- Holdings Validation
- Live Order Value Calculation
- Order Confirmation Screen

---

## 💼 Portfolio / Holdings
- Live Holdings
- Live Portfolio P&L
- Total Invested
- Current Portfolio Value
- Profit & Loss (₹ & %)
- Average Cost
- Quantity Held
- Sorting:
  - P&L
  - Symbol
  - Current Value

---

## 🎨 User Interface
- Material 3 Design
- Light Theme
- Dark Theme
- Theme Persistence
- Side Navigation Drawer
- Responsive UI
- Smooth Animations

---

# 📦 Stocks Included

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

- Flutter (Stable)
- Dart
- Riverpod
- Hive
- FL Chart
- Material 3

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

Clone the repository

```bash
git clone https://github.com/irutviksolanki/TradeFlow_App.git
```

Move into the project

```bash
cd tradeflow
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 💾 Persistent Data

The following data is stored locally using **Hive**:

- User Login
- Theme Preference
- Watchlists
- Holdings
- Wallet Balance
- Order History

---

# 📱 Supported Platforms

- ✅ Android
- ✅ iOS

---

# 📸 Application Screens

- Splash Screen
- Login Screen
- Market Dashboard
- Watchlists
- Stock Detail
- Buy/Sell Ticket
- Holdings
- Order Confirmation
- Navigation Drawer
- Profile Dialog

---

# 📋 Assignment Coverage

| Feature | Status |
|---------|:------:|
| Live Market Feed | ✅ |
| Multiple Watchlists | ✅ |
| Buy / Sell Ticket | ✅ |
| Portfolio / Holdings | ✅ |
| Live P&L | ✅ |
| Market Open / Close Logic | ✅ |
| Interactive Stock Chart | ✅ |
| Theme Switching | ✅ |
| Authentication Flow | ✅ |
| Local Persistence | ✅ |
| Responsive UI | ✅ |

---

# 📹 Walkthrough

A complete walkthrough video demonstrating all implemented features is included with the submission.

---

# 👨‍💻 Author

**Rutvik Solanki**

Flutter Developer

GitHub: https://github.com/irutviksolanki

---

# 📄 License

This project was developed as part of the **021 Trading App Flutter Assignment** for evaluation purposes.