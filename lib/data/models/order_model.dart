class OrderModel {
  final String id;
  final String symbol;
  final String side;
  final int quantity;
  final double price;
  final double value;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.value,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'side': side,
    'quantity': quantity,
    'price': price,
    'value': value,
    'createdAt': createdAt.toIso8601String(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      symbol: json['symbol'],
      side: json['side'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
