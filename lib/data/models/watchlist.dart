class Watchlist {
  final String id;
  final String name;
  final List<String> symbols;

  Watchlist({
    required this.id,
    required this.name,
    required this.symbols,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'symbols': symbols,
  };

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'],
      name: json['name'],
      symbols: List<String>.from(json['symbols'] ?? []),
    );
  }

  Watchlist copyWith({
    String? id,
    String? name,
    List<String>? symbols,
  }) {
    return Watchlist(
      id: id ?? this.id,
      name: name ?? this.name,
      symbols: symbols ?? this.symbols,
    );
  }
}