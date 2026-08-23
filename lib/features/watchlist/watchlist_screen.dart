import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/stocks.dart';
import '../../data/models/watchlist.dart';
import '../../providers/market_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../ticket/order_ticket_screen.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final watchlists = ref.watch(watchlistProvider);

    if (watchlists.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (selectedIndex >= watchlists.length) {
      selectedIndex = 0;
    }

    final selectedWatchlist = watchlists[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedWatchlist.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddStockSheet(selectedWatchlist),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'create') _createWatchlistDialog();
              if (value == 'rename') _renameWatchlistDialog(selectedWatchlist);
              if (value == 'delete') _deleteWatchlist(selectedWatchlist);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'create', child: Text('Create Watchlist')),
              PopupMenuItem(value: 'rename', child: Text('Rename Watchlist')),
              PopupMenuItem(value: 'delete', child: Text('Delete Watchlist')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: watchlists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = watchlists[index];
                final isSelected = index == selectedIndex;

                return ChoiceChip(
                  label: Text(item.name),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedIndex = index);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selectedWatchlist.symbols.isEmpty
                ? _EmptyWatchlist(
                    onAdd: () => _showAddStockSheet(selectedWatchlist),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedWatchlist.symbols.length,
                    onReorder: (oldIndex, newIndex) {
                      ref
                          .read(watchlistProvider.notifier)
                          .reorderStock(
                            selectedWatchlist.id,
                            oldIndex,
                            newIndex,
                          );
                    },
                    itemBuilder: (context, index) {
                      final symbol = selectedWatchlist.symbols[index];

                      return WatchlistStockRow(
                        key: ValueKey(symbol),
                        symbol: symbol,
                        watchlistId: selectedWatchlist.id,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddStockSheet(Watchlist watchlist) {
    final existing = watchlist.symbols;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Add Stock',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...stockSymbols.map((symbol) {
              final alreadyAdded = existing.contains(symbol);

              return ListTile(
                title: Text(symbol),
                subtitle: Text(stockNames[symbol] ?? symbol),
                trailing: alreadyAdded
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.add),
                onTap: alreadyAdded
                    ? null
                    : () {
                        ref
                            .read(watchlistProvider.notifier)
                            .addStock(watchlist.id, symbol);
                        Navigator.pop(context);
                      },
              );
            }),
          ],
        );
      },
    );
  }

  void _createWatchlistDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create Watchlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Watchlist name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                ref.read(watchlistProvider.notifier).createWatchlist(name);
                Navigator.pop(context);

                setState(() {
                  selectedIndex = ref.read(watchlistProvider).length - 1;
                });
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _renameWatchlistDialog(Watchlist watchlist) {
    final controller = TextEditingController(text: watchlist.name);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Rename Watchlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Watchlist name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                ref
                    .read(watchlistProvider.notifier)
                    .renameWatchlist(watchlist.id, name);

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWatchlist(Watchlist watchlist) {
    ref.read(watchlistProvider.notifier).deleteWatchlist(watchlist.id);
    setState(() => selectedIndex = 0);
  }
}

class WatchlistStockRow extends ConsumerWidget {
  final String symbol;
  final String watchlistId;

  const WatchlistStockRow({
    super.key,
    required this.symbol,
    required this.watchlistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickAsync = ref.watch(stockTickProvider(symbol));

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: tickAsync.when(
        loading: () => ListTile(title: Text(symbol)),
        error: (_, __) => ListTile(title: Text('Error loading $symbol')),
        data: (tick) {
          final color = tick.change >= 0 ? Colors.green : Colors.red;

          return ListTile(
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
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(stockNames[symbol] ?? symbol),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${tick.ltp.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${tick.change >= 0 ? '+' : ''}${tick.change.toStringAsFixed(2)} '
                      '(${tick.changePercent.toStringAsFixed(2)}%)',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    ref
                        .read(watchlistProvider.notifier)
                        .removeStock(watchlistId, symbol);
                  },
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyWatchlist({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility_off_outlined, size: 56),
          const SizedBox(height: 12),
          const Text(
            'No stocks in this watchlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text('Add stocks to start tracking live prices.'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Stock'),
          ),
        ],
      ),
    );
  }
}
