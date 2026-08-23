import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/chart_provider.dart';
import '../../providers/market_provider.dart';
import '../ticket/order_ticket_screen.dart';

class StockDetailScreen extends ConsumerWidget {
  final String symbol;

  const StockDetailScreen({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(stockTickProvider(symbol)).valueOrNull;
    final history = ref.watch(stockHistoryProvider(symbol));

    if (tick == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDown = tick.change < 0;
    final priceColor = isDown ? Colors.redAccent : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${tick.ltp.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: priceColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${isDown ? '↓' : '↑'} ${tick.changePercent.abs().toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: priceColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${tick.change >= 0 ? '+' : ''}${tick.change.toStringAsFixed(2)} today',
                  style: TextStyle(
                    color: priceColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Market price updates in real time',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 24),

            _RangeTabs(),

            const SizedBox(height: 16),

            SizedBox(
              height: 280,
              child: _BigStockChart(
                history: history,
                color: priceColor,
              ),
            ),

            const SizedBox(height: 24),

            _StatsGrid(
              open: tick.previousClose,
              high: history.isEmpty
                  ? tick.ltp
                  : history.map((e) => e.ltp).reduce((a, b) => a > b ? a : b),
              low: history.isEmpty
                  ? tick.ltp
                  : history.map((e) => e.ltp).reduce((a, b) => a < b ? a : b),
              previousClose: tick.previousClose,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTicketScreen(symbol: symbol),
                    ),
                  );
                },
                child: const Text('Buy / Sell'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ['1D', '5D', '1M', '6M', 'YTD', '1Y', '5Y', 'Max'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        final selected = item == '1D';

        return Column(
          children: [
            Text(
              item,
              style: TextStyle(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _BigStockChart extends StatelessWidget {
  final List history;
  final Color color;

  const _BigStockChart({
    required this.history,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return const Center(child: Text('Collecting chart data...'));
    }

    final spots = history.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.ltp,
      );
    }).toList();

    final prices = history.map((e) => e.ltp as double).toList();
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minY: minY - 5,
        maxY: maxY + 5,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: ((maxY - minY) / 3).abs() == 0
              ? 1
              : ((maxY - minY) / 3).abs(),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: color,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final double open;
  final double high;
  final double low;
  final double previousClose;

  const _StatsGrid({
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatRow('Open', open, 'Previous close', previousClose),
        _StatRow('High', high, 'Mkt cap', 3.88),
        _StatRow('Low', low, 'P/E ratio', 14.02),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String leftTitle;
  final double leftValue;
  final String rightTitle;
  final double rightValue;

  const _StatRow(
      this.leftTitle,
      this.leftValue,
      this.rightTitle,
      this.rightValue,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(leftValue.toStringAsFixed(2)),
          ),
          Expanded(
            child: Text(
              rightTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(rightValue.toStringAsFixed(2)),
          ),
        ],
      ),
    );
  }
}