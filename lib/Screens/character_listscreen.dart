import 'package:flutter/material.dart';
import 'package:gita/Screens/character.dart';
import 'package:gita/data/local/database_helper.dart';

// Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6F00);
const Color kBackgroundColor = Color(0xFFFFF8E1);
const Color kAccentGold = Color(0xFFFFB300);
const Color kSacredRed = Color(0xFFD84315);
const Color kTextPrimary = Color(0xFF4E342E);

// --- Character List Page Widget ---
class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    // Load character data when the widget is created
    _charactersFuture = DatabaseHelper.instance.fetchAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Gita Characters',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kPrimaryOrange,
                kSacredRed,
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching data
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryOrange),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading Characters...',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // Show an error message if something went wrong
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: kSacredRed),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading characters',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message if no data is found
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: kAccentGold),
                  const SizedBox(height: 16),
                  Text(
                    'No characters found in the database.',
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Data is successfully loaded
          final characters = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return _CharacterListTile(character: character);
            },
          );
        },
      ),
    );
  }
}

// --- Custom Character ListTile Widget ---
class _CharacterListTile extends StatelessWidget {
  final Character character;
  
  // Define the maximum number of lines for the summary before it shows '...'
  static const int _maxSummaryLines = 3;

  const _CharacterListTile({required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            kBackgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimaryOrange.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterPage(character: character), // 👈 Pass the object here!
          ),
        );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ⬅️ IMAGE ON THE LEFT ⬅️
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [kAccentGold, kPrimaryOrange],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryOrange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.asset(
                        character.imagePath.trim(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: kBackgroundColor,
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: kPrimaryOrange,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 14),
                
                // Character Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Character Name
                      Text(
                        character.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kTextPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      
                      const SizedBox(height: 5),
                      
                      // Character Summary
                      Text(
                        character.summary,
                        maxLines: _maxSummaryLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kTextPrimary.withOpacity(0.75),
                          fontSize: 14,
                          height: 1.4,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: kAccentGold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}