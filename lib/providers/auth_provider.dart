import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    _load();
  }

  final _box = Hive.box('tradeflow_box');

  void _load() {
    state = _box.get('is_logged_in', defaultValue: false);
  }

  void login() {
    state = true;
    _box.put('is_logged_in', true);
  }

  void logout() {
    state = false;
    _box.put('is_logged_in', false);
  }
}