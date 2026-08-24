# 📈 TradeFlow
TradeFlow is a Flutter-based stock trading simulator developed for the **021 Trading App Flutter Assignment**.
The application simulates a real-time stock trading experience with a live mock market feed, customizable watchlists, portfolio management, and buy/sell order execution.
---
## ✨ Features
### 🔐 Authentication
- Splash Screen
- Login using Password
- Login using OTP (Demo)
- Continue with Google (Mock)
- Continue with Facebook (Mock)
- Persistent Login using Hive
- Logout
---
### 📊 Live Market
- Live simulated market feed
- 10 predefined NSE stocks
- Real-time LTP updates
- Price Change & Change %
- Green/Red flash animation on price updates
- Interactive stock chart
- Stock Detail screen
- Market Open / Market Closed logic
#### Market Hours
- Monday – Friday
- 09:15 AM – 03:30 PM IST
---
### ⭐ Watchlists
- Create multiple watchlists
- Rename watchlists
- Delete watchlists
- Add stocks
- Remove stocks
- Drag & drop stock reordering
- Live price synchronization
- Persistent watchlists
---
### 📈 Stock Details
- Interactive price chart
- Live LTP
- Previous Close
- Open / High / Low
- Market statistics
- Buy/Sell shortcuts
---
### 💰 Buy / Sell Orders
- Live price updates
- Buy orders
- Sell orders
- Wallet balance validation
- Quantity validation
- Holdings validation
- Live order value calculation
- Order confirmation screen
---
### 💼 Portfolio / Holdings
- Live holdings
- Live portfolio P&L
- Total invested amount
- Current portfolio value
- Profit & Loss in ₹ and %
- Average cost
- Quantity held
#### Portfolio Sorting
- P&L
- Symbol
- Current Value
---
### 🎨 User Interface
- Material 3 Design
- Light Theme
- Dark Theme
- Theme persistence
- Side Navigation Drawer
- Responsive UI
- Smooth animations
---
## 📦 Stocks Included
The application includes the following 10 predefined NSE stocks:
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
## 🛠 Tech Stack
- **Flutter** – Cross-platform application development
- **Dart** – Programming language
- **Riverpod** – State management
- **Hive** – Local data persistence
- **FL Chart** – Interactive charts
- **Material 3** – UI and theming
---
## 📂 Project Structure
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

⸻

🚀 Getting Started

Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio / Xcode
* Android or iOS device/emulator

You can verify your Flutter installation using:

flutter doctor

⸻

Clone the Repository

git clone https://github.com/irutviksolanki/TradeFlow_App.git

Move into the Project

cd TradeFlow_App

Install Dependencies

flutter pub get

Run the Application

flutter run

⸻

💾 Persistent Data

The application uses Hive for local data persistence.

The following data is stored locally:

* User Login
* Theme Preference
* Watchlists
* Holdings
* Wallet Balance
* Order History

This allows important application data to remain available even after restarting the application.

⸻

📱 Supported Platforms

* ✅ Android
* ✅ iOS

⸻

📸 Application Screens

The application includes the following screens and flows:

* Splash Screen
* Login Screen
* Market Dashboard
* Watchlists
* Stock Detail
* Buy/Sell Ticket
* Holdings
* Order Confirmation
* Navigation Drawer
* Profile Dialog

⸻

📋 Assignment Coverage

Feature	Status
Live Market Feed	✅
Multiple Watchlists	✅
Buy / Sell Ticket	✅
Portfolio / Holdings	✅
Live P&L	✅
Market Open / Close Logic	✅
Interactive Stock Chart	✅
Theme Switching	✅
Authentication Flow	✅
Local Persistence	✅
Responsive UI	✅

⸻

📹 App Walkthrough

A complete walkthrough video is provided to demonstrate how the application works and to showcase the implemented features.

🎥 Watch the App Walkthrough

▶️ View TradeFlow App Walkthrough⁠￼

The walkthrough demonstrates:

* Authentication flow
* Market dashboard
* Live simulated stock prices
* Watchlist management
* Stock details and charts
* Buy/Sell order flow
* Wallet validation
* Holdings and portfolio P&L
* Theme switching
* Navigation
* Local persistence

⸻

🔄 Application Flow

Splash Screen
      ↓
Authentication
      ↓
Market Dashboard
      ↓
 ┌───────────────┬────────────────┐
 ↓               ↓                ↓
Watchlist     Stock Details    Holdings
 ↓               ↓                ↓
Add/Remove     Buy / Sell       Portfolio
Stocks         Order Ticket     P&L
 ↓               ↓
Live Prices    Confirmation
      ↓
Local Persistence

⸻

🧪 Mock Trading Environment

TradeFlow is a stock trading simulator created for assignment and demonstration purposes.

It does not connect to a real stock exchange or execute real financial transactions.

The market prices are generated using a mock market feed to simulate live price movements and trading scenarios.

⸻

👨‍💻 Author

Rutvik Solanki

Flutter Developer

GitHub: github.com/irutviksolanki⁠￼

⸻

📄 License

This project was developed as part of the 021 Trading App Flutter Assignment for evaluation purposes.