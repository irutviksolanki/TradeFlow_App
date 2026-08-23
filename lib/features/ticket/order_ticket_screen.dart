import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/market_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../market/widgets/stock_chart.dart';
import 'order_confirmation_screen.dart';

class OrderTicketScreen extends ConsumerStatefulWidget {
  final String symbol;

  const OrderTicketScreen({super.key, required this.symbol});

  @override
  ConsumerState<OrderTicketScreen> createState() => _OrderTicketScreenState();
}

class _OrderTicketScreenState extends ConsumerState<OrderTicketScreen> {
  final quantityController = TextEditingController();
  String side = 'Buy';
  String? errorText;

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tickAsync = ref.watch(stockTickProvider(widget.symbol));
    final portfolio = ref.watch(portfolioProvider);

    return Scaffold(
      appBar: AppBar(title: Text('${side.toUpperCase()} ${widget.symbol}')),
      body: tickAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load price')),
        data: (tick) {
          final qty = int.tryParse(quantityController.text.trim()) ?? 0;
          final orderValue = qty * tick.ltp;
          final holding = ref
              .read(portfolioProvider.notifier)
              .getHolding(widget.symbol);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '₹${tick.ltp.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: (tick.change >= 0 ? Colors.green : Colors.red)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${tick.change >= 0 ? '↑' : '↓'} ${tick.changePercent.abs().toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: tick.change >= 0 ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${tick.change >= 0 ? '+' : ''}${tick.change.toStringAsFixed(2)} today',
                              style: TextStyle(
                                color: tick.change >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: StockChart(symbol: widget.symbol),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.symbol,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Live LTP'),
                            Text(
                              '₹${tick.ltp.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Buy',
                      label: Text('Buy'),
                      icon: Icon(Icons.trending_up),
                    ),
                    ButtonSegment(
                      value: 'Sell',
                      label: Text('Sell'),
                      icon: Icon(Icons.trending_down),
                    ),
                  ],
                  selected: {side},
                  onSelectionChanged: (value) {
                    setState(() {
                      side = value.first;
                      errorText = null;
                    });
                  },
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                    errorText: errorText,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() => errorText = null);
                  },
                ),

                const SizedBox(height: 20),

                _InfoTile(
                  title: 'Available Balance',
                  value: '₹${portfolio.balance.toStringAsFixed(2)}',
                ),
                _InfoTile(
                  title: 'Quantity Held',
                  value: '${holding?.quantity ?? 0}',
                ),
                _InfoTile(
                  title: 'Projected Order Value',
                  value: '₹${orderValue.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      _submitOrder(price: tick.ltp);
                    },
                    child: Text('$side ${widget.symbol}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitOrder({required double price}) {
    final text = quantityController.text.trim();

    if (text.isEmpty) {
      setState(() => errorText = 'Quantity is required');
      return;
    }

    final quantity = int.tryParse(text);

    if (quantity == null) {
      setState(() => errorText = 'Enter a valid whole number');
      return;
    }

    if (quantity <= 0) {
      setState(() => errorText = 'Quantity must be greater than 0');
      return;
    }

    final error = ref
        .read(portfolioProvider.notifier)
        .placeOrder(
          symbol: widget.symbol,
          side: side,
          quantity: quantity,
          price: price,
        );

    if (error != null) {
      setState(() => errorText = error);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          symbol: widget.symbol,
          side: side,
          quantity: quantity,
          price: price,
          value: quantity * price,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
