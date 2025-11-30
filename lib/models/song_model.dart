class Song {
  final int id;
  final String firstLetter;
  final String title;
  final int hasChords;
  final String lyrics;
  int isFavorite;
  final String language; // <-- নতুন ফিল্ড যোগ করা হয়েছে

  Song({
    required this.id,
    required this.firstLetter,
    required this.title,
    required this.hasChords,
    required this.lyrics,
    required this.isFavorite,
    required this.language, // <-- কনস্ট্রাক্টরে যোগ করা হয়েছে
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      firstLetter: map['firstLetter'],
      title: map['title'],
      hasChords: map['hasChords'],
      lyrics: map['lyrics'],
      isFavorite: map['isFavorite'],
      language: map['language'], // <-- fromMap-এ যোগ করা হয়েছে
    );
  }
}
