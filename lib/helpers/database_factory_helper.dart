// lib/helpers/database_factory_helper.dart

// এই ফাইলটি প্ল্যাটফর্ম অনুযায়ী সঠিক ডাটাবেস ফ্যাক্টরি প্রদান করবে।
// এটি একটি "ফ্যাক্টরি ফাংশন" যা সঠিক ফ্যাক্টরিটি রিটার্ন করে।

import 'package:sqflite_common/sqlite_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

// ওয়েব এবং ডেস্কটপের জন্য FFI প্যাকেজগুলো ইম্পোর্ট করা হচ্ছে
// এই ইম্পোর্টগুলো এরর দেবে না কারণ আমরা এগুলোকে শর্তসাপেক্ষে ব্যবহার করব।
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

DatabaseFactory getDatabaseFactory() {
  if (kIsWeb) {
    // ওয়েবের জন্য
    return databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // ডেস্কটপের জন্য
    sqfliteFfiInit();
    return databaseFactoryFfi;
  } else {
    // মোবাইল (Android/iOS) এর জন্য
    // এখানে sqflite.databaseFactory ব্যবহার করতে হবে, যা ডিফল্ট
    return databaseFactory;
  }
}
