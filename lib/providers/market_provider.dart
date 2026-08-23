import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/stock_tick.dart';
import '../data/services/mock_market_feed.dart';

final marketFeedProvider = Provider<MockMarketFeed>((ref) {
  final feed = MockMarketFeed();
  ref.onDispose(feed.dispose);
  return feed;
});

final stockTickProvider =
StreamProvider.family<StockTick, String>((ref, symbol) {
  final feed = ref.watch(marketFeedProvider);
  return feed.streamFor(symbol);
});