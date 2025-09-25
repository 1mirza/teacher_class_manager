// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تنظیمات'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('یادآور برنامه هفتگی'),
            subtitle:
                const Text('۱۰ دقیقه قبل از شروع زنگ، نوتیفیکیشن دریافت کنید'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                // TODO: منطق فعال/غیرفعال کردن نوتیفیکیشن‌ها را پیاده‌سازی کنید
              });
            },
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('درباره برنامه'),
            onTap: () {
              // TODO: یک دیالوگ یا صفحه برای نمایش اطلاعات برنامه نشان دهید
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج از حساب کاربری',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: منطق خروج از حساب و بازگشت به صفحه ورود
            },
          ),
        ],
      ),
    );
  }
}
