import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/song_model.dart';
import 'song_details_page.dart';

class FavoriteListPage extends StatefulWidget {
  const FavoriteListPage({super.key});
  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  // Future টি স্টেট ভ্যারিয়েবল হিসেবে থাকবে
  late Future<List<Song>> _favoriteSongsFuture;

  @override
  void initState() {
    super.initState();
    // initState এর ভেতরে সরাসরি Future এসাইন করা হবে। এটি নিরাপদ।
    _favoriteSongsFuture = DatabaseHelper.instance.getFavoriteSongs();
  }

  // তালিকা রিফ্রেশ করার জন্য একটি ফাংশন
  void _refreshFavorites() {
    // setState কল করে Future ভ্যারিয়েবলটিকে নতুন করে এসাইন করা হচ্ছে।
    // এটি FutureBuilder কে রি-বিল্ড করার জন্য ট্রিগার করবে।
    setState(() {
      _favoriteSongsFuture = DatabaseHelper.instance.getFavoriteSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite List')),
      // FutureBuilder ব্যবহার করে UI বিল্ড করা হবে
      body: FutureBuilder<List<Song>>(
        future: _favoriteSongsFuture, // এই Future টিকে listen করা হবে
        builder: (context, snapshot) {
          // যখন Future চলছে
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // যদি Future এ কোনো এরর আসে
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // যদি ডেটা না থাকে বা খালি থাকে
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'আপনার কোনো ফেভারিট গান নেই।',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // যদি ডেটা সফলভাবে আসে
          final songs = snapshot.data!;
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: const Icon(Icons.music_note, color: Colors.blue),
                title: Text(song.title),
                trailing: const Icon(Icons.favorite, color: Colors.red),
                onTap: () async {
                  // SongDetailsPage এ যাওয়া হবে এবং ফিরে আসার জন্য অপেক্ষা করা হবে
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SongDetailsPage(song: song)),
                  );
                  // ফিরে আসার পর তালিকা রিফ্রেশ করা হবে
                  _refreshFavorites();
                },
              );
            },
          );
        },
      ),
    );
  }
}
