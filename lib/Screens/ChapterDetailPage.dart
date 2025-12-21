import 'package:flutter/material.dart';
import 'package:gita/Screens/readingpage.dart';
import 'package:gita/data/local/database_helper.dart';

const Color kPrimaryOrange = Color(0xFFE65100);
const Color kBackgroundColor = Color(0xFFFAF8F5);
const Color kCardColor = Color(0xFFFFFBF5);

class ChapterDetailPage extends StatefulWidget {
  final int chapterNumber;
  final String chapterTitle;
  final String chapterSummary;

  const ChapterDetailPage({
    super.key,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.chapterSummary,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  List<Verse> _verses = [];
  bool _isLoading = true;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _fetchChapterVerses();
  }

  Future<void> _fetchChapterVerses() async {
    try {
      final verses = await _dbHelper.fetchChapterVerses(widget.chapterNumber);
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching verses for Chapter ${widget.chapterNumber}: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildVerseCard(Verse verse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReadingPage(
                  initialVerse: verse,
                  chapterNumber: widget.chapterNumber,
                  verseNumber: verse.verseNumber,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: kPrimaryOrange.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryOrange.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  kPrimaryOrange.withOpacity(0.15),
                                  kPrimaryOrange.withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${verse.verseNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kPrimaryOrange,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Verse ${verse.verseNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: Color(0xFF2C2C2C),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      if (verse.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryOrange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle, 
                                  size: 14, 
                                  color: kPrimaryOrange),
                              SizedBox(width: 4),
                              Text(
                                'Read',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryOrange,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    verse.translation,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xFF4A4A4A),
                      letterSpacing: 0.1,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryOrange.withOpacity(0.8),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: kPrimaryOrange.withOpacity(0.8),
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: Colors.white,
        title: Text(
          'Chapter ${widget.chapterNumber}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF2C2C2C),
            letterSpacing: 0.3,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, 
                color: Color(0xFF2C2C2C), 
                size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.text_fields,
                  color: Color(0xFF2C2C2C),
                  size: 20,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kPrimaryOrange.withOpacity(0.08),
                          kPrimaryOrange.withOpacity(0.03),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: kPrimaryOrange.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryOrange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'अध्याय ${widget.chapterNumber}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${widget.chapterTitle} - Lamenting the Consequences of War',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C2C2C),
                            height: 1.3,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.chapterSummary,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF4A4A4A),
                            height: 1.6,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.expand_more, size: 18),
                          label: const Text('Show more'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            foregroundColor: kPrimaryOrange,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_verses.length}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryOrange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Verses',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: 'Jump To',
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF2C2C2C),
                            size: 20,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C2C2C),
                          ),
                          underline: Container(),
                          items: <String>[
                            'Jump To',
                            'Verse 10',
                            'Verse 20',
                            'Verse 30',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.0),
                            child: CircularProgressIndicator(
                              color: kPrimaryOrange,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : (_verses.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 80.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.menu_book_outlined,
                                      size: 64,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No verses found for this chapter.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _verses
                                  .map((verse) => _buildVerseCard(verse))
                                  .toList(),
                            )),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, 
                              color: Color(0xFF2C2C2C),
                              size: 24),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chapter ${widget.chapterNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          Text(
                            '${widget.chapterTitle.split(' ').first} Yog',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, 
                          color: Color(0xFF2C2C2C),
                          size: 24),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}