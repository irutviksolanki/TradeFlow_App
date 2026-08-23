import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../data/models/watchlist.dart';

final watchlistProvider =
StateNotifierProvider<WatchlistNotifier, List<Watchlist>>((ref) {
  return WatchlistNotifier();
});

class WatchlistNotifier extends StateNotifier<List<Watchlist>> {
  WatchlistNotifier() : super([]) {
    _load();
  }

  final _box = Hive.box('tradeflow_box');
  final _uuid = const Uuid();

  void _load() {
    final rawList = _box.get('watchlists');

    if (rawList == null) {
      final defaultList = Watchlist(
        id: _uuid.v4(),
        name: 'My Watchlist',
        symbols: [],
      );

      state = [defaultList];
      _save();
      return;
    }

    state = List<Map>.from(rawList)
        .map((e) => Watchlist.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void _save() {
    _box.put(
      'watchlists',
      state.map((e) => e.toJson()).toList(),
    );
  }

  void createWatchlist(String name) {
    state = [
      ...state,
      Watchlist(
        id: _uuid.v4(),
        name: name,
        symbols: [],
      ),
    ];
    _save();
  }

  void renameWatchlist(String id, String name) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(name: name) else item,
    ];
    _save();
  }

  void deleteWatchlist(String id) {
    state = state.where((item) => item.id != id).toList();

    if (state.isEmpty) {
      createWatchlist('My Watchlist');
    } else {
      _save();
    }
  }

  void addStock(String watchlistId, String symbol) {
    state = [
      for (final item in state)
        if (item.id == watchlistId && !item.symbols.contains(symbol))
          item.copyWith(symbols: [...item.symbols, symbol])
        else
          item,
    ];
    _save();
  }

  void removeStock(String watchlistId, String symbol) {
    state = [
      for (final item in state)
        if (item.id == watchlistId)
          item.copyWith(
            symbols: item.symbols.where((e) => e != symbol).toList(),
          )
        else
          item,
    ];
    _save();
  }

  void reorderStock(String watchlistId, int oldIndex, int newIndex) {
    state = [
      for (final item in state)
        if (item.id == watchlistId)
          item.copyWith(
            symbols: _reorderedList(item.symbols, oldIndex, newIndex),
          )
        else
          item,
    ];
    _save();
  }

  List<String> _reorderedList(List<String> symbols, int oldIndex, int newIndex) {
    final updated = [...symbols];

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    return updated;
  }
}