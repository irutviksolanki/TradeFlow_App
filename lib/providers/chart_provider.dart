import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/stock_tick.dart';
import 'market_provider.dart';

final stockHistoryProvider =
StateNotifierProvider.family<StockHistoryNotifier, List<StockTick>, String>(
      (ref, symbol) {
    final notifier = StockHistoryNotifier();

    ref.listen(stockTickProvider(symbol), (previous, next) {
      next.whenData((tick) {
        notifier.addTick(tick);
      });
    });

    return notifier;
  },
);

class StockHistoryNotifier extends StateNotifier<List<StockTick>> {
  StockHistoryNotifier() : super([]);

  static const int maxPoints = 40;

  void addTick(StockTick tick) {
    final updated = [...state, tick];

    if (updated.length > maxPoints) {
      state = updated.sublist(updated.length - maxPoints);
    } else {
      state = updated;
    }
  }
}