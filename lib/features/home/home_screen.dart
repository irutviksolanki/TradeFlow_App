import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import '../holdings/holdings_screen.dart';
import '../market/market_screen.dart';
import '../watchlist/watchlist_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  final screens = const [
    MarketScreen(),
    WatchlistScreen(),
    HoldingsScreen(),
  ];

  final titles = const [
    'Market',
    'Watchlist',
    'Holdings',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Rutvik Solanki'),
                accountEmail: const Text('Trading App User'),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    'R',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                subtitle: const Text('Demo trading account'),
                onTap: () {
                  Navigator.pop(context);
                  _showProfileDialog(context);
                },
              ),

              SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                ),
                title: const Text('Dark Theme'),
                subtitle: Text(isDark ? 'Enabled' : 'Disabled'),
                value: isDark,
                onChanged: (_) {
                  ref.read(themeProvider.notifier).toggleTheme();

                  Navigator.of(context).pop(); // Close Drawer
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.show_chart),
                title: const Text('Market'),
                selected: selectedIndex == 0,
                onTap: () {
                  setState(() => selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_border),
                title: const Text('Watchlist'),
                selected: selectedIndex == 1,
                onTap: () {
                  setState(() => selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('Holdings'),
                selected: selectedIndex == 2,
                onTap: () {
                  setState(() => selectedIndex = 2);
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'TradeFlow v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: 'Market',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            label: 'Watchlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Holdings',
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Profile'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                child: Text(
                  'R',
                  style: TextStyle(fontSize: 28),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Rutvik Solanki',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 6),
              Text('Demo Trading Account'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}