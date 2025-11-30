import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // --- ডাটাবেস কনফিগারেশন ---
  // ডাটাবেসের সংস্করণ পরিবর্তন করুন যখনই আপনি schema পরিবর্তন করবেন (যেমন নতুন কলাম যোগ করা)
  static const int _newDbVersion = 15; // উদাহরণ: আগে ১১ ছিল, এখন ১২
  static const String _dbVersionKey = 'praise_the_lord_db_version';
  static const String _dbFileName = 'songs_database.db';
  static const String _tableName = 'songs';
  // -------------------------

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbFileName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedDbVersion = prefs.getInt(_dbVersionKey) ?? 0;
    bool dbExists = await databaseExists(path);

    // যদি ডাটাবেস না থাকে অথবা নতুন সংস্করণ আসে, তাহলে assets থেকে কপি করা হবে
    if (!dbExists || savedDbVersion < _newDbVersion) {
      print(
          "Database does not exist or version is old. Copying new database...");
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data =
            await rootBundle.load(join('assets/database/', _dbFileName));
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        await prefs.setInt(_dbVersionKey, _newDbVersion);
        print("Database copied successfully. New version: $_newDbVersion");
      } catch (e) {
        print("Error copying database: $e");
      }
    }
    return await openDatabase(path);
  }

  // --- ডেটা অ্যাক্সেস ফাংশন ---

  // সমস্ত গান নিয়ে আসার জন্য (এখন আর ব্যবহৃত হচ্ছে না, তবে রাখা যেতে পারে)
  Future<List<Song>> getAllSongs() async {
    final db = await database;
    final res = await db.query(_tableName, orderBy: 'title COLLATE NOCASE');
    return res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
  }

  // **আপডেট করা হয়েছে:** ভাষা এবং প্রথম অক্ষর অনুযায়ী গান খুঁজবে
  Future<List<Song>> getSongsByLanguageAndFirstLetter(
      String languageCode, String letter) async {
    final db = await database;
    final res = await db.query(
      _tableName,
      where: 'language = ? AND firstLetter = ?',
      whereArgs: [languageCode, letter],
      orderBy: 'title COLLATE NOCASE',
    );
    return res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
  }

  // **আপডেট করা হয়েছে:** ভাষা অনুযায়ী কর্ডসহ গান খুঁজবে
  Future<List<Song>> getSongsWithChordsByLanguage(String languageCode) async {
    final db = await database;
    final res = await db.query(
      _tableName,
      where: 'language = ? AND hasChords = ?',
      whereArgs: [languageCode, 1],
      orderBy: 'title COLLATE NOCASE',
    );
    return res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
  }

  // সার্চ ফাংশন (ভাষা নির্বিশেষে সব গানে সার্চ করবে)
  Future<List<Song>> searchSongs(String query) async {
    final db = await database;
    final res = await db.query(
      _tableName,
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'title COLLATE NOCASE',
    );
    return res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
  }

  // ফেভারিট গান নিয়ে আসার জন্য (ভাষা নির্বিশেষে সব ফেভারিট গান দেখাবে)
  Future<List<Song>> getFavoriteSongs() async {
    final db = await database;
    final res = await db.query(
      _tableName,
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'title COLLATE NOCASE',
    );
    return res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
  }

  // ফেভারিট স্ট্যাটাস পরিবর্তন করার জন্য
  Future<void> toggleFavorite(int id, int currentStatus) async {
    final db = await database;
    await db.update(
      _tableName,
      {'isFavorite': currentStatus == 1 ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
