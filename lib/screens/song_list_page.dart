import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/song_model.dart';
import 'song_details_page.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Song> _songs = [];
  bool _isLoading = true;

  // --- স্টেট ভেরিয়েবল ---
  String _selectedLanguage = 'BN'; // ডিফল্ট ভাষা বাংলা
  String _selectedFilter = 'কর্ড';
  // -----------------------

  // --- দুটি ভাষার জন্য আলাদা ফিল্টার বাটন তালিকা ---
  final List<String> bengaliFilterButtons = [
    'কর্ড',
    'অ',
    'আ',
    'ই',
    'ঈ',
    'উ',
    'এ',
    'ঐ',
    'ও',
    'ক',
    'খ',
    'গ',
    'ঘ',
    'চ',
    'ছ',
    'জ',
    'ট',
    'ড',
    'ত',
    'থ',
    'দ',
    'ধ',
    'ন',
    'প',
    'ফ',
    'ব',
    'ভ',
    'ম',
    'য',
    'র',
    'ল',
    'শ',
    'স',
    'হ',
    'ক্ষ'
  ];
  final List<String> englishFilterButtons = [
    'Chords',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  // -------------------------------------

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadSongs(); // অ্যাপ চালু হলে ডিফল্ট গান লোড হবে (বাংলা, কর্ড)
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // গান লোড করার জন্য আপডেট করা এবং নির্ভরযোগ্য ফাংশন
  Future<void> _loadSongs({String? filter}) async {
    if (filter != null) _selectedFilter = filter;
    setState(() => _isLoading = true);

    List<Song> songs;

    // --- সমাধান: ফিল্টার নামটি case-insensitive এবং উভয় ভাষার জন্য চেক করা হচ্ছে ---
    if (_selectedFilter.toLowerCase().contains('chord') ||
        _selectedFilter.contains('কর্ড')) {
      songs = await dbHelper.getSongsWithChordsByLanguage(_selectedLanguage);
    } else {
      songs = await dbHelper.getSongsByLanguageAndFirstLetter(
          _selectedLanguage, _selectedFilter);
    }
    // -------------------------------------------------------------------------

    if (mounted)
      setState(() {
        _songs = songs;
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    // বর্তমান ভাষা অনুযায়ী সঠিক ফিল্টার তালিকা নির্বাচন করা
    final currentFilterButtons =
        _selectedLanguage == 'BN' ? bengaliFilterButtons : englishFilterButtons;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('Songs List'),
          actions: [
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => showSearch(
                    context: context, delegate: SongSearchDelegate(dbHelper)))
          ],
          backgroundColor: Colors.transparent,
          elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/a.png"), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // SegmentedButton কে পুরো প্রস্থ দেওয়ার জন্য
            children: [
              // --- ভাষা নির্বাচনের জন্য UI ---
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SegmentedButton<String>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                  ),
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                        value: 'BN',
                        label: Text('বাংলা গান'),
                        icon: Icon(Icons.check, size: 16)),
                    ButtonSegment<String>(
                        value: 'EN',
                        label: Text('English Songs'),
                        icon: Icon(Icons.check, size: 16)),
                  ],
                  selected: {_selectedLanguage},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedLanguage = newSelection.first;
                      _selectedFilter =
                          _selectedLanguage == 'BN' ? 'কর্ড' : 'Chords';
                      _loadSongs();
                    });
                  },
                ),
              ),
              const Divider(
                  color: Colors.white54, indent: 16, endIndent: 16, height: 1),
              // --- ফিল্টার বাটন সেকশন ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 18),
                      onPressed: () => _scrollController.animateTo(
                          _scrollController.offset - 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: currentFilterButtons.length,
                          itemBuilder: (context, index) {
                            final filter = currentFilterButtons[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ElevatedButton(
                                onPressed: () => _loadSongs(filter: filter),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedFilter == filter
                                      ? (filter
                                                  .toLowerCase()
                                                  .contains('chord') ||
                                              filter.contains('কর্ড')
                                          ? Colors.amber[700]
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary)
                                      : Colors.white.withOpacity(0.8),
                                  foregroundColor: _selectedFilter == filter
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: Text(filter),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 18),
                      onPressed: () => _scrollController.animateTo(
                          _scrollController.offset + 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut),
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: Colors.white54, indent: 16, endIndent: 16, height: 1),
              // --- গান দেখানোর তালিকা ---
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : _songs.isEmpty
                        ? const Center(
                            child: Text('এই ফিল্টারে কোনো গান পাওয়া যায়নি।',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)))
                        : ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: _songs.length,
                            itemBuilder: (context, index) {
                              final song = _songs[index];
                              return Card(
                                color: Colors.black.withOpacity(0.4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      child: song.hasChords == 1
                                          ? const Icon(Icons.music_note,
                                              color: Colors.amber)
                                          : Text(song.firstLetter,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                  title: Text(song.title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SongDetailsPage(song: song)))
                                      .then((_) =>
                                          _loadSongs(filter: _selectedFilter)),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SongSearchDelegate অপরিবর্তিত থাকবে
class SongSearchDelegate extends SearchDelegate<Song?> {
  final DatabaseHelper dbHelper;
  SongSearchDelegate(this.dbHelper);
  @override
  List<Widget>? buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null));
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty)
      return const Center(child: Text('অনুগ্রহ করে গানের শিরোনাম লিখুন।'));
    return FutureBuilder<List<Song>>(
      future: dbHelper.searchSongs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text('কোনো গান পাওয়া যায়নি।'));
        final songs = snapshot.data!;
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              title: Text(song.title),
              onTap: () {
                close(context, song);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SongDetailsPage(song: song)));
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
