class Holding {
  final String symbol;
  final int quantity;
  final double avgCost;

  Holding({
    required this.symbol,
    required this.quantity,
    required this.avgCost,
  });

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'quantity': quantity,
    'avgCost': avgCost,
  };

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'],
      quantity: json['quantity'],
      avgCost: (json['avgCost'] as num).toDouble(),
    );
  }

  Holding copyWith({
    String? symbol,
    int? quantity,
    double? avgCost,
  }) {
    return Holding(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      avgCost: avgCost ?? this.avgCost,
    );
  }
}