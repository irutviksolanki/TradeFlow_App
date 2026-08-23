class StockTick {
  final String symbol;
  final double ltp;
  final double previousClose;
  final DateTime time;
  final double change;
  final double changePercent;
  final bool isUp;

  StockTick({
    required this.symbol,
    required this.ltp,
    required this.previousClose,
    DateTime? time,
  })  : time = time ?? DateTime.now(),
        change = ltp - previousClose,
        changePercent = ((ltp - previousClose) / previousClose) * 100,
        isUp = ltp >= previousClose;
}