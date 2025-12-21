import 'package:flutter/material.dart';
import 'package:gita/data/local/database_helper.dart'; // Ensure correct import path
import 'package:gita/Screens/readingpage.dart'; // Ensure correct import path

// Reusing style constants
const Color kPrimaryOrange = Color(0xFFFF6F00); 
const Color kBackgroundColor = Color(0xFFFFF8E1); 
const Color kAccentGold = Color(0xFFFFB300);
const Color kTextPrimary = Color(0xFF4E342E); 

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  // State to hold the fully loaded Verse objects
  List<Verse> _savedVerses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  // --- DATA FETCHING LOGIC ---
  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
    });

    final List<Bookmark> bookmarks = await _dbHelper.fetchAllBookmarks();
    List<Verse> verses = [];

    // Fetch the full content for each bookmark
    for (var bookmark in bookmarks) {
      final verse = await _dbHelper.fetchSpecificVerse(
        bookmark.chapterNumber,
        bookmark.verseNumber,
      );
      if (verse != null) {
        verses.add(verse);
      }
    }

    if (mounted) {
      setState(() {
        _savedVerses = verses;
        _isLoading = false;
      });
    }
  }

  // --- UI WIDGET: Single Saved Verse Card ---
  Widget _buildBookmarkCard(Verse verse) {
    // Determine the snippet to display (Hindi preferred if available, otherwise English)
    final snippet = verse.translation;

    
    // Truncate the snippet for the list view
    final displaySnippet = snippet.length > 80 ? '${snippet.substring(0, 80)}...' : snippet;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          // Navigate to the ReadingPage with the full verse content
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingPage(
                initialVerse: verse,
                chapterNumber: verse.chapterNumber,
                verseNumber: verse.verseNumber,
                 // Assuming initialVerse has the chapter number embedded or passed
              ),
            ),
          );
          // Optional: Reload bookmarks when returning to refresh the list state
          // .then((_) => _loadBookmarks()); 
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kPrimaryOrange.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Chapter and Verse Number
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chapter ${verse.chapterNumber}.${verse.verseNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: kPrimaryOrange,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
              const SizedBox(height: 8),

              // Snippet Text
              Text(
                displaySnippet,
                style: TextStyle(
                  fontSize: 14,
                  color: kTextPrimary.withOpacity(0.8),
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Saved Verses',
          style: TextStyle(color: kTextPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryOrange))
          : _savedVerses.isEmpty
              ? const Center(
                  child: Text(
                    'No verses saved yet. Tap the bookmark icon to save one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kTextPrimary, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _savedVerses.length,
                  itemBuilder: (context, index) {
                    return _buildBookmarkCard(_savedVerses[index]);
                  },
                ),
    );
  }
}
