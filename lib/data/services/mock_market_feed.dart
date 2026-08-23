import 'dart:async';
import 'dart:math';

import '../../core/constants/stocks.dart';
import '../models/stock_tick.dart';

class MockMarketFeed {
  static const int tickIntervalMs = 200;

  final _random = Random();
  final Map<String, double> _prices = {};
  final Map<String, double> _previousClose = {};
  final Map<String, StreamController<StockTick>> _controllers = {};

  Timer? _timer;

  MockMarketFeed() {
    final startPrices = {
      'RELIANCE': 1314.00,
      'TCS': 2295.00,
      'INFY': 1119.00,
      'HDFCBANK': 729.00,
      'ICICIBANK': 1418.00,
      'SBIN': 1041.00,
      'ITC': 269.55,
      'LT': 4087.50,
      'BHARTIARTL': 1946.80,
      'AXISBANK': 1245.50,
    };

    for (final symbol in stockSymbols) {
      _prices[symbol] = startPrices[symbol]!;
      _previousClose[symbol] = startPrices[symbol]!;

      _controllers[symbol] = StreamController<StockTick>.broadcast();

      _controllers[symbol]!.add(
        StockTick(
          symbol: symbol,
          ltp: _prices[symbol]!,
          previousClose: _previousClose[symbol]!,
        ),
      );
    }

    _timer = Timer.periodic(
      const Duration(milliseconds: tickIntervalMs),
          (_) {
        if (isMarketOpen()) {
          _emitRandomTick();
        }
      },
    );
  }

  bool isMarketOpen() {
    final now = DateTime.now();

    // final isWeekend =
    //     now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    //
    // if (isWeekend) return false;

    final marketOpen = DateTime(now.year, now.month, now.day, 9, 15);
    final marketClose = DateTime(now.year, now.month, now.day, 15, 30);

    return now.isAfter(marketOpen) && now.isBefore(marketClose);
  }

  String marketStatusMessage() {
    return isMarketOpen()
        ? 'Market is open'
        : 'Market is closed today. Please check tomorrow.';
  }

  Stream<StockTick> streamFor(String symbol) {
    return _controllers[symbol]!.stream;
  }

  StockTick currentTick(String symbol) {
    return StockTick(
      symbol: symbol,
      ltp: _prices[symbol]!,
      previousClose: _previousClose[symbol]!,
    );
  }

  void _emitRandomTick() {
    final symbol = stockSymbols[_random.nextInt(stockSymbols.length)];
    final oldPrice = _prices[symbol]!;

    final movementPercent = (_random.nextDouble() - 0.5) * 0.004;
    final newPrice = oldPrice + (oldPrice * movementPercent);

    _prices[symbol] = double.parse(newPrice.toStringAsFixed(2));

    _controllers[symbol]!.add(
      StockTick(
        symbol: symbol,
        ltp: _prices[symbol]!,
        previousClose: _previousClose[symbol]!,
      ),
    );
  }

  void dispose() {
    _timer?.cancel();

    for (final controller in _controllers.values) {
      controller.close();
    }
  }
}