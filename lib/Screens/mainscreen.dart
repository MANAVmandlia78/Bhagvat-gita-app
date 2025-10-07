import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:gita/Screens/readingpage.dart'; // Required for ImageFilter and BackdropFilter

// Custom Colors based on the image's aesthetic
const Color kPrimaryOrange = Color(0xFFE65100); // Deep Orange for buttons
const Color kBackgroundColor = Color(0xFFF7F7F7); // Light gray background
const Color kDeepBlue = Color.fromARGB(
  255,
  255,
  255,
  255,
  ); // Deep blue for the banner
const Color kHeroOverlay = Color.fromARGB(
  255,
  255,
  255,
  255,
  ); // Even deeper blue/indigo for overlay
const Color kChapterNumberBg = Color(
  0xFFEEEEEE,
  ); // Light background for number circle

// --- Mock Data Structures ---
class Chapter {
  final int number;
  final String title;
  final int verses;
  final int completedPercentage;

  Chapter(this.number, this.title, this.verses, {this.completedPercentage = 0});
}

class MostReadVerse {
  final String verseNumber;
  final String chapterTag;
  final String text;

  MostReadVerse(this.verseNumber, this.chapterTag, this.text);
}

// --- Mock Data for Chapters List ---
final List<Chapter> mockChapters = [
  Chapter(1, 'Arjun Viṣhād Yog', 47, completedPercentage: 8),
  Chapter(2, 'Sānkhya Yog', 72),
  Chapter(3, 'Karm Yog', 43),
  Chapter(4, 'Jñāna Karma Sanyās Yog', 42),
  Chapter(5, 'Karma Sanyās Yog', 29, completedPercentage: 55),
  Chapter(6, 'Dhyāna Yog', 47),
  Chapter(7, 'Jñāna Vijñāna Yog', 30),
  Chapter(8, 'Akṣhara Brahma Yog', 28),
  Chapter(9, 'Rāja Vidyā Rāja Guhya Yog', 34),
  Chapter(10, 'Vibhūti Yog', 42),
  Chapter(11, 'Viśhwarūp Darśhan Yog', 55),
  Chapter(12, 'Bhakti Yog', 20),
  Chapter(13, 'Kṣhetra Kṣhetrajña Vibhāga Yog', 35),
  Chapter(14, 'Guṇatraya Vibhāga Yog', 27),
  Chapter(15, 'Puruṣhottama Yog', 20),
  Chapter(16, 'Daivāsura Sampad Vibhāga Yog', 24),
  Chapter(17, 'Śhraddhātraya Vibhāga Yog', 28),
  Chapter(18, 'Mokṣha Sanyāsa Yog', 78),
];

// --- Mock Data for Most Read Verses ---
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
];

// --- HOME PAGE WIDGET (This is the main screen content) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // State for the bottom navigation bar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you would navigate to different screens here.
  }

  // --- UNIFORM STYLING WIDGET: Build a single Chapter Card ---
  Widget _buildChapterCard(Chapter chapter) {
    // Styling is now uniform, regardless of chapter.completedPercentage

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        // No Shadow/Elevation
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          // Subtle orange border (Used a lighter shade in the original, keeping it for this section)
          side: const BorderSide(
            color: Color.fromARGB(224, 242, 146, 91),
            width: 2.0,
            ),
          ),
        child: InkWell(
          onTap: () {
            // Action to navigate to the chapter details page ReadingPage()

            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReadingPage()),
                      );
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 1. Chapter Number Circle (Uniform light gray filled background)
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // Uniform light orange fill
                    color: Color.fromARGB(255, 243, 163, 78),
                    ),
                  child: Center(
                    child: Text(
                      '${chapter.number}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        // Uniform dark text color
                        color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),

                // 2. Chapter Title and Subtitle
                // Using Flexible and FractionallySizedBox to ensure text responsiveness and prevent overflow
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chapter Title: Wrapped with Flexible/FractionallySizedBox for very long titles if needed, but Expanded above should handle it.
                      // The main point is to ensure the title itself handles overflow with ellipsis.
                      Text(
                        'Chapter ${chapter.number}. ${chapter.title}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF333333),
                          ),
                        maxLines: 1, // Ensure title does not wrap to avoid height issues
                        overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        // Displaying completion status if available, but without styling it orange
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
                const SizedBox(width: 10), // Added spacing for responsiveness

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

  // --- UPDATED WIDGET: Build a single Most Read Verse Card for the horizontal list ---
  Widget _buildMostReadVerseCard(MostReadVerse verse) {
    // The width is set to take up about 85% of the screen width for the scrollable effect
    final cardWidth = MediaQuery.of(context).size.width * 0.85;
    // The height is defined by the parent SizedBox, but we need to pass that constraint down.

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // 💡 ADDED ORANGE BORDER HERE
          side: const BorderSide(
            color: Color.fromARGB(220, 244, 134, 74), // Use the main orange color
            width: 2.0,
            ),
          ),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            // 💡 FIX: Constrain the inner Column's height to prevent the Expanded widget from overflowing.
            // Since the parent SizedBox in _buildMostReadVersesSection is 250, we use that for the ConstrainedBox.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250 - 40), // 250 (SizedBox height) - 40 (Card Padding top/bottom)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top: Verse Number and Chapter Tag
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
                      // Chapter Tag Button/Pill
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

                  // Middle: Verse Text - This is what causes the overflow
                  Expanded(
                    child: Text(
                      verse.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Colors.black87,
                        ),
                      // 💡 FIX: MaxLines and overflow is essential for long text in an Expanded widget
                      // when its parent is constrained in a scrollable view.
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

  // --- Most Read Verses Section (Fixed the structure to prevent possible header-row overflow) ---
  Widget _buildMostReadVersesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 💡 FIX: Use Flexible/Expanded for the Title to prevent overflow on very small screens
              const Flexible(
                child: Text(
                  'Most Read Verses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333333),
                    ),
                  // Added maxLines and overflow for responsiveness
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

        // Horizontal Scrollable List
        SizedBox(
          // Define a fixed height for the horizontal list view (This is good practice)
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
    // Determine the height of the banner (e.g., 35% of screen height)
    final double bannerHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: kBackgroundColor, // Set scaffold background to match
      // The body is a scrollable view
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // 1. HERO BANNER (Top Section with Curve) - INLINE WIDGET TREE
            // =========================================================
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: kBackgroundColor),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Background Image Container
                  Container(
                    height: bannerHeight,
                    decoration: BoxDecoration(
                      // Using a large radius for the curve at the bottom corners
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
                      // Local Asset Image
                      image: const DecorationImage(
                        // NOTE: This will fail if the image is not present, but the structure is correct.
                        image: AssetImage('assets/images/mainpageimage.jpg'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        ),
                      ),
                    ),

                  // Top Navigation Icons and Banner Text
                  Positioned(
                    // 💡 FIX: Increased top padding for better safe area support
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Icon (Dark Mode)
                        IconButton(
                          icon: const Icon(
                            Icons.nightlight_round,
                            color: Color.fromARGB(200, 255, 255, 255),
                            size: 28,
                            ),
                          onPressed: () {},
                          ),

                        // Center Banner Text: "Radhe Radhe" with GLASSMORHPISM EFFECT
                        ClipRRect(
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
                                '🙏 Radhe Radhe Manav 🙏',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Right Icon (Language)
                        const Text(
                          'अ',
                          style: TextStyle(
                            color: Color.fromARGB(200, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            ),
                          ),
                      ],
                      ),
                    ),
                ],
                ),
              ),
            // =========================================================
            // 2. MAIN CONTENT AREA (Verse of the Day & Last Read)
            // =========================================================
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10), // Padding below the curve
                  // Verse of the Day Heading
                  const Text(
                    'Verse of the day',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF333333),
                      ),
                    ),
                  const SizedBox(height: 15),

                  // VERSE OF THE DAY CARD - INLINE WIDGET TREE (Unchanged)
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
                          // Verse Number
                          const Text(
                            'BG 6.19',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryOrange,
                              ),
                            ),
                          const SizedBox(height: 8),

                          // Verse Text
                          const Text(
                            'Just as a lamp in a windless place does not flicker, so the disciplined mind of a yogi remains steady in meditation on the Supreme.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: Colors.black87,
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Read More Button
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

                  // Last Read Section Heading
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
                      // Last Read Timestamp
                      const Text(
                        '3 days ago',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                          ),
                        ),
                    ],
                    ),
                  const SizedBox(height: 8),

                  // LAST READ CARD
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left: Image Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              // NOTE: This will fail if the image is not present, but the structure is correct.
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

                          // Right: Text Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Verse Number
                                const Text(
                                  'BG 1.1',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    ),
                                  ),
                                const SizedBox(height: 4),

                                // Verse Text Snippet
                                const Text(
                                  'Dhritarashtra said: O Sanjay, after gather...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 8),

                                // Continue Reading Link
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
                  // *** END LAST READ CARD ***

                  // CHAPTERS SECTION
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

                  // CHAPTERS LIST (Rendered using the enhanced _buildChapterCard method)
                  // 💡 FIX: The map/toList is fine here since the list is inside the SingleChildScrollView
                  ...mockChapters
                      .map((chapter) => _buildChapterCard(chapter))
                      .toList(),
                ],
                ),
              ),

            // =========================================================
            // 3. MOST READ VERSES SECTION
            // =========================================================
            // 💡 FIX: Removed the Padding here as the internal section handles its own horizontal padding
            _buildMostReadVersesSection(),
            const SizedBox(
              height: 50,
              ), // Extra space at the bottom to clear nav bar
          ],
          ),
        ),
      // =========================================================
      // 4. BOTTOM NAVIGATION BAR - INLINE WIDGET TREE
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
              icon: Icon(Icons.settings),
              label: 'Settings',
              ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryOrange, // Orange for active item
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed, // Ensure all items are visible
          onTap: _onItemTapped,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
  }
}