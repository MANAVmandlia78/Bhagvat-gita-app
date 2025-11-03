import 'package:flutter/material.dart';
// Import the Verse model from your database helper file
import 'package:gita/data/local/database_helper.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Enhanced color palette with spiritual touch
const Color kPrimaryOrange = Color(0xFFFF6F00);
const Color kBackgroundColor = Color(0xFFFFF8E1); // Warm cream background
const Color kAccentGold = Color(0xFFFFB300);
const Color kSacredRed = Color(0xFFD84315);
const Color kTextPrimary = Color(0xFF4E342E); // Warm brown for text

class ReadingPage extends StatefulWidget {
  final Verse initialVerse;
  final int chapterNumber;

  const ReadingPage({
    super.key,
    required this.initialVerse,
    required this.chapterNumber,
  });

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  double _currentSliderValue = 0.0;
  FlutterTts flutterTts = FlutterTts();
  bool _isPlaying = false;

  late Verse _currentVerse;
  int _totalVerses = 0; // Initialized to 0, will be fetched from DB
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  bool _showHindiTranslation = false; 

  void initState() {
    super.initState();
    flutterTts.setLanguage("en-IN"); // you can use "en-US" or any other locale
    flutterTts.setPitch(0.1); // voice tone
    flutterTts.setSpeechRate(0.8); // speaking speed (0.0 - 1.0)
    _currentVerse = widget.initialVerse;
    _loadChapterMetadata(); // Load total verse count
  }

  String _getTranslationText() {
    if (_showHindiTranslation) {
      return _currentVerse.translationH;
    }
    return _currentVerse.translation;
  }

  Future<void> _loadChapterMetadata() async {
    final count = await _dbHelper.getTotalVersesInChapter(widget.chapterNumber);
    setState(() {
      _totalVerses = count;
    });
  }
void _togglePlayPause() async {
  if (_isPlaying) {
    await flutterTts.stop();
    setState(() {
      _isPlaying = false;
    });
  } else {
    setState(() {
      _isPlaying = true;
    });

    // Step 1: Speak Sanskrit (hi-IN can read Devanagari)
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(_currentVerse.sanskrit);

    flutterTts.setCompletionHandler(() async {
      if (_isPlaying) {
        await Future.delayed(const Duration(seconds: 1));

        // Step 2: Speak translation based on toggle
        if (_showHindiTranslation) {
          // Hindi translation
          await flutterTts.setLanguage("hi-IN");
          await flutterTts.setPitch(1.0);
          await flutterTts.speak(_currentVerse.translationH);
        } else {
          // English translation
          await flutterTts.setLanguage("en-IN");
          await flutterTts.setPitch(0.85);
          await flutterTts.speak(_currentVerse.translation);
        }

        flutterTts.setCompletionHandler(() async {
          if (_isPlaying) {
            await Future.delayed(const Duration(seconds: 1));

            // Step 3: Speak commentary (always in English for now)
            await flutterTts.setLanguage("en-IN");
            await flutterTts.speak(_currentVerse.commentary);

            flutterTts.setCompletionHandler(() {
              setState(() {
                _isPlaying = false;
              });
            });
          }
        });
      }
    });
  }
}


  void _seekForwardBackward(int seconds) {
    print('Seeking $seconds seconds...');
  }

  Future<void> _fetchAndSetVerse(int newVerseNumber) async {
    if (newVerseNumber < 1 || newVerseNumber > _totalVerses) {
      return; // Boundary check: should be caught by Opacity, but essential here
    }

    // Optional: Show a temporary loading indicator (or keep old text until new loads)
    // For simplicity, we fetch directly and update when ready.

    final newVerse = await _dbHelper.fetchSpecificVerse(
      widget.chapterNumber,
      newVerseNumber,
    );

    if (mounted && newVerse != null) {
      setState(() {
        _currentVerse = newVerse;
        _currentSliderValue = 0.0; // Reset audio position
      });
    } else if (mounted) {
      // Optional: Show error or toast message if verse fetch failed
      print("Failed to fetch verse ${widget.chapterNumber}.$newVerseNumber");
    }
  }

  // --- UPDATED NAVIGATION LOGIC ---
  void _nextVerse() {
    final nextNumber = _currentVerse.verseNumber + 1;
    if (nextNumber <= _totalVerses) {
      _fetchAndSetVerse(nextNumber);
    }
  }

  void _previousVerse() {
    final previousNumber = _currentVerse.verseNumber - 1;
    if (previousNumber >= 1) {
      _fetchAndSetVerse(previousNumber);
    }
  }

  // Decorative Om symbol divider
  Widget _buildOmDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: kAccentGold.withOpacity(0.5), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '🪷',
              style: TextStyle(fontSize: 20, color: kPrimaryOrange),
            ),
          ),
          Expanded(
            child: Divider(color: kAccentGold.withOpacity(0.5), thickness: 1),
          ),
        ],
      ),
    );
  }

  // Enhanced lotus divider
  Widget _buildLotusDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: kAccentGold.withOpacity(0.5), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '🪷',
              style: TextStyle(fontSize: 18, color: kSacredRed),
            ),
          ),
          Expanded(
            child: Divider(color: kAccentGold.withOpacity(0.5), thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSanskritSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade50.withOpacity(0.3), Colors.transparent],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Verse Number with decorative border
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: kAccentGold, width: 2),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Text(
              '${widget.chapterNumber}.${_currentVerse.verseNumber}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryOrange,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Sanskrit Text with enhanced styling
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: kAccentGold.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryOrange.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _currentVerse.sanskrit,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Sanskrit',
                height: 2.0,
                color: kTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          _buildOmDivider(),
        ],
      ),
    );
  }

  Widget _buildAudioControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccentGold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade50,
                ),
                child: IconButton(
                  icon: const Icon(Icons.replay_5),
                  iconSize: 28,
                  color: kPrimaryOrange,
                  onPressed: () => _seekForwardBackward(-5),
                ),
              ),
              const SizedBox(width: 20),

              // Main Play/Pause Button with enhanced design
              InkWell(
                onTap: _togglePlayPause,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kPrimaryOrange, kSacredRed],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryOrange.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Forward button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade50,
                ),
                child: IconButton(
                  icon: const Icon(Icons.forward_5),
                  iconSize: 28,
                  color: kPrimaryOrange,
                  onPressed: () => _seekForwardBackward(5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Enhanced slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              thumbColor: kPrimaryOrange,
              activeTrackColor: kPrimaryOrange,
              inactiveTrackColor: kAccentGold.withOpacity(0.3),
            ),
            child: Slider(
              value: _currentSliderValue,
              min: 0,
              max: 100,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),

          // Time Labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:00',
                  style: TextStyle(
                    fontSize: 13,
                    color: kTextPrimary.withOpacity(0.7),
                  ),
                ),
                Text(
                  '00:00',
                  style: TextStyle(
                    fontSize: 13,
                    color: kTextPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordMeaningsSection() {
    final Map<String, String> wordMeanings = _currentVerse.wordMeaning
        .split(';')
        .where((s) => s.contains('—'))
        .fold({}, (map, element) {
          final parts = element.split('—');
          if (parts.length == 2) {
            map[parts[0].trim()] = parts[1].trim();
          }
          return map;
        });

    return Column(
      children: [
        _buildLotusDivider(),

        // Header with decorative elements
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
            const SizedBox(width: 12),
            const Text(
              'Word Meanings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPrimaryOrange,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
          ],
        ),

        const SizedBox(height: 25),

        // Word meanings in a card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kAccentGold.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: wordMeanings.entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 16,
                            color: kAccentGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: kTextPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryOrange,
                                  ),
                                ),
                                const TextSpan(text: ' — '),
                                TextSpan(text: entry.value),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationSection() {
     // Determine header text and content based on toggle state
    final headerText = _showHindiTranslation ? 'हिन्दी अनुवाद' : 'English Translation';
    final contentText = _showHindiTranslation ? _currentVerse.translationH : _currentVerse.translation;
    final headerColor = _showHindiTranslation ? kSacredRed : kPrimaryOrange;
    return Column(
      children: [
        _buildLotusDivider(),

        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
            const SizedBox(width: 12),
            const Text(
              'Translation',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPrimaryOrange,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
          ],
        ),

        const SizedBox(height: 25),

        // Translation text in card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kAccentGold.withOpacity(0.3), width: 1),
          ),
          child: Text(
            contentText,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, height: 1.8, color: kTextPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentarySection() {
    return Column(
      children: [
        _buildLotusDivider(),

        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
            const SizedBox(width: 12),
            const Text(
              'Commentary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPrimaryOrange,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Text('✦', style: TextStyle(color: kAccentGold, fontSize: 16)),
          ],
        ),

        const SizedBox(height: 25),

        // Commentary text in card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: kAccentGold.withOpacity(0.3), width: 1),
          ),
          child: Text(
            _currentVerse.commentary,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, height: 1.8, color: kTextPrimary),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBottomVerseNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: kAccentGold.withOpacity(0.3), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Verse Button
          Opacity(
            opacity: _currentVerse.verseNumber > 1 ? 1.0 : 0.3,
            child: Container(
              decoration: BoxDecoration(
                color: _currentVerse.verseNumber > 1
                    ? Colors.orange.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 28),
                color: kPrimaryOrange,
                onPressed: _currentVerse.verseNumber > 1
                    ? _previousVerse
                    : null,
              ),
            ),
          ),

          // Current Verse Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccentGold.withOpacity(0.5), width: 1),
            ),
            child: Text(
              'Verse ${_currentVerse.verseNumber}/$_totalVerses',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimaryOrange,
              ),
            ),
          ),

          // Next Verse Button
          Opacity(
            opacity: _currentVerse.verseNumber < _totalVerses ? 1.0 : 0.3,
            child: Container(
              decoration: BoxDecoration(
                color: _currentVerse.verseNumber < _totalVerses
                    ? Colors.orange.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 28),
                color: kPrimaryOrange,
                onPressed: _currentVerse.verseNumber < _totalVerses
                    ? _nextVerse
                    : null,
              ),
            ),
          ),
        ],
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: kAccentGold.withOpacity(0.3), width: 2),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: kTextPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chapter ${widget.chapterNumber}',
              style: const TextStyle(
                color: kPrimaryOrange,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
  icon: Text(
    _showHindiTranslation ? 'T' : 'अ', // toggle text
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: kPrimaryOrange,
    ),
  ),
  onPressed: () {
    setState(() {
      _showHindiTranslation = !_showHindiTranslation;
    });
  },
),

          IconButton(
            icon: const Icon(Icons.bookmark_border, color: kPrimaryOrange),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildSanskritSection(),
            const SizedBox(height: 10),
            _buildAudioControls(),
            _buildWordMeaningsSection(),
            _buildTranslationSection(),
            _buildCommentarySection(),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomVerseNavigation(),
    );
  }
}
