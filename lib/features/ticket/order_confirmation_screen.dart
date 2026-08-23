import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String symbol;
  final String side;
  final int quantity;
  final double price;
  final double value;

  const OrderConfirmationScreen({
    super.key,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = side == 'Buy';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 70,
                  color: isBuy ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  '$side Order Successful',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                _RowText(title: 'Symbol', value: symbol),
                _RowText(title: 'Quantity', value: '$quantity'),
                _RowText(title: 'Price', value: '₹${price.toStringAsFixed(2)}'),
                _RowText(title: 'Value', value: '₹${value.toStringAsFixed(2)}'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final String title;
  final String value;

  const _RowText({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}