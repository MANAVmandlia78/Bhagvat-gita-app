import 'package:flutter/material.dart';

// Use the primary color defined in previous files for consistency
const Color kPrimaryOrange = Color(0xFFE65100); 
const Color kBackgroundColor = Color(0xFFF7F7F7); // Light background

// Mock data for the current verse
const int currentChapter = 1;
const int currentVerse = 1;
const int totalVerses = 47;
const String sanskritText = 'धृतराष्ट्र उवाच |\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सव: |\nमामका: पाण्डवाश्चैव किमकुर्वत सञ्जय ||1||';
const String transliterationText = 
  'dhṛtarāṣṭra uvāca |\n'
  'dharma-kṣhetre kuru-kṣhetre samavetā yuyutsavaḥ |\n'
  'māmakāḥ pāṇḍavāśhchaiva kimakurvata sañjaya ||1||';
const String translationText = 
  'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?';
const String commentaryText = 
  'The two armies had gathered on the battlefield of Kurukshetra, well prepared to fight a war that was inevitable. Still, in this verse, King Dhritarashtra asked Sanjay, what his sons and his brother Pandu’s sons were doing on the battlefield? It was apparent that they would fight, then why did he ask such a question?\n\n'
  'The blind King Dhritarashtra\'s fondness for his own sons had clouded his spiritual wisdom and deviated him from the path of virtue. He had usurped the kingdom of Hastinapur from the rightful heirs; the Pandavas, sons of his brother Pandu. Feeling guilty of the injustice...';


// Mock data for Word Meanings
final Map<String, String> wordMeanings = {
  'dhṛtarāṣṭraḥ uvāca': 'Dhṛtarāṣhṭra said;',
  'dharma-kṣhetre': 'the land of dharma;',
  'kuru-kṣhetre': 'at Kurukṣhetra;',
  'samavetāḥ': 'having gathered;',
  'yuyutsavaḥ': 'desiring to fight;',
  'māmakāḥ': 'my sons;',
  'pāṇḍavāḥ': 'the sons of Pandu;',
  'cha': 'and;',
  'eva': 'certainly;',
  'kim': 'what;',
  'akurvata': 'did they do;',
  'sañjaya': 'Sanjay;',
};


class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  // Mock state for audio player
  double _currentSliderValue = 0.0;
  bool _isPlaying = false;
  int _currentVerseIndex = currentVerse;

  // Mock audio player logic (not functional, just UI state)
  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekForwardBackward(int seconds) {
    // In a real app, this would control the audio player position
    print('Seeking $seconds seconds...');
  }
  
  void _nextVerse() {
    setState(() {
      _currentVerseIndex = (_currentVerseIndex % totalVerses) + 1;
    });
  }

  void _previousVerse() {
    setState(() {
      _currentVerseIndex = _currentVerseIndex == 1 ? totalVerses : _currentVerseIndex - 1;
    });
  }

  // Widget to display the Sanskrit text and its separator
  Widget _buildSanskritSection() {
    return Column(
      children: [
        // Verse Number
        Text(
          '$currentChapter.$_currentVerseIndex',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        // Sanskrit Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            sanskritText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Sanskrit', // Using a generic font name
              height: 1.8,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Decorative Separator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Divider(color: Colors.brown.shade200, thickness: 1),
        ),
      ],
    );
  }
  
  // Widget to display the audio controls section
  Widget _buildAudioControls() {
    return Column(
      children: [
        // Play/Pause and Seek Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rewind 5 seconds
            IconButton(
              icon: const Icon(Icons.replay_5),
              iconSize: 30,
              color: Colors.grey.shade600,
              onPressed: () => _seekForwardBackward(-5),
            ),
            const SizedBox(width: 20),

            // Main Play/Pause Button
            InkWell(
              onTap: _togglePlayPause,
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryOrange,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryOrange.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
            
            // Forward 5 seconds
            IconButton(
              icon: const Icon(Icons.forward_5),
              iconSize: 30,
              color: Colors.grey.shade600,
              onPressed: () => _seekForwardBackward(5),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Time Slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                ),
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 100, // Mock max duration
                  activeColor: kPrimaryOrange,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              
              // Time Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:00', // Mock Current Time
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  Text(
                    '00:00', // Mock Total Duration
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        
        // Separator below audio controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Divider(color: Colors.brown.shade200, thickness: 1),
        ),
      ],
    );
  }

  // Widget to display the Transliteration section
  Widget _buildTransliterationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Transliteration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            transliterationText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 30),

          // Decorative Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: Colors.brown.shade200, thickness: 1),
          ),
        ],
      ),
    );
  }

  // Word Meanings Section (Padded and Centered List)
Widget _buildWordMeaningsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 30),

      // Header
      const Text(
        'Word Meanings',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 20),

      // Centered Content
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...wordMeanings.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ✅ shrink to content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Word (Orange)
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryOrange,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Separator/Dash
                    const Text(
                      '—',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(width: 6),

                    // Meaning (Black/Grey)
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 30),

      // Decorative Separator
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Divider(color: Colors.brown.shade200, thickness: 1),
      ),
    ],
  );
}
  // --- NEW WIDGET: Translation Section ---
  Widget _buildTranslationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Translation',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87, 
            ),
          ),
          const SizedBox(height: 20),

          Text(
            translationText,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 30),

          // Decorative Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: Colors.brown.shade200, thickness: 1),
          ),
        ],
      ),
    );
  }

  // --- NEW WIDGET: Commentary Section ---
  Widget _buildCommentarySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Commentary',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87, 
            ),
          ),
          const SizedBox(height: 20),

          Text(
            commentaryText,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
          // No bottom separator or padding needed here, as the content ends the scroll view
        ],
      ),
    );
  }


  // Widget for the bottom verse navigation bar
  Widget _buildBottomVerseNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Verse Button
          Opacity(
            opacity: _currentVerseIndex > 1 ? 1.0 : 0.4,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 30),
              color: Colors.black87,
              onPressed: _currentVerseIndex > 1 ? _previousVerse : null,
            ),
          ),
          
          // Current Verse Indicator
          Text(
            'Verse $_currentVerseIndex/$totalVerses',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Font Size Icon (Placeholder)
          const Icon(Icons.font_download_outlined, color: Colors.black87, size: 24),
          
          // Next Verse Button
          Opacity(
            opacity: _currentVerseIndex < totalVerses ? 1.0 : 0.4,
            child: IconButton(
              icon: const Icon(Icons.chevron_right, size: 30),
              color: Colors.black87,
              onPressed: _currentVerseIndex < totalVerses ? _nextVerse : null,
            ),
          ),
          
          // Font Settings Button
          const Text(
            'aA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimaryOrange,
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
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            // Navigator.pop(context); // Close the reading page (assuming this is used for navigation)
          },
        ),
        title: Text(
          'Chapter $currentChapter',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Icon for changing script/language (Placeholder for 'अ')
          IconButton(
            icon: const Text('अ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              // Action for bookmarking
            },
          ),
        ],
      ),
      
      // Main content is scrollable
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            
            // Sanskrit Verse Section
            _buildSanskritSection(),

            // Audio Controls Section
            _buildAudioControls(),
            
            // Transliteration Section
            _buildTransliterationSection(),

            // Word Meanings Section
            _buildWordMeaningsSection(),
            
            // NEW SECTION: Translation
            _buildTranslationSection(),

            // NEW SECTION: Commentary
            _buildCommentarySection(),

            // Final Spacing above bottom navigation
            const SizedBox(height: 50), 
          ],
        ),
      ),
      
      // Bottom Navigation for verse movement
      bottomNavigationBar: _buildBottomVerseNavigation(),
    );
  }
}
