// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:teacher_class_manager/screens/dashboard_screen.dart'; // مسیر فایل را اصلاح کنید

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // TODO: با استفاده از پایگاه داده چک کنید که آیا معلمی ثبت‌نام کرده است یا خیر
  // bool _isFirstTime = await DatabaseService.isFirstTime();
  bool _isLoginView = false; // به صورت پیش‌فرض صفحه ثبت‌نام نمایش داده می‌شود

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // TODO: منطق ورود یا ثبت‌نام را با پایگاه داده پیاده‌سازی کنید
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Icon(Icons.class_, size: 80, color: Colors.indigo[400]),
                  const SizedBox(height: 20),
                  Text(
                    _isLoginView ? 'ورود به حساب کاربری' : 'ایجاد حساب جدید',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!_isLoginView) ..._buildRegisterFields(),
                  if (_isLoginView) ..._buildLoginFields(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isLoginView ? 'ورود' : 'ثبت نام'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginView = !_isLoginView;
                      });
                    },
                    child: Text(
                      _isLoginView
                          ? 'حساب کاربری ندارید؟ ثبت نام کنید'
                          : 'قبلاً ثبت نام کرده‌اید؟ وارد شوید',
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

  List<Widget> _buildLoginFields() {
    return [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'نام کاربری',
          prefixIcon: Icon(Icons.person_outline),
        ),
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'نام کاربری را وارد کنید' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'رمز عبور',
          prefixIcon: Icon(Icons.lock_outline),
        ),
        obscureText: true,
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'رمز عبور را وارد کنید' : null,
      ),
    ];
  }

  List<Widget> _buildRegisterFields() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'نام و نام خانوادگی معلم'),
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'مقطع تحصیلی'),
      ),
      const SizedBox(height: 16),
      TextFormField(decoration: const InputDecoration(labelText: 'نام مدرسه')),
      const SizedBox(height: 16),
      TextFormField(decoration: const InputDecoration(labelText: 'نام کلاس')),
      const SizedBox(height: 16),
      TextFormField(decoration: const InputDecoration(labelText: 'نام کاربری')),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(labelText: 'رمز عبور'),
        obscureText: true,
      ),
    ];
  }
}
