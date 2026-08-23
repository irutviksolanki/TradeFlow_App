import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trade_flow/features/market/stock_detail_screen.dart';

import '../../core/constants/stocks.dart';
import '../../providers/market_provider.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(marketFeedProvider);
    final isMarketOpen = feed.isMarketOpen();

    return Column(
      children: [
        if (!isMarketOpen)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Text(
              'Market is closed today. Please check tomorrow.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stockSymbols.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final symbol = stockSymbols[index];
              return MarketPriceRow(symbol: symbol);
            },
          ),
        ),
      ],
    );
  }
}

class MarketPriceRow extends ConsumerWidget {
  final String symbol;

  const MarketPriceRow({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickAsync = ref.watch(stockTickProvider(symbol));

    return tickAsync.when(
      loading: () => _PriceCardLoading(symbol: symbol),
      error: (error, _) => _PriceCardError(symbol: symbol),
      data: (tick) {
        final changeColor = tick.change >= 0 ? Colors.green : Colors.red;
        final arrow =
        tick.change >= 0 ? Icons.arrow_upward : Icons.arrow_downward;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockDetailScreen(symbol: symbol),
              ),
            );
          },
          child: TweenAnimationBuilder<Color?>(
            key: ValueKey('${tick.symbol}-${tick.ltp}'),
            tween: ColorTween(
              begin: changeColor.withOpacity(0.25),
              end: Theme.of(context).cardColor,
            ),
            duration: const Duration(milliseconds: 450),
            builder: (context, color, child) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                child: child,
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tick.symbol,
                        style:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stockNames[tick.symbol] ?? tick.symbol,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${tick.ltp.toStringAsFixed(2)}',
                      style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          arrow,
                          size: 14,
                          color: changeColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${tick.change >= 0 ? '+' : ''}${tick.change.toStringAsFixed(2)} '
                              '(${tick.changePercent.toStringAsFixed(2)}%)',
                          style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: changeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PriceCardLoading extends StatelessWidget {
  final String symbol;

  const _PriceCardLoading({
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Text(
        symbol,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _PriceCardError extends StatelessWidget {
  final String symbol;

  const _PriceCardError({
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      child: Text(
        'Failed to load $symbol',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}