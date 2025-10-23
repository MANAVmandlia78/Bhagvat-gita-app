import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// --- NEW DATA STRUCTURE for type-safe data handling ---
class Chapter {
  final int id;
  final int number;
  final String title;
  final String titleSanskrit;
  final String summary;
  final int verses;
  final int completedPercentage;

  Chapter({
    required this.id,
    required this.number,
    required this.title,
    required this.titleSanskrit,
    required this.summary,
    required this.verses,
    this.completedPercentage = 0,
  });

  // Factory constructor to create a Chapter from a Map (database row)
  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] as int,
      number: map['chapter_number'] as int,
      title: map['chapter_name'] as String,
      titleSanskrit: map['chapter_name_sanskrit'] as String,
      summary: map['summary'] as String,
      verses: map['total_verses'] as int,
      // Ensure the default value handles null if not present, though the table defines a default
      completedPercentage: map['completed_percentage'] as int? ?? 0, 
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bhagavad_gita.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Using deleteDatabase to ensure the onCreate method (with initial inserts)
    // runs every time during development, which is safer for this case.
    // In a production app, you would use onUpgrade for schema changes.
    // For now, let's keep the original logic which relies on onCreate.

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create tables
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chapters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chapter_number INTEGER NOT NULL,
        chapter_name TEXT NOT NULL,
        chapter_name_sanskrit TEXT,
        summary TEXT,
        total_verses INTEGER NOT NULL,
        completed_percentage INTEGER DEFAULT 0
      );
    ''');

    // Populate all 18 chapters with metadata
    await _insertInitialChapters(db);
  }

  // Function to insert all chapters initially (Unchanged)
  Future<void> _insertInitialChapters(Database db) async {
    final chaptersData = [
      {
        'chapter_number': 1,
        'chapter_name': 'Arjun Viṣhād Yog',
        'chapter_name_sanskrit': 'अर्जुनविषादयोग',
        'summary': 'Arjuna’s despondency and moral confusion on the battlefield of Kurukshetra.',
        'total_verses': 47,
        'completed_percentage': 8, // Added this back from mock for demonstration
      },
      {
        'chapter_number': 2,
        'chapter_name': 'Sānkhya Yog',
        'chapter_name_sanskrit': 'सांख्ययोग',
        'summary': 'Krishna explains the eternal nature of the soul and introduces the concept of selfless action.',
        'total_verses': 72,
      },
      {
        'chapter_number': 3,
        'chapter_name': 'Karm Yog',
        'chapter_name_sanskrit': 'कर्मयोग',
        'summary': 'The path of action — Krishna advises Arjuna to act selflessly without attachment to results.',
        'total_verses': 43,
      },
      {
        'chapter_number': 4,
        'chapter_name': 'Jñāna Karma Sanyās Yog',
        'chapter_name_sanskrit': 'ज्ञानकर्मसंन्यासयोग',
        'summary': 'The Yoga of Knowledge and Renunciation of Action. Krishna explains divine knowledge and purpose of karma.',
        'total_verses': 42,
      },
      {
        'chapter_number': 5,
        'chapter_name': 'Karma Sanyās Yog',
        'chapter_name_sanskrit': 'कर्मसंन्यासयोग',
        'summary': 'The Yoga of Renunciation — Krishna explains renunciation and detachment from fruits of action.',
        'total_verses': 29,
        'completed_percentage': 55, // Added this back from mock for demonstration
      },
      {
        'chapter_number': 6,
        'chapter_name': 'Dhyān Yog',
        'chapter_name_sanskrit': 'ध्यानयोग',
        'summary': 'The Yoga of Meditation — Krishna describes discipline of the mind and meditation practices.',
        'total_verses': 47,
      },
      {
        'chapter_number': 7,
        'chapter_name': 'Jñān Vijñān Yog',
        'chapter_name_sanskrit': 'ज्ञानविज्ञानयोग',
        'summary': 'Krishna reveals his divine nature and the knowledge of both material and spiritual aspects.',
        'total_verses': 30,
      },
      {
        'chapter_number': 8,
        'chapter_name': 'Akṣhar Brahma Yog',
        'chapter_name_sanskrit': 'अक्षरब्रह्मयोग',
        'summary': 'The path to the imperishable Brahman and the process of remembering God at death.',
        'total_verses': 28,
      },
      {
        'chapter_number': 9,
        'chapter_name': 'Rājavidyā Rājaguhya Yog',
        'chapter_name_sanskrit': 'राजविद्याराजगुह्ययोग',
        'summary': 'The Yoga of Royal Knowledge and Royal Secret — the greatness of devotion to Krishna.',
        'total_verses': 34,
      },
      {
        'chapter_number': 10,
        'chapter_name': 'Vibhūti Yog',
        'chapter_name_sanskrit': 'विभूतियोग',
        'summary': 'Krishna describes his divine manifestations and opulences throughout creation.',
        'total_verses': 42,
      },
      {
        'chapter_number': 11,
        'chapter_name': 'Vishwaroop Darshan Yog',
        'chapter_name_sanskrit': 'विश्वरूपदर्शनयोग',
        'summary': 'Arjuna is granted divine vision and witnesses Krishna’s universal cosmic form.',
        'total_verses': 55,
      },
      {
        'chapter_number': 12,
        'chapter_name': 'Bhakti Yog',
        'chapter_name_sanskrit': 'भक्तियोग',
        'summary': 'The path of devotion — Krishna explains the qualities of true devotees.',
        'total_verses': 20,
      },
      {
        'chapter_number': 13,
        'chapter_name': 'Kṣhetra Kṣhetrajña Vibhaag Yog',
        'chapter_name_sanskrit': 'क्षेत्रक्षेत्रज्ञविभागयोग',
        'summary': 'Explains the field (body) and the knower of the field (soul).',
        'total_verses': 35,
      },
      {
        'chapter_number': 14,
        'chapter_name': 'Guṇatraya Vibhaag Yog',
        'chapter_name_sanskrit': 'गुणत्रयविभागयोग',
        'summary': 'Krishna describes the three modes of material nature: sattva, rajas, and tamas.',
        'total_verses': 27,
      },
      {
        'chapter_number': 15,
        'chapter_name': 'Puruṣhottam Yog',
        'chapter_name_sanskrit': 'पुरुषोत्तमयोग',
        'summary': 'The Supreme Divine Personality — Krishna describes the eternal tree of life and the ultimate reality.',
        'total_verses': 20,
      },
      {
        'chapter_number': 16,
        'chapter_name': 'Daivāsur Sampad Vibhaag Yog',
        'chapter_name_sanskrit': 'दैवासुरसम्पद्विभागयोग',
        'summary': 'The difference between divine and demoniac natures in humans.',
        'total_verses': 24,
      },
      {
        'chapter_number': 17,
        'chapter_name': 'Śhraddhātray Vibhaag Yog',
        'chapter_name_sanskrit': 'श्रद्धात्रयविभागयोग',
        'summary': 'Classification of faith and how it affects food, sacrifice, and austerity.',
        'total_verses': 28,
      },
      {
        'chapter_number': 18,
        'chapter_name': 'Mokṣha Sanyās Yog',
        'chapter_name_sanskrit': 'मोक्षसंन्यासयोग',
        'summary': 'Final teachings summarizing renunciation, knowledge, and liberation.',
        'total_verses': 78,
      },
    ];

    for (final chapter in chaptersData) {
      await db.insert('chapters', chapter);
    }
  }

  // MODIFIED: Fetch all chapters and map them to the new Chapter model
  Future<List<Chapter>> fetchAllChapters() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chapters',
      orderBy: 'chapter_number ASC',
    );
    
    // Convert the List<Map> to List<Chapter>
    return List.generate(maps.length, (i) {
      return Chapter.fromMap(maps[i]);
    });
  }

  // Close DB (Unchanged)
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}