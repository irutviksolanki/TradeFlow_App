import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  bool useOtp = true;
  bool otpSent = false;
  String? errorText;

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _completeLogin() {
    ref.read(authProvider.notifier).login();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _loginWithPassword() {
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.length != 10) {
      setState(() => errorText = 'Enter valid 10 digit mobile number');
      return;
    }

    if (password.length < 4) {
      setState(() => errorText = 'Password must be at least 4 characters');
      return;
    }

    _completeLogin();
  }

  void _sendOtp() {
    final mobile = mobileController.text.trim();

    if (mobile.length != 10) {
      setState(() => errorText = 'Enter valid 10 digit mobile number');
      return;
    }

    setState(() {
      otpSent = true;
      errorText = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo OTP is 123456')),
    );
  }

  void _verifyOtp() {
    if (otpController.text.trim() != '123456') {
      setState(() => errorText = 'Invalid OTP. Use 123456');
      return;
    }

    _completeLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'TradeFlow',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('Login to your demo trading account'),

                  const SizedBox(height: 24),

                  SegmentedButton<bool>(
                    selected: {useOtp},
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('OTP'),
                        icon: Icon(Icons.sms_outlined),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Password'),
                        icon: Icon(Icons.lock_outline),
                      ),
                    ],
                    onSelectionChanged: (value) {
                      setState(() {
                        useOtp = value.first;
                        errorText = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() => errorText = null),
                  ),

                  const SizedBox(height: 14),

                  if (useOtp && otpSent)
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'OTP',
                        hintText: 'Use 123456',
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      onChanged: (_) => setState(() => errorText = null),
                    ),

                  if (!useOtp)
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Any password min 4 chars',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() => errorText = null),
                    ),

                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: useOtp
                          ? otpSent
                          ? _verifyOtp
                          : _sendOtp
                          : _loginWithPassword,
                      child: Text(
                        useOtp
                            ? otpSent
                            ? 'Verify OTP'
                            : 'Send OTP'
                            : 'Login',
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _completeLogin,
                      icon: const Icon(Icons.g_mobiledata, size: 30),
                      label: const Text('Continue with Google'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _completeLogin,
                      icon: const Icon(Icons.facebook),
                      label: const Text('Continue with Facebook'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}