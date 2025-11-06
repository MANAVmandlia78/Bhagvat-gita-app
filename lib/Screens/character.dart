import 'package:flutter/material.dart';
// ❗ IMPORTANT: Make sure this import path points to your Character model!
import 'package:gita/data/local/database_helper.dart'; 

const Color kPrimaryOrange = Color(0xFFFF6F00);
const Color kBackgroundColor = Color(0xFFFFF8E1);
const Color kAccentGold = Color(0xFFFFB300);
const Color kSacredRed = Color(0xFFD84315);
const Color kTextPrimary = Color(0xFF4E342E);

class CharacterPage extends StatelessWidget {
  // 1. 🎯 Define a final field to hold the Character data
  final Character character;

  // 2. 🎯 Update the constructor to require a Character object
  const CharacterPage({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        // 3. 🎯 Use the character's name for the AppBar title
        title: Text(
          character.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Sacred Image with decorative frame
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kAccentGold.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // Image container with border
                Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: kAccentGold,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    // 4. 🎯 Use the character's image path
                    child: Image.asset(
                      character.imagePath.trim(), // Use .trim() for safety
                      fit: BoxFit.cover,
                       errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.broken_image, size: 50, color: kSacredRed),
                          );
                        },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Lotus Divider
            _buildLotusDivider(),

            const SizedBox(height: 20),

            // Character Name (The section below the image is redundant if it's in the AppBar, but using data)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryOrange,
                    kAccentGold,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryOrange.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                // 5. 🎯 Use the character's name
                character.name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildLotusDivider(),
            const SizedBox(height: 20),

            // Character Summary Section
            _buildSection(
              title: 'Character Summary',
              // 6. 🎯 Use the character's summary
              content: character.summary,
            ),

            const SizedBox(height: 20),
            _buildLotusDivider(),
            const SizedBox(height: 20),

            // Role Description Section
            _buildSection(
              title: 'Role in Gita / Mahabharata',
              // 7. 🎯 Use the character's role
              content: character.role,
            ),

            const SizedBox(height: 20),
            _buildLotusDivider(),
            const SizedBox(height: 20),

            // Key Lessons Section
            _buildSection(
              title: 'Key Lessons',
              // 8. 🎯 Use the character's key lessons
              content: character.keyLessons,
            ),

            const SizedBox(height: 30),

            // Lotus Divider
            _buildLotusDivider(),

            const SizedBox(height: 25),

            // Sacred Quote
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kSacredRed.withOpacity(0.1),
                    kPrimaryOrange.withOpacity(0.15),
                    kAccentGold.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: kSacredRed.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '🪷',
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(height: 12),
                  Text(
                    // 9. 🎯 Use the character's quote
                    '"${character.quote}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                      color: kSacredRed,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: kAccentGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      // 10. 🎯 Use the quote chapter
                      '– Bhagavad Gita ${character.quoteChapter}',
                      style: TextStyle(
                        fontSize: 14,
                        color: kTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper methods remain the same
  Widget _buildLotusDivider() {
    // ... (Your existing _buildLotusDivider code)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  kAccentGold.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('🪷', style: TextStyle(fontSize: 24)),
        ),
        Expanded(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  kAccentGold.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required String content}) {
    // ... (Your existing _buildSection code)
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kAccentGold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryOrange.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kSacredRed, kPrimaryOrange],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kSacredRed,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: kTextPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}