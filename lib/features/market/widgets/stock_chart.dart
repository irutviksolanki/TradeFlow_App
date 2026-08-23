import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/chart_provider.dart';

class StockChart extends ConsumerWidget {
  final String symbol;

  const StockChart({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(stockHistoryProvider(symbol));

    if (history.length < 2) {
      return const SizedBox(
        height: 260,
        child: Center(child: Text('Collecting chart data...')),
      );
    }

    final prices = history.map((e) => e.ltp as double).toList();
    final firstPrice = prices.first;
    final lastPrice = prices.last;

    final isDown = lastPrice < firstPrice;
    final lineColor = isDown ? Colors.redAccent : Colors.green;

    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final padding = ((maxY - minY) * 0.25).clamp(2.0, 20.0);

    final spots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.ltp);
    }).toList();

    final previousClose = firstPrice;

    return SizedBox(
      height: 280,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (history.length - 1).toDouble(),
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY - minY) / 3).abs() <= 0
                ? 1
                : ((maxY - minY) / 3).abs(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).dividerColor.withOpacity(0.45),
                strokeWidth: 1,
              );
            },
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
                reservedSize: 46,
                interval: ((maxY - minY) / 3).abs() <= 0
                    ? 1
                    : ((maxY - minY) / 3).abs(),
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: history.length / 3,
                getTitlesWidget: (value, meta) {
                  String text = '';

                  if (value <= 1) {
                    text = '10:00 am';
                  } else if (value >= history.length / 2 - 1 &&
                      value <= history.length / 2 + 1) {
                    text = '1:00 pm';
                  } else if (value >= history.length - 3) {
                    text = '3:00 pm';
                  }

                  return Text(
                    text,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (items) {
                return items.map((item) {
                  return LineTooltipItem(
                    '₹${item.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: previousClose,
                color: Theme.of(context).dividerColor.withOpacity(0.7),
                strokeWidth: 1,
                dashArray: [4, 8],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) =>
                  'Previous close ${previousClose.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            verticalLines: [
              VerticalLine(
                x: (history.length - 1).toDouble(),
                color: Theme.of(context).dividerColor.withOpacity(0.8),
                strokeWidth: 1,
                dashArray: [4, 6],
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: lineColor,
              barWidth: 2.8,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return spot.x == (history.length - 1).toDouble();
                },
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 5,
                    color: lineColor,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}