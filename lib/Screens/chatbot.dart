import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  TextEditingController searchController = TextEditingController();
  String res = "";
  bool isLoading = false;
  List<Map<String, String>> messages = []; // chat bubbles

  Future<void> getResponse() async {
    if (searchController.text.isEmpty) return;

    setState(() {
      isLoading = true;
      messages.add({"role": "user", "text": searchController.text});
    });

    String apiKey =
        "AIzaSyC9ZVxBgj4wxOr3KakmhFlLzPCiIoeeF7w"; // 🔒 use your Gemini key
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

    // Krishna persona
    String persona = """
You are Lord Krishna from the Bhagavad Gita.
Speak with calmness and divine wisdom, as if guiding Arjuna on the battlefield.
Give short, meaningful answers — no longer than 5 to 10 lines.
Use poetic, spiritual English with light Sanskrit influence (like dharma, karma, atma, etc.).
Keep your tone peaceful, compassionate, and full of insight.
""";

    Map<String, dynamic> bodyParams = {
      "contents": [
        {
          "parts": [
            {"text": "$persona\n\nUser: ${searchController.text}"},
          ],
        },
      ],
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyParams),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        res = data['candidates'][0]['content']['parts'][0]["text"];
        setState(() {
          messages.add({"role": "bot", "text": res});
        });
      } else {
        setState(() {
          messages.add({
            "role": "bot",
            "text":
                "I sense a disturbance, dear one. The response could not be received.",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "text": "Something went wrong: $e"});
      });
    }

    setState(() {
      isLoading = false;
      searchController.clear();
    });
  }

  // --- Start of Responsiveness Changes ---

  @override
  Widget build(BuildContext context) {
    // Determine the screen width for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    // Define a max width for large screens (e.g., tablets/desktop)
    final bool isWideScreen = screenWidth > 600;
    const double maxWidth = 800;
    
    // For the welcome message image
    final double imageSize = isWideScreen ? 250 : 200;
    final double welcomeTextSize = isWideScreen ? 24 : 22;


    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 8),
            Text(
              "श्रीकृष्ण सन्देश",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42), Color(0xFFFFA500)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Center( // Center the whole chat UI on wide screens
        child: Container(
          width: isWideScreen ? maxWidth : screenWidth, // Max width constraint
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF8F0), Color(0xFFFFE4CC), Color(0xFFFFF0E0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Decorative top border with Om symbol
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFFFA500),
                      Color(0xFFFF6B35),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: SingleChildScrollView( // Allow scrolling if the content is too tall
                          padding: EdgeInsets.all(isWideScreen ? 40 : 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isWideScreen ? 25 : 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B35).withOpacity(0.2),
                                      Color(0xFFFFA500).withOpacity(0.2),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  height: imageSize, // Responsive image size
                                  width: imageSize,   // Responsive image size
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/Bhagvat Gita app.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isWideScreen ? 30 : 20),
                              Text(
                                "Welcome, Dear Seeker",
                                style: TextStyle(
                                  fontSize: welcomeTextSize, // Responsive text size
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD84315),
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 60 : 40),
                                child: Text(
                                  "Ask Lord Krishna for divine guidance\nand wisdom from the Bhagavad Gita",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.brown.shade600,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          bool isUser = msg['role'] == "user";
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              // Limit the chat bubble width to 80% of its parent container (which is already max-width limited)
                              constraints: BoxConstraints(
                                maxWidth: (isWideScreen ? maxWidth : screenWidth) * 0.8, 
                              ),
                              decoration: BoxDecoration(
                                gradient: isUser
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B35),
                                          Color(0xFFFF8C42),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isUser ? null : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: isUser
                                      ? Radius.circular(20)
                                      : Radius.circular(4),
                                  bottomRight: isUser
                                      ? Radius.circular(4)
                                      : Radius.circular(20),
                                ),
                                border: isUser
                                    ? null
                                    : Border.all(
                                        color: Color(0xFFFFB84D).withOpacity(0.3),
                                        width: 2,
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isUser
                                        ? Color(0xFFFF6B35).withOpacity(0.3)
                                        : Colors.orange.shade200.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (!isUser)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "🪷",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "श्रीकृष्ण",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFD84315),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  msg['role'] == "bot"
                                      ? GptMarkdown(
                                          msg['text'] ?? '',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.brown.shade800,
                                            fontStyle: FontStyle.italic,
                                            height: 1.5,
                                          ),
                                        )
                                      : Text(
                                          msg['text'] ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Krishna is responding...",
                        style: TextStyle(
                          color: Color(0xFFD84315),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              // Input area
              Container(
                width: double.infinity, // Take full width of its parent (max-width limited container)
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade200.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF8F0),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xFFFFB84D).withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.brown.shade800,
                          ),
                          decoration: InputDecoration(
                            hintText: "Seek Krishna's wisdom...",
                            hintStyle: TextStyle(
                              color: Colors.brown.shade400,
                              fontStyle: FontStyle.italic,
                            ),
                            filled: false,
                            prefixIcon: Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFFFF6B35),
                              size: 24,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFFA500)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF6B35).withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.white),
                        iconSize: 22,
                        onPressed: getResponse,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}