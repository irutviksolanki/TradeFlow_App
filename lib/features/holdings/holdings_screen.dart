import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/market_provider.dart';
import '../../providers/portfolio_provider.dart';
import '../ticket/order_ticket_screen.dart';

enum HoldingSort { pnl, symbol, value }

class HoldingsScreen extends ConsumerStatefulWidget {
  const HoldingsScreen({super.key});

  @override
  ConsumerState<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends ConsumerState<HoldingsScreen> {
  HoldingSort selectedSort = HoldingSort.pnl;

  @override
  Widget build(BuildContext context) {
    final portfolio = ref.watch(portfolioProvider);
    final holdings = [...portfolio.holdings];

    if (holdings.isEmpty) {
      return const Center(
        child: Text('No holdings yet'),
      );
    }

    holdings.sort((a, b) {
      if (selectedSort == HoldingSort.symbol) {
        return a.symbol.compareTo(b.symbol);
      }

      final tickA = ref.watch(stockTickProvider(a.symbol)).valueOrNull;
      final tickB = ref.watch(stockTickProvider(b.symbol)).valueOrNull;

      final ltpA = tickA?.ltp ?? a.avgCost;
      final ltpB = tickB?.ltp ?? b.avgCost;

      final valueA = a.quantity * ltpA;
      final valueB = b.quantity * ltpB;

      final pnlA = valueA - (a.quantity * a.avgCost);
      final pnlB = valueB - (b.quantity * b.avgCost);

      if (selectedSort == HoldingSort.value) {
        return valueB.compareTo(valueA);
      }

      return pnlB.compareTo(pnlA);
    });

    double totalInvested = 0;
    double currentValue = 0;

    for (final holding in holdings) {
      final tick = ref.watch(stockTickProvider(holding.symbol)).valueOrNull;
      final ltp = tick?.ltp ?? holding.avgCost;

      totalInvested += holding.quantity * holding.avgCost;
      currentValue += holding.quantity * ltp;
    }

    final totalPnl = currentValue - totalInvested;
    final totalPnlPercent =
    totalInvested == 0 ? 0 : (totalPnl / totalInvested) * 100;

    return Column(
      children: [
        _SummaryCard(
          totalInvested: totalInvested,
          currentValue: currentValue,
          totalPnl: totalPnl,
          totalPnlPercent: totalPnlPercent.toDouble(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<HoldingSort>(
            value: selectedSort,
            decoration: const InputDecoration(
              labelText: 'Sort by',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: HoldingSort.pnl,
                child: Text('P&L High to Low'),
              ),
              DropdownMenuItem(
                value: HoldingSort.symbol,
                child: Text('Symbol A to Z'),
              ),
              DropdownMenuItem(
                value: HoldingSort.value,
                child: Text('Current Value High to Low'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => selectedSort = value);
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: holdings.length,
            itemBuilder: (context, index) {
              final holding = holdings[index];

              return HoldingRow(
                key: ValueKey(holding.symbol),
                symbol: holding.symbol,
                quantity: holding.quantity,
                avgCost: holding.avgCost,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double totalInvested;
  final double currentValue;
  final double totalPnl;
  final double totalPnlPercent;

  const _SummaryCard({
    required this.totalInvested,
    required this.currentValue,
    required this.totalPnl,
    required this.totalPnlPercent,
  });

  @override
  Widget build(BuildContext context) {
    final pnlColor = totalPnl >= 0 ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryRow(
              title: 'Total Invested',
              value: '₹${totalInvested.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              title: 'Current Value',
              value: '₹${currentValue.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              title: 'Total P&L',
              value:
              '₹${totalPnl.toStringAsFixed(2)} (${totalPnlPercent.toStringAsFixed(2)}%)',
              color: pnlColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class HoldingRow extends ConsumerWidget {
  final String symbol;
  final int quantity;
  final double avgCost;

  const HoldingRow({
    super.key,
    required this.symbol,
    required this.quantity,
    required this.avgCost,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickAsync = ref.watch(stockTickProvider(symbol));

    return tickAsync.when(
      loading: () => Card(
        child: ListTile(
          title: Text(symbol),
        ),
      ),
      error: (_, __) => Card(
        child: ListTile(
          title: Text('Error $symbol'),
        ),
      ),
      data: (tick) {
        final invested = quantity * avgCost;
        final currentValue = quantity * tick.ltp;
        final pnl = currentValue - invested;
        final pnlPercent = invested == 0 ? 0 : (pnl / invested) * 100;
        final pnlColor = pnl >= 0 ? Colors.green : Colors.red;

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderTicketScreen(symbol: symbol),
                ),
              );
            },
            title: Text(
              symbol,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              'Qty: $quantity | Avg: ₹${avgCost.toStringAsFixed(2)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${currentValue.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  'P&L ₹${pnl.toStringAsFixed(2)} (${pnlPercent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: pnlColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}