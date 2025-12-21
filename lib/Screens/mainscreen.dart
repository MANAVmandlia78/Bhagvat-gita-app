import 'package:flutter/material.dart';
import 'package:gita/Screens/ChapterDetailPage.dart';
import 'package:gita/Screens/character.dart';
import 'package:gita/Screens/character_listscreen.dart';
import 'package:gita/Screens/chatbot.dart';
import 'dart:ui';
// 1. IMPORT DATABASE HELPER AND THE NEW MODEL
import 'package:gita/data/local/database_helper.dart'; // Make sure this is your SQLite helper file
import 'package:gita/Screens/readingpage.dart';
import 'package:gita/Screens/bookmarkscreen.dart'; // 💥 NEW IMPORT 💥
import 'package:gita/notification.dart';
import 'package:gita/verse_of_the_day.dart';

// Custom Colors based on the image's aesthetic (UNCHANGED)
const Color kPrimaryOrange = Color(0xFFE65100);
const Color kBackgroundColor = Color(0xFFF7F7F7);
const Color kDeepBlue = Color.fromARGB(255, 255, 255, 255);
const Color kHeroOverlay = Color.fromARGB(255, 255, 255, 255);
const Color kChapterNumberBg = Color(0xFFEEEEEE);

// --- Mock Data Structures (REMOVED: Old Chapter class is now in database_helper.dart) ---

// --- Mock Data for Chapters List (REMOVED) ---
// final List<Chapter> mockChapters = [...];

// --- Mock Data for Most Read Verses (KEPT, as there's no DB table for it yet) ---
class MostReadVerse {
  final String verseNumber;
  final String chapterTag;
  final String text;

  MostReadVerse(this.verseNumber, this.chapterTag, this.text);
}

final List<MostReadVerse> mockMostReadVerses = [
  MostReadVerse(
    '2.47',
    'Karma Yog',
    'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself to be the cause of the results of your activities, nor be attached to inaction.',
  ),
  MostReadVerse(
    '18.66',
    'Mokṣha Sanyāsa Yog',
    'Abandon all varieties of religion and simply surrender unto Me. I shall deliver you from all sinful reactions; do not fear.',
  ),
  MostReadVerse(
    '9.34',
    'Rāja Vidyā Rāja Guhya Yog',
    'Engage your mind always in thinking of Me, offer obeisances and just worship Me. Being completely absorbed in Me, surely you will come to Me.',
  ),
  MostReadVerse(
    '4.7',
    'Jñāna–Karma–Sanyāsa Yog',
    'Whenever there is a decline in righteousness and an increase in unrighteousness, O Arjuna, at that time I manifest Myself.',
  ),

  MostReadVerse(
    '4.8',
    'Jñāna–Karma–Sanyāsa Yog',
    'To protect the righteous, to annihilate the wicked, and to reestablish the principles of dharma, I appear millennium after millennium.',
  ),

  MostReadVerse(
    '6.5',
    'Ātma–Saṁyama Yog',
    'One must elevate oneself by one’s own mind and not degrade oneself. The mind is the friend of the conditioned soul, and his enemy as well.',
  ),

  MostReadVerse(
    '6.6',
    'Ātma–Saṁyama Yog',
    'For one who has conquered the mind, the mind is the best of friends; but for one who has failed to do so, the mind will remain the greatest enemy.',
  ),

  MostReadVerse(
    '12.15',
    'Bhakti Yog',
    'One who is not disturbed by others and who does not disturb others, who is free from fear and anxiety, is very dear to Me.',
  ),
];

// --- HOME PAGE WIDGET ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, String> todayVerse;
  int _selectedIndex = 0;
  late PageController _pageController;
  // 3. STATE VARIABLE FOR CHAPTERS
  List<Chapter> _chapters = [];
  bool _isLoading = true;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Verse? lastReadVerse;

  @override
  void initState() {
    super.initState();
    todayVerse = VerseOfTheDay.getTodayVerse();
    NotificationService.scheduleDailyVerse(
    title: 'Verse of the Day • ${todayVerse['ref']}',
    body: todayVerse['text']!,
  );
    loadLastRead();
    _pageController = PageController();
    // 4. FETCH CHAPTERS ON INIT
    _fetchChapters();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchChapters() async {
    try {
      final chapters = await _dbHelper.fetchAllChapters();
      setState(() {
        _chapters = chapters;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error, e.g., show a snackbar or log it
      print('Error fetching chapters: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadLastRead() async {
    final verse = await DatabaseHelper.instance.fetchLastReadVerse();

    setState(() {
      lastReadVerse = verse;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // 🟣 When user taps "Gita GPT" icon
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Chatbot()),
      );
      return; // prevent changing the bottom nav highlight
    }
    if (index == 2) {
      // 🟣 When user taps "Gita GPT" icon
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookmarksPage()),
      );
      return; // prevent changing the bottom nav highlight
    }
    if (index == 3) {
      // 🟣 When user taps "Gita GPT" icon
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CharacterListPage()),
      );
      return; // prevent changing the bottom nav highlight
    }

    // Normal tab switching for others
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper method to build responsive drawer items
  // Widget _buildDrawerItem(
  //   BuildContext context,
  //   IconData icon,
  //   String title,
  //   VoidCallback onTap, {
  //   bool isDestructive = false,
  // }) {
  //   return ListTile(
  //     contentPadding: EdgeInsets.symmetric(
  //       horizontal: MediaQuery.of(context).size.width * 0.05,
  //       vertical: MediaQuery.of(context).size.height * 0.005,
  //     ),
  //     leading: Icon(
  //       icon,
  //       color: isDestructive ? Colors.red : kPrimaryOrange,
  //       size: MediaQuery.of(context).size.width * 0.06,
  //     ),
  //     title: Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: MediaQuery.of(context).size.width * 0.04,
  //         fontWeight: FontWeight.w500,
  //         color: isDestructive ? Colors.red : Colors.black87,
  //       ),
  //     ),
  //     onTap: onTap,
  //   );
  // }

  // 5. UPDATED METHOD SIGNATURE TO USE THE NEW Chapter MODEL
  // Remember to import your Chapter model and ChapterDetailPage at the top of mainscreen.dart

  Widget _buildChapterCard(Chapter chapter) {
    // The UI part remains UNCHANGED, only the source of 'chapter' has changed.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: Color.fromARGB(224, 242, 146, 91),
            width: 2.0,
          ),
        ),
        child: InkWell(
          // 💥 MODIFIED ONTAP LOGIC 💥
          onTap: () {
            // Navigate to ChapterDetailPage, passing the unique chapter data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChapterDetailPage(
                  // Passing the specific chapter data to the detail page
                  chapterNumber: chapter.number,
                  chapterTitle: chapter.title,
                  chapterSummary: chapter.summary,
                ),
              ),
            );
          },
          // --------------------------
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 1. Chapter Number Circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.transparent, // 👈 No fill color
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        250,
                        144,
                        30,
                      ), // 👈 Border color
                      width: 2, // 👈 Border thickness
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${chapter.number}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(
                          255,
                          33,
                          32,
                          31,
                        ), // 👈 Match text color with border
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // 2. Chapter Title and Subtitle
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter ${chapter.number}. ${chapter.title}', // Uses chapter.title
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Uses chapter.verses and chapter.completedPercentage
                        chapter.completedPercentage > 0
                            ? '${chapter.verses} Verses • ${chapter.completedPercentage}% Completed'
                            : '${chapter.verses} Verses',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // 3. Trailing Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // --- Other Methods (UNCHANGED) ---

  Widget _buildMostReadVerseCard(MostReadVerse verse) {
    // ... (widget implementation is unchanged)
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color.fromARGB(220, 244, 134, 74),
            width: 2.0,
          ),
        ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250 - 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verse ${verse.verseNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 89, 0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          verse.chapterTag,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      verse.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildMostReadVersesSection() {
    // ... (widget implementation is unchanged)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  'Most Read Verses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: mockMostReadVerses.length,
            itemBuilder: (context, index) {
              return _buildMostReadVerseCard(mockMostReadVerses[index]);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      // 🆕 NEW APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6F00),
        elevation: 4,
        shadowColor: Colors.orange.withOpacity(0.5),
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(
        //       Icons.menu,
        //       color: Colors.white,
        //       size: 28,
        //     ),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //   ),
        // ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('🪷', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Bhagavad Gita',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Text('🪷', style: TextStyle(fontSize: 20)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // 1. HERO BANNER (MODIFIED - Removed top icons)
            // =========================================================
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: kBackgroundColor),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: bannerHeight,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kHeroOverlay.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/mainpageimage.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              230,
                              223,
                              223,
                            ).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Text(
                            '🙏 Radhe Radhe 🙏',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // =========================================================
            // 2. MAIN CONTENT AREA (UNCHANGED)
            // =========================================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Verse of the day',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // VERSE OF THE DAY CARD (UNCHANGED)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            todayVerse['ref']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryOrange,
                            ),
                          ),
                          const SizedBox(height: 8),
                           Text(
                            todayVerse['text']!,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 6,
                                shadowColor: kPrimaryOrange.withOpacity(0.5),
                              ),
                              child: const Text(
                                'Read more',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Last Read Section Heading (UNCHANGED)
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Last Read',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // LAST READ CARD (UNCHANGED)
                  if (lastReadVerse != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadingPage(
                              initialVerse:
                                  lastReadVerse!, // ✅ pass verse object
                              chapterNumber: lastReadVerse!.chapterNumber,
                              verseNumber: lastReadVerse!.verseNumber,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/teaching.jpg',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.menu_book,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BG ${lastReadVerse!.chapterNumber}.${lastReadVerse!.verseNumber}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${lastReadVerse!.translation}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          'Continue reading',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryOrange,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: kPrimaryOrange,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // CHAPTERS SECTION Heading (UNCHANGED)
                  const SizedBox(height: 30),
                  const Text(
                    'Chapters',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 6. CHAPTERS LIST (REPLACED mockChapters with conditional List)
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryOrange,
                          ),
                        ) // Show loader while fetching
                      : Column(
                          // Use Column to display the list of widgets
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _chapters
                              .map((chapter) => _buildChapterCard(chapter))
                              .toList(),
                        ),
                ],
              ),
            ),

            // =========================================================
            // 3. MOST READ VERSES SECTION (UNCHANGED)
            // =========================================================
            _buildMostReadVersesSection(),
            const SizedBox(height: 80), // 🆕 ADDED BOTTOM PADDING
          ],
        ),
      ),
      // =========================================================
      // 4. BOTTOM NAVIGATION BAR (UNCHANGED)
      // =========================================================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'Gita GPT',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Characters',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryOrange,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
