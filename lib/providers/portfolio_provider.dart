import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../data/models/holding.dart';
import '../data/models/order_model.dart';

final portfolioProvider =
StateNotifierProvider<PortfolioNotifier, PortfolioState>((ref) {
  return PortfolioNotifier();
});

class PortfolioState {
  final double balance;
  final List<Holding> holdings;
  final List<OrderModel> orders;

  PortfolioState({
    required this.balance,
    required this.holdings,
    required this.orders,
  });

  PortfolioState copyWith({
    double? balance,
    List<Holding>? holdings,
    List<OrderModel>? orders,
  }) {
    return PortfolioState(
      balance: balance ?? this.balance,
      holdings: holdings ?? this.holdings,
      orders: orders ?? this.orders,
    );
  }
}

class PortfolioNotifier extends StateNotifier<PortfolioState> {
  PortfolioNotifier()
      : super(
    PortfolioState(
      balance: 1000000.00,
      holdings: [],
      orders: [],
    ),
  ) {
    _load();
  }

  final _box = Hive.box('tradeflow_box');
  final _uuid = const Uuid();

  void _load() {
    final savedBalance = _box.get('wallet_balance');
    final savedHoldings = _box.get('holdings');
    final savedOrders = _box.get('orders');

    state = PortfolioState(
      balance: savedBalance == null
          ? 1000000.00
          : (savedBalance as num).toDouble(),
      holdings: savedHoldings == null
          ? []
          : List<Map>.from(savedHoldings)
          .map((e) => Holding.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      orders: savedOrders == null
          ? []
          : List<Map>.from(savedOrders)
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  void _save() {
    _box.put('wallet_balance', state.balance);
    _box.put(
      'holdings',
      state.holdings.map((e) => e.toJson()).toList(),
    );
    _box.put(
      'orders',
      state.orders.map((e) => e.toJson()).toList(),
    );
  }

  String? placeOrder({
    required String symbol,
    required String side,
    required int quantity,
    required double price,
  }) {
    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }

    final orderValue = quantity * price;

    if (side == 'Buy') {
      if (orderValue > state.balance) {
        return 'Insufficient balance';
      }

      _buy(
        symbol: symbol,
        quantity: quantity,
        price: price,
        orderValue: orderValue,
      );
    } else {
      final holding = getHolding(symbol);

      if (holding == null || holding.quantity < quantity) {
        return 'Insufficient quantity to sell';
      }

      _sell(
        symbol: symbol,
        quantity: quantity,
        price: price,
        orderValue: orderValue,
      );
    }

    _addOrder(
      symbol: symbol,
      side: side,
      quantity: quantity,
      price: price,
      value: orderValue,
    );

    _save();
    return null;
  }

  Holding? getHolding(String symbol) {
    try {
      return state.holdings.firstWhere((e) => e.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  void _buy({
    required String symbol,
    required int quantity,
    required double price,
    required double orderValue,
  }) {
    final existing = getHolding(symbol);

    List<Holding> updatedHoldings;

    if (existing == null) {
      updatedHoldings = [
        ...state.holdings,
        Holding(
          symbol: symbol,
          quantity: quantity,
          avgCost: price,
        ),
      ];
    } else {
      final oldValue = existing.quantity * existing.avgCost;
      final newValue = quantity * price;
      final totalQty = existing.quantity + quantity;
      final newAvgCost = (oldValue + newValue) / totalQty;

      updatedHoldings = [
        for (final item in state.holdings)
          if (item.symbol == symbol)
            item.copyWith(
              quantity: totalQty,
              avgCost: newAvgCost,
            )
          else
            item,
      ];
    }

    state = state.copyWith(
      balance: state.balance - orderValue,
      holdings: updatedHoldings,
    );
  }

  void _sell({
    required String symbol,
    required int quantity,
    required double price,
    required double orderValue,
  }) {
    final existing = getHolding(symbol)!;
    final remainingQty = existing.quantity - quantity;

    final updatedHoldings = remainingQty == 0
        ? state.holdings.where((e) => e.symbol != symbol).toList()
        : [
      for (final item in state.holdings)
        if (item.symbol == symbol)
          item.copyWith(quantity: remainingQty)
        else
          item,
    ];

    state = state.copyWith(
      balance: state.balance + orderValue,
      holdings: updatedHoldings,
    );
  }

  void _addOrder({
    required String symbol,
    required String side,
    required int quantity,
    required double price,
    required double value,
  }) {
    final order = OrderModel(
      id: _uuid.v4(),
      symbol: symbol,
      side: side,
      quantity: quantity,
      price: price,
      value: value,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      orders: [order, ...state.orders],
    );
  }
}