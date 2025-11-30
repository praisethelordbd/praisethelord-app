// lib/main.dart

// --- প্রয়োজনীয় ইম্পোর্টগুলো যোগ করুন ---
import 'package:flutter/foundation.dart'
    show kIsWeb; // ওয়েব প্ল্যাটফর্ম চেক করার জন্য
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:praisethelord/helpers/database_helper.dart';
import 'package:praisethelord/providers/settings_provider.dart';
import 'package:praisethelord/screens/home_page.dart';
import 'dart:io' show Platform; // ডেস্কটপ প্ল্যাটফর্ম চেক করার জন্য

// FFI প্যাকেজগুলোর জন্য ইম্পোর্ট
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  // এই লাইনটি সবসময় প্রথমে থাকবে
  WidgetsFlutterBinding.ensureInitialized();

  // --- সমাধান এখানে: প্ল্যাটফর্ম অনুযায়ী ডাটাবেস ফ্যাক্টরি সেট করা ---
  if (kIsWeb) {
    // যদি প্ল্যাটফর্ম ওয়েব হয়
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // যদি প্ল্যাটফর্ম ডেস্কটপ (উইন্ডোজ, লিনাক্স, ম্যাক) হয়
    sqfliteFfiInit(); // FFI লাইব্রেরি চালু করা
    databaseFactory = databaseFactoryFfi; // ডাটাবেস ফ্যাক্টরি সেট করা
  }
  // অ্যান্ড্রয়েড এবং আইওএস-এর জন্য কোনো বিশেষ ইনিশিয়ালাইজেশনের প্রয়োজন নেই।
  // -----------------------------------------------------------------

  // এখন ডাটাবেস অ্যাক্সেস করা নিরাপদ
  await DatabaseHelper.instance.database;

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

// MyApp ক্লাসটি অপরিবর্তিত থাকবে
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      title: 'Praise the LORD BD',
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: settingsProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
