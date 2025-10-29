import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gita/Screens/loginscreen.dart'; // Required for BackdropFilter and ImageFilter

// --- Utility Classes and Colors ---

// The primary orange color from the previous bottom navigation bar, used for consistency.
const Color kPrimaryOrange = Color(0xFFE65100); 

// Placeholder screen for the 'Continue' button navigation
class MainContentScreenPlaceholder extends StatelessWidget {
  const MainContentScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Content')),
      body: const Center(
        child: Text(
          'You successfully continued! This is where the chapter list would be.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }
}

// --- HOME SCREEN WIDGET (The new welcome screen) ---
class HomeScreen extends StatelessWidget {
  // Since we removed the bottom navigation bar and its state, we can make this stateless again.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get safe area padding (e.g., notch height)
    final safePaddingTop = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      // Set Scaffold background to transparent or black for the image to show correctly
      // Note: Setting a color on Scaffold is important if the image asset fails to load.
      backgroundColor: Colors.black,
      
      // Removed BottomNavigationBar
      body: Stack(
        children: [
          // 1. FULL SCREEN BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              // Using the file name from your previous request, assuming this image is the one
              // you want to use for the new background.
              'assets/images/home_page.jpg', 
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.orange.shade800,
                  alignment: Alignment.center,
                  child: Text(
                    "Image not loaded. Ensure 'assets/images/home page.jpg' is correctly added.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                  ),
                );
              },
            ),
          ),

          // 2. DARK GRADIENT OVERLAY for Text Readability (Bottom Half)
          // Creates the fade from the image color to dark for the white text.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0), // Transparent at the top
                    Colors.black.withOpacity(0.4), // Subtle darkening in the middle
                    Colors.black.withOpacity(0.7), // Darkest at the very bottom
                  ],
                  stops: const [0.5, 0.75, 1.0], // Starts darkening slightly lower
                ),
              ),
            ),
          ),

          // 3. MAIN CONTENT (Text and Button)
          // 💡 Removed the height buffer for the bottom nav bar.
          Padding(
            padding: EdgeInsets.only(top: safePaddingTop, left: 32, right: 32, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Empty space at the top to position content near the bottom
                const Spacer(flex: 3), // Increased spacer flex to push content lower

                // Large Title Text
                const Text(
                  "Welcome to the Gita App",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    // height: 1.2,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Subtitle/Description Text
                const Text(
                  "Begin exploring Krishna's divine wisdom with beautiful translations, commentary, and verse-by-verse audio guidance.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    height: 1.4,
                    shadows: [
                      Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1))
                    ],
                  ),
                ),
                
                SizedBox(
                  height: 20,
                ),
                 // Ensures proper spacing before the button

                // "Continue" CTA Button (Full Width, Orange)
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the main content after the welcome screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(220, 158, 123, 241), // Deep Orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                      shadowColor: const Color.fromARGB(220, 158, 123, 241).withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}