import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/database_helper.dart';
import '../models/song_model.dart';

class SongDetailsPage extends StatefulWidget {
  final Song song;
  const SongDetailsPage({super.key, required this.song});
  @override
  _SongDetailsPageState createState() => _SongDetailsPageState();
}

class _SongDetailsPageState extends State<SongDetailsPage> {
  late Song _currentSong;
  double _fontSize = 18.0;
  Color _textColor = Colors.white; // ডিফল্ট টেক্সট কালার
  TextAlign _textAlign = TextAlign.left;
  bool _showChords = true;
  bool _isControlPanelVisible = false;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.song;
    if (_currentSong.hasChords == 0) {
      _showChords = false;
    }
  }

  Future<void> _toggleFavorite() async {
    await DatabaseHelper.instance
        .toggleFavorite(_currentSong.id, _currentSong.isFavorite);
    final newFavoriteStatus = _currentSong.isFavorite == 1 ? 0 : 1;
    if (mounted) {
      setState(() => _currentSong.isFavorite = newFavoriteStatus);
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newFavoriteStatus == 1
              ? '${_currentSong.title} ফেভারিট লিস্টে যোগ করা হয়েছে।'
              : '${_currentSong.title} ফেভারিট লিস্ট থেকে মুছে ফেলা হয়েছে.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _changeFontSize(double delta) {
    setState(() => _fontSize = (_fontSize + delta).clamp(12.0, 32.0));
  }

  // --- সমাধান: আপনার দেওয়া _showColorPicker ফাংশনটি এখানে যোগ করা হয়েছে ---
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Text Color"),
        content: Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            Colors.white,
            Colors.yellow,
            Colors.lightBlueAccent,
            Colors.lightGreenAccent
          ]
              .map((c) => IconButton(
                    icon: Icon(Icons.circle, color: c, size: 36),
                    onPressed: () {
                      setState(
                          () => _textColor = c); // নির্বাচিত রঙ সেট করা হচ্ছে
                      Navigator.of(context).pop();
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------

  bool _isChordLine(String line) {
    if (line.trim().isEmpty) return false;
    final chordRegex = RegExp(r'^[A-Ga-g0-9#b\s/msuSUDIMAadimg\[\]\(\)]*$');
    return chordRegex.hasMatch(line.trim());
  }

  Widget _buildLyricsWidget() {
    List<String> lines = _currentSong.lyrics.split('\n');
    List<Widget> widgets = [];
    for (String line in lines) {
      if (_isChordLine(line)) {
        if (_showChords) {
          widgets.add(
            Text(
              line,
              textAlign: _textAlign,
              style: TextStyle(
                fontSize: _fontSize - 1,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          );
        }
      } else {
        widgets.add(
          Text(
            line,
            textAlign: _textAlign,
            style: TextStyle(
              fontSize: _fontSize,
              color:
                  _textColor, // এখানে _textColor ভেরিয়েবলটি ব্যবহার করা হচ্ছে
              height: 1.6,
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: _textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : (_textAlign == TextAlign.right
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start),
      children: widgets,
    );
  }

  Widget _buildControlPanel() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.2)
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: _isControlPanelVisible
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon:
                          const Icon(Icons.text_decrease, color: Colors.white),
                      onPressed: () => _changeFontSize(-2.0)),
                  Text(_fontSize.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  IconButton(
                      icon:
                          const Icon(Icons.text_increase, color: Colors.white),
                      onPressed: () => _changeFontSize(2.0)),

                  const VerticalDivider(
                      width: 12,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.white30),

                  ToggleButtons(
                    isSelected: [
                      _textAlign == TextAlign.left,
                      _textAlign == TextAlign.center,
                      _textAlign == TextAlign.right
                    ],
                    onPressed: (index) => setState(() => _textAlign = index == 0
                        ? TextAlign.left
                        : (index == 1 ? TextAlign.center : TextAlign.right)),
                    color: Colors.white,
                    selectedColor: Colors.amber,
                    fillColor: Colors.white.withOpacity(0.2),
                    borderColor: Colors.white54,
                    selectedBorderColor: Colors.amber,
                    borderRadius: BorderRadius.circular(8.0),
                    constraints:
                        const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
                    children: const [
                      Icon(Icons.format_align_left, size: 20),
                      Icon(Icons.format_align_center, size: 20),
                      Icon(Icons.format_align_right, size: 20)
                    ],
                  ),

                  const VerticalDivider(
                      width: 12,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.white30),

                  // --- সমাধান: কালার পিকার চালু করার জন্য নতুন বাটন ---
                  IconButton(
                    icon: Icon(Icons.color_lens_outlined, color: _textColor),
                    tooltip: "Change Text Color",
                    onPressed: () => _showColorPicker(context),
                  ),
                  // ---------------------------------------------
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(_currentSong.title, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Text Styles',
            onPressed: () => setState(
                () => _isControlPanelVisible = !_isControlPanelVisible),
          ),
          if (_currentSong.hasChords == 1)
            IconButton(
              icon: Icon(
                  _showChords ? Icons.music_note : Icons.music_off_outlined,
                  color: _showChords ? Colors.amber : Colors.white),
              tooltip: 'Show/Hide Chords',
              onPressed: () => setState(() => _showChords = !_showChords),
            ),
          IconButton(
            icon: Icon(
                _currentSong.isFavorite == 1
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _currentSong.isFavorite == 1
                    ? Colors.redAccent
                    : Colors.white),
            tooltip: 'Favorite',
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/a.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildControlPanel(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Card(
                    color: Colors.black.withOpacity(0.55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _currentSong.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                          const Divider(
                              height: 20, thickness: 1, color: Colors.white30),
                          _buildLyricsWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
