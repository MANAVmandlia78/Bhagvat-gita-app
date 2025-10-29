import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// --- NEW MODEL CLASS for Verses ---
class Verse {
  final int id;
  final int verseNumber;
  final String sanskrit;
  final String translation;
  final String wordMeaning;
  final String commentary;
  final bool isRead; // Added for UI state demonstration

  Verse({
    required this.id,
    required this.verseNumber,
    required this.sanskrit,
    required this.translation,
    required this.wordMeaning,
    required this.commentary,
    this.isRead = false, // Set a default value
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    return Verse(
      id: map['id'] as int,
      verseNumber: map['verse_number'] as int,
      sanskrit: map['sanskrit'] as String,
      translation: map['translation'] as String,
      wordMeaning: map['word_meaning'] as String,
      commentary: map['commentary'] as String,
      // Assuming 'is_read' is not in DB yet, setting default for UI
      isRead: map['is_read'] == 1,
    );
  }
}

// --- MODEL CLASS for Chapters ---
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

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] as int,
      number: map['chapter_number'] as int,
      title: map['chapter_name'] as String,
      titleSanskrit: map['chapter_name_sanskrit'] as String,
      summary: map['summary'] as String,
      verses: map['total_verses'] as int,
      completedPercentage: map['completed_percentage'] as int? ?? 0,
    );
  }
}

// --- MAIN DATABASE HELPER CLASS ---
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

    // Delete database during development to reset
    await deleteDatabase(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // --- CREATE ALL TABLES ---
  Future _createDB(Database db, int version) async {
    // 1️⃣ Chapters meta table
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

    // Insert metadata for all 18 chapters
    await _insertInitialChapters(db);

    // 2️⃣ Create Chapter 1 table dynamically
    await createChapterTable(db, 1);

    // Insert sample verses for Chapter 1
    await insertChapter1Verses(db);

    await createChapterTable(db, 2);

    await insertChapter2Verses(db);

    await createChapterTable(db, 3);

    await insertChapter3Verses(db);

    await createChapterTable(db, 4);

    await insertChapter4Verses(db);

    // 💥 NEW: Create Chapter 5 table dynamically 💥
    await createChapterTable(db, 5);

    // 💥 NEW: Insert verses for Chapter 5 💥
    await insertChapter5Verses(db);

    // 💥 NEW: Create Chapter 6 table dynamically 💥
    await createChapterTable(db, 6);

    // 💥 NEW: Insert verses for Chapter 6 💥
    await insertChapter6Verses(db);

    // 💥 NEW: Create Chapter 7 table dynamically 💥
    await createChapterTable(db, 7);

    // 💥 NEW: Insert verses for Chapter 7 💥
    await insertChapter7Verses(db);

    // 💥 NEW: Create Chapter 8 table dynamically 💥
    await createChapterTable(db, 8);

    // 💥 NEW: Insert verses for Chapter 8 💥
    await insertChapter8Verses(db);

    await createChapterTable(db, 9);

    await insertChapter9Verses(db);

    // 💥 NEW: Create Chapter 10 table dynamically 💥
    await createChapterTable(db, 10);

    // 💥 NEW: Insert verses for Chapter 10 💥
    await insertChapter10Verses(db);

    // 💥 NEW: Create Chapter 11 table dynamically 💥
    await createChapterTable(db, 11);

    // 💥 NEW: Insert verses for Chapter 11 💥
    await insertChapter11Verses(db);

    await createChapterTable(db, 12);

    await insertChapter12Verses(db);

    await createChapterTable(db, 13);

    await insertChapter13Verses(db);

    await createChapterTable(db, 14);

    await insertChapter14Verses(db);

    await createChapterTable(db, 15);

    await insertChapter15Verses(db);

    await createChapterTable(db, 16);

    await insertChapter16Verses(db);

     await createChapterTable(db, 17);

    await insertChapter17Verses(db);

    await createChapterTable(db, 18);

    await insertChapter18Verses(db);
  }

  // --- DYNAMIC TABLE CREATION FUNCTION ---
  Future<void> createChapterTable(Database db, int chapterNumber) async {
    final tableName = 'chapter_$chapterNumber';

    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        verse_number INTEGER,
        sanskrit TEXT,
        translation TEXT,
        word_meaning TEXT,
        commentary TEXT
      );
    ''');
  }

  // --- INSERT VERSES FOR CHAPTER 1 ---
  Future<void> insertChapter1Verses(Database db) async {
    // Verse 1: Dhritarashtra's Inquiry (Already provided)
    await db.insert('chapter_1', {
      'verse_number': 1,
      'sanskrit':
          'धृतराष्ट्र उवाच | धर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः | मामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय || 1 ||',
      'translation':
          'Dhritarashtra said: O Sanjay, after gathering on the holy field of Kurukshetra, and desiring to fight, what did my sons and the sons of Pandu do?',
      'word_meaning':
          'धृतराष्ट्रः उवाच—Dhritarashtra said; धर्म-क्षेत्रे—in the land of dharma; कुरु-क्षेत्रे—in Kurukshetra; समवेताः—assembled together; युयुत्सवः—desiring to fight; मामकाः—my sons; पाण्डवाः—the sons of Pandu; च—and; एव—certainly; किम्—what; अकुर्वत—did do; सञ्जय—O Sanjay.',
      'commentary':
          'Dhritarashtra, being blind and attached to his sons, inquires what happened when both armies assembled on the battlefield of Kurukshetra. The field being dharma-kshetra signifies that righteousness will prevail.',
    });

    // Verse 2: Sanjay's observation (Already provided)
    await db.insert('chapter_1', {
      'verse_number': 2,
      'sanskrit':
          'सञ्जय उवाच | दृष्ट्वा तु पाण्डवानीकं व्यूढं दुर्योधनस्तदा | आचार्यमुपसङ्गम्य राजा वचनमब्रवीत् || 2 ||',
      'translation':
          'Sanjay said: At that time, seeing the Pandava army arranged in military formation, King Duryodhana approached his teacher Dronacharya and spoke these words:',
      'word_meaning':
          'सञ्जयः उवाच—Sanjay said; दृष्ट्वा—having seen; तु—but; पाण्डव-अनीकम्—the army of the Pandavas; व्यूढम्—arrayed in military formation; दुर्योधनः—King Duryodhana; तदा—then; आचार्यम्—teacher (Dronacharya); उपसङ्गम्य—approaching; राजा—the king; वचनम्—words; अब्रवीत्—spoke.',
      'commentary':
          'Sanjay begins his narration to Dhritarashtra. Duryodhana, upon seeing the Pandava army, approached his teacher to discuss battle strategy. His words reflect both fear and cunning.',
    });

    // Verse 3: Duryodhana describes the Pandava forces
    await db.insert('chapter_1', {
      'verse_number': 3,
      'sanskrit':
          'पश्यैतां पाण्डुपुत्राणामाचार्य महतीं चमूम् | व्यूढां द्रुपदपुत्रेण तव शिष्येण धीमता || 3 ||',
      'translation':
          'O teacher, behold this mighty army of the sons of Pandu, so expertly arranged for battle by your highly intelligent disciple, the son of Drupada.',
      'word_meaning':
          'पश्य—behold; एताम्—this; पाण्डु-पुत्राणाम्—of the sons of Pandu; आचार्य—O teacher; महतीम्—great; चमूम्—army; व्यूढाम्—arranged; द्रुपद-पुत्रेण—by the son of Drupada (Dhrishtadyumna); तव—your; शिष्येण—disciple; धी-मता—intelligent.',
      'commentary':
          'Duryodhana points out Dhrishtadyumna, Dronacharya’s own disciple, as the orchestrator of the enemy’s array. This shows Duryodhana\'s underlying distrust and attempt to provoke Dronacharya.',
    });

    // Verse 4: Duryodhana names the heroes in the Pandava army
    await db.insert('chapter_1', {
      'verse_number': 4,
      'sanskrit':
          'अत्र शूरा महेष्वासा भीमार्जुनसमा युधि | युयुधानो विराटश्च द्रुपदश्च महारथः || 4 ||',
      'translation':
          'In this army are many heroic bowmen equal to Bhima and Arjuna in battle, such as Yuyudhana, Virata, and the great warrior Drupada.',
      'word_meaning':
          'अत्र—here; शूराः—heroes; महा-इषु-आसाः—great archers; भीम-अर्जुन-समाः—equal to Bhima and Arjuna; युधि—in battle; युयुधानः—Yuyudhana (Satyaki); विराटः—Virata; च—and; द्रुपदः—Drupada; च—and; महा-रथः—great warrior.',
      'commentary':
          'Duryodhana lists the formidable warriors, highlighting their strengths, which serves to emphasize the danger and perhaps to increase the anxiety of his own general.',
    });

    // Verse 5: More warriors
    await db.insert('chapter_1', {
      'verse_number': 5,
      'sanskrit':
          'धृष्टकेतुश्चेकितानः काशिराजश्च वीर्यवान् | पुरुजित्कुन्तिभोजश्च शैब्यश्च नरपुङ्गवः || 5 ||',
      'translation':
          'Also amongst them are Dhrishtaketu, Chekitana, the valiant King of Kashi, Purujit, Kuntibhoja, and Shaibya, the best of men.',
      'word_meaning':
          'धृष्टकेतुः—Dhrishtaketu; चेकितानः—Chekitana; काशिराजः—the King of Kashi; च—and; वीर्यवान्—valiant; पुरुजित्—Purujit; कुन्तिभोजः—Kuntibhoja; च—and; शैब्यः—Shaibya; च—and; नर-पुङ्गवः—chief among men.',
      'commentary':
          'The list continues, covering powerful allies and friends of the Pandavas, further demonstrating the extensive and high-quality military support they have amassed.',
    });

    // Verse 6: Final names of the Pandava heroes
    await db.insert('chapter_1', {
      'verse_number': 6,
      'sanskrit':
          'युधामन्युश्च विक्रान्त उत्तमौजाश्च वीर्यवान् | सौभद्रो द्रौपदेयाश्च सर्व एव महारथाः || 6 ||',
      'translation':
          'There are also the mighty Yudhamanyu and the valiant Uttamauja, the son of Subhadra (Abhimanyu), and the sons of Draupadi—all of them are great chariot-warriors.',
      'word_meaning':
          'युधामन्युः—Yudhamanyu; च—and; विक्रान्तः—mighty; उत्तम-औजाः—Uttamauja; च—and; वीर्यवान्—valiant; सौभद्रः—the son of Subhadra (Abhimanyu); द्रौपदेयाः—the sons of Draupadi; च—and; सर्वे—all; एव—certainly; महा-रथः—great chariot-warriors.',
      'commentary':
          'Duryodhana concludes his list by mentioning the young but fierce warriors, Abhimanyu (Arjuna’s son) and the sons of Draupadi, confirming the Pandava army’s status as a collection of high-caliber generals.',
    });

    // Verse 7: Duryodhana shifts focus to his own side
    await db.insert('chapter_1', {
      'verse_number': 7,
      'sanskrit':
          'अस्माकं तु विशिष्टा ये तान्निबोध द्विजोत्तम | नायका मम सैन्यस्य सञ्ज्ञार्थं तान्ब्रवीमि ते || 7 ||',
      'translation':
          'But for your information, O best of the twice-born (Dronacharya), let me tell you about the principal commanders on our side, who are especially qualified to lead my military force.',
      'word_meaning':
          'अस्माकम्—our; तु—but; विशिष्टाः—especially powerful; ये—who; तान्—them; निबोध—be informed; द्विज-उत्तम—O best of the twice-born; नायकाः—commanders; मम—my; सैन्यस्य—of the army; सञ्ज्ञा-अर्थम्—for the purpose of informing; तान्—them; ब्रवीमि—I am speaking; ते—to you.',
      'commentary':
          'Having expressed his anxiety about the Pandavas, Duryodhana attempts to reassure himself (and Drona) by listing his own powerful generals, subtly trying to bind Dronacharya to his cause.',
    });

    // Verse 8: Duryodhana names the key Kaurava commanders
    await db.insert('chapter_1', {
      'verse_number': 8,
      'sanskrit':
          'भवान्भीष्मश्च कर्णश्च कृपश्च समितिञ्जयः | अश्वत्थामा विकर्णश्च सौमदत्तिस्तथैव च || 8 ||',
      'translation':
          'There are personalities like yourself (Drona), Bhishma, Karna, Kripa (victorious in battle), Ashwatthama, Vikarna, and the son of Somadatta (Bhūriśhravā).',
      'word_meaning':
          'भवान्—yourself; भीष्मः—Bhishma; च—and; कर्णः—Karna; च—and; कृपः—Kripa; च—and; समिति-ञ्जयः—victorious in battle; अश्वत्थामा—Ashwatthama; विकर्णः—Vikarna; च—and; सौमदत्तिः—the son of Somadatta (Bhūriśhravā); तथा—also; एव—certainly; च—and.',
      'commentary':
          'Duryodhana names the pillars of his army. The placement of Drona’s name first is a psychological tactic to remind the teacher of his duty and loyalty.',
    });

    // Verse 9: Other important fighters
    await db.insert('chapter_1', {
      'verse_number': 9,
      'sanskrit':
          'अन्ये च बहवः शूरा मदर्थे त्यक्तजीविताः | नानाशस्त्रप्रहरणाः सर्वे युद्धविशारदाः || 9 ||',
      'translation':
          'There are many other heroes who are prepared to lay down their lives for my sake. They are armed with various kinds of weapons and are all experienced in military science.',
      'word_meaning':
          'अन्ये—others; च—and; बहवः—many; शूराः—heroes; मत्-अर्थे—for my sake; त्यक्त-जीविताः—having abandoned life; नाना-शस्त्र-प्रहरणाः—armed with various weapons; सर्वे—all; युद्ध-विशारदाः—expert in fighting.',
      'commentary':
          'Duryodhana includes the general mass of devoted warriors, boosting morale by emphasizing their number and their fierce loyalty to his cause, contrasting with his earlier anxiety.',
    });

    // Verse 10: Duryodhana assesses the armies' strengths
    await db.insert('chapter_1', {
      'verse_number': 10,
      'sanskrit':
          'अपर्याप्तं तदस्माकं बलं भीष्माभिरक्षितम् | पर्याप्तं त्विदमेतेषां बलं भीमाभिरक्षितम् || 10 ||',
      'translation':
          'Our army, protected by Bhishma, is immeasurable, while the strength of their army, protected by Bhima, is easily measurable (or limited).',
      'word_meaning':
          'अ-पर्याप्तम्—unlimited/insufficient; तत्—that; अस्माकम्—our; बलम्—strength; भीष्म-अभिरक्षितम्—perfectly protected by Bhishma; पर्याप्तम्—limited/sufficient; तु—but; इदम्—this; एतेषाम्—of these (Pandavas); बलम्—strength; भीम-अभिरक्षितम्—protected by Bhima.',
      'commentary':
          'This verse is often interpreted with two meanings: 1) **(Common)** Our strength is insufficient/unlimited compared to theirs. 2) **(Alternate)** Our army (under the elderly Bhishma) is immeasurable, but theirs (under the young Bhima) is measurable/limited. The former shows Duryodhana\'s deep fear; the latter, his attempt at false bravado.',
    });

    await db.insert('chapter_1', {
      'verse_number': 11,
      'sanskrit':
          'अयनेषु च सर्वेषु यथाभागमवस्थिताः | भीष्ममेवाभिरक्षन्तु भवन्तः सर्व एव हि || 11 ||',
      'translation':
          'Therefore, all of you standing in your respective divisions of the army must give full support to Grandfather Bhishma.',
      'word_meaning':
          'अयनेषु—in the strategic points; च—also; सर्वेषु—in all; यथा-भागम्—as divided; अवस्थिताः—situated; भीष्मम्—unto Bhishma; एव—certainly; अभिरक्षन्तु—should give support; भवान्तः—you all; सर्वः—all respectively; एव हि—certainly.',
      'commentary':
          'Duryodhana issues a direct order to his commanders: the key to their success is protecting their Supreme Commander, Bhishma. This reveals his awareness that the Kaurava army’s strength hinges entirely on Bhishma\'s presence.',
    });

    // Verse 12: Bhishma blows his conch
    await db.insert('chapter_1', {
      'verse_number': 12,
      'sanskrit':
          'तस्य सञ्जनयन्हर्षं कुरुवृद्धः पितामहः | सिंहनादं विनद्योच्चैः शङ्खं दध्मौ प्रतापवान् || 12 ||',
      'translation':
          'Then, the glorious oldest man of the Kuru dynasty, Bhishma, the grandfather, roared like a lion and blew his conch shell very loudly, cheering Duryodhana.',
      'word_meaning':
          'तस्य—his (Duryodhana’s); सञ्जनयन्—creating; हर्षम्—joy; कुरु-वृद्धः—the great old man of the Kurus; पितामहः—the grandfather (Bhishma); सिंह-नादम्—a lion\'s roar; विनद्य—sounding; उच्चैः—loudly; शङ्खम्—conch shell; दध्मौ—blew; प्रतापवान्—glorious/powerful.',
      'commentary':
          'Bhishma\'s sound of the conch (Panchajanya) was a fierce act intended to alleviate Duryodhana’s fear, signaling that the battle was officially underway, despite his inner turmoil.',
    });

    // Verse 13: General war sounds on the Kaurava side
    await db.insert('chapter_1', {
      'verse_number': 13,
      'sanskrit':
          'ततः शङ्खाश्च भेर्यश्च पणवानकगोमुखाः | सहसैवाभ्यहन्यन्त स शब्दस्तुमुलोऽभवत् || 13 ||',
      'translation':
          'Following this, conch shells, kettle-drums, drums, tabors, and cow-horns suddenly all blared forth. The sound was tumultuous.',
      'word_meaning':
          'ततः—thereafter; शङ्खाः—conch shells; च—and; भेर्यः—kettle-drums; च—and; पणव-आनक-गोमुखाः—tabors, drums, and cow-horns; सहसा एव—suddenly; अभ्यहन्यन्त—were sounded; सः—that; शब्दः—sound; तुमूलः—tumultuous; अभवत्—became.',
      'commentary':
          'The combined sound of the Kaurava instruments was overwhelming, marking the powerful response to Bhishma and further intensifying the atmosphere of the imminent war.',
    });

    // Verse 14: Krishna and Arjuna respond
    await db.insert('chapter_1', {
      'verse_number': 14,
      'sanskrit':
          'ततः श्वेतैर्हयैर्युक्ते महति स्यन्दने स्थितौ | माधवः पाण्डवश्चैव दिव्यौ शङ्खौ प्रदध्मतुः || 14 ||',
      'translation':
          'Then, situated in a magnificent chariot yoked with white horses, Madhava (Krishna) and the son of Pandu (Arjuna) blew their divine conch shells.',
      'word_meaning':
          'ततः—then; श्वेतैः—with white; हयैः—horses; युक्ते—joined; महति—in a magnificent; स्यन्दने—chariot; स्थितौ—situated; माधवः—Krishna; पाण्डवः—Arjuna; च—and; एव—certainly; दिव्यौ—divine; शङ्खौ—two conches; प्रदध्मतुः—blew.',
      'commentary':
          'The mention of the "divine conches" and the "magnificent chariot" (bearing the flag of Hanuman) highlights the divine protection and celestial nature of the Pandava cause, contrasting the human fear felt by the Kauravas.',
    });

    // Verse 15: Krishna, Arjuna, and Bhima's conches
    await db.insert('chapter_1', {
      'verse_number': 15,
      'sanskrit':
          'पाञ्चजन्यं हृषीकेशो देवदत्तं धनञ्जयः | पौण्ड्रं दध्मौ महाशङ्खं भीमकर्मा वृकोदरः || 15 ||',
      'translation':
          'Lord Krishna blew His conch shell, Pāñchajanya; Arjuna blew his, Devadatta; and Bhīma, the doer of terrible deeds, blew his great conch, Pauṇḍra.',
      'word_meaning':
          'पाञ्चजन्यम्—Pāñchajanya; हृषीकेशः—Hṛiṣhīkeśha (Krishna); देवदत्तम्—Devadatta; धनञ्जयः—Dhanañjaya (Arjuna); पौण्ड्रम्—Pauṇḍra; दध्मौ—blew; महा-शङ्खम्—the great conch; भीम-कर्मा—one who performs fearful deeds; वृक-उदरः—Vṛikodara (Bhīma).',
      'commentary':
          'This verse explicitly names the conches of the principal heroes, each possessing a unique, powerful sound. Krishna’s role as Hṛiṣhīkeśha (master of the senses) is important, indicating His control over the situation.',
    });

    // Verse 16: Yudhisthira, Nakula, and Sahadeva's conches
    await db.insert('chapter_1', {
      'verse_number': 16,
      'sanskrit':
          'अनन्तविजयं राजा कुन्तीपुत्रो युधिष्ठिरः | नकुलः सहदेवश्च सुघोषमणिपुष्पकौ || 16 ||',
      'translation':
          'King Yudhisthira, the son of Kunti, blew the Anantavijaya; and Nakula and Sahadeva blew the Sughosha and Manipushpaka, respectively.',
      'word_meaning':
          'अनन्त-विजयम्—Anantavijaya; राजा—King; कुन्ती-पुत्रः—the son of Kunti; युधिष्ठिरः—Yudhisthira; नकुलः—Nakula; सहदेवः—Sahadeva; च—and; सुघोष-मणिपुष्पकौ—Sughosha and Manipushpaka.',
      'commentary':
          'The sounding of Yudhisthira’s conch (Eternal Victory) by the righteous King himself was a sign of divine assurance. The conches of the younger brothers also added to the symphony of the Pandava challenge.',
    });

    // Verse 17: The conch of the King of Kashi
    await db.insert('chapter_1', {
      'verse_number': 17,
      'sanskrit':
          'काश्यश्च परमेष्वासः शिखण्डी च महारथः | धृष्टद्युम्नो विराटश्च सात्यकिश्चापराजितः || 17 ||',
      'translation':
          'The King of Kashi, a supreme archer, and Shikhandi, the great chariot-warrior, Dhrishtadyumna, Virata, and the unconquerable Satyaki also blew their conch shells.',
      'word_meaning':
          'काश्यः—the King of Kashi; च—and; परम-इषु-आसः—the greatest archer; शिखण्डी—Shikhanḍī; च—and; महा-रथः—great chariot-warrior; धृष्टद्युम्नः—Dhrishṭadyumna; विराटः—Virāṭa; च—and; सात्यकिः—Sātyaki; च—and; अपराजितः—unconquerable.',
      'commentary':
          'Sanjay continues to describe the Pandava side’s overwhelming sound. The emphasis on "unconquerable" warriors like Satyaki highlights the mental strength of the Pandava alliance.',
    });

    // Verse 18: Drupada, Draupadi's sons, and Subhadra's son
    await db.insert('chapter_1', {
      'verse_number': 18,
      'sanskrit':
          'द्रुपदो द्रौपदेयाश्च सर्वशः पृथिवीपते | सौभद्रश्च महाबाहुः शङ्खान्दध्मुः पृथक्पृथक् || 18 ||',
      'translation':
          'O King (Dhritarashtra), Drupada, the sons of Draupadi, and the mighty-armed son of Subhadra (Abhimanyu)—all of them blew their respective conch shells.',
      'word_meaning':
          'द्रुपदः—Drupada; द्रौपदेयाः—the sons of Draupadi; च—and; सर्वशः—all around; पृथिवी-पते—O King; सौभद्रः—the son of Subhadra; च—and; महा-बाहुः—mighty-armed; शङ्खान्—conch shells; दध्मुः—blew; पृथक् पृथक्—individually.',
      'commentary':
          'The detail that they blew their conches "individually" suggests a resounding clarity and conviction from the Pandava side, directly contrasting the tumultuous, group effort from the Kaurava side described earlier.',
    });

    // Verse 19: The sound breaks the hearts of the Kauravas
    await db.insert('chapter_1', {
      'verse_number': 19,
      'sanskrit':
          'स घोषो धार्तराष्ट्राणां हृदयानि व्यदारयत् | नभश्च पृथिवीं चैव तुमुलो व्यनुनादयन् || 19 ||',
      'translation':
          'That tremendous sound, reverberating both in the sky and on the earth, tore the hearts of the sons of Dhritarashtra.',
      'word_meaning':
          'सः—that; घोषः—sound; धार्तराष्ट्राणाम्—of the sons of Dhritarashtra; हृदयानि—hearts; व्यदारयत्—tore asunder; नभः—the sky; च—and; पृथिवीम्—the earth; च—and; एव—certainly; तुमूलः—tumultuous; व्यनुनादयन्—reverberating.',
      'commentary':
          'This is Sanjay’s personal interpretation of the effect of the Pandava’s mighty sounds. It was not just noise, but a psychological blow that foreshadowed the Kauravas’ ultimate defeat.',
    });

    // Verse 20: Arjuna prepares for action
    await db.insert('chapter_1', {
      'verse_number': 20,
      'sanskrit':
          'अथ व्यवस्थितान्दृष्ट्वा धार्तराष्ट्रान्कपिध्वजः | प्रवृत्ते शस्त्रसम्पाते धनुरुद्यम्य पाण्डवः || 20 ||',
      'translation':
          'O King (Dhritarashtra), seeing your sons positioned for battle, the son of Pandu, Arjuna (whose flag bore the emblem of Hanuman), then lifted his bow, ready to release his arrows.',
      'word_meaning':
          'अथ—then; व्यवस्थितान्—situated; दृष्ट्वा—having seen; धार्तराष्ट्रान्—the sons of Dhritarashtra; कपि-ध्वजः—he whose flag is Hanuman (Arjuna); प्रवृत्ते—having begun; शस्त्र-सम्पाते—the discharge of arrows; धनुः—bow; उद्यम्य—lifting; पाण्डवः—the son of Pandu.',
      'commentary':
          'The action shifts to **Arjuna**, who is now ready to begin the fight. The title **Kapi-dhvaja** (one with the flag of Hanuman) reinforces his divine strength and the support of celestial forces, just before he begins to experience doubt.',
    });

    await db.insert('chapter_1', {
      'verse_number': 21,
      'sanskrit':
          'अर्जुन उवाच | सेनयोरुभयोर्मध्ये रथं स्थापय मेऽच्युत || 21 ||',
      'translation':
          'Arjuna said: O Infallible One (Achyuta), please place my chariot between the two armies.',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; सेनयोः—of the armies; उभयोः—both; मध्ये—in the middle; रथम्—chariot; स्थापय—please place; मे—my; अच्युत—O infallible one (Krishna).',
      'commentary':
          'Arjuna addresses Krishna as **Achyuta** (the infallible one), signifying his complete faith in Krishna’s dependable nature, even as he asks the Supreme Lord to act as his charioteer.',
    });

    // Verse 22: Arjuna states his reason
    await db.insert('chapter_1', {
      'verse_number': 22,
      'sanskrit':
          'यावदेतान्निरीक्षेऽहं योद्धुकामानवस्थितान् | कैर्मया सह योद्धव्यमस्मिन् रणसमुद्यमे || 22 ||',
      'translation':
          'So that I may behold those who are arrayed here, eager to fight, and know with whom I must contend in this great enterprise of battle.',
      'word_meaning':
          'यावत्—as long as; एतान्—these; निरीक्षे—I may look; अहम्—I; योद्धु-कामान्—desiring to fight; अवस्थितान्—situated; कैः—with whom; मया—by me; सह—with; योद्धव्यम्—to be fought; अस्मिन्—in this; रण-समुद्यमे—effort of battle.',
      'commentary':
          'Arjuna is not merely looking at the numbers but assessing the specific warriors he has to face. This request is the prelude to his mental collapse, which will be triggered by seeing his loved ones.',
    });

    // Verse 23: Arjuna seeks to identify the supporters of the wicked
    await db.insert('chapter_1', {
      'verse_number': 23,
      'sanskrit':
          'योत्स्यमानानवेक्षेऽहं य एतेऽत्र समागताः | धार्तराष्ट्रस्य दुर्बुद्धेर्युद्धे प्रियचिकीर्षवः || 23 ||',
      'translation':
          'Let me observe those who have come here to fight, intending to please the wicked-minded son of Dhritarashtra (Duryodhana) in battle.',
      'word_meaning':
          'योत्स्यमानान्—those who are fighting; अवेक्षे—I shall look; अहम्—I; ये—who; एते—these; अत्र—here; समागताः—assembled; धार्तराष्ट्रस्य—of the son of Dhritarashtra; दुर्बुद्धेः—of the wicked intelligence; युद्धे—in battle; प्रिय-चिकीर्षवः—desiring to please.',
      'commentary':
          'Arjuna initially views the enemy through the lens of **Dharma**, trying to separate those who are evil from those merely forced to fight. He assigns the wickedness solely to Duryodhana, but this distinction is soon blurred by his personal attachment.',
    });

    // Verse 24: Sanjay's narration to Dhritarashtra
    await db.insert('chapter_1', {
      'verse_number': 24,
      'sanskrit':
          'सञ्जय उवाच | एवमुक्तो हृषीकेशो गुडाकेशेन भारत | सेनयोरुभयोर्मध्ये स्थापयित्वा रथोत्तमम् || 24 ||',
      'translation':
          'Sanjay said: O descendant of Bharata (Dhritarashtra), having been addressed thus by the conqueror of sleep (Arjuna), Lord Hrishikesha (Krishna) placed the supreme chariot between the two armies.',
      'word_meaning':
          'सञ्जयः उवाच—Sanjay said; एवम् उक्तः—thus addressed; हृषीकेशः—Hṛiṣhīkeśha (Krishna, master of the senses); गुडाकेशेन—by the conqueror of sleep (Arjuna); भारत—O descendant of Bharata; सेनयोः—of the armies; उभयोः—both; मध्ये—in the middle; स्थापयित्वा—having placed; रथ-उत्तमम्—the excellent chariot.',
      'commentary':
          'Krishna is referred to as **Hṛiṣhīkeśha** (master of the senses), implying that He knows Arjuna\'s true intention (which is not just to view the enemy but to prepare for collapse), and He is steering the situation according to His will.',
    });

    // Verse 25: Krishna's instruction to Arjuna
    await db.insert('chapter_1', {
      'verse_number': 25,
      'sanskrit':
          'भीष्मद्रोणप्रमुखतः सर्वेषां च महीक्षिताम् | उवाच पार्थ पश्यैतान् समवेतान् कुरूनिति || 25 ||',
      'translation':
          'Facing Bhishma, Drona, and all the other kings, Hrishikesha said: "O Pārtha (Arjuna), behold all the Kurus gathered here."',
      'word_meaning':
          'भीष्म-द्रोण-प्रमुखतः—in front of Bhishma and Drona; सर्वेषाम्—all; च—and; मही-क्षितम्—of the kings; उवाच—said; पार्थ—O son of Pritha (Arjuna); पश्य—behold; एतान्—these; समवेतान्—assembled; कुरून्—Kurus; इति—thus.',
      'commentary':
          'Krishna places the chariot in the most vulnerable spot, directly exposing Arjuna to his most revered elders. Krishna’s simple command, "Behold the Kurus," intentionally forces Arjuna to confront the full scope of his family ties.',
    });

    // Verse 26: Arjuna sees his kinsmen
    await db.insert('chapter_1', {
      'verse_number': 26,
      'sanskrit':
          'तत्रापश्यत्स्थितान् पार्थः पितॄनथ पितामहान् | आचार्यान्मातुलान्भ्रातॄन्पुत्रान्पौत्रान्सखींस्तथा || 26 ||',
      'translation':
          'There, Arjuna saw situated uncles, grandfathers, teachers, maternal uncles, brothers, sons, grandsons, and well-wishing friends.',
      'word_meaning':
          'तत्र—there; अपश्यत्—saw; स्थितान्—situated; पार्थः—Arjuna; पितॄन्—fathers/uncles; अथ—also; पितामहान्—grandfathers; आचार्यान्—teachers; मातुलान्—maternal uncles; भ्रातॄन्—brothers; पुत्रान्—sons; पौत्रान्—grandsons; सखीन्—friends; तथा—also.',
      'commentary':
          'This is the moment of truth. Arjuna’s initial excitement for battle is instantly replaced by deep familial connection and attachment as he recognizes the faces on the enemy side.',
    });

    // Verse 27: Arjuna sees the relatives of both sides
    await db.insert('chapter_1', {
      'verse_number': 27,
      'sanskrit':
          'श्वशुरान्सुहृदश्चैव सेनयोरुभयोरपि | तान् समीक्ष्य स कौन्तेयः सर्वान् बन्धूनवस्थितान् || 27 ||',
      'translation':
          'He also saw fathers-in-law and well-wishers in both armies. Seeing all these relatives arrayed, the son of Kunti (Arjuna) was overwhelmed.',
      'word_meaning':
          'श्वशुरान्—fathers-in-law; सुहृदः—well-wishers; च—and; एव—certainly; सेनयोः—of the armies; उभयोः—both; अपि—also; तान्—those; समीक्ष्य—seeing; सः—he; कौन्तेयः—the son of Kunti (Arjuna); सर्वान्—all; बन्धून्—relatives; अवस्थितान्—situated.',
      'commentary':
          'The phrase "in both armies" is crucial. Arjuna realizes that whether he wins or loses, he will be destroying his own family structure, which is the source of his subsequent grief.',
    });

    // Verse 28: Arjuna is overwhelmed by pity
    await db.insert('chapter_1', {
      'verse_number': 28,
      'sanskrit':
          'कृपया परयाविष्टो विषीदन्निदमब्रवीत् | दृष्ट्वेमं स्वजनं कृष्ण युयुत्सुं समुपस्थितम् || 28 ||',
      'translation':
          'Arjuna spoke these words, overcome with deep pity and sorrow: "O Krishna, seeing my own kinsmen gathered here, eager to fight—"',
      'word_meaning':
          'कृपया—by compassion; परया—supreme; आविष्टः—overwhelmed; विषीदन्—lamenting; इदम्—this; अब्रवीत्—said; दृष्ट्वा—seeing; इमम्—this; स्व-जनम्—own kinsmen; कृष्ण—O Krishna; युयुत्सुम्—desirous to fight; समुपस्थितम्—arrayed.',
      'commentary':
          'The word **Kṛipayā** (pity or compassion) is the first seed of Arjuna’s dejection. His compassion is rooted in material attachment (`Sva-janam` - own people) rather than spiritual wisdom, leading to confusion and sorrow.',
    });

    // Verse 29: Arjuna describes his physical distress
    await db.insert('chapter_1', {
      'verse_number': 29,
      'sanskrit':
          'सीदन्ति मम गात्राणि मुखं च परिशुष्यति | वेपथुश्च शरीरे मे रोमहर्षश्च जायते || 29 ||',
      'translation':
          '"My limbs are failing, and my mouth is drying up. My body is trembling, and my hair is standing on end."',
      'word_meaning':
          'सीदन्ति—are failing; मम—my; गात्राणि—limbs; मुखम्—mouth; च—and; परिशुष्यति—is drying up; वेपथुः—trembling; च—and; शरीरे—in the body; मे—my; रोम-हर्षः—standing of hair on end; च—and; जायते—is happening.',
      'commentary':
          'Arjuna’s distress manifests in acute physical symptoms. This psychological reaction (fear, anxiety) demonstrates that his mental energy, previously dedicated to his warrior duty, has completely failed him.',
    });

    // Verse 30: Arjuna drops his weapon
    await db.insert('chapter_1', {
      'verse_number': 30,
      'sanskrit':
          'गाण्डीवं स्रंसते हस्तात्त्वक्चैव परिदह्यते | न च शक्नोम्यवस्थातुं भ्रमतीव च मे मनः || 30 ||',
      'translation':
          '"My bow Gāṇḍīva is slipping from my hand, and my skin is burning. I am unable to stand steady, and my mind seems to be whirling."',
      'word_meaning':
          'गाण्डीवम्—the Gāṇḍīva bow; स्रंसते—is slipping; हस्तात्—from the hand; त्वक्—skin; च—and; एव—certainly; परिदह्यते—is burning; न—not; च—and; शक्नोमि—I am able; अवस्थातुम्—to remain standing; भ्रमति—is whirling; इव—as if; च—and; मे—my; मनः—mind.',
      'commentary':
          'Arjuna’s physical and mental breakdown is complete. The loss of grip on his bow, Gāṇḍīva (a symbol of his duty and power), signifies his total **dereliction of Dharma** as a warrior (Kshatriya). This prepares the ground for Krishna’s sermon on duty and selflessness in Chapter 2.',
    });

    await db.insert('chapter_1', {
      'verse_number': 31,
      'sanskrit':
          'निमित्तानि च पश्यामि विपरीतानि केशव | न च श्रेयोऽनुपश्यामि हत्वा स्वजनमाहवे || 31 ||',
      'translation':
          'O Keshava (Krishna), I see only adverse omens. Nor do I foresee any good in killing my own kinsmen in this battle.',
      'word_meaning':
          'निमित्तानि—omens; च—also; पश्यामि—I see; विपरीतानि—adverse; केशव—O Keshava (Krishna); न च—nor; श्रेयः—good; अनुपश्यामि—I see; हत्वा—by killing; स्व-जनम्—own kinsmen; आहवे—in battle.',
      'commentary':
          'Arjuna attempts to justify his dejection with superstition and logic, stating that the omens are bad. He argues that material victory (kingdom) is not worth the moral sin of killing family.',
    });

    // Verse 32: Rejecting victory and kingdom
    await db.insert('chapter_1', {
      'verse_number': 32,
      'sanskrit':
          'न काङ्क्षे विजयं कृष्ण न च राज्यं सुखानि च | किं नो राज्येन गोविन्द किं भोगैर्जीवितेन वा || 32 ||',
      'translation':
          'O Krishna, I do not desire victory, nor kingdom, nor pleasure. O Govinda, what is the use to us of a kingdom, of enjoyments, or even of life itself?',
      'word_meaning':
          'न—not; काङ्क्षे—I desire; विजयम्—victory; कृष्ण—O Krishna; न च—nor; राज्यम्—kingdom; सुखानि—pleasures; च—and; किम्—what; नः—to us; राज्येन—by kingdom; गोविन्द—O Govinda (Krishna); किम्—what; भोगैः—by enjoyments; जीवितेन—by life; वा—or.',
      'commentary':
          'Arjuna expresses a type of renunciation, rejecting the fruits of victory (kingdom, pleasure). However, this is motivated by fear and attachment (`Moha`), not genuine detachment (`Vairagya`).',
    });

    // Verse 33: The people for whom they desire the kingdom
    await db.insert('chapter_1', {
      'verse_number': 33,
      'sanskrit':
          'येषामर्थे काङ्क्षितं नो राज्यं भोगाः सुखानि च | त इमेऽवस्थिता युद्धे प्राणान्स्त्यक्त्वा धनानि च || 33 ||',
      'translation':
          'Those, for whose sake we desire the kingdom, enjoyments, and pleasures, are arrayed here in battle, having given up their lives and wealth.',
      'word_meaning':
          'येषाम् अर्थे—for whose sake; काङ्क्षितम्—is desired; नः—by us; राज्यम्—kingdom; भोगाः—enjoyments; सुखानि—pleasures; च—and; ते—they; इमे—these; अवस्थिताः—situated; युद्धे—in battle; प्राणान्—lives; त्यक्त्वा—giving up; धनानि—wealth; च—and.',
      'commentary':
          'Arjuna makes a poignant point: the kingdom they fight for would be worthless if it meant killing the very elders and family members (Bhishma, Drona) who would normally share in its joy.',
    });

    // Verse 34: Listing the respected relatives
    await db.insert('chapter_1', {
      'verse_number': 34,
      'sanskrit':
          'आचार्याः पितरः पुत्रास्तथैव च पितामहाः | मातुलाः श्वशुराः पौत्राः श्यालाः सम्बन्धिनस्तथा || 34 ||',
      'translation':
          'Teachers, fathers, sons, and grandfathers, maternal uncles, fathers-in-law, grandsons, brothers-in-law, and other relatives.',
      'word_meaning':
          'आचार्याः—teachers; पितरः—fathers/uncles; पुत्राः—sons; तथा एव च—as also; पितामहाः—grandfathers; मातुलाः—maternal uncles; श्वशुराः—fathers-in-law; पौत्राः—grandsons; श्यालाः—brothers-in-law; सम्बन्धिनः—other relatives; तथा—and.',
      'commentary':
          'This is a second, emotional list of his relations, underscoring the depth of his attachment. Arjuna sees all these relationships as sacred bonds, not merely as opposing warriors.',
    });

    // Verse 35: Resolution not to fight revered elders
    await db.insert('chapter_1', {
      'verse_number': 35,
      'sanskrit':
          'एतान्न हन्तुमिच्छामि घ्नतोऽपि मधुसूदन | अपि त्रैलोक्यराज्यस्य हेतोः किं नु महीकृते || 35 ||',
      'translation':
          'O Madhusūdana (Krishna), even if they kill me, I do not wish to kill them, even for the sovereignty of the three worlds—what, then, for the sake of the earth?',
      'word_meaning':
          'एतान्—these; न—not; हन्तुम्—to kill; इच्छामि—I desire; घ्नतः—killing; अपि—even if; मधुसूदन—O Madhusūdana (Krishna, killer of the Madhu demon); अपि—even; त्रैलोक्य-राज्यस्य—of the three worlds\' kingdom; हेतोः—for the sake of; किम् नु—what, then; मही-कृते—for the sake of the earth.',
      'commentary':
          'Arjuna uses the name **Madhusūdana**, reminding Krishna of His destructive power against demons. Arjuna argues that killing his revered elders for a temporary earthly kingdom is worse than killing a demon for cosmic balance. This is the moral height of his argument.',
    });

    // Verse 36: Sinful reaction for killing aggressors (Ātatāyis)
    await db.insert('chapter_1', {
      'verse_number': 36,
      'sanskrit':
          'निहत्य धार्तराष्ट्रान्नः का प्रीतिः स्याज्जनार्दन | पापमेवाश्रयेदस्मान् हत्वैतानाततायिनः || 36 ||',
      'translation':
          'What pleasure shall we obtain, O Janārdana (Krishna), by killing the sons of Dhritarashtra? Sin alone will accrue to us by killing these aggressors.',
      'word_meaning':
          'निहत्य—by killing; धार्तराष्ट्रान्—the sons of Dhritarashtra; नः—our; का—what; प्रीतिः—pleasure; स्यात्—will be; जनार्दन—O Janārdana (Krishna, protector of men); पापम्—sin; एव—certainly; आश्रयेत्—will come upon; अस्मान्—us; हत्वा—by killing; एतान्—these; आततायिनः—aggressors.',
      'commentary':
          'A Kshatriya can kill an Ātatāyī (aggressor) without incurring sin. Arjuna acknowledges the Kauravas are aggressors but argues that because they are family, the usual moral rule does not apply, and he will incur sin (Pāpa) regardless.',
    });

    // Verse 37: The true motive of Duryodhana's army
    await db.insert('chapter_1', {
      'verse_number': 37,
      'sanskrit':
          'तस्मान्नार्हा वयं हन्तुं धार्तराष्ट्रान् स्वबान्धवान् | स्वजनं हि कथं हत्वा सुखिनः स्याम माधव || 37 ||',
      'translation':
          'Therefore, we should not kill the sons of Dhritarashtra, our relatives. O Mādhava (Krishna), how can we ever be happy by killing our own kinsmen?',
      'word_meaning':
          'तस्मात्—therefore; न अर्हाः—not proper; वयम्—we; हन्तुम्—to kill; धार्तराष्ट्रान्—the sons of Dhritarashtra; स्व-बान्धवान्—our own kinsmen; स्व-जनम्—own people; हि—certainly; कथम्—how; हत्वा—by killing; सुखिनः—happy; स्याम—shall we be; माधव—O Mādhava (Krishna).',
      'commentary':
          'Arjuna insists that happiness cannot be achieved by eliminating one\'s own family. His perspective is driven by the traditional social understanding that family is the source of joy and stability.',
    });

    // Verse 38: The greed of the Kauravas
    await db.insert('chapter_1', {
      'verse_number': 38,
      'sanskrit':
          'यद्यप्येते न पश्यन्ति लोभोपहतचेतसः | कुलक्षयकृतं दोषं मित्रद्रोहे च पातकम् || 38 ||',
      'translation':
          'Although they, whose minds are overpowered by greed, see no fault in destroying the family or committing treason against friends,',
      'word_meaning':
          'यद्यपि—although; एते—they (Kauravas); न—not; पश्यन्ति—see; लोभ-उपहत-चेतसः—whose consciousness is overcome by greed; कुल-क्षय-कृतम्—caused by the destruction of the family; दोषम्—fault/evil; मित्र-द्रोहे—in hostility toward friends; च—and; पातकम्—sin.',
      'commentary':
          'Arjuna distinguishes himself from the Kauravas, claiming that their greed blinds them to the immorality of the act. Arjuna claims moral superiority because he *does* see the ethical failings of war.',
    });

    // Verse 39: Arjuna's duty to see the wrong
    await db.insert('chapter_1', {
      'verse_number': 39,
      'sanskrit':
          'कथं न ज्ञेयमस्माभिः पापादस्मान्निवर्तितुम् | कुलक्षयकृतं दोषं प्रपश्यद्भिर्जनार्दन || 39 ||',
      'translation':
          'Why should we not know how to turn away from this sin, O Janārdana, since we clearly see the evil resulting from the destruction of the family?',
      'word_meaning':
          'कथम्—why; न—not; ज्ञेयम्—should be known; अस्माभिः—by us; पापात्—from sin; अस्मात्—this; निवर्तितुम्—to turn away; कुल-क्षय-कृतम्—caused by the destruction of the family; दोषम्—fault/evil; प्रपश्यद्भिः—by those who clearly see; जनार्दन—O Janārdana.',
      'commentary':
          'This is Arjuna’s final logical plea based on social duty (Dharma). Since he, unlike the greedy Kauravas, can see the sin, it is his greater responsibility to retreat from the unrighteous path.',
    });

    // Verse 40: Consequences of family destruction (Kula-Dharma)
    await db.insert('chapter_1', {
      'verse_number': 40,
      'sanskrit':
          'कुलक्षये प्रणश्यन्ति कुलधर्माः सनातनाः | धर्मे नष्टे कुलं कृत्स्नमधर्मोऽभिभवत्युत || 40 ||',
      'translation':
          'With the destruction of the family, the eternal family traditions (Kula-Dharmas) are vanquished, and when Dharma is destroyed, irreligion (Adharma) overtakes the entire family.',
      'word_meaning':
          'कुल-क्षये—in the destruction of the family; प्रणश्यन्ति—are vanquished; कुल-धर्माः—family traditions; सनातनाः—eternal; धर्मे—religion/tradition; नष्टे—being destroyed; कुलम्—family; कृत्स्नम्—the entire; अधर्मः—irreligion; अभिभवति—overcomes; उत—certainly.',
      'commentary':
          'Arjuna introduces the core socio-religious argument of this chapter. He argues that the elders (who carry the tradition) will die, leading to the collapse of *Kula-Dharma* (family morality) and the subsequent rise of *Adharma* (irreligion) in society.',
    });

    // Verse 41: Adharma leads to corruption of women
    await db.insert('chapter_1', {
      'verse_number': 41,
      'sanskrit':
          'अधर्माभिभवात्कृष्ण प्रदुष्यन्ति कुलस्त्रियः | स्त्रीषु दुष्टासु वार्ष्णेय जायते वर्णसङ्करः || 41 ||',
      'translation':
          'With the prevalence of irreligion, O Krishna, the women of the family become corrupted; and from the corruption of women, O descendant of Vrishni, unwanted progeny are born.',
      'word_meaning':
          'अधर्म-अभिभवात्—by the prevalence of irreligion; कृष्ण—O Krishna; प्रदुष्यन्ति—become corrupted; कुल-स्त्रियः—women of the family; स्त्रीषु—of women; दुष्टासु—being corrupted; वार्ष्णेय—O descendant of Vrishni (Krishna); जायते—are born; वर्ण-सङ्करः—unwanted progeny/intermingling of classes.',
      'commentary':
          'Arjuna argues that the loss of men in battle will leave women unprotected and vulnerable, leading to the breakdown of moral order and resulting in a mixed or unwanted population, which is seen as a social catastrophe.',
    });

    // Verse 42: Unwanted progeny leads to ruin for family and ancestors
    await db.insert('chapter_1', {
      'verse_number': 42,
      'sanskrit':
          'सङ्करो नरकायैव कुलघ्नानां कुलस्य च | पतन्ति पितरो ह्येषां लुप्तपिण्डोदकक्रियाः || 42 ||',
      'translation':
          'The unwanted progeny create a hellish situation for the destroyers of the family and for the family itself. Their ancestors also fall from heaven, deprived of the offerings of rice-balls (piṇḍa) and water.',
      'word_meaning':
          'सङ्करः—unwanted progeny; नरकाय—to hell; एव—certainly; कुल-घ्नानाम्—of the family destroyers; कुलस्य—of the family; च—and; पतन्ति—fall down; पितरः—ancestors; हि—certainly; एषाम्—of these; लुप्त-पिण्ड-उदक-क्रियाः—deprived of the ceremonies of food (piṇḍa) and water.',
      'commentary':
          'Arjuna’s concern extends beyond the living to the dead. He believes that the collapse of tradition will stop the *śrāddha* rites, causing ancestors to suffer in the afterlife. This underscores his commitment to traditional Vedic rituals.',
    });

    // Verse 43: Eternal family traditions are destroyed
    await db.insert('chapter_1', {
      'verse_number': 43,
      'sanskrit':
          'दोषैरेतैः कुलघ्नानां वर्णसङ्करकारकैः | उत्साद्यन्ते जातिधर्माः कुलधर्माश्च शाश्वताः || 43 ||',
      'translation':
          'By these misdeeds of the family destroyers, which cause the intermingling of classes, the eternal community and family traditions are destroyed.',
      'word_meaning':
          'दोषैः एतैः—by these faults; कुल-घ्नानाम्—of the destroyers of the family; वर्ण-सङ्कर-कारकैः—the cause of the intermingling of classes; उत्साद्यन्ते—are destroyed; जाति-धर्माः—community traditions; कुल-धर्माः—family traditions; च—and; शाश्वताः—eternal.',
      'commentary':
          'This summarizes Arjuna’s cultural argument: the entire social and spiritual fabric is held together by *Kula-Dharma* (family tradition) and *Jāti-Dharma* (community tradition), both of which are irreversibly lost due to war.',
    });

    // Verse 44: Consequences of lost Dharma
    await db.insert('chapter_1', {
      'verse_number': 44,
      'sanskrit':
          'उत्सन्नकुलधर्माणां मनुष्याणां जनार्दन | नरके नियतं वासो भवतीत्यनुशुश्रुम || 44 ||',
      'translation':
          'We have heard, O Janārdana (Krishna), that the men whose family traditions are destroyed certainly dwell in hell forever.',
      'word_meaning':
          'उत्सन्न-कुल-धर्माणां—of the men whose family traditions are destroyed; मनुष्याणाम्—of the men; जनार्दन—O Janārdana (Krishna); नरके—in hell; नियतम्—certainly; वासः—residence; भवति—is; इति—thus; अनुशुश्रुम—we have heard (from authorities).',
      'commentary':
          'Arjuna cites established scriptural authority (**"we have heard"**) to support his claim, believing that eternal damnation awaits those responsible for destroying the established order. This fear paralyzes him.',
    });

    // Verse 45: Arjuna expresses the desire for martyrdom
    await db.insert('chapter_1', {
      'verse_number': 45,
      'sanskrit':
          'अहो बत महत्पापं कर्तुं व्यवसिता वयम् | यद्राज्यसुखलोभेन हन्तुं स्वजनमुद्यताः || 45 ||',
      'translation':
          'Alas, how strange that we are preparing to commit a great sin! Driven by the desire for the pleasure of the kingdom, we are intent on killing our own kinsmen.',
      'word_meaning':
          'अहो—alas; बत—how strange; महत्—great; पापम्—sin; कर्तुम्—to commit; व्यवसिताः—resolved; वयम्—we; यत्—because; राज्य-सुख-लोभेन—by the desire for the pleasure of the kingdom; हन्तुम्—to kill; स्व-जनम्—own kinsmen; उद्यताः—prepared.',
      'commentary':
          'Arjuna expresses remorse for his initial intent, recognizing his desire for the kingdom as the driving force behind the impending "great sin." This completes his acceptance of moral guilt.',
    });

    // Verse 46: Surrender to non-resistance
    await db.insert('chapter_1', {
      'verse_number': 46,
      'sanskrit':
          'यदि मामप्रतीकारमशस्त्रं शस्त्रपाणयः | धार्तराष्ट्रा रणे हन्युस्तन्मे क्षेमतरं भवेत् || 46 ||',
      'translation':
          'It would be better for me if the sons of Dhritarashtra, with weapons in hand, were to kill me, unarmed and unresisting, in the battle.',
      'word_meaning':
          'यदि—if; माम्—me; अप्रतीकारम्—unresisting; अशस्त्रम्—unarmed; शस्त्र-पाणयः—with weapons in hand; धार्तराष्ट्राः—the sons of Dhritarashtra; रणे—in battle; हन्युः—might kill; तत्—that; मे—for me; क्षेम-तरम्—more beneficial/better; भवेत्—would be.',
      'commentary':
          'Arjuna concludes that non-resistance and death as an unarmed martyr would be a morally superior path to fighting a sinful war. This statement marks his complete rejection of his *Kshatriya* duty.',
    });

    // Verse 47: Sanjay's final observation (Conclusion of Chapter 1)
    await db.insert('chapter_1', {
      'verse_number': 47,
      'sanskrit':
          'सञ्जय उवाच | एवमुक्त्वार्जुनः सङ्ख्ये रथोपस्थ उपाविशत् | विसृज्य सशरं चापं शोकसंविग्नमानसः || 47 ||',
      'translation':
          'Sanjay said: Having spoken thus on the battlefield, Arjuna cast aside his bow and arrow and sank down on the seat of the chariot, his mind distressed with sorrow.',
      'word_meaning':
          'सञ्जयः उवाच—Sanjay said; एवम् उक्त्वा—speaking thus; अर्जुनः—Arjuna; सङ्ख्ये—on the battlefield; रथ-उपस्थे—on the seat of the chariot; उपाविशत्—sat down; विसृज्य—casting aside; स-शरम्—along with arrows; चापम्—the bow; शोक-संविग्न-मानसः—with a mind overwhelmed with grief.',
      'commentary':
          'This is the climax of the first chapter, aptly titled **Arjun Viṣhād Yog** (The Yoga of Arjuna’s Dejection). Arjuna’s failure to act, demonstrated by physically dropping his weapons, creates the necessary moment of crisis for Lord Krishna to deliver the philosophical instructions in Chapter 2.',
    });
  }

  Future<void> insertChapter2Verses(Database db) async {
    // Verse 1: Sanjay describes Arjuna's condition
    await db.insert('chapter_2', {
      'verse_number': 1,
      'sanskrit':
          'सञ्जय उवाच | तं तथा कृपयाविष्टमश्रुपूर्णाकुलेक्षणम् | विषीदन्तमिदं वाक्यमुवाच मधुसूदनः || 1 ||',
      'translation':
          'Sañjaya said: To him who was thus overwhelmed with pity, lamenting, with eyes full of tears and agitated, Madhusūdana (Krishna) spoke the following words.',
      'word_meaning':
          'सञ्जयः उवाच—Sañjaya said; तम्—unto Arjuna; तथा—thus; कृपया—by compassion; आविष्टम्—overwhelmed; अश्रु-पूर्ण-आकुल-ईक्षणम्—with tearful and agitated eyes; विषीदन्तम्—lamenting; इदम्—these; वाक्यम्—words; उवाच—spoke; मधुसूदनः—Madhusūdana (Krishna).',
      'commentary':
          'Chapter 2 marks the shift from Arjuna’s grief (Arjun Viṣhād Yog) to Lord Krishna’s divine wisdom (Sānkhya Yog). Krishna is addressed as Madhusūdana, the killer of the Madhu demon, indicating that He is about to slay the demon of delusion in Arjuna’s mind.',
    });

    // Verse 2: Krishna begins his discourse, chastising Arjuna's weakness
    await db.insert('chapter_2', {
      'verse_number': 2,
      'sanskrit':
          'श्रीभगवानुवाच | कुतस्त्वा कश्मलमिदं विषमे समुपस्थितम् | अनार्यजुष्टमस्वर्ग्यमकीर्तिकरमर्जुन || 2 ||',
      'translation':
          'The Supreme Lord said: My dear Arjuna, how has this delusion come upon you in this hour of peril? It is not befitting a noble person. It leads not to the higher abodes, but to disgrace.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; कुतः—wherefrom; त्वा—to you; कश्मलम्—delusion/impurity; इदम्—this; विषमे—in this critical moment; समुपस्थितम्—overcome; अनार्य-जुष्टम्—unbecoming of a noble person; अस्वर्ग्यम्—which does not lead to heaven; अकीर्ति-करम्—disgraceful; अर्जुन—O Arjuna.',
      'commentary':
          'Krishna’s first words are a sharp reprimand. He immediately rejects Arjuna’s grief as weakness (`kaśhmalam`), pointing out that giving up duty at the critical moment is ignoble, will lead to infamy, and will prevent Arjuna from attaining spiritual benefit.',
    });

    await db.insert('chapter_2', {
      'verse_number': 3,
      'sanskrit':
          'क्लैब्यं मा स्म गमः पार्थ नैतत्त्वय्युपपद्यते | क्षुद्रं हृदयदौर्बल्यं त्यक्त्वोत्तिष्ठ परन्तप || 3 ||',
      'translation':
          'O son of Pṛithā (Arjuna), do not yield to this degrading impotence. It does not become you. Give up such petty weakness of heart and arise, O chastiser of the enemy!',
      'word_meaning':
          'क्लैब्यम्—impotence/unmanliness; मा स्म गमः—do not yield; पार्थ—O son of Pṛithā (Arjuna); न एतत्—this is not; त्वयि—in you; उपपद्यते—befitting; क्षुद्रम्—petty; हृदय-दौर्बल्यम्—weakness of heart; त्यक्त्वा—casting aside; उत्तिष्ठ—arise; परन्तप—O chastiser of the foes.',
      'commentary':
          'Krishna uses harsh words to provoke Arjuna, appealing to his identity as a warrior (`Parantapa`) and reminding him of his mother\'s heritage (`Pārtha`). The command is simple: stop feeling sorry for yourself and fight.',
    });

    await db.insert('chapter_2', {
      'verse_number': 4,
      'sanskrit':
          'अर्जुन उवाच | कथं भीष्ममहं सङ्ख्ये द्रोणं च मधुसूदन | इषुभिः प्रतियोत्स्यामि पूजार्हावरिसूदन || 4 ||',
      'translation':
          'Arjuna said: O Madhusūdana, how can I counter-attack with arrows in battle, Bhishma and Droṇa, who are worthy of my worship, O Slayer of foes (Ari-sūdana)?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; कथम्—how; भीष्मम्—Bhishma; अहम्—I; सङ्ख्ये—in battle; द्रोणम्—Droṇa; च—and; मधुसूदन—O Madhusūdana; इषुभिः—with arrows; प्रतियोत्स्यामि—shall I fight back; पूजा-अर्हौ—worshipable; अरि-सूदन—O killer of enemies.',
      'commentary':
          'Arjuna confirms that his primary dilemma is fighting revered elders. He uses two of Krishna’s names, Madhusūdana and Ari-sūdana, implicitly asking why the slayer of enemies (Krishna) would ask him to slay worshipable figures.',
    });

    // Verse 5: Arjuna favors living by begging
    await db.insert('chapter_2', {
      'verse_number': 5,
      'sanskrit':
          'गुरूनहत्वा हि महानुभावान् श्रेयो भोक्तुं भैक्ष्यमपीह लोके | हत्वार्थकामांस्तु गुरूनिहैव भुञ्जीय भोगान् रुधिरप्रदिग्धान् || 5 ||',
      'translation':
          'It is better to live in this world by begging than to enjoy life by killing these noble preceptors. If I kill them, all the enjoyments I have will be stained with their blood.',
      'word_meaning':
          'गुरून्—the teachers; अ-हत्वा—without killing; हि—certainly; महा-अनुभावान्—great personalities; श्रेयः—it is better; भोक्तुम्—to enjoy; भैक्ष्यम्—alms; अपि—even; इह—in this; लोके—world; हत्वा—after killing; अर्थ-कामान्—desiring worldly gain; तु—but; गुरून्—teachers; इह एव—here and now; भुञ्जीय—I would enjoy; भोगान्—enjoyments; रुधिर-प्रदिग्धान्—stained with blood.',
      'commentary':
          'Arjuna elevates his moral standard, suggesting that a life of penance (begging) is morally superior to a life of stained kingship. He sees the acquisition of wealth/pleasure (`artha-kāmān`) as tainted by the act of killing his gurus.',
    });

    // Verse 6: Arjuna expresses doubt about victory
    await db.insert('chapter_2', {
      'verse_number': 6,
      'sanskrit':
          'न चैतद्विद्मः कतरन्नो गरीयो यद्वा जयेम यदि वा नो जयेयुः | यानेव हत्वा न जिजीविषामस् तेऽवस्थिताः प्रमुखे धार्तराष्ट्राः || 6 ||',
      'translation':
          'Nor do we know which is better—conquering them or being conquered by them. Moreover, after killing the sons of Dhritarashtra, we would not wish to live, yet they stand before us.',
      'word_meaning':
          'न च—nor; एतत्—this; विद्मः—we know; कतरत्—which; नः—for us; गरीयः—is better; यत् वा—whether; जयेम—we conquer; यदि वा—or whether; नः—us; जयेयुः—they conquer; यान्—those whom; एव—certainly; हत्वा—after killing; न—not; जिजीविषामः—we wish to live; ते—they; अवस्थिताः—are standing; प्रमुखे—in the front; धार्तराष्ट्राः—the sons of Dhritarashtra.',
      'commentary':
          'Arjuna reveals his profound internal crisis. He cannot see a favorable outcome, regardless of the battle\'s result. Even victory seems worse than defeat, as he would have to live with the guilt of killing his family.',
    });

    // Verse 7: Arjuna surrenders and seeks guidance
    await db.insert('chapter_2', {
      'verse_number': 7,
      'sanskrit':
          'कार्पण्यदोषोपहतस्वभावः पृच्छामि त्वां धर्मसम्मूढचेताः | यच्छ्रेयः स्यान्निश्चितं ब्रूहि तन्मे शिष्यस्तेऽहं शाधि मां त्वां प्रपन्नम् || 7 ||',
      'translation':
          'My nature is tainted by the weakness of miserly pity, and my mind is confused about my duty (Dharma). I ask You: tell me decisively what is best for me. I am Your disciple, surrendered to You; please instruct me.',
      'word_meaning':
          'कार्पण्य-दोष-उपहत-स्वभावः—my nature is corrupted by the flaw of weakness/pity; पृच्छामि—I am asking; त्वाम्—You; धर्म-सम्मूढ-चेताः—with a mind bewildered about duty; यत्—that which; श्रेयः—better/beneficial; स्यात्—may be; निश्चितम्—decisively; ब्रूहि—tell; तत्—that; मे—to me; शिष्यः—disciple; ते—Your; अहम्—I am; शाधि—instruct; माम्—me; त्वाम्—unto You; प्रपन्नम्—surrendered.',
      'commentary':
          'This is the most critical verse in the Gita. Arjuna drops his arguments and formally accepts Krishna as his Guru (`śiṣyas te ’haṁ`), moving the conversation from a casual debate between friends to a spiritual discourse between a master and a disciple. This surrender legitimizes the entire teaching of the Bhagavad Gita.',
    });

    // Verse 8: Arjuna states that no material gain can remove his grief
    await db.insert('chapter_2', {
      'verse_number': 8,
      'sanskrit':
          'न हि प्रपश्यामि ममापनुद्याद् यच्छोकमुच्छोषणमिन्द्रियाणाम् | अवाप्य भूमावसपत्नमृद्धं राज्यं सुराणामपि चाधिपत्यम् || 8 ||',
      'translation':
          'I do not see how this sorrow, which is drying up my senses, can be removed, even if I attain an unrivaled, prosperous kingdom on earth or lordship over the celestial gods.',
      'word_meaning':
          'न—not; हि—certainly; प्रपश्यामि—I see; मम—my; अपनद्यात्—will remove; यत्—that which; शोकम्—grief; उच्छोषणम्—drying up; इन्द्रियाणाम्—of the senses; अवाप्य—having obtained; भूमौ—on the earth; असपत्नम्—unrivaled; ऋद्धम्—prosperous; राज्यम्—kingdom; सुराणाम्—of the demigods; अपि—even; च—and; आधिपत्यम्—supremacy.',
      'commentary':
          'Arjuna emphasizes that his grief is not material but psychological/spiritual. He asserts that worldly success (even cosmic dominion) cannot cure his deep-seated anxiety, proving his need for philosophical instruction, not just battle tactics.',
    });

    // Verse 9: Sanjay's observation: Arjuna ceases fighting
    await db.insert('chapter_2', {
      'verse_number': 9,
      'sanskrit':
          'सञ्जय उवाच | एवमुक्त्वा हृषीकेशं गुडाकेशः परन्तप | न योत्स्य इति गोविन्दमुक्त्वा तूष्णीं बभूव ह || 9 ||',
      'translation':
          'Sañjaya said: Having spoken thus to Hrishikesha (Krishna), Arjuna, the conqueror of sleep and chastiser of foes, declared to Govinda, "I shall not fight," and fell silent.',
      'word_meaning':
          'सञ्जयः उवाच—Sañjaya said; एवम् उक्त्वा—speaking thus; हृषीकेशम्—unto Hrishikesha; गुडाकेशः—Arjuna (conqueror of sleep); परन्तप—the chastiser of enemies; न योत्स्ये—I shall not fight; इति—thus; गोविन्दम्—unto Govinda; उक्त्वा—after speaking; तूष्णीम्—silent; बभूव ह—became.',
      'commentary':
          'Arjuna’s formal surrender is complete. By saying "I shall not fight" and then falling silent, he hands the initiative entirely to Krishna, signaling his readiness to receive divine knowledge.',
    });

    // Verse 10: Krishna's acceptance and opening words
    await db.insert('chapter_2', {
      'verse_number': 10,
      'sanskrit':
          'तमुवाच हृषीकेशः प्रहसन्निव भारत | सेनयोरुभयोर्मध्ये विषीदन्तमिदं वचः || 10 ||',
      'translation':
          'O descendant of Bharata (Dhritarashtra), Hrishikesha (Krishna), as if smiling, spoke these words to the lamenting Arjuna in the midst of the two armies.',
      'word_meaning':
          'तम्—unto him (Arjuna); उवाच—spoke; हृषीकेशः—Hrishikesha (Krishna); प्रहसन् इव—as if smiling; भारत—O descendant of Bharata; सेनयोः—of the armies; उभयोः—both; मध्ये—in the middle; विषीदन्तम्—lamenting; इदम्—these; वचः—words.',
      'commentary':
          'Krishna finally speaks, but "as if smiling." This smile signifies His detachment from the drama, His patience with Arjuna\'s confusion, and His anticipation of delivering the profound truths that follow. This verse sets the stage for the primary philosophical discourse of the Bhagavad Gita.',
    });

    // Verse 11: Krishna begins the instruction, calling Arjuna unwise
    await db.insert('chapter_2', {
      'verse_number': 11,
      'sanskrit':
          'श्रीभगवानुवाच | अशोच्यानन्वशोचस्त्वं प्रज्ञावादांश्च भाषसे | गतासूनगतासूंश्च नानुशोचन्ति पण्डिताः || 11 ||',
      'translation':
          'The Supreme Lord said: While speaking words of wisdom, you are mourning for that which is not worthy of grief. The wise lament neither for the living nor for the dead.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; अशोच्यान्—not worthy of grief; अन्वशोचः—you are mourning; त्वम्—you; प्रज्ञा-वादान्—learned words; च—and; भाषसे—are speaking; गत-असून्—the dead; अ-गत-असून्—the living; च—and; न—never; अनुशोचन्ति—lament; पण्डिताः—the wise.',
      'commentary':
          'Krishna begins His discourse by directly challenging Arjuna’s foundational premise. He states that true wisdom (`prajñā`) lies in understanding the difference between the eternal (soul) and the temporary (body). Since the wise know this distinction, they have no reason to grieve for anyone.',
    });

    // Verse 12: The eternity of the Soul and God
    await db.insert('chapter_2', {
      'verse_number': 12,
      'sanskrit':
          'न त्वेवाहं जातु नासं न त्वं नेमे जनाधिपाः | न चैव न भविष्यामः सर्वे वयमतः परम् || 12 ||',
      'translation':
          'Never was there a time when I did not exist, nor you, nor all these kings; nor shall any of us cease to be in the future.',
      'word_meaning':
          'न तु एव—never was; अहम्—I; जातु—at any time; न आसम्—did not exist; न त्वम्—nor you; न इमे—nor these; जन-अधिपाः—kings/rulers; न च एव—nor certainly; न भविष्यामः—shall cease to exist; सर्वे—all; वयम्—we; अतः परम्—hereafter.',
      'commentary':
          'Krishna introduces the concept of the eternal nature of the individual soul (Ātman). This verse establishes that life is a continuous existence, independent of the body, and that all beings (including God) are eternal entities.',
    });

    // Verse 13: The journey of the embodied soul (reincarnation)
    await db.insert('chapter_2', {
      'verse_number': 13,
      'sanskrit':
          'देहिनोऽस्मिन्यथा देहे कौमारं यौवनं जरा | तथा देहान्तरप्राप्तिर्धीरस्तत्र न मुह्यति || 13 ||',
      'translation':
          'Just as the embodied soul continuously passes, in this body, from childhood to youth to old age, the soul similarly passes into another body at death. A sober person is not bewildered by such a change.',
      'word_meaning':
          'देहिनः—of the embodied soul; अस्मिन्—in this; यथा—as; देहे—in the body; कौमारम्—childhood; यौवनम्—youth; जरा—old age; तथा—similarly; देह-अन्तर-प्राप्तिः—obtainment of another body; धीरः—the sober/wise; तत्र—therein; न मुह्यति—is not deluded/bewildered.',
      'commentary':
          'This famous verse explains death and rebirth as merely a process of changing bodies, comparable to the physical changes experienced throughout life. The wise (`Dhīra`) understand this continuity and remain undisturbed by the temporary nature of the body.',
    });

    // Verse 14: The temporary nature of dualities
    await db.insert('chapter_2', {
      'verse_number': 14,
      'sanskrit':
          'मात्रास्पर्शास्तु कौन्तेय शीतोष्णसुखदुःखदाः | आगमापायिनोऽनित्यास्तांस्तितिक्षस्व भारत || 14 ||',
      'translation':
          'O son of Kuntī (Arjuna), the contact of the senses with the sense objects gives rise to fleeting feelings of heat and cold, pleasure and pain. They are temporary, appearing and disappearing; therefore, learn to tolerate them, O descendant of Bharata.',
      'word_meaning':
          'मात्रा-स्पर्शाः—the contact of the senses with sense objects; तु—but; कौन्तेय—O son of Kuntī; शीत-उष्ण—cold and heat; सुख-दुःख-दाः—givers of pleasure and pain; आगम-अपायिनः—with coming and going (temporary); अनित्याः—non-eternal; तान्—them; तितिक्षस्व—learn to tolerate; भारत—O descendant of Bharata.',
      'commentary':
          'Since the soul is eternal and bodies are transient, the experiences of pleasure, pain, heat, and cold are also temporary, caused by the interaction of the senses with matter. Krishna instructs Arjuna in the practice of **Toleration** (`titikṣasva`) as the first step toward transcendence.',
    });

    // Verse 15: The result of tolerance
    await db.insert('chapter_2', {
      'verse_number': 15,
      'sanskrit':
          'यं हि न व्यथयन्त्येते पुरुषं पुरुषर्षभ | समदुःखसुखं धीरं सोऽमृतत्वाय कल्पते || 15 ||',
      'translation':
          'O best among men (Arjuna), the person who is not disturbed by happiness and distress, and remains steady in both, is certainly eligible for immortality (liberation).',
      'word_meaning':
          'यम्—whom; हि—certainly; न व्यथयन्ति—do not distress; एते—these; पुरुषम्—a person; पुरुष-ऋषभ—O best among men; सम-दुःख-सुखम्—equipoised in pain and pleasure; धीरम्—sober/patient; सः—that person; अमृतत्वाय—for immortality; कल्पते—is eligible.',
      'commentary':
          'This verse establishes the key prerequisite for spiritual realization (Mokṣha): the ability to remain unmoved by life’s dualities. This spiritual steadfastness elevates one above the material world to attain the state of immortality.',
    });

    // Verse 16: The distinction between real and unreal
    await db.insert('chapter_2', {
      'verse_number': 16,
      'sanskrit':
          'नासतो विद्यते भावो नाभावो विद्यते सतः | उभयोरपि दृष्टोऽन्तस्त्वनयोस्तत्त्वदर्शिभिः || 16 ||',
      'translation':
          'Of the unreal (the material body), there is no permanence, and of the real (the soul), there is no cessation. The knowers of the truth (Tattva-darśhibhiḥ) have concluded this by studying the nature of both.',
      'word_meaning':
          'न—not; असतः—of the non-existent (unreal); विद्यते—there is; भावः—permanence/existence; न—nor; अभावः—non-existence/cessation; विद्यते—there is; सतः—of the eternal (real); उभयोः—of both; अपि—also; दृष्टः—seen/concluded; अन्तः—the truth/end; तु—but; अनयोः—of these two; तत्त्व-दर्शिभिः—by the seers of the truth.',
      'commentary':
          'This verse presents the philosophical core of the Sānkhya system (analytical knowledge). It asserts that the *Sat* (eternal soul) cannot be destroyed, and the *Asat* (temporary body) cannot truly exist forever. The wise focus their concern only on the eternal Reality.',
    });

    // Verse 17: The pervasive and indestructible nature of the Soul
    await db.insert('chapter_2', {
      'verse_number': 17,
      'sanskrit':
          'अविनाशि तु तद्विद्धि येन सर्वमिदं ततम् | विनाशमव्ययस्यास्य न कश्चित्कर्तुमर्हति || 17 ||',
      'translation':
          'Know that which pervades the entire body to be indestructible. No one can cause the destruction of the imperishable soul.',
      'word_meaning':
          'अविनाशि—indestructible; तु—but; तत्—that; विद्धि—know; येन—by which; सर्वम्—all; इदम्—this; ततम्—is pervaded; विनाशम्—destruction; अव्ययस्य—of the imperishable; अस्य—this; न कश्चित्—no one; कर्तुम् अर्हति—is able to do.',
      'commentary':
          'The soul is characterized as pervasive (extending throughout the body, like consciousness) and immutable. Since the soul is not a composite object, its destruction by any means is logically impossible, eliminating Arjuna\'s fear of killing the soul.',
    });

    // Verse 18: The perishable nature of the body (conclusion to fight)
    await db.insert('chapter_2', {
      'verse_number': 18,
      'sanskrit':
          'अन्तवन्त इमे देहा नित्यस्योक्ताः शरीरिणः | अनाशिनोऽप्रमेयस्य तस्माद्युध्यस्व भारत || 18 ||',
      'translation':
          'The material bodies of the embodied, eternal, indestructible, and immeasurable soul are transient. Therefore, fight, O descendant of Bharata.',
      'word_meaning':
          'अन्त-वन्तः—having an end; इमे—these; देहाः—bodies; नित्यस्य—of the eternal; उक्ताः—are said to be; शरीरिणः—of the embodied soul; अ-नाशिनः—indestructible; अ-प्रमेयस्य—immeasurable; तस्मात्—therefore; युध्यस्व—fight; भारत—O descendant of Bharata.',
      'commentary':
          'This is Krishna’s first direct command to action. The logic is: since the bodies are perishable and the soul is eternal, Arjuna should not mourn the body, which will perish anyway, but should fulfill his duty by fighting.',
    });

    // Verse 19: Ignorance about the soul's ability to kill
    await db.insert('chapter_2', {
      'verse_number': 19,
      'sanskrit':
          'य एनं वेत्ति हन्तारं यश्चैनं मन्यते हतम् | उभौ तौ न विजानीतो नायं हन्ति न हन्यते || 19 ||',
      'translation':
          'The one who thinks the soul is the slayer and the one who thinks the soul is slain—both are ignorant. The soul neither slays nor is slain.',
      'word_meaning':
          'यः—who; एनम्—this (soul); वेत्ति—knows; हन्तारम्—the slayer; यः—who; च—and; एनम्—this; मन्यते—thinks; हतम्—slain; उभौ—both; तौ—those; न विजानीतः—do not know; न अयम्—nor this one; हन्ति—slays; न हन्यते—nor is slain.',
      'commentary':
          'Krishna counters Arjuna\'s primary fear of incurring the sin of killing. Both the feeling of being the doer ("I kill") and the feeling of being a victim ("They will be killed") are based on the delusion that the body is the self or the soul is the agent of action.',
    });

    // Verse 20: Detailed description of the soul's nature
    await db.insert('chapter_2', {
      'verse_number': 20,
      'sanskrit':
          'न जायते म्रियते वा कदाचि न्नायं भूत्वा भविता वा न भूयः | अजो नित्यः शाश्वतोऽयं पुराणो न हन्यते हन्यमाने शरीरे || 20 ||',
      'translation':
          'The soul is neither born nor does it ever die; nor, having once been, does it ever cease to be. The soul is unborn, eternal, everlasting, and ancient. It is not killed when the body is killed.',
      'word_meaning':
          'न जायते—is never born; म्रियते—dies; वा—or; कदाचित्—at any time; न अयम्—nor this (soul); भूत्वा—having come into being; भविता वा न भूयः—will cease to exist again; अजः—unborn; नित्यः—eternal; शाश्वतः—ever-existing; अयम्—this; पुराणः—ancient; न हन्यते—is not killed; हन्यमाने—being killed; शरीरे—when the body.',
      'commentary':
          'This verse emphatically confirms the soul\'s six unchanging qualities: unborn, eternal, everlasting, ancient, unslain, and unperishing. This detailed knowledge should resolve Arjuna\'s grief, as the real "self" of his relatives is unaffected by the battle.',
    });

    // Verse 21: The Non-doership of the Knower (Continuation of eternal nature)
    await db.insert('chapter_2', {
      'verse_number': 21,
      'sanskrit':
          'वेदाविनाशिनं नित्यं य एनमजमव्ययम् | कथं स पुरुषः पार्थ कं घातयति हन्ति कम् || 21 ||',
      'translation':
          'O Pārtha, how can one who knows the soul to be imperishable, eternal, unborn, and immutable kill anyone or cause anyone to kill?',
      'word_meaning':
          'वेद—knows; अविनाशिनम्—imperishable; नित्यम्—eternal; यः—who; एनम्—this (soul); अजम्—unborn; अव्ययम्—immutable; कथम्—how; सः पुरुषः—that person; पार्थ—O Pārtha; कम्—whom; घातयति—causes to kill; हन्ति—kills; कम्—whom.',
      'commentary':
          'This verse addresses the concept of **agency**. A wise person knows the soul is not the doer of the body\'s actions and is therefore free from the illusion of "I kill" or "I am killed."',
    });

    // Verse 22: Analogy of changing clothes (Reincarnation explained simply)
    await db.insert('chapter_2', {
      'verse_number': 22,
      'sanskrit':
          'वासांसि जीर्णानि यथा विहाय नवानि गृह्णाति नरोऽपराणि | तथा शरीराणि विहाय जीर्णान्यन्यानि संयाति नवानि देही || 22 ||',
      'translation':
          'Just as a person casts off worn-out garments and puts on new ones, so too the embodied soul discards worn-out bodies and enters into new ones.',
      'word_meaning':
          'वासांसि—garments; जीर्णानि—worn-out; यथा—as; विहाय—casting aside; नवानि—new; गृह्णाति—accepts; नरः—a person; अपराणि—others; तथा—similarly; शरीराणि—bodies; विहाय—casting aside; जीर्णानि—worn-out; अन्यानि—others; संयाति—enters fully; नवानि—new; देही—the embodied soul.',
      'commentary':
          'This is the most famous analogy in the Gita. It removes the fear of death by portraying the loss of the physical body as a trivial change of attire, not an ending of existence.',
    });

    // Verse 23: The inability to destroy the soul by elemental forces
    await db.insert('chapter_2', {
      'verse_number': 23,
      'sanskrit':
          'नैनं छिन्दन्ति शस्त्राणि नैनं दहति पावकः | न चैनं क्लेदयन्त्यापो न शोषयति मारुतः || 23 ||',
      'translation':
          'Weapons cannot cut the soul, fire cannot burn it, water cannot moisten it, nor can the wind dry it.',
      'word_meaning':
          'न एनम्—cannot this (soul); छिन्दन्ति—cut; शस्त्राणि—weapons; न एनम्—nor this; दहति—burn; पावकः—fire; न च एनम्—nor this; क्लेदयन्ति—moisten; आपः—water; न शोषयति—nor dry; मारुतः—wind.',
      'commentary':
          'Krishna further defines the soul\'s immutability by contrasting it with the five gross elements (*Pañcha Mahābhūta*). The soul is unaffected by the primary forces of the material world, making it truly indestructible.',
    });

    // Verse 24: Summary of the soul's immutable nature
    await db.insert('chapter_2', {
      'verse_number': 24,
      'sanskrit':
          'अच्छेद्योऽयमदाह्योऽयमक्लेद्योऽशोष्य एव च | नित्यः सर्वगतः स्थाणुरचलोऽयं सनातनः || 24 ||',
      'translation':
          'The soul is unbreakable, incombustible, cannot be moistened, and cannot be dried. It is eternal, all-pervading, stable, immovable, and everlasting.',
      'word_meaning':
          'अच्छेद्यः—cannot be cut; अयम्—this (soul); अदाह्यः—cannot be burned; अयम्—this; अक्लेद्यः—cannot be moistened; अशोष्यः—cannot be dried; एव च—certainly; नित्यः—eternal; सर्व-गतः—all-pervading; स्थाणुः—stable; अचलः—immovable; अयम्—this; सनातनः—everlasting.',
      'commentary':
          'This verse compiles the key characteristics of the soul, contrasting its permanent, non-material nature with the ever-changing, divisible nature of the body. The soul is truly transcendental and non-reactive to material change.',
    });

    // Verse 25: Conclusion to the Sānkhya argument
    await db.insert('chapter_2', {
      'verse_number': 25,
      'sanskrit':
          'अव्यक्तोऽयमचिन्त्योऽयमविकार्योऽयमुच्यते | तस्मादेवं विदित्वैनं नानुशोचितुमर्हसि || 25 ||',
      'translation':
          'The soul is said to be unmanifest (invisible), inconceivable (beyond thought), and immutable (unchangeable). Knowing this to be true, you should not grieve for the body.',
      'word_meaning':
          'अव्यक्तः—unmanifest; अयम्—this; अचिन्त्यः—inconceivable; अयम्—this; अविकार्यः—immutable; अयम्—this; उच्यते—is said to be; तस्मात्—therefore; एवम्—thus; विदित्वा—having known; एनम्—this; न अनुशोचितुम्—not to lament; अर्हसि—you should.',
      'commentary':
          'Krishna concludes the initial philosophical argument: since the soul\'s nature is beyond the grasp of material perception and logic, attachment to the body (and its fate) is baseless. Therefore, lamentation is inappropriate.',
    });

    // Verse 26: Addressing the materialist view (The alternative argument)
    await db.insert('chapter_2', {
      'verse_number': 26,
      'sanskrit':
          'अथ चैनं नित्यजातं नित्यं वा मन्यसे मृतम् | तथापि त्वं महाबाहो नैवं शोचितुमर्हसि || 26 ||',
      'translation':
          'And even if you think the soul is eternally born and eternally dies, even then, O mighty-armed (Arjuna), you should not grieve.',
      'word_meaning':
          'अथ च—and moreover; एनम्—this (soul); नित्य-जातम्—eternally born; नित्यम् वा—or eternally; मन्यसे—you think; मृतम्—dead; तथा अपि—even so; त्वम्—you; महा-बाहो—O mighty-armed; न एवम्—not thus; शोचितुम् अर्हसि—should lament.',
      'commentary':
          'Krishna now shifts tactics, addressing the perspective of a materialist who denies the soul\'s eternity. Even if one believes that consciousness is born with the body and dies with it, one still shouldn\'t lament, as birth and death are unavoidable natural cycles.',
    });

    // Verse 27: The cycle of birth and death (The unavoidable)
    await db.insert('chapter_2', {
      'verse_number': 27,
      'sanskrit':
          'जातस्य हि ध्रुवो मृत्युर्ध्रुवं जन्म मृतस्य च | तस्मादपरिहार्येऽर्थे न त्वं शोचितुमर्हसि || 27 ||',
      'translation':
          'For one who has taken birth, death is certain; and for one who is dead, birth is certain. Therefore, in the face of the unavoidable, you should not grieve.',
      'word_meaning':
          'जातस्य—of one who is born; हि—certainly; ध्रुवः—sure; मृत्युः—death; ध्रुवम्—sure; जन्म—birth; मृतस्य—of one who is dead; च—and; तस्मात्—therefore; अपरिहार्ये—in the unavoidable; अर्थे—matter; न त्वम्—you should not; शोचितुम् अर्हसि—grieve.',
      'commentary':
          'This provides a secondary, practical argument: if an event (like death) is certain and inevitable, wasting energy on lamentation is futile. Arjuna should focus on his duty rather than grieving natural, unavoidable processes.',
    });

    // Verse 28: Beings are unmanifest in the beginning and end
    await db.insert('chapter_2', {
      'verse_number': 28,
      'sanskrit':
          'अव्यक्तादीनि भूतानि व्यक्तमध्यानि भारत | अव्यक्तनिधनान्येव तत्र का परिदेवना || 28 ||',
      'translation':
          'O descendant of Bharata (Arjuna), all created beings are unmanifest in their beginning, manifest in their intermediate state, and unmanifest again when they are annihilated. So, why lament?',
      'word_meaning':
          'अव्यक्त-आदीनि—unmanifest at the beginning; भूतानि—beings; व्यक्त-मध्यानि—manifest in the middle; भारत—O descendant of Bharata; अव्यक्त-निधनानि—unmanifest at annihilation; एव—certainly; तत्र—there; का—what; परिदेवना—lamentation.',
      'commentary':
          'This offers the final intellectual argument against grief. Since the true nature of beings (the soul) is invisible before birth and after death, the intermediate, visible state (the body) is merely a temporary phenomenon, unworthy of prolonged sorrow.',
    });

    // Verse 29: The wonder of the Soul (Rarity of True Knowledge)
    await db.insert('chapter_2', {
      'verse_number': 29,
      'sanskrit':
          'आश्चर्यवत्पश्यति कश्चिदेनमाश्चर्यवद्वदति तथैव चान्यः | आश्चर्यवच्चैनमन्यः श्रृणोति श्रुत्वाप्येनं वेद न चैव कश्चित् || 29 ||',
      'translation':
          'Some look upon the soul as amazing, some speak of it as amazing, and some hear of it as amazing, while others, even after hearing, do not comprehend it at all.',
      'word_meaning':
          'आश्चर्य-वत्—as amazing; पश्यति—sees; कश्चित्—someone; एनम्—this (soul); आश्चर्य-वत्—as amazing; वदति—speaks; तथा एव च—and similarly; अन्यः—another; आश्चर्य-वत्—as amazing; च—and; एनम्—this; अन्यः—another; शृणोति—hears; श्रुत्वा—having heard; अपि—even; एनम्—this; वेद—knows; न च एव—never; कश्चित्—anyone.',
      'commentary':
          'Krishna highlights the profound difficulty of truly grasping the nature of the soul. The soul is so subtle and divine that most people can only regard it with wonder, unable to attain direct realization, emphasizing the value of the knowledge being revealed.',
    });

    // Verse 30: Conclusion of the Sānkhya Yoga section (The Soul is safe)
    await db.insert('chapter_2', {
      'verse_number': 30,
      'sanskrit':
          'देही नित्यमवध्योऽयं देहे सर्वस्य भारत | तस्मात्सर्वाणि भूतानि न त्वं शोचितुमर्हसि || 30 ||',
      'translation':
          'O descendant of Bharata, the embodied soul dwelling in the body can never be killed. Therefore, you should not grieve for any living being.',
      'word_meaning':
          'देही—the embodied soul; नित्यम्—eternally; अवध्यः—cannot be killed; अयम्—this; देहे—in the body; सर्वस्य—of everyone; भारत—O descendant of Bharata; तस्मात्—therefore; सर्वाणि—all; भूतानि—living beings; न त्वम्—you should not; शोचितुम् अर्हसि—grieve.',
      'commentary':
          'This verse summarizes the entire Sānkhya Yoga argument (Verses 11-30). It reiterates the fundamental truth that the soul is eternally safe and cannot be slain, definitively removing the basis for Arjuna\'s lamentation.',
    });

    // Verse 31: The argument of Swadharma (Duty) begins
    await db.insert('chapter_2', {
      'verse_number': 31,
      'sanskrit':
          'स्वधर्ममपि चावेक्ष्य न विकम्पितुमर्हसि | धर्म्याद्धि युद्धाच्छ्रेयोऽन्यत्क्षत्रियस्य न विद्यते || 31 ||',
      'translation':
          'Besides, considering your specific duty as a warrior (Kshatriya), you should not waver. Indeed, for a warrior, there is no better engagement than fighting for the upholding of righteousness (Dharma).',
      'word_meaning':
          'स्व-धर्मम्—one’s own duty; अपि—also; च—and; अवेक्ष्य—considering; न—not; विकम्पितुम्—to waver; अर्हसि—you should; धर्म्यात्—righteous; हि—indeed; युद्धात्—than fighting; श्रेयः—better; अन्यत्—another; क्षत्रियस्य—of a warrior; न विद्यते—there is not.',
      'commentary':
          'Krishna pivots the argument from the eternal soul to occupational duty (*Swadharma*). For a Kshatriya, a righteous war is the highest duty, and shirking it is condemned.',
    });

    // Verse 32: The fortunate warrior
    await db.insert('chapter_2', {
      'verse_number': 32,
      'sanskrit':
          'यदृच्छया चोपपन्नं स्वर्गद्वारमपावृतम् | सुखिनः क्षत्रियाः पार्थ लभन्ते युद्धमीदृशम् || 32 ||',
      'translation':
          'O Pārtha, happy are the warriors to whom such a fighting opportunity comes by chance, opening for them the doors of heaven.',
      'word_meaning':
          'यदृच्छया—by its own accord/by chance; च—and; उपपन्नम्—attained; स्वर्ग-द्वारम्—door of heaven; अपावृतम्—wide open; सुखिनः—happy; क्षत्रियाः—warriors; पार्थ—O Pārtha; लभन्ते—obtain; युद्धम्—a battle; ईदृशम्—such.',
      'commentary':
          'Krishna appeals to Arjuna’s warrior ethos and desire for celestial rewards. He suggests the war is not a tragedy, but a blessed chance for a Kshatriya to fulfill his Dharma and earn a place in heaven.',
    });

    // Verse 33: The consequences of not fighting
    await db.insert('chapter_2', {
      'verse_number': 33,
      'sanskrit':
          'अथ चेत्त्वमिमं धर्म्यं सङ्ग्रामं न करिष्यसि | ततः स्वधर्मं कीर्तिं च हित्वा पापमवाप्स्यसि || 33 ||',
      'translation':
          'If, however, you do not fight this righteous war, then you will incur sin by abandoning your duty and your reputation, and you will certainly attain a degraded position.',
      'word_meaning':
          'अथ चेत्—but if; त्वम्—you; इमम्—this; धर्म्यम्—righteous; सङ्ग्रामम्—battle; न करिष्यसि—will not perform; ततः—then; स्व-धर्मम्—your duty; कीर्तिम्—fame; च—and; हित्वा—giving up; पापम्—sin; अवाप्स्यसि—you will incur.',
      'commentary':
          'The failure to perform *Swadharma* results in two distinct losses: **spiritual** (incurring sin) and **worldly** (losing reputation). Both are considered ruinous.',
    });

    // Verse 34: Disgrace is worse than death
    await db.insert('chapter_2', {
      'verse_number': 34,
      'sanskrit':
          'अकीर्तिं चापि भूतानि कथयिष्यन्ति तेऽव्ययाम् | संभावितस्य चाकीर्तिर्मरणादतिरिच्यते || 34 ||',
      'translation':
          'People will forever recount your infamy, and for a respected person, dishonor is worse than death.',
      'word_meaning':
          'अकीर्तिम्—ill-repute; च अपि—and also; भूतानि—people; कथयिष्यन्ति—will speak; ते—your; अव्ययाम्—everlasting; संभावितस्य—of a respected person; च—and; अकीर्तिः—dishonor; मरणात्—than death; अतिरिच्यते—is worse.',
      'commentary':
          'Krishna appeals to Arjuna’s pride and status. For a highly esteemed warrior, eternal disgrace and mockery from his peers is a fate far more painful than any physical death.',
    });

    // Verse 35: The enemies' perception
    await db.insert('chapter_2', {
      'verse_number': 35,
      'sanskrit':
          'भयाद्रणादुपरतं मंस्यन्ते त्वां महारथाः | येषां च त्वं बहुमतो भूत्वा यास्यसि लाघवम् || 35 ||',
      'translation':
          'The great chariot warriors will think you have withdrawn from battle out of fear, and those who held you in high esteem will now treat you with contempt.',
      'word_meaning':
          'भयात्—out of fear; रणात्—from the battle; उपरतम्—withdrawn; मंस्यन्ते—they will think; त्वाम्—you; महा-रथाः—the great chariot fighters; येषाम्—of whom; च—and; त्वम्—you; बहु-मतः—held in high esteem; भूत्वा—having been; यास्यसि—you will go; लाघवम्—to lightness/contempt.',
      'commentary':
          'This reinforces the personal consequence. Arjuna’s great allies and adversaries will not credit his decision to pity or piety, but to simple cowardice, destroying his professional standing.',
    });

    // Verse 36: Enemies will mock him
    await db.insert('chapter_2', {
      'verse_number': 36,
      'sanskrit':
          'अवाच्यवादांश्च बहून्वदिष्यन्ति तवाहिताः | निन्दन्तस्तव सामर्थ्यं ततो दुःखतरं नु किम् || 36 ||',
      'translation':
          'Your enemies will speak many unutterable and harsh words, deriding your ability. What could be more painful than that?',
      'word_meaning':
          'अवाच्य-वादान्—forbidden words; च—and; बहून्—many; वदिष्यन्ति—will speak; तव—your; अहिताः—enemies; निन्दन्तः—deriding; तव—your; सामर्थ्यम्—capability; ततः—than that; दुःख-तरम्—more painful; नु—indeed; किम्—what.',
      'commentary':
          'The ultimate punishment is emotional and psychological: hearing one’s most despised enemies mock one’s strength and ability. Krishna suggests this mental suffering outweighs any physical pain.',
    });

    // Verse 37: The win-win proposition
    await db.insert('chapter_2', {
      'verse_number': 37,
      'sanskrit':
          'हतो वा प्राप्स्यसि स्वर्गं जित्वा वा भोक्ष्यसे महीम् | तस्मादुत्तिष्ठ कौन्तेय युद्धाय कृतनिश्चयः || 37 ||',
      'translation':
          'If you are killed in battle, you will attain heaven; or if you conquer, you will enjoy the kingdom. Therefore, arise, O son of Kuntī, with a firm resolve to fight!',
      'word_meaning':
          'हतः—killed; वा—or; प्राप्स्यसि—you will attain; स्वर्गम्—heaven; जित्वा—conquering; वा—or; भोक्ष्यसे—you will enjoy; महीम्—the earth/kingdom; तस्मात्—therefore; उत्तिष्ठ—arise; कौन्तेय—O son of Kuntī; युद्धाय—for battle; कृत-निश्चयः—with firm resolve.',
      'commentary':
          'This is a purely utilitarian argument tailored to the Kshatriya perspective: the result is a win-win scenario. Krishna gives the final command: **Arise and fight!**',
    });

    // Verse 38: Introduction to Karma Yoga (Equanimity in Action)
    await db.insert('chapter_2', {
      'verse_number': 38,
      'sanskrit':
          'सुखदुःखे समे कृत्वा लाभालाभौ जयाजयौ | ततो युद्धाय युज्यस्व नैवं पापमवाप्स्यसि || 38 ||',
      'translation':
          'Fight for the sake of fighting, without considering happiness or distress, gain or loss, victory or defeat. By engaging in this way, you will never incur sin.',
      'word_meaning':
          'सुख-दुःखे—happiness and distress; समे—equipoised; कृत्वा—having made; लाभ-अलाभौ—gain and loss; जय-अजयौ—victory and defeat; ततः—thereafter; युद्धाय—for fighting; युज्यस्व—engage; न एवम्—not thus; पापम्—sin; अवाप्स्यसि—you will incur.',
      'commentary':
          'This is the most important transitional verse, introducing the principle of **Karma Yoga**: action performed with equanimity, without attachment to the results. This attitude neutralizes the karmic reaction (*pāpam*).',
    });

    // Verse 39: The two systems of knowledge
    await db.insert('chapter_2', {
      'verse_number': 39,
      'sanskrit':
          'एषा तेऽभिहिता साङ्ख्ये बुद्धिर्योगे त्विमां श्रृणु | बुद्ध्या युक्तो यया पार्थ कर्मबन्धं प्रहास्यसि || 39 ||',
      'translation':
          'Thus far, I have declared this wisdom to you from the perspective of analytical knowledge (*Sānkhya*). Now, hear the wisdom of the path of action (*Yoga*), by which, O Pārtha, you can break the bondage of karma.',
      'word_meaning':
          'एषा—this; ते—to you; अभिहिता—spoken; साङ्ख्ये—in the analytic study (Sānkhya); बुद्धिः—wisdom; योगे—in the path of action (Yoga); तु—but; इमाम्—this; शृणु—hear; बुद्ध्या—by the intellect; युक्तः—united; यया—by which; पार्थ—O Pārtha; कर्म-बन्धम्—bondage of karma; प्रहास्यसि—you will break.',
      'commentary':
          'Krishna formally introduces the two complementary paths: **Sānkhya** (knowledge of the soul) and **Yoga** (the method of action). The rest of the chapter will focus on *Buddhi Yoga* or the *Yoga of Intellect*, which is the practical application of Sānkhya principles.',
    });

    // Verse 40: The safety of Karma Yoga
    await db.insert('chapter_2', {
      'verse_number': 40,
      'sanskrit':
          'नेहाभिक्रमनाशोऽस्ति प्रत्यवायो न विद्यते | स्वल्पमप्यस्य धर्मस्य त्रायते महतो भयात् || 40 ||',
      'translation':
          'In this endeavor (Karma Yoga), there is no loss of effort and no adverse result. Even a little of this righteous practice protects one from the greatest fear (of rebirth).',
      'word_meaning':
          'न इह—not here; अभिक्रम-नाशः—loss of endeavor; अस्ति—there is; प्रत्यवायः—adverse result; न विद्यते—is not found; स्वल्पम्—a small amount; अपि—even; अस्य—of this; धर्मस्य—righteous practice; त्रायते—delivers; महतः—great; भयात्—from fear.',
      'commentary':
          'This offers reassurance about the path of action. Unlike material pursuits, spiritual effort, no matter how small, is never wasted and offers protection from the cycle of birth and death (the greatest fear).',
    });

    // Verse 41: Single-pointed Determination (Vyavasāyātmikā Buddhi)
    await db.insert('chapter_2', {
      'verse_number': 41,
      'sanskrit':
          'व्यवसायात्मिका बुद्धिरेकेह कुरुनन्दन। बहुशाखा ह्यनन्ताश्च बुद्धयोऽव्यवसायिनाम्।। ४१।।',
      'translation':
          'Here, O beloved child of the Kurus (Arjuna), the intellect of those who are resolute has a single-pointed determination; the thoughts of the irresolute are many-branched and endless.',
      'word_meaning':
          'व्यवसायात्मिका—resolute in determination; बुद्धिः—intellect/resolve; एका—only one; इह—here (in this path of Yoga); कुरुनन्दन—O joy of the Kurus; बहुशाखाः—having many branches; हि—indeed; अनन्ताः—unlimited; च—and; बुद्धयः—intellects/thoughts; अव्यवसायिनाम्—of the irresolute.',
      'commentary':
          'This verse establishes the first principle of Yoga: concentration. A person with a spiritual goal has a single, unwavering focus, while those seeking various material pleasures have scattered, infinite desires.',
    });

    // Verse 42: Criticism of Fruitive Language (The "flowery speech")
    await db.insert('chapter_2', {
      'verse_number': 42,
      'sanskrit':
          'यामिमां पुष्पितां वाचं प्रवदन्त्यविपश्िचतः। वेदवादरताः पार्थ नान्यदस्तीति वादिनः।। ४२।।',
      'translation':
          'O Pārtha, those of stunted wisdom (*avipaścitaḥ*) are attached to the flowery words of the Vedas, proclaiming that there is nothing else.',
      'word_meaning':
          'याम् इमाम्—which this; पुष्पिताम्—flowery; वाचम्—speech; प्रवदन्ति—speak; अविपश्िचतः—those who lack discrimination; वेदवाद-रताः—attached to the words of the Vedas; पार्थ—O Pārtha; न अन्यत्—nothing else; अस्ति—is; इति वादिनः—those who say.',
      'commentary':
          'Krishna criticizes those who only focus on the ritualistic portions of the Vedas that promise temporary heaven and material rewards, misunderstanding the ultimate goal of liberation.',
    });

    // Verse 43: Fruitive Motivation Defined
    await db.insert('chapter_2', {
      'verse_number': 43,
      'sanskrit':
          'कामात्मानः स्वर्गपरा जन्मकर्मफलप्रदाम्। क्रियाविशेषबहुलां भोगैश्वर्यगतिं प्रति।। ४३।।',
      'translation':
          'They are full of desires, focused on attaining heaven, and are engaged in many ritualistic activities that promise good birth, power, and sense gratification.',
      'word_meaning':
          'कामात्मानः—whose minds are full of desires; स्वर्गपराः—having heaven as their ultimate goal; जन्म-कर्म-फल-प्रदाम्—resulting in (good) birth and (fruitive) action; क्रिया-विशेष-बहुलाम्—abounding in specific rituals; भोग-ऐश्वर्य-गतिम्—for the attainment of enjoyment and opulence; प्रति—towards.',
      'commentary':
          'This elaborates on the mindset of the non-resolute: they are driven by the pursuit of temporary pleasure and prosperity in this life or the next, binding them to the cycle of karma.',
    });

    // Verse 44: The effect of material attachment
    await db.insert('chapter_2', {
      'verse_number': 44,
      'sanskrit':
          'भोगैश्वर्यप्रसक्तानां तयापहृतचेतसाम्। व्यवसायात्मिका बुद्धिः समाधौ न विधीयते।। ४४।।',
      'translation':
          'For those who are deeply attached to sense enjoyment and opulence, and whose minds are captivated by those things, resolute determination for spiritual absorption (*samādhi*) is not achieved.',
      'word_meaning':
          'भोग-ऐश्वर्य-प्रसक्तानाम्—of those attached to enjoyment and opulence; तया—by those (flowery words); अपहृत-चेतसाम्—whose minds are stolen; व्यवसायात्मिका—resolute; बुद्धिः—intellect; समाधौ—in meditation/spiritual absorption; न विधीयते—is not established.',
      'commentary':
          'Attachment acts as a thief, stealing the mind’s focus and preventing the development of the one-pointed resolve necessary for deep spiritual practice and liberation.',
    });

    // Verse 45: Transcendence of the Gunas
    await db.insert('chapter_2', {
      'verse_number': 45,
      'sanskrit':
          'त्रैगुण्यविषया वेदा निस्त्रैगुण्यो भवार्जुन। निर्द्वन्द्वो नित्यसत्त्वस्थो निर्योगक्षेम आत्मवान्।। ४५।।',
      'translation':
          'The Vedas primarily deal with the three modes of material nature (*guṇas*). O Arjuna, be transcendental to these three *guṇas*. Be free from dualities, ever fixed in purity (*sattva*), free from acquiring and preserving, and established in the Self.',
      'word_meaning':
          'त्रैगुण्य-विषयाः—relating to the three *guṇas* (modes); वेदाः—the Vedas; निस्त्रैगुण्यः—free from the three *guṇas*; भव—be; अर्जुन—O Arjuna; निर्द्वन्द्वः—free from dualities (pleasure/pain); नित्य-सत्त्वस्थः—ever fixed in purity; निर्योग-क्षेमः—free from (the desire for) acquisition and protection; आत्मवान्—established in the Self.',
      'commentary':
          'Krishna’s teaching is to rise above the relative world of the *guṇas*. He advises the state of **non-dualism** (*nir-dvandva*) and freedom from the anxiety of material gain (*yoga* - acquiring) and preservation (*kṣema* - protecting).',
    });

    // Verse 46: The analogy of the well and the reservoir
    await db.insert('chapter_2', {
      'verse_number': 46,
      'sanskrit':
          'यावानर्थ उदपाने सर्वतः सम्प्लुतोदके। तावान्सर्वेषु वेदेषु ब्राह्मणस्य विजानतः।। ४६।।',
      'translation':
          'To a Brahmin who is self-realized, all the Vedas are as useful as a small well or pond is when compared to a vast, overflowing reservoir of water.',
      'word_meaning':
          'यावान्—whatever; अर्थः—purpose; उदपाने—in a well; सर्वतः—everywhere; सम्प्लुतोदके—in a great reservoir; तावान्—that much; सर्वेषु—in all; वेदेषु—the Vedas; ब्राह्मणस्य—for the person who knows Brahman; विजानतः—who is realized.',
      'commentary':
          'This verse illustrates the superiority of spiritual knowledge (*Brahma-jñāna*) over Vedic rituals. Once the highest truth is attained, the preparatory steps (rituals) lose their significance.',
    });

    // Verse 47: The core principle of Karma Yoga
    await db.insert('chapter_2', {
      'verse_number': 47,
      'sanskrit':
          'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन। मा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि।। ४७।।',
      'translation':
          'You have the right to perform your prescribed duty, but you are never entitled to the fruits of action. Never consider yourself the cause of the results of your activities, and never be attached to not performing your duty (inaction).',
      'word_meaning':
          'कर्मणि—in action; एव—certainly; अधिकारः—right; ते—your; मा—not; फलेषु—in the fruits/results; कदाचन—ever; मा—not; कर्म-फल-हेतुः—the cause of the result of the action; भूः—be; मा—not; ते—your; सङ्गः—attachment; अस्तु—let there be; अकर्मणि—to inaction.',
      'commentary':
          'This is the most famous verse of the Gita. It defines action without desire for rewards (non-attachment) as the path to freedom. It also strictly forbids inaction (laziness) or renouncing one\'s duty out of fear of results.',
    });

    // Verse 48: Definition of Yoga as Equanimity
    await db.insert('chapter_2', {
      'verse_number': 48,
      'sanskrit':
          'योगस्थः कुरु कर्माणि सङ्गं त्यक्त्वा धनञ्जय। सिद्ध्यसिद्ध्योः समो भूत्वा समत्वं योग उच्यते।। ४८।।',
      'translation':
          'O Dhanañjaya, perform your duty with detachment, remaining equipoised in success and failure. This equanimity is called *Yoga*.',
      'word_meaning':
          'योगस्थः—established in Yoga; कुरु—perform; कर्माणि—actions; सङ्गम्—attachment; त्यक्त्वा—having abandoned; धनञ्जय—O conqueror of wealth (Arjuna); सिद्धि-असिद्ध्योः—in success and failure; समः—equipoised; भूत्वा—having become; समत्वम्—equanimity; योगः—Yoga; उच्यते—is called.',
      'commentary':
          'The definition of *Yoga* is given here as **equanimity** (*Samattvam*). Action must be performed while maintaining a steady mind, treating success and failure with the same calmness.',
    });

    // Verse 49: Karma Yoga is superior to Fruitive Action
    await db.insert('chapter_2', {
      'verse_number': 49,
      'sanskrit':
          'दूरेण ह्यवरं कर्म बुद्धियोगाद्धनञ्जय। बुद्धौ शरणमन्विच्छ कृपणाः फलहेतवः।। ४९।।',
      'translation':
          'O Dhanañjaya, action performed with desire for results is far inferior to action performed with spiritual intelligence (*Buddhi Yoga*). Seek refuge in this intelligence. Those who crave the fruits of labor are indeed pitiable (*kṛipaṇāḥ*).',
      'word_meaning':
          'दूरेण—by a great distance; हि—indeed; अवरम्—inferior; कर्म—action (with motive); बुद्धि-योगात्—than the Yoga of intellect; धनञ्जय—O conqueror of wealth; बुद्धौ—in the intellect; शरणम्—shelter; अन्विच्छ—seek; कृपणाः—pitiable/miserable; फल-हेतवः—those who desire the fruits.',
      'commentary':
          'Krishna emphasizes that working for personal results is a **wretched** (*kṛipaṇāḥ*) state of bondage. The higher path is *Buddhi Yoga*, using the intellect to work for duty alone.',
    });

    // Verse 50: Yoga is Skill in Action
    await db.insert('chapter_2', {
      'verse_number': 50,
      'sanskrit':
          'बुद्धियुक्तो जहातीह उभे सुकृतदुष्कृते। तस्माद्योगाय युज्यस्व योगः कर्मसु कौशलम् || ५०||',
      'translation':
          'One who is endowed with this intelligence (Yoga) casts off both good deeds (*sukṛta*) and bad deeds (*duṣhkṛita*) in this life. Therefore, strive for Yoga, for **Yoga is skill in action** (*karmasu kauśhalam*).',
      'word_meaning':
          'बुद्धि-युक्तः—endowed with this intelligence; जहाति—casts off/gets rid of; इह—in this life; उभे—both; सुकृत-दुष्कृते—good and bad deeds; तस्मात्—therefore; योगाय—for Yoga; युज्यस्व—strive/engage; योगः—Yoga; कर्मसु—in actions; कौशलम्—skill.',
      'commentary':
          'The ultimate definition of *Yoga* is provided. The "skill" (*kauśhalam*) is the ability to perform actions so effectively that they do not generate any binding **karmic reactions**, freeing the soul from the cycle of rebirth.',
    });

    // Verse 51: The fruit of Buddhi Yoga (Liberation)
    await db.insert('chapter_2', {
      'verse_number': 51,
      'sanskrit':
          'कर्मजं बुद्धियुक्ता हि फलं त्यक्त्वा मनीषिणः | जन्मबन्धविनिर्मुक्ताः पदं गच्छन्त्यनामयम् || 51 ||',
      'translation':
          'The wise, endowed with this spiritual intelligence, abandon the fruits born of action and, freed from the bondage of birth, attain the state beyond all misery (liberation).',
      'word_meaning':
          'कर्म-जम्—born of action; बुद्धि-युक्ताः—endowed with intelligence; हि—certainly; फलम्—fruit/result; त्यक्त्वा—having abandoned; मनीषिणः—the wise men; जन्म-बन्ध-विनिर्मुक्ताः—freed from the bondage of birth; पदम्—the state; गच्छन्ति—they attain; अनामयम्—without misery (liberated).',
      'commentary':
          'This concludes the discussion on the mechanics of Karma Yoga: action performed with detachment breaks the cycle of *saṁsāra* (birth and death) and leads to the supreme, sorrowless state.',
    });

    // Verse 52: Transcendence beyond Vedic rituals
    await db.insert('chapter_2', {
      'verse_number': 52,
      'sanskrit':
          'यदा ते मोहकलिलं बुद्धिर्व्यतितरिष्यति | तदा गन्तासि निर्वेदं श्रोतव्यस्य श्रुतस्य च || 52 ||',
      'translation':
          'When your intellect completely crosses the mire of delusion, you shall attain indifference concerning all that has been heard and all that is yet to be heard (in Vedic injunctions).',
      'word_meaning':
          'यदा—when; ते—your; मोह-कलिलम्—mire of delusion; बुद्धिः—intellect; व्यतितरिष्यति—will cross beyond; तदा—then; गन्ता असि—you will go; निर्वेदम्—to indifference/detachment; श्रोतव्यस्य—of what is to be heard; श्रुतस्य—of what has been heard; च—and.',
      'commentary':
          'Once the intellect is purified by Yoga, it transcends the need for ritualistic Vedic knowledge, which deals only with material results. The realized soul becomes self-sufficient in wisdom.',
    });

    // Verse 53: Fixedness in Samadhi
    await db.insert('chapter_2', {
      'verse_number': 53,
      'sanskrit':
          'श्रुतिविप्रतिपन्ना ते यदा स्थास्यति निश्चला | समाधावचला बुद्धिस्तदा योगमवाप्स्यसि || 53 ||',
      'translation':
          'When your intellect, confused by the conflicting declarations of the scriptures, stands firm and unmoving, fixed in spiritual absorption (*samādhi*), then you shall attain complete *Yoga*.',
      'word_meaning':
          'श्रुति-विप्रतिपन्ना—confused by the variety of scriptural statements; ते—your; यदा—when; स्थास्यति—will stand; निश्चला—unmoving/steady; समाधौ—in spiritual absorption; अचला—immovable; बुद्धिः—intellect; तदा—then; योगम्—Yoga; अवाप्स्यसि—you will attain.',
      'commentary':
          'True spiritual practice culminates not in intellectual debate over scriptures, but in direct, unmoving experience (*samādhi*). This is the final mark of true self-realization.',
    });

    // Verse 54: Arjuna asks about the Sthitaprajña (Man of Steady Wisdom)
    await db.insert('chapter_2', {
      'verse_number': 54,
      'sanskrit':
          'अर्जुन उवाच | स्थितप्रज्ञस्य का भाषा समाधिस्थस्य केशव | स्थितधीः किं प्रभाषेत किमासीत व्रजेत किम् || 54 ||',
      'translation':
          'Arjuna said: What are the characteristics of a person whose intellect is steady (*Sthitaprajña*), O Keśhava, one who is fixed in *samādhi*? How does one of steady wisdom speak, sit, and walk?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; स्थित-प्रज्ञस्य—of one with steady wisdom; का—what; भाषा—description/sign; समाधि-स्थस्य—of one situated in *samādhi*; केशव—O Keśhava (Krishna); स्थित-धीः—one of steady intellect; किम्—what; प्रभाषेत—does he speak; किम्—how; आसीत—does he sit; व्रजेत—does he walk; किम्—how.',
      'commentary':
          'Arjuna recognizes that this knowledge is abstract and asks for practical, behavioral traits of a truly realized person. The rest of this chapter answers this question, describing the ideal human being.',
    });

    // Verse 55: Krishna begins the description (Abandonment of desires)
    await db.insert('chapter_2', {
      'verse_number': 55,
      'sanskrit':
          'श्रीभगवानुवाच | प्रजहाति यदा कामान्सर्वान्पार्थ मनोगतान् | आत्मन्येवात्मना तुष्टः स्थितप्रज्ञस्तदोच्यते || 55 ||',
      'translation':
          'The Supreme Lord said: O Pārtha, a person is said to be one of steady wisdom (*Sthitaprajña*) when they completely abandon all desires that enter the mind and are fully content in the Self by the Self.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; प्रजहाति—completely gives up; यदा—when; कामान्—desires; सर्वान्—all; पार्थ—O Pārtha; मनोगतान्—that have entered the mind; आत्मनि—in the Self; एव—only; आत्मना—by the Self; तुष्टः—content; स्थित-प्रज्ञः—of steady wisdom; तदा—then; उच्यते—is called.',
      'commentary':
          'The primary defining characteristic of the *Sthitaprajña* is inner contentment. Liberation is not achieved by physically suppressing desires, but by replacing the lower, fleeting satisfaction of the senses with the higher, permanent bliss of the Self.',
    });

    // Verse 56: Equanimity in sorrow, happiness, and freedom from passion
    await db.insert('chapter_2', {
      'verse_number': 56,
      'sanskrit':
          'दुःखेष्वनुद्विग्नमनाः सुखेषु विगतस्पृहः | वीतरागभयक्रोधः स्थितधीर्मुनिरुच्यते || 56 ||',
      'translation':
          'One whose mind is undisturbed amidst sorrow, free from desire for happiness, and who is liberated from attachment, fear, and anger is called a sage (*muni*) of steady intellect (*Sthitadhīḥ*).',
      'word_meaning':
          'दुःखेषु—in sorrow; अनुद्विग्न-मनाः—whose mind is undisturbed; सुखेषु—in happiness; विगत-स्पृहः—free from desire; वीत-राग-भय-क्रोधः—one who is free from attachment, fear, and anger; स्थित-धीः—steady in intellect; मुनिः—a sage; उच्यते—is called.',
      'commentary':
          'This defines the Sthitaprajña in terms of their psychological stability. The three enemies that bind the soul are **attachment** (*rāga*), **fear** (*bhaya*), and **anger** (*krodha*). Freedom from these is the mark of a true sage (*muni*).',
    });

    // Verse 57: Freedom from attachment and aversion
    await db.insert('chapter_2', {
      'verse_number': 57,
      'sanskrit':
          'यः सर्वत्रानभिस्नेहस्तत्तत्प्राप्य शुभाशुभम् | नाभिनन्दति न द्वेष्टि तस्य प्रज्ञा प्रतिष्ठिता || 57 ||',
      'translation':
          'One who is without attachment everywhere, and who neither rejoices in obtaining good things nor grieves upon receiving bad things—their wisdom is firmly established.',
      'word_meaning':
          'यः—who; सर्वत्र—everywhere; अनभिस्नेहः—without attachment; तत् तत्—that and that; प्राप्य—obtaining; शुभ-अशुभम्—good and bad; न अभिनन्दति—neither rejoices; न द्वेष्टि—nor hates/grieves; तस्य—his; प्रज्ञा—wisdom; प्रतिष्ठिता—is firmly established.',
      'commentary':
          'The steady intellect is characterized by two specific reactions: absence of attachment (*anabhisnehaḥ*) and absence of aversion (*dveṣṭi*). They see the duality of pleasure/pain as irrelevant to the higher Self.',
    });

    // Verse 58: Sense Withdrawal (The Tortoise Analogy)
    await db.insert('chapter_2', {
      'verse_number': 58,
      'sanskrit':
          'यदा संहरते चायं कूर्मोऽङ्गानीव सर्वशः | इन्द्रियाणीन्द्रियार्थेभ्यस्तस्य प्रज्ञा प्रतिष्ठिता || 58 ||',
      'translation':
          'When, like a tortoise retracting its limbs, one is able to completely withdraw the senses from the sense objects, their wisdom is firmly established.',
      'word_meaning':
          'यदा—when; संहरते—withdraws; च अयम्—and this person; कूर्मः—a tortoise; अङ्गानि इव—like limbs; सर्वशः—completely; इन्द्रियाणि—senses; इन्द्रिय-अर्थेभ्यः—from sense objects; तस्य—his; प्रज्ञा—wisdom; प्रतिष्ठिता—is firmly established.',
      'commentary':
          'This provides the practical method for inner stability: sense control (*Pratyāhāra*). The mind is stable only when it is not dragged outwards by the senses toward external objects.',
    });

    // Verse 59: The persistence of subtle desire
    await db.insert('chapter_2', {
      'verse_number': 59,
      'sanskrit':
          'विषया विनिवर्तन्ते निराहारस्य देहिनः | रसवर्जं रसोऽप्यस्य परं दृष्ट्वा निवर्तते || 59 ||',
      'translation':
          'The sense objects cease for the embodied soul who abstains from them, but the taste for them remains. However, the taste also vanishes for one who perceives the Supreme Reality.',
      'word_meaning':
          'विषयाः—sense objects; विनिवर्तन्ते—cease to affect; निराहारस्य—of one who starves (the body); देहिनः—of the embodied; रस-वर्जम्—except for the taste; रसः—the taste; अपि—even; अस्य—his; परम्—the Supreme; दृष्ट्वा—having seen; निवर्तते—vanishes.',
      'commentary':
          'Mere austerity (fasting or forced abstinence) only removes the *gross* connection to objects; the subtle craving (*rasa*) remains. True detachment only happens when the higher, Supreme Reality is experienced, replacing the lower, subtle taste completely.',
    });

    // Verse 60: The strength of the senses (The warning)
    await db.insert('chapter_2', {
      'verse_number': 60,
      'sanskrit':
          'यततो ह्यपि कौन्तेय पुरुषस्य विपश्चितः | इन्द्रियाणि प्रमाथीनि हरन्ति प्रसभं मनः || 60 ||',
      'translation':
          'The turbulent senses, O son of Kuntī, forcibly carry away the mind even of a wise person who is striving for perfection.',
      'word_meaning':
          'यततः—while striving; हि अपि—even though; कौन्तेय—O son of Kuntī; पुरुषस्य—of a person; विपश्चितः—endowed with discrimination; इन्द्रियाणि—the senses; प्रमाथीनि—turbulent/agitating; हरन्ति—carry away; प्रसभम्—forcibly; मनः—the mind.',
      'commentary':
          'This serves as a crucial warning: the power of the senses is immense. Even a knowledgeable aspirant must remain vigilant, as a single moment of laxity can forcefully pull the mind back into material attachment.',
    });

    // Verse 61: The positive method of control (Devotion)
    await db.insert('chapter_2', {
      'verse_number': 61,
      'sanskrit':
          'तानि सर्वाणि संयम्य युक्त आसीत मत्परः | वशे हि यस्येन्द्रियाणि तस्य प्रज्ञा प्रतिष्ठिता || 61 ||',
      'translation':
          'Having restrained all the senses, the disciplined person should sit absorbed in Me; for the wisdom of one whose senses are under control is firmly established.',
      'word_meaning':
          'तानि—them; सर्वाणि—all; संयम्य—subduing; युक्तः—disciplined; आसीत—should be seated; मत्-परः—devoted to Me; वशे—control; हि—certainly; यस्य—whose; इन्द्रियाणि—senses; तस्य—his; प्रज्ञा—wisdom; प्रतिष्ठिता—is fixed.',
      'commentary':
          'Krishna provides the positive method for sense control: **devotion to God** (*Mat-paraḥ*). The mind cannot remain empty; it must be fixed on a higher goal (God) to naturally detach from lower sense objects.',
    });

    // Verse 62: The downward spiral begins with contemplation
    await db.insert('chapter_2', {
      'verse_number': 62,
      'sanskrit':
          'ध्यायतो विषयान्पुंसः सङ्गस्तेषूपजायते | सङ्गात्सञ्जायते कामः कामात्क्रोधोऽभिजायते || 62 ||',
      'translation':
          'While contemplating the objects of the senses, a person develops attachment to them; from attachment, desire (*kāma*) develops, and from unfulfilled desire, anger (*krodha*) arises.',
      'word_meaning':
          'ध्यायतः—contemplating; विषयान्—sense objects; पुंसः—of a person; सङ्गः—attachment; तेषु—in them; उपजायते—develops; सङ्गात्—from attachment; सञ्जायते—arises; कामः—desire/lust; कामात्—from desire; क्रोधः—anger; अभिजायते—arises.',
      'commentary':
          'Krishna maps out the descent into bondage: the problem begins not with the action itself, but with **contemplation** of the object. Contemplation rightarrow Attachment rightarrow Desire rightarrow Anger.',
    });

    // Verse 63: The final stage of destruction
    await db.insert('chapter_2', {
      'verse_number': 63,
      'sanskrit':
          'क्रोधाद्भवति संमोहः संमोहात्स्मृतिविभ्रमः | स्मृतिभ्रंशाद् बुद्धिनाशो बुद्धिनाशात्प्रणश्यति || 63 ||',
      'translation':
          'From anger comes delusion (*sammohaḥ*); from delusion, confusion of memory; from confusion of memory, the destruction of the intellect (*buddhināśo*); and when the intellect is destroyed, one perishes.',
      'word_meaning':
          'क्रोधात्—from anger; भवति—comes; संमोहः—delusion; संमोहात्—from delusion; स्मृति-विभ्रमः—bewilderment of memory; स्मृति-भ्रंशात्—from loss of memory; बुद्धि-नाशः—destruction of the intellect; बुद्धि-नाशात्—from destruction of the intellect; प्रणश्यति—one perishes.',
      'commentary':
          'This completes the tragic sequence: Anger rightarrow Delusion rightarrow Memory Loss rightarrow **Destruction of Intellect** rightarrow Perishment (spiritual ruin). The key loss is the intellect, the faculty of discrimination.',
    });

    // Verse 64: The path to divine grace (Prasāda)
    await db.insert('chapter_2', {
      'verse_number': 64,
      'sanskrit':
          'रागद्वेषवियुक्तैस्तु विषयानिन्द्रियैश्चरन् | आत्मवश्यैर्विधेयात्मा प्रसादमधिगच्छति || 64 ||',
      'translation':
          'But one who is free from attachment and aversion (*rāga-dveṣa*), and controls their senses while engaging with sense objects, attains divine serenity (*prasāda*).',
      'word_meaning':
          'राग-द्वेष-वियुक्तैः—free from attachment and aversion; तु—but; विषयान्—sense objects; इन्द्रियैः—by the senses; चरन्—engaging; आत्म-वश्यैः—under the control of the Self; विधेय-आत्मा—the submissive mind; प्रसादम्—divine grace/serenity; अधिगच्छति—attains.',
      'commentary':
          'The goal is not avoiding objects, but encountering them without inner reaction (detachment/aversion). This inner freedom leads to **Prasāda**, a calm, joyful mental state reflective of divine grace.',
    });

    // Verse 65: The blessing of serenity
    await db.insert('chapter_2', {
      'verse_number': 65,
      'sanskrit':
          'प्रसादे सर्वदुःखानां हानिरस्योपजायते | प्रसन्नचेतसो ह्याशु बुद्धिः पर्यवतिष्ठते || 65 ||',
      'translation':
          'In that serenity, all miseries are destroyed, and the intellect of the serene-minded quickly becomes firmly established.',
      'word_meaning':
          'प्रसादे—in serenity; सर्व-दुःखानाम्—of all miseries; हानिः—destruction; अस्य—his; उपजायते—occurs; प्रसन्न-चेतसः—of the serene mind; हि—certainly; आशु—quickly; बुद्धिः—intellect; पर्यवतिष्ठते—becomes firmly fixed.',
      'commentary':
          'Serenity (*prasāda*) is the cure for all suffering. Once the mind is peaceful, the intellect immediately regains its discriminatory power, making spiritual realization possible.',
    });

    // Verse 66: The state of the uncontrolled mind
    await db.insert('chapter_2', {
      'verse_number': 66,
      'sanskrit':
          'नास्ति बुद्धिरयुक्तस्य न चायुक्तस्य भावना | न चाभावयतः शान्तिरशान्तस्य कुतः सुखम् || 66 ||',
      'translation':
          'For one who is uncontrolled (*ayuktasya*), there is no spiritual intellect, nor the power of meditation. Without meditation, there is no peace, and how can there be happiness without peace?',
      'word_meaning':
          'न अस्ति—there is no; बुद्धिः—intellect (spiritual); अयुक्तस्य—of the uncontrolled; न च—nor; अयुक्तस्य—of the uncontrolled; भावना—meditation/contemplation; न च—nor; अ-भावयतः—of one who does not meditate; शान्तिः—peace; अ-शान्तस्य—of the peaceless; कुतः—where is; सुखम्—happiness.',
      'commentary':
          'This establishes the chain necessary for happiness: Control rightarrow Spiritual Intellect rightarrow Meditation rightarrow Peace rightarrow Happiness. Lacking control means lacking everything else.',
    });

    // Verse 67: The analogy of the wind and the boat
    await db.insert('chapter_2', {
      'verse_number': 67,
      'sanskrit':
          'इन्द्रियाणां हि चरतां यन्मनोऽनुविधीयते | तदस्य हरति प्रज्ञां वायुर्नावमिवाम्भसि || 67 ||',
      'translation':
          'Just as a strong wind sweeps away a boat on the water, the mind that yields to any one of the senses carries away the spiritual intelligence (*prajñā*) of a person.',
      'word_meaning':
          'इन्द्रियाणाम्—of the senses; हि—certainly; चरताम्—wandering; यत्—which; मनः—mind; अनुविधीयते—follows; तत्—that; अस्य—his; हरति—carries away; प्रज्ञाम्—wisdom; वायुः—wind; नावम्—a boat; इव—like; अम्भसि—on the water.',
      'commentary':
          'This powerful analogy emphasizes the devastating power of the senses. Even if just one sense is uncontrolled, it is enough to hijack the entire mind and destroy the carefully built spiritual progress (*prajñā*).',
    });

    // Verse 68: The man of perfect knowledge
    await db.insert('chapter_2', {
      'verse_number': 68,
      'sanskrit':
          'तस्माद्यस्य महाबाहो निगृहीतानि सर्वशः | इन्द्रियाणीन्द्रियार्थेभ्यस्तस्य प्रज्ञा प्रतिष्ठिता || 68 ||',
      'translation':
          'Therefore, O mighty-armed (Arjuna), one whose senses are completely restrained from the sense objects—their wisdom is firmly established.',
      'word_meaning':
          'तस्मात्—therefore; यस्य—whose; महा-बाहो—O mighty-armed; निगृहीतानि—completely restrained; सर्वशः—completely; इन्द्रियाणि—senses; इन्द्रिय-अर्थेभ्यः—from the sense objects; तस्य—his; प्रज्ञा—wisdom; प्रतिष्ठिता—is established.',
      'commentary':
          'This summarizes the entire instruction on *Pratyāhāra* (sense withdrawal) by reiterating the criteria for the *Sthitaprajña*—total, deliberate control over the senses.',
    });

    // Verse 69: The paradoxical life of the Sage
    await db.insert('chapter_2', {
      'verse_number': 69,
      'sanskrit':
          'या निशा सर्वभूतानां तस्यां जागर्ति संयमी | यस्यां जाग्रति भूतानि सा निशा पश्यतो मुनेः || 69 ||',
      'translation':
          'What is night for all beings is the time of waking for the self-controlled person (*saṁyamī*); and what is day for all beings is night for the introspective sage (*muni*).',
      'word_meaning':
          'या—which; निशा—night; सर्व-भूतानाम्—of all beings; तस्याम्—in that; जागर्ति—is awake; संयमी—the self-controlled person; यस्याम्—in which; जाग्रति—are awake; भूतानि—beings; सा—that; निशा—night; पश्यतः—of the seeing; मुनेः—sage.',
      'commentary':
          'This famous verse describes the *paradoxical existence* of the sage. The worldly life (sense enjoyment) that consumes others is "night" for the sage; conversely, the subtle, spiritual reality that is "night" to the world is the sage\'s waking reality.',
    });

    // Verse 70: The analogy of the ocean
    await db.insert('chapter_2', {
      'verse_number': 70,
      'sanskrit':
          'आपूर्यमाणमचलप्रतिष्ठं समुद्रमापः प्रविशन्ति यद्वत् | तद्वत्कामा यं प्रविशन्ति सर्वे स शान्तिमाप्नोति न कामकामी || 70 ||',
      'translation':
          'Just as the waters of rivers enter the ocean, which remains steady and undisturbed despite being filled from all sides, so too, the person into whom all desires enter without creating agitation attains peace, not the one who strives to satisfy such desires.',
      'word_meaning':
          'आपूर्यमाणम्—being filled; अचल-प्रतिष्ठम्—steadily established; समुद्रम्—the ocean; आपः—waters; प्रविशन्ति—enter; यद्वत्—just as; तद्वत्—so too; कामाः—desires; यम्—whom; प्रविशन्ति—enter; सर्वे—all; सः—that person; शान्तिम्—peace; आप्नोति—attains; न—not; काम-कामी—the desirer of desires.',
      'commentary':
          'The true measure of peace is not the absence of external desires, but inner stability. The sage is like the deep ocean, receiving desires without being disturbed or overflowed by them. Peace is found in acceptance, not acquisition.',
    });

    // Verse 71: The man who attains peace
    await db.insert('chapter_2', {
      'verse_number': 71,
      'sanskrit':
          'विहाय कामान्यः सर्वान्पुमांश्चरति निःस्पृहः | निर्ममो निरहङ्कारः स शान्तिमधिगच्छति || 71 ||',
      'translation':
          'The person who abandons all desires and moves about without longing, without the sense of "mine" (possessiveness), and without egoism (*ahaṅkāra*), attains peace.',
      'word_meaning':
          'विहाय—abandoning; कामान्—desires; यः—who; सर्वान्—all; पुमान्—a person; चरति—moves about; निःस्पृहः—without longing; निर्ममः—without the sense of "mine"; निरहङ्कारः—without egoism; सः—that person; शान्तिम्—peace; अधिगच्छति—attains.',
      'commentary':
          'This summarizes the practical life of the *Sthitaprajña*. Inner peace is the result of abandoning three core material faults: **Desire** (*Kāma*), **Possessiveness** (*Mama*), and **Egoism** (*Ahaṅkāra*).',
    });

    // Verse 72: Conclusion to the Brahmic State
    await db.insert('chapter_2', {
      'verse_number': 72,
      'sanskrit':
          'एषा ब्राह्मी स्थितिः पार्थ नैनां प्राप्य विमुह्यति | स्थित्वास्यामन्तकालेऽपि ब्रह्मनिर्वाणमृच्छति || 72 ||',
      'translation':
          'O son of Pṛithā, this is the **Brahmic State** (*Brāhmī Sthiti*). Having attained this, one is never deluded. Being established in this state, even at the end of life, one attains oneness with the Supreme (*Brahmanirvāṇa*).',
      'word_meaning':
          'एषा—this; ब्राह्मी—the Divine/Brahmic; स्थितिः—state; पार्थ—O son of Pṛithā; न एनाम्—not this; प्राप्य—having attained; विमुह्यति—is deluded; स्थित्वा—being established; अस्याम्—in this; अन्त-काले—at the end of life; अपि—even; ब्रह्म-निर्वाणम्—absorption in the Supreme; ऋच्छति—attains.',
      'commentary':
          'Krishna concludes the chapter by labeling the state of the *Sthitaprajña* as the **Brāhmī Sthiti** (the Divine State). This state guarantees liberation, highlighting that spiritual enlightenment is not limited to any stage of life but can be attained even at the moment of death.',
    });
  }

  Future<void> insertChapter3Verses(Database db) async {
    // Verse 1: Arjuna questions Krishna (Confusion over Knowledge vs. Action)
    await db.insert('chapter_3', {
      'verse_number': 1,
      'sanskrit':
          'अर्जुन उवाच | ज्यायसी चेत्कर्मणस्ते मता बुद्धिर्जनार्दन | तत्किं कर्मणि घोरे मां नियोजयसि केशव || 1 ||',
      'translation':
          'Arjuna said: O Janārdana (Krishna), if You consider knowledge superior to action, then why do You ask me to wage this terrible war, O Keśhava?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; ज्यायसी—superior; चेत्—if; कर्मणः—than action; ते—by You; मता—is considered; बुद्धिः—intellect/knowledge; जनार्दन—O Janārdana (Krishna); तत्—then; किम्—why; कर्मणि—in action; घोरे—terrible/ghastly; माम्—me; नियोजयसि—do You engage; केशव—O Keśhava (Krishna).',
      'commentary':
          'Arjuna is confused. Krishna first taught the philosophical path (*Sānkhya*) emphasizing knowledge (Buddhi), and then commanded action (fight!). Arjuna perceives this as contradictory and questions why he should perform the "terrible action" of war if knowledge is higher.',
    });

    // Verse 2: Arjuna asks for the definitive path
    await db.insert('chapter_3', {
      'verse_number': 2,
      'sanskrit':
          'व्यामिश्रेणेव वाक्येन बुद्धिं मोहयसीव मे | तदेकं वद निश्चित्य येन श्रेयोऽहमाप्नुयाम् || 2 ||',
      'translation':
          'My intellect is bewildered by Your ambiguous statements. Please tell me decisively that one path by which I may attain the highest good.',
      'word_meaning':
          'व्यामिश्रेण—mixed/ambiguous; इव—as if; वाक्येन—by statements; बुद्धिम्—intellect; मोहयसि—You are deluding; इव—as if; मे—my; तत्—that; एकम्—one; वद—tell; निश्चित्य—decisively; येन—by which; श्रेयः—highest good/bliss; अहम्—I; आप्नुयाम्—may attain.',
      'commentary':
          'Arjuna asks Krishna to clearly delineate one path—knowledge or action—for liberation, unaware that the true path involves a synthesis of both.',
    });

    // Verse 3: Krishna explains the two paths (Nishthas)
    await db.insert('chapter_3', {
      'verse_number': 3,
      'sanskrit':
          'श्रीभगवानुवाच | लोकेऽस्मिन्द्विविधा निष्ठा पुरा प्रोक्ता मयानघ | ज्ञानयोगेन साङ्ख्यानां कर्मयोगेन योगिनाम् || 3 ||',
      'translation':
          'The Supreme Lord said: O sinless one (Arjuna), in this world, I previously declared two types of resolute paths (*niṣṭhā*): the path of knowledge (*Jñāna Yoga*) for the contemplative (*Sānkhyas*) and the path of action (*Karma Yoga*) for the active (*Yogīs*).',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; लोके—in the world; अस्मिन्—this; द्विविधा—two types of; निष्ठा—paths of steady devotion; पुरा—previously; प्रोक्ता—declared; मया—by Me; अनघ—O sinless one; ज्ञान-योगेन—by the Yoga of knowledge; साङ्ख्यानाम्—of the contemplative; कर्म-योगेन—by the Yoga of action; योगिनाम्—of the active.',
      'commentary':
          'Krishna clarifies that He offered two lifestyles suited to different temperaments, not a contradictory choice. Both lead to the same goal: purification and knowledge.',
    });

    // Verse 4: Inaction does not lead to freedom
    await db.insert('chapter_3', {
      'verse_number': 4,
      'sanskrit':
          'न कर्मणामनारम्भान्नैष्कर्म्यं पुरुषोऽश्नुते | न च संन्यसनादेव सिद्धिं समधिगच्छति || 4 ||',
      'translation':
          'One cannot achieve freedom from reaction (*naiṣhkarmya*) merely by abstaining from work, nor can one attain spiritual perfection simply by renouncing activity.',
      'word_meaning':
          'न—not; कर्मणाम्—of actions; अनारम्भात्—by non-commencement; नैष्कर्म्यम्—freedom from reaction/inaction; पुरुषः—a person; अश्नुते—attains; न च—nor; संन्यसनात्—by renunciation; एव—merely; सिद्धिम्—perfection; समधिगच्छति—attains completely.',
      'commentary':
          'This is a strong refutation of superficial renunciation. True liberation comes not from external non-action, but from internal non-attachment. Freedom from karma requires wisdom, not just inactivity.',
    });

    // Verse 5: Action is inevitable (The compulsion of nature)
    await db.insert('chapter_3', {
      'verse_number': 5,
      'sanskrit':
          'न हि कश्चित्क्षणमपि जातु तिष्ठत्यकर्मकृत् | कार्यते ह्यवशः कर्म सर्वः प्रकृतिजैर्गुणैः || 5 ||',
      'translation':
          'Indeed, no one can remain without performing action even for a moment. All beings are inevitably compelled to act by the qualities (*guṇas*) born of material nature.',
      'word_meaning':
          'न हि—certainly not; कश्चित्—anyone; क्षणम्—moment; अपि—even; जातु—ever; तिष्ठति—remains; अकर्म-कृत्—one who does no work; कार्यते—is compelled to act; हि—for; अवशः—helplessly; कर्म—action; सर्वः—all; प्रकृति-जैः—born of material nature; गुणैः—by the qualities (*guṇas*).',
      'commentary':
          'The fundamental reason action is necessary is the overpowering force of the three *guṇas* (Sattva, Rajas, Tamas). Because the mind and body are products of nature, they are constantly active; therefore, true non-action is impossible in the embodied state.',
    });

    // Verse 6: The hypocrite (Mithyāchāra)
    await db.insert('chapter_3', {
      'verse_number': 6,
      'sanskrit':
          'कर्मेन्द्रियाणि संयम्य य आस्ते मनसा स्मरन् | इन्द्रियार्थान्विमूढात्मा मिथ्याचारः स उच्यते || 6 ||',
      'translation':
          'The deluded soul who restrains the organs of action but dwells mentally upon the objects of the senses is called a hypocrite (*mithyāchāraḥ*).',
      'word_meaning':
          'कर्म-इन्द्रियाणि—organs of action; संयम्य—controlling; यः—who; आस्ते—sits; मनसा—with the mind; स्मरन्—remembering/dwelling; इन्द्रिय-अर्थान्—sense objects; विमूढ-आत्मा—deluded soul; मिथ्या-आचारः—hypocrite; सः—he; उच्यते—is called.',
      'commentary':
          'Krishna condemns merely external renunciation. True control is internal. Suppression of action while the mind still dwells on sense objects is dishonest and counterproductive to spiritual progress.',
    });

    // Verse 7: The superior performer of Karma Yoga
    await db.insert('chapter_3', {
      'verse_number': 7,
      'sanskrit':
          'यस्त्विन्द्रियाणि मनसा नियम्यारभतेऽर्जुन | कर्मेन्द्रियैः कर्मयोगमसक्तः स विशिष्यते || 7 ||',
      'translation':
          'But, O Arjuna, one who controls the senses with the mind and engages the organs of action in *Karma Yoga* (action performed without attachment) is certainly superior.',
      'word_meaning':
          'यः तु—but one who; इन्द्रियाणि—senses; मनसा—with the mind; नियम्य—controlling; आरभते—begins; अर्जुन—O Arjuna; कर्म-इन्द्रियैः—with the working senses; कर्म-योगम्—the Yoga of action; असक्तः—unattached; सः—he; विशिष्यते—is superior.',
      'commentary':
          'The true path is **internal control, external action**. The mind, guided by the intellect, controls the senses, but the hands still work for the fulfillment of duty, making this person superior to the hypocrite.',
    });

    // Verse 8: Perform your prescribed duty
    await db.insert('chapter_3', {
      'verse_number': 8,
      'sanskrit':
          'नियतं कुरु कर्म त्वं कर्म ज्यायो ह्यकर्मणः | शरीरयात्रापि च ते न प्रसिद्ध्येदकर्मणः || 8 ||',
      'translation':
          'Perform your prescribed duty, for action is superior to inaction. Even the maintenance of your body would not be possible if you cease activity.',
      'word_meaning':
          'नियतम्—prescribed; कुरु—perform; कर्म—action; त्वम्—you; कर्म—action; ज्यायः—superior; हि—certainly; अकर्मणः—than inaction; शरीर-यात्रा—bodily maintenance; अपि च—also; ते—your; न प्रसिद्ध्येत्—would not be accomplished; अकर्मणः—by inaction.',
      'commentary':
          'Krishna gives the direct command: **Niyataṁ Kuru Karma** (Perform your duty). This is based on two practical reasons: 1) Action is inherently better than sloth. 2) Inactivity makes even biological existence impossible.',
    });

    // Verse 9: Work as Yajna (Sacrifice)
    await db.insert('chapter_3', {
      'verse_number': 9,
      'sanskrit':
          'यज्ञार्थात्कर्मणोऽन्यत्र लोकोऽयं कर्मबन्धनः | तदर्थं कर्म कौन्तेय मुक्तसङ्गः समाचर || 9 ||',
      'translation':
          'The world is bound by actions other than those performed for the sake of sacrifice (*Yajña*). Therefore, O son of Kuntī, perform your duty efficiently for the sake of *Yajña*, free from all attachment.',
      'word_meaning':
          'यज्ञ-अर्थात्—for the sake of sacrifice; कर्मणः—than action; अन्यत्र—otherwise; लोकः—the world; अयम्—this; कर्म-बन्धनः—bound by actions; तत्-अर्थम्—for the sake of that; कर्म—action; कौन्तेय—O son of Kuntī; मुक्त-सङ्गः—free from attachment; समाचर—perform properly.',
      'commentary':
          'Action binds when performed for personal gain. It liberates when performed as an offering (*Yajña*). Krishna redefines work as spiritual sacrifice, making action itself the path to freedom.',
    });

    // Verse 10: The creation cycle (Prajāpati's Command)
    await db.insert('chapter_3', {
      'verse_number': 10,
      'sanskrit':
          'सहयज्ञाः प्रजाः सृष्ट्वा पुरोवाच प्रजापतिः | अनेन प्रसविष्यध्वमेष वोऽस्त्विष्टकामधुक् || 10 ||',
      'translation':
          'In the beginning, Prajāpati (the creator) created humankind along with the performance of sacrifice (*Yajña*) and commanded: "By this, you will multiply, and this will be the wish-fulfilling cow for your desires."',
      'word_meaning':
          'सह-यज्ञाः—with sacrifice; प्रजाः—beings; सृष्ट्वा—having created; पुरा—in the beginning; उवाच—said; प्रजापतिः—Prajāpati (the creator); अनेन—by this (sacrifice); प्रसविष्यध्वम्—you shall multiply; एषः—this; वः—your; अस्तु—let it be; इष्ट-काम-धुक्—the wish-fulfilling cow for desires.',
      'commentary':
          'This provides the cosmological basis for *Yajña*. The universe runs on a cycle of reciprocal giving. Sacrificial action is a cosmic duty established at creation, ensuring mutual nourishment between humanity and the celestial powers.',
    });

    // Verse 11: Mutual nourishment (Devatā interaction)
    await db.insert('chapter_3', {
      'verse_number': 11,
      'sanskrit':
          'देवान्भावयतानेन ते देवा भावयन्तु वः | परस्परं भावयन्तः श्रेयः परमवाप्स्यथ || 11 ||',
      'translation':
          'By performing these sacrifices (actions offered without selfish desire), you will please the celestial gods, and the gods will, in turn, sustain you. By cooperating in this manner, you will achieve the highest prosperity.',
      'word_meaning':
          'देवान्—celestial gods; भावयता—will be pleased; अनेन—by this (sacrifice); ते देवाः—those gods; भावयन्तु—will sustain; वः—you; परस्परम्—one another; भावयन्तः—pleasing/sustaining; श्रेयः—prosperity/good; परम्—highest; अवाप्स्यथ—shall achieve.',
      'commentary':
          'This establishes a cosmic chain of interdependence. When humans perform duty as *Yajña*, the cosmic forces (Devatās) are pleased and bless the world with rain and sustenance. True prosperity comes from cooperative, selfless action.',
    });

    // Verse 12: The results of Yajna (The Cosmic Bank)
    await db.insert('chapter_3', {
      'verse_number': 12,
      'sanskrit':
          'इष्टान्भोगान्हि वो देवा दास्यन्ते यज्ञभाविताः | तैरदत्तानप्रदायैभ्यो यो भुङ्क्ते स्तेन एव सः || 12 ||',
      'translation':
          'Pleased by the sacrifices, the celestial gods will grant you the desired objects of enjoyment. One who enjoys those gifts without offering anything in return is certainly a thief.',
      'word_meaning':
          'इष्टान्—desired; भोगान्—objects of enjoyment; हि—certainly; वः—to you; देवाः—gods; दास्यन्ते—will give; यज्ञ-भाविताः—being pleased by sacrifice; तैः—by them; अदत्तान्—not given; अप्रदाय—without offering; एभ्यः—to them; यः—who; भुङ्क्ते—enjoys; स्तेनः—a thief; एव सः—certainly he.',
      'commentary':
          'All material resources are a gift from the cosmic powers via *Yajña*. Enjoying these resources selfishly, without first dedicating them back to the source (God or community), is considered an act of theft against the cosmic order.',
    });

    // Verse 13: Yajna purifies the sin of action
    await db.insert('chapter_3', {
      'verse_number': 13,
      'sanskrit':
          'यज्ञशिष्टाशिनः सन्तो मुच्यन्ते सर्वकिल्बिषैः | भुञ्जते ते त्वघं पापा ये पचन्त्यात्मकारणात् || 13 ||',
      'translation':
          'The righteous who eat the remnants of *Yajña* (sacrifice) are freed from all kinds of sin. But those who cook food only for their own enjoyment verily eat only sin.',
      'word_meaning':
          'यज्ञ-शिष्ट-अशिनः—those who eat the remnants of sacrifice; सन्तः—the righteous; मुच्यन्ते—are freed; सर्व-किल्बिषैः—from all sins; भुञ्जते—enjoy; ते—they; तु—but; अघम्—sin; पापाः—sinful ones; ये—who; पचन्ति—cook; आत्म-कारणात्—for their own sake.',
      'commentary':
          'This provides the spiritual purification benefit of Karma Yoga: Action (even eating) performed in a sacrificial mindset leads to freedom from sin. Selfish action, conversely, leads to bondage.',
    });

    // Verse 14: The food cycle (Yajña-Chakra)
    await db.insert('chapter_3', {
      'verse_number': 14,
      'sanskrit':
          'अन्नाद्भवन्ति भूतानि पर्जन्यादन्नसम्भवः | यज्ञाद्भवति पर्जन्यो यज्ञः कर्मसमुद्भवः || 14 ||',
      'translation':
          'Living beings subsist on food, food is produced by rain, rain is caused by the performance of sacrifice (*Yajña*), and *Yajña* is born from prescribed action.',
      'word_meaning':
          'अन्नात्—from food; भवन्ति—are born/subsist; भूतानि—living beings; पर्जन्यात्—from rain; अन्न-सम्भवः—food is produced; यज्ञात्—from sacrifice; भवति—comes; पर्जन्यः—rain; यज्ञः—sacrifice; कर्म-समुद्भवः—born of prescribed action.',
      'commentary':
          'Krishna details the unbreakable **cosmic food chain** (*Yajña-Chakra*). Human life is physically dependent on this cycle, which is initiated by selfless action (*Yajña*). This demonstrates why action is obligatory, not optional.',
    });

    // Verse 15: The source of action (Vedas and Brahman)
    await db.insert('chapter_3', {
      'verse_number': 15,
      'sanskrit':
          'कर्म ब्रह्मोद्भवं विद्धि ब्रह्माक्षरसमुद्भवम् | तस्मात्सर्वगतं ब्रह्म नित्यं यज्ञे प्रतिष्ठितम् || 15 ||',
      'translation':
          'Know that prescribed actions originate from the Vedas, and the Vedas originate from the Imperishable (*Akṣhara Brahman*). Therefore, the all-pervading Supreme is eternally situated in the sacrifice (*Yajña*).',
      'word_meaning':
          'कर्म—action; ब्रह्म-उद्भवम्—originates from the Vedas; विद्धि—know; ब्रह्म—the Vedas; अक्षर-समुद्भवम्—originate from the Imperishable; तस्मात्—therefore; सर्व-गतम्—all-pervading; ब्रह्म—the Supreme; नित्यम्—eternally; यज्ञे—in sacrifice; प्रतिष्ठितम्—is situated.',
      'commentary':
          'This establishes the divine hierarchy: The Supreme Reality (*Brahman*) is the source of the Vedas, which ordain **Action** (*Karma*). Since action for God (Yajña) is divinely ordained, performing it is a spiritual act.',
    });

    // Verse 16: The law of the cycle (Warning to non-cooperators)
    await db.insert('chapter_3', {
      'verse_number': 16,
      'sanskrit':
          'एवं प्रवर्तितं चक्रं नानुवर्तयतीह यः | अघायुरिन्द्रियारामो मोघं पार्थ स जीवति || 16 ||',
      'translation':
          'O son of Pṛithā, one who does not help to keep this divinely ordained cycle revolving leads a sinful life. Living only for the delight of the senses, such a person lives in vain.',
      'word_meaning':
          'एवम्—thus; प्रवर्तितम्—set in motion; चक्रम्—the cycle; न अनुवर्तयति—does not follow/contribute; इह—here; यः—who; अघ-आयुः—one whose life is sin; इन्द्रिय-आरामः—who delights in the senses; मोघम्—in vain; पार्थ—O Pṛithā; सः—he; जीवति—lives.',
      'commentary':
          'This verse delivers a strong warning: failure to participate in the cosmic cycle of giving and receiving makes one a cosmic criminal, rendering their life worthless (`moghaṁ`), regardless of material success.',
    });

    // Verse 17: The joy of the Self-Realized (Exemption from action)
    await db.insert('chapter_3', {
      'verse_number': 17,
      'sanskrit':
          'यस्त्वात्मरतिरेव स्यादात्मतृप्तश्च मानवः | आत्मन्येव च सन्तुष्टस्तस्य कार्यं न विद्यते || 17 ||',
      'translation':
          'But for the person who rejoices in the Self, is content in the Self, and is completely satisfied only with the Self—for them, there is no obligatory duty to perform.',
      'word_meaning':
          'यः तु—but one who; आत्म-रतिः—rejoicing in the Self; एव—only; स्यात्—is; आत्म-तृप्तः—satisfied in the Self; च—and; मानवः—a human being; आत्मनि—in the Self; एव च—only; सन्तुष्टः—content; तस्य—his; कार्यम्—duty; न विद्यते—is not present/does not exist.',
      'commentary':
          'Krishna presents the exception: the **Jñānī** (one established in knowledge) is exempt from duty because they have transcended the needs of the body and mind. This justifies why Krishna spoke of both *Jñāna* and *Karma* paths in Verse 3.',
    });

    // Verse 18: No gain or loss for the Self-Realized
    await db.insert('chapter_3', {
      'verse_number': 18,
      'sanskrit':
          'नैव तस्य कृतेनार्थो नाकृतेनेह कश्चन | न चास्य सर्वभूतेषु कश्चिदर्थव्यपाश्रयः || 18 ||',
      'translation':
          'For the self-realized person, there is no purpose served by action, nor any loss by inaction. They do not depend on any living being for any purpose.',
      'word_meaning':
          'न एव—not indeed; तस्य—his; कृतेन—by doing; अर्थः—purpose; न अकृतेन—nor by not doing; इह—here; कश्चन—anything; न च—nor; अस्य—his; सर्व-भूतेषु—among all beings; कश्चित्—any; अर्थ-व्यपाश्रयः—object of dependence.',
      'commentary':
          'The enlightened soul operates outside the realm of merit, demerit, gain, and loss. Their actions do not create *karma*, nor does their non-action lead to sin, as their satisfaction is fully internal.',
    });

    // Verse 19: The mandate for unattached action
    await db.insert('chapter_3', {
      'verse_number': 19,
      'sanskrit':
          'तस्मादसक्तः सततं कार्यं कर्म समाचर | असक्तो ह्याचरन्कर्म परमाप्नोति पूरुषः || 19 ||',
      'translation':
          'Therefore, perform your obligatory duty without attachment to the results; by acting unattached, a person attains the Supreme.',
      'word_meaning':
          'तस्मात्—therefore; असक्तः—unattached; सततम्—always; कार्यम्—obligatory; कर्म—action; समाचर—perform properly; असक्तः—unattached; हि—certainly; आचरन्—performing; कर्म—action; परम्—the Supreme; आप्नोति—attains; पूरुषः—a person.',
      'commentary':
          'This verse is a direct synthesis of the chapter: **Since most people are not enlightened (Verse 17), and action is obligatory (Verse 8), the required method is unattached action, which leads to liberation.**',
    });

    // Verse 20: The example of King Janaka
    await db.insert('chapter_3', {
      'verse_number': 20,
      'sanskrit':
          'कर्मणैव हि संसिद्धिमास्थिता जनकादयः | लोकसङ्ग्रहमेवापि सम्पश्यन्कर्तुमर्हसि || 20 ||',
      'translation':
          'The realized King Janaka and others attained perfection solely by performing action. You should therefore perform your duty for the sake of setting an example to the masses.',
      'word_meaning':
          'कर्मणा—by action; एव हि—certainly; संसिद्धिम्—perfection; आस्थिताः—situated; जनक-आदयः—Janaka and others; लोक-सङ्ग्रहम्—the gathering/welfare of the masses; एव अपि—also; सम्पश्यन्—considering; कर्तुम्—to perform; अर्हसि—you should.',
      'commentary':
          'Krishna provides a historical role model, King Janaka, who was both a realized sage and an active ruler. The message for Arjuna is twofold: 1) Action can lead to *siddhi* (perfection). 2) The wise must act to maintain *loka-saṅgraha* (social order and public instruction).',
    });

    // Verse 21: The Power of Example (Loka-saṅgraha)
    await db.insert('chapter_3', {
      'verse_number': 21,
      'sanskrit':
          'यद्यदाचरति श्रेष्ठस्तत्तदेवेतरो जनः | स यत्प्रमाणं कुरुते लोकस्तदनुवर्तते || 21 ||',
      'translation':
          'Whatever actions a great person performs, common people follow. Whatever standards they set by their actions, the world pursues.',
      'word_meaning':
          'यत् यत्—whatever; आचरति—does/practices; श्रेष्ठः—a great/superior person; तत् तत्—that and that alone; एव—certainly; इतरः—common; जनः—person; सः—he; यत्—whatever; प्रमाणम्—authority/standard; कुरुते—establishes; लोकः—the world/people; तत्—that; अनुवर्तते—follows.',
      'commentary':
          'This establishes the principle of **Loka-saṅgraha** (welfare of the world). Leaders must continue to act diligently, even if personally enlightened, because their actions serve as the moral standard for the masses, who learn through imitation.',
    });

    // Verse 22: Krishna states His own need to act
    await db.insert('chapter_3', {
      'verse_number': 22,
      'sanskrit':
          'न मे पार्थास्ति कर्तव्यं त्रिषु लोकेषु किञ्चन | नानवाप्तमवाप्तव्यं वर्त एव च कर्मणि || 22 ||',
      'translation':
          'O Pārtha, there is no prescribed duty for Me in all the three worlds, nor is there anything I lack or need to gain. Yet, I am engaged in action.',
      'word_meaning':
          'न मे—not My; पार्थ—O Pārtha; अस्ति—is; कर्तव्यम्—duty; त्रिषु लोकेषु—in the three worlds; किञ्चन—anything; न अनवाप्तम्—nothing ungained; अवाप्तव्यम्—to be gained; वर्ते—I am engaged; एव च—certainly; कर्मणि—in action.',
      'commentary':
          'Krishna uses Himself, the Supreme Lord, as the ultimate role model. Though perfectly fulfilled and free from cosmic obligations, He constantly works to maintain universal order (Dharma), demonstrating that action is essential even at the highest level.',
    });

    // Verse 23: Consequences if Krishna ceases to act
    await db.insert('chapter_3', {
      'verse_number': 23,
      'sanskrit':
          'यदि ह्यहं न वर्तेयं जातु कर्मण्यतन्द्रितः | मम वर्त्मानुवर्तन्ते मनुष्याः पार्थ सर्वशः || 23 ||',
      'translation':
          'For if I were not to engage carefully in action, O Pārtha, all men would follow My path in all respects.',
      'word_meaning':
          'यदि—if; हि—certainly; अहम्—I; न वर्तेयम्—were not to engage; जातु—ever; कर्मणि—in action; अतन्द्रितः—without lassitude/carefully; मम—My; वर्त्म—path; अनुवर्तन्ते—would follow; मनुष्याः—men; पार्थ—O Pārtha; सर्वशः—in all respects.',
      'commentary':
          'Krishna warns that if the perfect being were to stop acting, it would legitimize idleness for the masses. Since the actions of leaders set the standard (Verse 21), His inaction would lead to universal collapse.',
    });

    // Verse 24: Universal catastrophe due to inaction
    await db.insert('chapter_3', {
      'verse_number': 24,
      'sanskrit':
          'उत्सीदेयुरिमे लोका न कुर्यां कर्म चेदहम् | सङ्करस्य च कर्ता स्यामुपहन्यामिमाः प्रजाः || 24 ||',
      'translation':
          'If I were to cease performing action, all these worlds would perish. I would be the creator of social disorder (varṇa-saṅkara) and would thereby destroy all these living beings.',
      'word_meaning':
          'उत्सीदेयुः—would perish; इमे—these; लोकाः—worlds; न कुर्याम्—were not to perform; कर्म—action; चेत्—if; अहम्—I; सङ्करस्य—of social disorder; च—and; कर्ता—creator; स्याम्—would be; उपहन्याम्—would destroy; इमाः—these; प्रजाः—living beings.',
      'commentary':
          'This is a dramatic statement on the metaphysical consequences of divine inaction. The constant action of the Lord (through nature) maintains the cosmic harmony; cessation leads to chaos (*varṇa-saṅkara*) and universal destruction.',
    });

    // Verse 25: The wise must set an example
    await db.insert('chapter_3', {
      'verse_number': 25,
      'sanskrit':
          'सक्ताः कर्मण्यविद्वांसो यथा कुर्वन्ति भारत | कुर्याद्विद्वांस्तथासक्तश्चिकीर्षुर्लोकसंग्रहम् || 25 ||',
      'translation':
          'O descendant of Bharata, just as the ignorant act with attachment to the results, so should the wise act without attachment, for the sake of setting an example for the good of the world (*loka-saṅgraha*).',
      'word_meaning':
          'सक्ताः—attached; कर्मणि—in action; अविद्वांसः—the ignorant; यथा—as; कुर्वन्ति—perform; भारत—O descendant of Bharata; कुर्यात्—should perform; विद्वान्—the wise person; तथा—similarly; असक्तः—unattached; चिकीर्षुः—desiring to achieve; लोक-सङ्ग्रहम्—the maintenance of the world.',
      'commentary':
          'The wise person (*vidvān*) must outwardly imitate the diligence of the ignorant (*avidvān*), but with one crucial difference: the wise perform the action **unattached** (*asaktaḥ*), purely for public welfare.',
    });

    // Verse 26: Do not unsettle the minds of the ignorant
    await db.insert('chapter_3', {
      'verse_number': 26,
      'sanskrit':
          'न बुद्धिभेदं जनयेदज्ञानां कर्मसङ्गिनाम् | जोषयेत्सर्वकर्माणि विद्वान् युक्तः समाचरन् || 26 ||',
      'translation':
          'The wise person should not create discord in the minds of ignorant people who are attached to fruitive actions, but should engage them in work by performing all actions with devotion (*Yoga*).',
      'word_meaning':
          'न—not; बुद्धि-भेदम्—division of intellect/confusion; जनयेत्—should produce; अज्ञानाम्—of the ignorant; कर्म-सङ्गिनाम्—who are attached to action; जोषयेत्—should encourage/inspire; सर्व-कर्माणि—all actions; विद्वान्—the wise; युक्तः—united (in Yoga); समाचरन्—performing properly.',
      'commentary':
          'A sage should not confuse people by telling them to stop working before they are ready for pure contemplation. Instead, they should inspire the masses by diligently performing their own duty with a spiritual, detached attitude.',
    });

    // Verse 27: The true doer is nature
    await db.insert('chapter_3', {
      'verse_number': 27,
      'sanskrit':
          'प्रकृतेः क्रियमाणानि गुणैः कर्माणि सर्वशः | अहङ्कारविमूढात्मा कर्ताऽहमिति मन्यते || 27 ||',
      'translation':
          'All activities are carried out by the modes of material nature (*guṇas*). The soul, bewildered by egoism (*ahaṅkāra*), thinks, "I am the doer."',
      'word_meaning':
          'प्रकृतेः—of material nature; क्रियमाणानि—being performed; गुणैः—by the *guṇas* (modes); कर्माणि—actions; सर्वशः—in all respects; अहङ्कार-विमूढ-आत्मा—the soul bewildered by egoism; कर्ता—doer; अहम्—I; इति—thus; मन्यते—thinks.',
      'commentary':
          'This is the philosophical basis for non-attachment. The body and mind are products of nature, and all action is executed by the *guṇas*. The delusion of **egoism** (*Ahaṅkāra*) is what makes the soul falsely claim ownership of the actions.',
    });

    // Verse 28: The Knower of Truth is not attached
    await db.insert('chapter_3', {
      'verse_number': 28,
      'sanskrit':
          'तत्त्ववित्तु महाबाहो गुणकर्मविभागयोः | गुणा गुणेषु वर्तन्त इति मत्वा न सज्जते || 28 ||',
      'translation':
          'O mighty-armed (Arjuna), one who knows the truth about the divisions of the material modes (*guṇas*) and action (*karma*) does not become attached, knowing that the *guṇas* are acting upon the *guṇas*.',
      'word_meaning':
          'तत्त्व-वित्—the knower of the truth; तु—but; महा-बाहो—O mighty-armed; गुण-कर्म-विभागयोः—of the divisions of the *guṇas* and actions; गुणाः—the *guṇas* (senses); गुणेषु—in the *guṇas* (sense objects); वर्तन्ते—are engaging; इति—thus; मत्वा—having thought; न सज्जते—is not attached.',
      'commentary':
          'The wise person sees the interaction between the senses (products of *guṇas*) and the sense objects (also products of *guṇas*) as a mere play of nature. By detaching the self from this transaction, they remain untainted.',
    });

    // Verse 29: The reason for continued bewilderment
    await db.insert('chapter_3', {
      'verse_number': 29,
      'sanskrit':
          'प्रकृतेर्गुणसम्मूढाः सज्जन्ते गुणकर्मसु | तानकृत्स्नविदो मन्दान्कृत्स्नविन्न विचालयेत् || 29 ||',
      'translation':
          'Those who are bewildered by the modes of nature remain attached to the actions performed by the *guṇas*. The enlightened person (knowing the whole truth) should not unsettle these ignorant, partial knowers.',
      'word_meaning':
          'प्रकृतेः—of material nature; गुण-सम्मूढाः—bewildered by the *guṇas*; सज्जन्ते—become attached; गुण-कर्मसु—to actions performed by the *guṇas*; तान्—them; अकृत्स्न-विदः—those who know only part (ignorant); मन्दान्—dull/slow; कृत्स्न-वित्—one who knows the whole truth (enlightened); न विचालयेत्—should not unsettle.',
      'commentary':
          'This reiterates the social responsibility of the sage (Verse 26). The partial knowledge of the ignorant must not be destabilized, as it is better for them to work with attachment than to cease work altogether.',
    });

    // Verse 30: The final instruction to Arjuna (Surrender in Action)
    await db.insert('chapter_3', {
      'verse_number': 30,
      'sanskrit':
          'मयि सर्वाणि कर्माणि संन्यस्याध्यात्मचेतसा | निराशीर्निर्ममो भूत्वा युध्यस्व विगतज्वरः || 30 ||',
      'translation':
          'Surrendering all your actions to Me, fixing your consciousness on the Self, free from hope (desire for results), free from the sense of "mine" (possessiveness), and free from mental fever, fight!',
      'word_meaning':
          'मयि—unto Me; सर्वाणि—all; कर्माणि—actions; संन्यस्य—surrendering; अध्यात्म-चेतसा—with a mind fixed on the Self; निराशीः—free from hope/desire; निर्ममः—free from the sense of "mine"; भूत्वा—having become; युध्यस्व—fight; विगत-ज्वरः—free from mental fever/agitation.',
      'commentary':
          'Krishna gives Arjuna the final, actionable command that synthesizes *Sānkhya* and *Karma Yoga*. The war must be fought as an act of selfless devotion, free of attachment, fear, and ego, by surrendering the results to God.',
    });

    // Verse 31: The reward of following Krishna’s teaching with faith
    await db.insert('chapter_3', {
      'verse_number': 31,
      'sanskrit':
          'ये मे मतमिदं नित्यमनुतिष्ठन्ति मानवाः | श्रद्धावन्तोऽनसूयन्तो मुच्यन्ते तेऽपि कर्मभिः || 31 ||',
      'translation':
          'Those human beings who constantly practice this teaching of Mine, full of faith and without caviling (envy or fault-finding), are released from the bondage of *karma*.',
      'word_meaning':
          'ये—those who; मे—My; मतम्—teaching; इदम्—this; नित्यम्—constantly; अनुतिष्ठन्ति—practice; मानवाः—human beings; श्रद्धावन्तः—full of faith; अनसूयन्तः—without caviling/envy; मुच्यन्ते—are freed; ते अपि—they also; कर्मभिः—from the bondage of action.',
      'commentary':
          'The effectiveness of *Karma Yoga* requires two things: **Śraddhā** (faith in the goal) and **Anasūyantaḥ** (freedom from critical envy towards the teacher). Practicing this teaching consistently ensures liberation from karmic reaction.',
    });

    // Verse 32: The consequence of neglecting Krishna’s teaching
    await db.insert('chapter_3', {
      'verse_number': 32,
      'sanskrit':
          'ये त्वेतदभ्यसूयन्तो नानुतिष्ठन्ति मे मतम् | सर्वज्ञानविमूढांस्तान्विद्धि नष्टानचेतसः || 32 ||',
      'translation':
          'But those who, finding fault with My teachings, do not practice them—know them to be completely bewildered in all knowledge, senseless, and doomed to ruin.',
      'word_meaning':
          'ये तु—but those who; एतत्—this; अभ्यसूयन्तः—finding fault with/envying; न अनुतिष्ठन्ति—do not practice; मे—My; मतम्—teaching; सर्व-ज्ञान-विमूढान्—bewildered in all knowledge; तान्—them; विद्धि—know; नष्टान्—doomed/ruined; अचेतसः—senseless.',
      'commentary':
          'This provides a strong contrast: lack of faith and envy prevents one from receiving the spiritual benefit of the teaching, confirming that the spiritual state depends entirely on the student\'s inner attitude.',
    });

    // Verse 33: The compulsion of one's own nature (Prakṛiti)
    await db.insert('chapter_3', {
      'verse_number': 33,
      'sanskrit':
          'सदृशं चेष्टते स्वस्याः प्रकृतेर्ज्ञानवानपि | प्रकृतिं यान्ति भूतानि निग्रहः किं करिष्यति || 33 ||',
      'translation':
          'Even the wise man acts according to his own nature (*prakṛti*), for all beings are driven by their nature. What can restraint possibly achieve?',
      'word_meaning':
          'सदृशम्—in accordance; चेष्टते—acts; स्वस्याः—one’s own; प्रकृतेः—nature; ज्ञानवान्—the wise man; अपि—even; प्रकृतिम्—nature; यान्ति—follow; भूतानि—beings; निग्रहः—restraint; किम्—what; करिष्यति—will do.',
      'commentary':
          'Krishna acknowledges the immense difficulty of overcoming deep-seated tendencies (*vāsanās*). Since nature is compelling, forced repression of action or desire (*nigraha*) is generally futile and only creates internal conflict.',
    });

    // Verse 34: The true obstacles: Raga and Dveṣa
    await db.insert('chapter_3', {
      'verse_number': 34,
      'sanskrit':
          'इन्द्रियस्येन्द्रियस्यार्थे रागद्वेषौ व्यवस्थितौ | तयोर्न वशमागच्छेत्तौ ह्यस्य परिपन्थिनौ || 34 ||',
      'translation':
          'Attachment (*rāga*) and aversion (*dveṣa*) reside in the sense objects of every sense. One should not come under their control, for they are the two highway robbers of the soul.',
      'word_meaning':
          'इन्द्रियस्य—of the sense; इन्द्रियस्य अर्थे—in the object of that sense; राग-द्वेषौ—attachment and aversion; व्यवस्थितौ—are situated; तयोः—of those two; न वशम्—not under the control; आगच्छेत्—should come; तौ—those two; हि—certainly; अस्य—his; परिपन्थिनौ—highway robbers/foes.',
      'commentary':
          'The real enemies on the spiritual path are the two reactions to sense objects: **Rāga** (attraction/attachment) and **Dveṣa** (repulsion/aversion). These dualities are inherent in the *Prakṛti* (nature) and must be carefully managed.',
    });

    // Verse 35: The superiority of Swadharma (One's own duty)
    await db.insert('chapter_3', {
      'verse_number': 35,
      'sanskrit':
          'श्रेयान्स्वधर्मो विगुणः परधर्मात्स्वनुष्ठितात् | स्वधर्मे निधनं श्रेयः परधर्मो भयावहः || 35 ||',
      'translation':
          'It is far better to perform one’s own duty (*svadharma*), even imperfectly, than to perform the duty of another perfectly. It is better to die in the discharge of one’s own duty; the duty of another is fraught with danger.',
      'word_meaning':
          'श्रेयान्—superior; स्व-धर्मः—one’s own duty; विगुणः—imperfect; पर-धर्मात्—than another’s duty; सु-अनुष्ठितात्—perfectly performed; स्व-धर्मे—in one’s own duty; निधनम्—death; श्रेयः—better; पर-धर्मः—another’s duty; भय-आवहः—fraught with danger.',
      'commentary':
          'This provides the social argument for action. Performing another’s duty is spiritually dangerous because it does not align with one\'s own *prakṛti* (nature) and acquired tendencies, leading to confusion and potential bondage.',
    });

    // Verse 36: Arjuna's question: What is the driving force?
    await db.insert('chapter_3', {
      'verse_number': 36,
      'sanskrit':
          'अर्जुन उवाच | अथ केन प्रयुक्तोऽयं पापं चरति पूरुषः | अनिच्छन्नपि वार्ष्णेय बलादिव नियोजितः || 36 ||',
      'translation':
          'Arjuna said: O Vārṣhṇeya (Krishna), what is it that forces a person to commit sin, even unwillingly, as if engaged by some powerful internal force?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; अथ—now/then; केन—by what; प्रयुक्तः—impelled; अयम्—this; पापम्—sin; चरति—commits; पूरुषः—a person; अनिच्छन्—unwillingly; अपि—even; वार्ष्णेय—O Vārṣhṇeya (Krishna); बलात् इव—as if by force; नियोजितः—engaged.',
      'commentary':
          'Arjuna now moves beyond his personal dilemma to a universal philosophical question: the nature of compulsion. He senses a powerful internal enemy that makes people act against their better judgment.',
    });

    // Verse 37: Krishna identifies the enemy: Desire (Kāma)
    await db.insert('chapter_3', {
      'verse_number': 37,
      'sanskrit':
          'श्रीभगवानुवाच | काम एष क्रोध एष रजोगुणसमुद्भवः | महाशनो महापाप्मा विद्ध्येनमिह वैरिणम् || 37 ||',
      'translation':
          'The Supreme Lord said: It is lust (*kāma*) alone, which transforms into anger (*krodha*), born of the material mode of passion (*rajo-guṇa*). Know this to be the all-devouring, greatest enemy in this world.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; कामः—desire/lust; एषः—this; क्रोधः—anger; एषः—this; रजः-गुण-समुद्भवः—born of the mode of passion; महा-अशनः—all-devouring; महा-पाप्मा—greatly sinful; विद्धि—know; एनम्—this; इह—here; वैरिणम्—the enemy.',
      'commentary':
          'Krishna names the true internal enemy: **Kāma** (desire/lust), which arises from *Rajo-guṇa* (passion). When desire is obstructed, it manifests as **Krodha** (anger). This one force is the source of all sin and bondage.',
    });

    // Verse 38: The covering of knowledge
    await db.insert('chapter_3', {
      'verse_number': 38,
      'sanskrit':
          'धूमेनाव्रियते वह्निर्यथादर्शो मलेन च | यथोल्बेनावृतो गर्भस्तथा तेनेदमावृतम् || 38 ||',
      'translation':
          'Just as fire is covered by smoke, a mirror by dust, and an embryo by the womb, similarly, knowledge is covered by this desire.',
      'word_meaning':
          'धूमेन—by smoke; आव्रियते—is covered; वह्निः—fire; यथा—as; आदर्शः—mirror; मलेन—by dust; च—and; यथा—as; उल्बेन—by the womb; आवृतः—covered; गर्भः—embryo; तथा—similarly; तेन—by that (desire); इदम्—this (knowledge); आवृतम्—is covered.',
      'commentary':
          'Knowledge is naturally present but is obscured by desire, likened to smoke, dust, and the womb. These examples show three different degrees of covering, with the most severe being the all-encompassing nature of lust.',
    });

    // Verse 39: The perpetual enemy of the wise
    await db.insert('chapter_3', {
      'verse_number': 39,
      'sanskrit':
          'आवृतं ज्ञानमेतेन ज्ञानिनो नित्यवैरिणा | कामरूपेण कौन्तेय दुष्पूरेणानलेन च || 39 ||',
      'translation':
          'O son of Kuntī, the wisdom of the discriminating soul is obscured by this insatiable fire in the form of desire, the eternal enemy of the wise.',
      'word_meaning':
          'आवृतम्—covered; ज्ञानम्—knowledge; एतेन—by this; ज्ञानिनः—of the wise; नित्य-वैरिणा—the eternal enemy; काम-रूपेण—in the form of desire; कौन्तेय—O son of Kuntī; दुष्पूरेण—insatiable; अनलेन—by fire; च—and.',
      'commentary':
          'Desire is described as insatiable (*duṣpūreṇa*), like fire, and is the perennial obstacle for those seeking spiritual wisdom. It is an enemy that grows stronger the more it is fed.',
    });

    // Verse 40: The abode of desire
    await db.insert('chapter_3', {
      'verse_number': 40,
      'sanskrit':
          'इन्द्रियाणि मनो बुद्धिरस्याधिष्ठानमुच्यते | एतैर्विमोहयत्येष ज्ञानमावृत्य देहिनम् || 40 ||',
      'translation':
          'The senses, the mind, and the intellect are said to be the breeding grounds (abodes) of this desire. Through these, desire obscures wisdom and bewilders the embodied soul.',
      'word_meaning':
          'इन्द्रियाणि—the senses; मनः—the mind; बुद्धिः—the intellect; अस्य—its; अधिष्ठानम्—abode/seat; उच्यते—is said to be; एतैः—by these; विमोहयति—bewilders; एषः—this (desire); ज्ञानम्—wisdom; आवृत्य—covering; देहिनम्—the embodied soul.',
      'commentary':
          'This locates the enemy. Desire operates primarily through the **senses**, the **mind** (Manas), and the **intellect** (Buddhi). To defeat desire, one must conquer these three internal instruments.',
    });

    // Verse 41: Krishna advises Arjuna to destroy the sinful destroyer (Kāma)
    await db.insert('chapter_3', {
      'verse_number': 41,
      'sanskrit':
          'तस्मात्त्वमिन्द्रियाण्यादौ नियम्य भरतर्षभ | पापमानं प्रजहि ह्येनं ज्ञानविज्ञाननाशनम् || 41 ||',
      'translation':
          'Therefore, O best of the Bhāratas (Arjuna), first control the senses, and then destroy this sinful destroyer of both spiritual knowledge (*jñāna*) and self-realization (*vijñāna*).',
      'word_meaning':
          'तस्मात्—therefore; त्वम्—you; इन्द्रियाणि—the senses; आदौ—first; नियम्य—controlling; भरतर्षभ—O best of the Bhāratas; पापमानम्—the sinful one (desire); प्रजहि—completely destroy; हि—certainly; एनम्—this; ज्ञान-विज्ञान-नाशनम्—the destroyer of theoretical and realized knowledge.',
      'commentary':
          'Since desire (*Kāma*) resides in the senses, mind, and intellect, the struggle must begin by conquering the most external instrument: the **senses**. Control of the senses is the essential first step before the higher battle for the mind can be won.',
    });

    // Verse 42: The hierarchy of consciousness
    await db.insert('chapter_3', {
      'verse_number': 42,
      'sanskrit':
          'इन्द्रियाणि पराण्याहुरिन्द्रियेभ्यः परं मनः | मनसस्तु परा बुद्धिर् यो बुद्धेः परतस्तु सः || 42 ||',
      'translation':
          'The senses are superior (subtler and more powerful) than the gross body; superior to the senses is the mind (*manas*); superior to the mind is the intellect (*buddhi*); and even superior to the intellect is the Self (*Saḥ*).',
      'word_meaning':
          'इन्द्रियाणि—the senses; पराणि—superior; आहुः—they say; इन्द्रियेभ्यः—than the senses; परम्—superior; मनः—the mind; मनसः तु—but than the mind; परा—superior; बुद्धिः—the intellect; यः—who; बुद्धेः—than the intellect; परतः तु—but superior; सः—He/the Self.',
      'commentary':
          'Krishna provides a map of the inner instruments, explaining the hierarchy of consciousness based on subtlety: **Body rightarrow Senses rightarrow Mind rightarrow Intellect rightarrow Self**. The key to success is using the superior instrument (intellect/Self) to govern the inferior ones (mind/senses).',
    });

    // Verse 43: The final command to conquer desire
    await db.insert('chapter_3', {
      'verse_number': 43,
      'sanskrit':
          'एवं बुद्धेः परं बुद्ध्वा संस्तभ्यात्मानमात्मना | जहि शत्रुं महाबाहो कामरूपं दुरासदम् || 43 ||',
      'translation':
          'Thus, knowing the Self to be superior to the material intellect, O mighty-armed (Arjuna), stabilize the mind by the intellect, and conquer this formidable enemy known as desire.',
      'word_meaning':
          'एवम्—thus; बुद्धेः—than the intellect; परम्—superior; बुद्ध्वा—having known; संस्तभ्य—stabilizing/restraining; आत्मानम्—the mind/lower self; आत्मना—by the Self/higher intellect; जहि—conquer/slay; शत्रुम्—the enemy; महा-बाहो—O mighty-armed; काम-रूपम्—in the form of desire; दुरासदम्—formidable/difficult to overcome.',
      'commentary':
          'This is the final, practical instruction of the chapter. Arjuna is commanded to utilize the power of the discriminative intellect to restrain the turbulent mind and senses, thereby slaying the elusive and powerful enemy of **Kāma**. This sets the stage for Chapter 4, which deals with the lineage of this knowledge.',
    });
  }

  Future<void> insertChapter4Verses(Database db) async {
    // Verse 1: Krishna reveals the ancient lineage of the Yoga
    await db.insert('chapter_4', {
      'verse_number': 1,
      'sanskrit':
          'श्रीभगवानुवाच | इमं विवस्वते योगं प्रोक्तवानहमव्ययम् | विवस्वान्मनवे प्राह मनुरिक्ष्वाकवेऽब्रवीत् || 1 ||',
      'translation':
          'The Supreme Lord said: I taught this imperishable science of Yoga to the Sun-god, Vivasvān, and Vivasvān instructed it to Manu (the father of mankind), who, in turn, told it to Ikṣhvāku.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; इमम्—this; विवस्वते—unto the sun-god; योगम्—Yoga/science of the spirit; प्रोक्तवान्—spoke; अहम्—I; अव्ययम्—imperishable; विवस्वान्—Vivasvān; मनवे—unto Manu; प्राह—declared; मनुः—Manu; इक्ष्वाकवे—unto Ikṣhvāku; अब्रवीत्—spoke.',
      'commentary':
          'Krishna establishes the divine, eternal, and non-sectarian nature of the *Bhagavad Gita*’s wisdom. The knowledge (*Jñāna*) did not originate with Krishna and Arjuna, but was passed down through a disciplined, unbroken lineage.',
    });

    // Verse 2: The knowledge was lost over time
    await db.insert('chapter_4', {
      'verse_number': 2,
      'sanskrit':
          'एवं परम्पराप्राप्तमिमं राजर्षयो विदुः | स कालेनेह महता योगो नष्टः परन्तप || 2 ||',
      'translation':
          'O chastiser of the enemy (Arjuna), this science of Yoga was thus received through disciplic succession, and the saintly kings understood it. But with the great passage of time, this knowledge was lost to the world.',
      'word_meaning':
          'एवम्—thus; परम्परा-प्राप्तम्—received through succession; इमम्—this; राजर्षयः—the saintly kings; विदुः—understood; सः—that; कालेन—by time; इह—here; महता—great; योगः—Yoga; नष्टः—lost; परन्तप—O chastiser of the enemy.',
      'commentary':
          'The knowledge was lost because the royal recipients (*Rājarṣis*) failed to transmit it properly, showing that spiritual truth requires not just wisdom, but dedicated practice and transmission.',
    });

    // Verse 3: Why Krishna is revealing it again
    await db.insert('chapter_4', {
      'verse_number': 3,
      'sanskrit':
          'स एवायं मया तेऽद्य योगः प्रोक्तः पुरातनः | भक्तोऽसि मे सखा चेति रहस्यं ह्येतदुत्तमम् || 3 ||',
      'translation':
          'The very same ancient Yoga I am today revealing to you, for you are My devotee and friend, and this knowledge is the supreme secret.',
      'word_meaning':
          'सः एव—that very same; अयम्—this; मया—by Me; ते—unto you; अद्य—today; योगः—Yoga; प्रोक्तः—spoken; पुरातनः—ancient; भक्तः—devotee; असि—are; मे—My; सखा—friend; च इति—and thus; रहस्यम्—secret; हि एतत्—certainly this; उत्तमम्—supreme.',
      'commentary':
          'The criteria for receiving this supreme knowledge are **Bhakti** (devotion) and **Sakhā** (friendship). Krishna reveals it because Arjuna is surrendered, not just intellectually curious.',
    });

    // Verse 4: Arjuna's doubt about Krishna's birth
    await db.insert('chapter_4', {
      'verse_number': 4,
      'sanskrit':
          'अर्जुन उवाच | अपरं भवतो जन्म परं जन्म विवस्वतः | कथमेतद्विजानीयां त्वमादौ प्रोक्तवानिति || 4 ||',
      'translation':
          'Arjuna said: Your birth is recent, and Vivasvān (the Sun-god) was born much earlier. How am I to understand that You instructed this science to him in the beginning?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; अपरम्—later/recent; भवतः—Your; जन्म—birth; परम्—earlier; जन्म—birth; विवस्वतः—of Vivasvān; कथम्—how; एतत्—this; विजानीयाम्—am I to understand; त्वम्—You; आदौ—in the beginning; प्रोक्तवान्—instructed; इति—thus.',
      'commentary':
          'Arjuna poses a logical doubt based on chronology: Krishna appears to be a contemporary. This question forces Krishna to reveal His divine, unborn nature.',
    });

    // Verse 5: Krishna's answer: Divine memory
    await db.insert('chapter_4', {
      'verse_number': 5,
      'sanskrit':
          'श्रीभगवानुवाच | बहूनि मे व्यतीतानि जन्मानि तव चार्जुन | तान्यहं वेद सर्वाणि न त्वं वेत्थ परन्तप || 5 ||',
      'translation':
          'The Supreme Lord said: Both you and I have passed through many births, O Arjuna. I remember them all, but you do not, O chastiser of the enemy.',
      'word_meaning':
          'बहूनि—many; मे—My; व्यतीतानि—have passed; जन्मानि—births; तव—your; च—and; अर्जुन—O Arjuna; तानि—those; अहम्—I; वेद—know; सर्वाणि—all; न त्वम्—not you; वेत्थ—know; परन्तप—O chastiser of the enemy.',
      'commentary':
          'Krishna clarifies that while the embodied soul (Arjuna) is subjected to the illusion of forgetfulness upon rebirth, the Supreme Lord (*Avatār*) maintains perfect knowledge and memory of His past appearances.',
    });

    // Verse 6: The Lord's form is not material
    await db.insert('chapter_4', {
      'verse_number': 6,
      'sanskrit':
          'अजोऽपि सन्नव्ययात्मा भूतानामीश्वरोऽपि सन् | प्रकृतिं स्वामधिष्ठाय संभवाम्यात्ममायया || 6 ||',
      'translation':
          'Although I am unborn, My nature is imperishable, and I am the Lord of all beings, yet by relying on My own divine power (*Yoga-māyā*), I appear in My transcendental form.',
      'word_meaning':
          'अजः अपि सन्—although unborn; अव्यय-आत्मा—My nature is imperishable; भूतानाम्—of all beings; ईश्वरः—the Lord; अपि सन्—although; प्रकृतिम्—material nature; स्वाम्—My own; अधिष्ठाय—by taking charge of; संभवामि—I manifest; आत्म-मायया—by My own divine energy (Yoga-māyā).',
      'commentary':
          'Krishna explains the miracle of His incarnation (*Avatāra*). Unlike ordinary beings, He does not take a body due to *karma*, but manifests it using His own internal, divine power (*Yoga-māyā*), ensuring His form is transcendental and unbinding.',
    });

    // Verse 7: When the Lord descends (Yada Yada Hi Dharmasya)
    await db.insert('chapter_4', {
      'verse_number': 7,
      'sanskrit':
          'यदा यदा हि धर्मस्य ग्लानिर्भवति भारत | अभ्युत्थानमधर्मस्य तदात्मानं सृजाम्यहम् || 7 ||',
      'translation':
          'Whenever and wherever there is a decline of righteousness (*dharma*), O descendant of Bharata, and a noticeable increase in unrighteousness (*adharma*)—at that time, I manifest Myself.',
      'word_meaning':
          'यदा यदा—whenever and wherever; हि—certainly; धर्मस्य—of righteousness; ग्लानिः—decline; भवति—is; भारत—O descendant of Bharata; अभ्युत्थानम्—increase; अधर्मस्य—of unrighteousness; तदा—at that time; आत्मानम्—Myself; सृजामि—I manifest; अहम्—I.',
      'commentary':
          'This is one of the most famous verses, defining the general principle of divine intervention (*Avatāra*). The Lord manifests not randomly, but precisely when cosmic balance is lost and Dharma is threatened.',
    });

    // Verse 8: The purpose of the Lord's manifestation
    await db.insert('chapter_4', {
      'verse_number': 8,
      'sanskrit':
          'परित्राणाय साधूनां विनाशाय च दुष्कृताम् | धर्मसंस्थापनार्थाय सम्भवामि युगे युगे || 8 ||',
      'translation':
          'To protect the righteous, to annihilate the wicked, and to firmly establish the principles of *dharma*, I manifest Myself on earth age after age.',
      'word_meaning':
          'परित्राणाय—for the protection; साधूनाम्—of the righteous; विनाशाय—for the annihilation; च—and; दुष्कृताम्—of the wicked; धर्म-संस्थापन-अर्थाय—for the purpose of firmly establishing righteousness; सम्भवामि—I manifest; युगे युगे—age after age.',
      'commentary':
          'This clarifies the dual purpose of the Avatāra: **protection** (*paritrāṇāya*) of the virtuous and **annihilation** (*vināśāya*) of the evil, all aimed at restoring moral order in the world.',
    });

    // Verse 9: The result of knowing the Lord's divinity
    await db.insert('chapter_4', {
      'verse_number': 9,
      'sanskrit':
          'जन्म कर्म च मे दिव्यमेवं यो वेत्ति तत्त्वतः | त्यक्त्वा देहं पुनर्जन्म नैति मामेति सोऽर्जुन || 9 ||',
      'translation':
          'O Arjuna, one who truly understands the divine nature of My birth and activities, upon leaving the body, does not take birth again but attains My eternal abode.',
      'word_meaning':
          'जन्म—birth; कर्म—activities; च—and; मे—My; दिव्यम्—divine/transcendental; एवम्—thus; यः—who; वेत्ति—knows; तत्त्वतः—in truth; त्यक्त्वा—having abandoned; देहम्—the body; पुनः जन्म—rebirth; न एति—does not attain; माम्—Me; एति—attains; सः—that person; अर्जुन—O Arjuna.',
      'commentary':
          'This offers the ultimate promise: knowledge of the Lord\'s transcendental nature is itself the means to liberation. Simply by understanding Krishna\'s divine appearance, the soul breaks the cycle of *saṁsāra* and returns to the spiritual realm.',
    });

    // Verse 10: The example of liberated souls
    await db.insert('chapter_4', {
      'verse_number': 10,
      'sanskrit':
          'वीतरागभयक्रोधा मन्मया मामुपाश्रिताः | बहवो ज्ञानतपसा पूता मद्भावमागताः || 10 ||',
      'translation':
          'Being free from attachment, fear, and anger, becoming fully absorbed in Me, and taking refuge in Me, many persons in the past became purified by the penance of knowledge and thus attained My divine love.',
      'word_meaning':
          'वीत-राग-भय-क्रोधाः—free from attachment, fear, and anger; मत्-मयाः—fully absorbed in Me; माम्—Me; उपाश्रिताः—having taken refuge in; बहवः—many; ज्ञान-तपसा—by the austerity of knowledge; पूताः—purified; मत्-भावम्—My divine nature; आगताः—attained.',
      'commentary':
          'This provides encouragement by citing past examples. The path to liberation requires internal purification (freedom from **Rāga, Bhaya, Krodha**) and external practice (**Bhakti/refuge in God**), leading to the attainment of the Lord\'s divine nature.',
    });

    // Verse 11: Karmic reciprocity: As you approach Me, I reciprocate
    await db.insert('chapter_4', {
      'verse_number': 11,
      'sanskrit':
          'ये यथा मां प्रपद्यन्ते तांस्तथैव भजाम्यहम् | मम वर्त्मानुवर्तन्ते मनुष्याः पार्थ सर्वशः || 11 ||',
      'translation':
          'In whatever way people surrender unto Me, I reciprocate accordingly. Everyone follows My path, knowingly or unknowingly, O son of Pṛthā (Arjuna).',
      'word_meaning':
          'ये—those who; यथा—in whichever way; माम्—unto Me; प्रपद्यन्ते—surrender; तान्—them; तथा एव—in the same way; भजामि—I reward/reciprocate; अहम्—I; मम—My; वर्त्म—path; अनुवर्तन्ते—follow; मनुष्याः—human beings; पार्थ—O son of Pṛthā; सर्वशः—in all respects.',
      'commentary':
          'This is the principle of **reciprocity**. The Lord meets the devotee where they are—whether they seek material wealth, liberation, or pure love. All paths, ultimately, lead back to Him.',
    });

    // Verse 12: Why people seek material goals
    await db.insert('chapter_4', {
      'verse_number': 12,
      'sanskrit':
          'काङ्क्षन्तः कर्मणां सिद्धिं यजन्त इह देवताः | क्षिप्रं हि मानुषे लोके सिद्धिर्भवति कर्मजा || 12 ||',
      'translation':
          'Those desiring success in fruitive actions (*karmaṇām siddhiṁ*) in this world worship the demigods, because results from work are quickly achieved in the human society.',
      'word_meaning':
          'काङ्क्षन्तः—desiring; कर्मणाम्—of fruitive actions; सिद्धिम्—success; यजन्ते—worship; इह—in this world; देवताः—demigods; क्षिप्रम्—quickly; हि—certainly; मानुषे लोके—in the human world; सिद्धिः—perfection/success; भवति—comes; कर्मजा—born of action.',
      'commentary':
          'The emphasis here is on the contrast: The path of pure devotion leads to liberation, but the path of worshipping demigods yields swift, though temporary, **material results** (*siddhi*).',
    });

    // Verse 13: The fourfold division of society (Guna and Karma)
    await db.insert('chapter_4', {
      'verse_number': 13,
      'sanskrit':
          'चातुर्वर्ण्यं मया सृष्टं गुणकर्मविभागशः | तस्य कर्तारमपि मां विद्ध्यकर्तारमव्ययम् || 13 ||',
      'translation':
          'The four divisions of human society (*cāturvarṇyaṁ*) were created by Me according to the three qualities (*guṇa*) and activities (*karma*). Although I am the creator of this system, know Me to be the non-doer (*akartā*) and immutable.',
      'word_meaning':
          'चातुः-वर्ण्यम्—the four divisions of society (caste); मया—by Me; सृष्टम्—created; गुण-कर्म-विभागशः—according to the division of qualities and work; तस्य—of that; कर्तारम्—the creator; अपि—although; माम्—Me; विद्धि—know; अकर्तारम्—the non-doer; अव्ययम्—immutable/non-perishing.',
      'commentary':
          'The **Varṇa** system (social classes) is based on inherent psychological qualities (*guṇa*) and the work (*karma*) one performs, not on birth alone. Krishna emphasizes His non-attachment to this creation by calling Himself the "non-doer" (*akartā*).',
    });

    // Verse 14: The Lord is untouched by action
    await db.insert('chapter_4', {
      'verse_number': 14,
      'sanskrit':
          'न मां कर्माणि लिम्पन्ति न मे कर्मफले स्पृहा | इति मां योऽभिजानाति कर्मभिर्न स बध्यते || 14 ||',
      'translation':
          'Actions do not affect Me, nor do I have any craving for the fruits of action. One who understands this truth about Me is also never bound by the results of his own actions.',
      'word_meaning':
          'न—never; माम्—Me; कर्माणि—actions; लिम्पन्ति—bind/contaminate; न—nor; मे—My; कर्म-फले—in the results of action; स्पृहा—desire; इति—thus; माम्—Me; यः—who; अभिजानाति—knows; कर्मभिः—by actions; न स बध्यते—is never bound.',
      'commentary':
          'The secret of liberation lies in imitating the Lord\'s attitude: performing work without attachment to the results. This knowledge frees the individual from the chain of *karma* (*karma-bandhana*).',
    });

    // Verse 15: The history of action-in-knowledge
    await db.insert('chapter_4', {
      'verse_number': 15,
      'sanskrit':
          'एवं ज्ञात्वा कृतं कर्म पूर्वैरपि मुमुक्षुभिः | कुरु कर्मैव तस्मात्त्वं पूर्वैः पूर्वतरं कृतम् || 15 ||',
      'translation':
          'All liberated souls in ancient times performed action with this knowledge in mind. Therefore, you should perform your duty, following in the footsteps of your predecessors.',
      'word_meaning':
          'एवम्—thus; ज्ञात्वा—having known; कृतम्—was performed; कर्म—work; पूर्वैः—by the ancients; अपि—also; मुमुक्षुभिः—by those desiring liberation; कुरु—perform; कर्म एव—action certainly; तस्मात्—therefore; त्वम्—you; पूर्वैः—by the predecessors; पूर्वतरम्—in ancient times; कृतम्—performed.',
      'commentary':
          'Krishna encourages Arjuna by showing that **Karma Yoga** is not a new invention but an ancient, proven method practiced by seekers of liberation (*mumukṣubhiḥ*).',
    });

    // Verse 16: The complexity of action
    await db.insert('chapter_4', {
      'verse_number': 16,
      'sanskrit':
          'किं कर्म किम कर्मेति कवयोऽप्यत्र मोहिताः | तत्ते कर्म प्रवक्ष्यामि यज्ज्ञात्वा मोक्ष्यसेऽशुभात् || 16 ||',
      'translation':
          'Even the intelligent (*kavayaḥ*) are bewildered about what is action (*karma*) and what is inaction (*akarma*). I shall therefore explain to you what action is, by knowing which you will be liberated from all inauspiciousness.',
      'word_meaning':
          'किम्—what; कर्म—action; किम्—what; अकर्म—inaction; इति—thus; कवयः—the intelligent/learned; अपि—even; अत्र—in this matter; मोहिताः—bewildered; तत्—that; ते—unto you; कर्म—action; प्रवक्ष्यामि—I shall explain; यत्—which; ज्ञात्वा—having known; मोक्ष्यसे—you will be liberated; अशुभात्—from inauspiciousness.',
      'commentary':
          'This verse sets up the profound philosophical core of the chapter, highlighting the subtle difficulty in distinguishing between real action (that which binds) and apparent inaction (that which liberates).',
    });

    // Verse 17: Distinction of the three types of action
    await db.insert('chapter_4', {
      'verse_number': 17,
      'sanskrit':
          'कर्मणो ह्यपि बोद्धव्यं बोद्धव्यं च विकर्मणः | अकर्मणश्च बोद्धव्यं गहना कर्मणो गतिः || 17 ||',
      'translation':
          'One must properly understand what is **action** (*karma*), what is **forbidden action** (*vikarma*), and what is **inaction** (*akarma*). The intricate path of action is extremely difficult to comprehend.',
      'word_meaning':
          'कर्मणः—of action; हि—certainly; अपि—also; बोद्धव्यम्—must be understood; बोद्धव्यम्—must be understood; च—and; विकर्मणः—of forbidden action; अकर्मणः—of inaction; च—and; बोद्धव्यम्—must be understood; गहना—very difficult; कर्मणः—of action; गतिः—the nature/way.',
      'commentary':
          'The three types of action are: **Karma** (prescribed duty), **Vikarma** (sinful or prohibited action), and **Akarma** (transcendental action or inaction in action). The nature of *karma* is compared to a dense forest (*gahanā gatiḥ*).',
    });

    // Verse 18: Inaction in action and action in inaction
    await db.insert('chapter_4', {
      'verse_number': 18,
      'sanskrit':
          'कर्मण्यकर्म यः पश्येदकर्मणि च कर्म यः | स बुद्धिमान्मनुष्येषु स युक्तः कृत्स्नकर्मकृत् || 18 ||',
      'translation':
          'One who sees **inaction in action** and **action in inaction** is intelligent among human beings. He is situated in the transcendental position and is the performer of all actions.',
      'word_meaning':
          'कर्मणि—in action; अकर्म—inaction; यः—who; पश्येत्—sees; अकर्मणि—in inaction; च—and; कर्म—action; यः—who; सः—he; बुद्धिमान्—is intelligent; मनुष्येषु—among human beings; सः—he; युक्तः—is engaged in Yoga/is transcendental; कृत्स्न-कर्म-कृत्—the doer of all actions.',
      'commentary':
          'This is the philosophical pinnacle of **Karmic wisdom**. **Inaction in action** means remaining unattached while physically working. **Action in inaction** means realizing that even apparent passivity (like meditation) is a dynamic spiritual pursuit with profound effect. This person is truly a *Yogi* (*yuktaḥ*).',
    });

    // Verse 19: The criteria for a knower of truth
    await db.insert('chapter_4', {
      'verse_number': 19,
      'sanskrit':
          'यस्य सर्वे समारम्भाः कामसङ्कल्पवर्जिताः | ज्ञानाग्निदग्धकर्माणं तमाहुः पण्डितं बुधाः || 19 ||',
      'translation':
          'One whose endeavors are free from the desire for sense gratification (*kāma*) and selfish motives (*saṅkalpa*), and whose karmic reactions have been burned by the fire of perfect knowledge (*jñānāgni*), is called a wise person by the learned.',
      'word_meaning':
          'यस्य—whose; सर्वे—all; समारम्भाः—endeavors; काम-सङ्कल्प-वर्जिताः—devoid of selfish desire and motive; ज्ञान-अग्नि-दग्ध-कर्माणम्—one whose actions are burned by the fire of knowledge; तम्—him; आहुः—call; पण्डितम्—learned/wise; बुधाः—those who know the truth.',
      'commentary':
          'The true *Paṇḍita* (wise person) is not defined by external actions but by internal purity. Their actions are merely movements, as the seeds of *karma* have been spiritually incinerated (*jñānāgni-dagdha-karmāṇaṁ*).',
    });

    // Verse 20: The state of a liberated worker
    await db.insert('chapter_4', {
      'verse_number': 20,
      'sanskrit':
          'त्यक्त्वा कर्मफलासङ्गं नित्यतृप्तो निराश्रयः | कर्मण्यभिप्रवृत्तोऽपि नैव किञ्चित्करोति सः || 20 ||',
      'translation':
          'Having given up attachment to the results of work, always content, and fully independent, such a person, though engaged in all kinds of activities, does not do anything at all.',
      'word_meaning':
          'त्यक्त्वा—having abandoned; कर्म-फल-आसङ्गम्—attachment to the results of work; नित्य-तृप्तः—always satisfied; निराश्रयः—without any dependence/refuge (on material things); कर्मणि—in work; अभिप्रवृत्तः—fully engaged; अपि—even though; न एव—never; किञ्चित्—anything; करोति—does; सः—he.',
      'commentary':
          'This summarizes the final state of the **Jñāna Karma Yogi**. By being internally detached and self-satisfied (*nitya-tṛpto*), their work is purely mechanical, performed out of duty and love, and therefore carries no binding reaction. They are "doing nothing at all" in the eyes of *karma*.',
    });

    // Verse 21: The condition for freedom from sin (The detached worker)
    await db.insert('chapter_4', {
      'verse_number': 21,
      'sanskrit':
          'निराशीर्यतचित्तात्मा त्यक्तसर्वपरिग्रहः | शारीरं केवलं कर्म कुर्वन्नाप्नोति किल्बिषम् || 21 ||',
      'translation':
          'Free from expectations and the sense of ownership, with the mind and intellect fully controlled, one incurs no sin even though performing actions only for the maintenance of the body.',
      'word_meaning':
          'निराशीः—free from expectation; यत-चित्त-आत्मा—with controlled mind and intellect; त्यक्त-सर्व-परिग्रहः—having abandoned all sense of ownership; शारीरम्—bodily; केवलम्—only/merely; कर्म—actions; कुर्वन्—performing; न आप्नोति—does not incur; किल्बिषम्—sin/reaction.',
      'commentary':
          'This describes the liberated state: the actions performed are merely mechanical movements of the body (*śārīraṁ kevalaṁ karma*), and because they are done without ego or possessiveness, they generate no karmic reaction (*kilbiṣham*).',
    });

    // Verse 22: Equanimity and contentment lead to freedom
    await db.insert('chapter_4', {
      'verse_number': 22,
      'sanskrit':
          'यदृच्छालाभसन्तुष्टो द्वन्द्वातीतो विमत्सरः | समः सिद्धावसिद्धौ च कृत्वापि न निबध्यते || 22 ||',
      'translation':
          'Content with whatever gain comes naturally, free from dualities, devoid of envy, and steady in both success and failure—such a person is never bound, even while acting.',
      'word_meaning':
          'यदृच्छा-लाभ-सन्तुष्टः—content with the gain that comes naturally; द्वन्द्व-अतीतः—transcending dualities; विमत्सरः—free from envy/malice; समः—equipoised; सिद्धौ-असिद्धौ—in success and failure; च—and; कृत्वा—having done; अपि—even; न निबध्यते—is not bound.',
      'commentary':
          'Inner contentment (*santuṣṭo*) and freedom from envy (*vimatsaraḥ*) are the psychological results of enlightenment. Such a person operates outside the binding conditions of the world.',
    });

    // Verse 23: The final stage of karmic annihilation
    await db.insert('chapter_4', {
      'verse_number': 23,
      'sanskrit':
          'गतसङ्गस्य मुक्तस्य ज्ञानावस्थितचेतसः | यज्ञायाचरतः कर्म समग्रं प्रविलीयते || 23 ||',
      'translation':
          'The work of one who is free from attachment, who is liberated, and whose mind is fixed in knowledge, dissolves completely when performed as a sacrifice (*Yajña*).',
      'word_meaning':
          'गत-सङ्गस्य—of one who is free from attachment; मुक्तस्य—of the liberated; ज्ञान-अवस्थित-चेतसः—whose mind is fixed in knowledge; यज्ञाय—for the purpose of sacrifice; आचरतः—performing; कर्म—action; समग्रम्—entirely; प्रविलीयते—is completely dissolved.',
      'commentary':
          'This is the culmination of *Karma Yoga*. Actions of the liberated soul (*Jñānāvasthita-cetasaḥ*) dissolve instantly, leaving no karmic trace because the action is performed as a pure, selfless offering (*Yajñāya ācarataḥ*).',
    });

    // Verse 24: Brahman as the Sacrifice (Brahmarpaṇam Brahma Havir)
    await db.insert('chapter_4', {
      'verse_number': 24,
      'sanskrit':
          'ब्रह्मार्पणं ब्रह्म हविर् ब्रह्माग्नौ ब्रह्मणा हुतम् | ब्रह्मैव तेन गन्तव्यं ब्रह्मकर्मसमाधिना || 24 ||',
      'translation':
          'For those completely absorbed in God-consciousness, the oblation is Brahman, the offering is Brahman, the fire is Brahman, and the sacrificer is Brahman. Such a person, focused on the action that is Brahman, certainly attains Brahman.',
      'word_meaning':
          'ब्रह्म-अर्पणम्—the act of offering is Brahman; ब्रह्म—Brahman; हविः—the oblation; ब्रह्म-अग्नौ—in the fire of Brahman; ब्रह्मणा—by Brahman; हुतम्—offered; ब्रह्म एव—Brahman only; तेन—by that person; गन्तव्यम्—is to be attained; ब्रह्म-कर्म-समाधिना—by one absorbed in the action that is Brahman.',
      'commentary':
          'This provides the mystical vision of the realized soul: all aspects of action—the agent, the instrument, the object, and the result—are seen as manifestations of the Supreme Reality (*Brahman*). This perception is the highest form of sacrifice (*Yajña*).',
    });

    // Verse 25: Different types of ritualistic sacrifice
    await db.insert('chapter_4', {
      'verse_number': 25,
      'sanskrit':
          'दैवमेवापरे यज्ञं योगिनः पर्युपासते | ब्रह्माग्नावपरे यज्ञं यज्ञेनैवोपजुह्वति || 25 ||',
      'translation':
          'Some Yogīs worship the celestial gods (*deva*) by ritualistic sacrifice. Others offer the Self as a sacrifice in the fire of *Brahman* (Self-Knowledge).',
      'word_meaning':
          'दैवम् एव—unto the celestial gods; अपरे—others; यज्ञम्—sacrifice; योगिनः—Yogīs; पर्युपासते—worship fully; ब्रह्म-अग्नौ—in the fire of Brahman; अपरे—others; यज्ञम्—sacrifice; यज्ञेन एव—by the sacrifice (Self) itself; उपजुह्वति—offer.',
      'commentary':
          'Krishna begins listing the various forms of *Yajña* performed by seekers. The distinction is between external worship of cosmic powers and internal contemplation leading to Self-realization.',
    });

    // Verse 26: Sacrifice through sense control
    await db.insert('chapter_4', {
      'verse_number': 26,
      'sanskrit':
          'श्रोत्रादीनीन्द्रियाण्यन्ये संयमाग्निषु जुह्वति | शब्दादीन्विषयानन्य इन्द्रियाग्निषु जुह्वति || 26 ||',
      'translation':
          'Some (Yogīs) sacrifice their hearing and other senses into the fire of self-control, while others sacrifice the sense objects (like sound) into the fire of their senses.',
      'word_meaning':
          'श्रोत्र-आदीनि—the hearing and other; इन्द्रियाणि—senses; अन्ये—some; संयम-अग्निषु—in the fire of self-control; जुह्वति—offer as sacrifice; शब्द-आदीन्—sound and other; विषयान—sense objects; अन्ये—others; इन्द्रिय-अग्निषु—in the fire of the senses; जुह्वति—offer.',
      'commentary':
          'This describes two methods of sense discipline: 1) controlling the sense organs by will (*saṁyama*), and 2) allowing the senses to meet their objects but with a detached attitude, offering the *experience* itself as a sacrifice.',
    });

    // Verse 27: Sacrifice through breath and mind control
    await db.insert('chapter_4', {
      'verse_number': 27,
      'sanskrit':
          'सर्वाणीन्द्रियकर्माणि प्राणकर्माणि चापरे | आत्मसंयमयोगाग्नौ जुह्वति ज्ञानदीपिते || 27 ||',
      'translation':
          'Others sacrifice all functions of the senses and the functions of the vital breath (*prāṇa*) into the fire of the Yoga of self-control, kindled by knowledge.',
      'word_meaning':
          'सर्वाणि—all; इन्द्रिय-कर्माणि—the actions of the senses; प्राण-कर्माणि—the actions of the life-breath; च अपरे—and others; आत्म-संयम-योग-अग्नौ—in the fire of the Yoga of self-control; जुह्वति—offer; ज्ञान-दीपिते—kindled by knowledge.',
      'commentary':
          'This refers to the practice of *Rāja Yoga*, where the entire physiological system (sense actions and breathing/Prāṇāyāma) is offered as a controlled sacrifice (*saṁyama*), allowing the light of knowledge (*jñāna*) to burn away impurities.',
    });

    // Verse 28: Sacrifice through austerity, study, and wealth
    await db.insert('chapter_4', {
      'verse_number': 28,
      'sanskrit':
          'द्रव्ययज्ञास्तपोयज्ञा योगयज्ञास्तथापरे | स्वाध्यायज्ञानयज्ञाश्च यतयः संशितव्रताः || 28 ||',
      'translation':
          'Some offer wealth (*dravya*) as sacrifice; others offer austerity (*tapas*) as sacrifice; some offer *Yoga* (meditation) as sacrifice; and still others, who are striving ascetics with firm vows, offer study of the scriptures (*svādhyāya*) and knowledge (*jñāna*) as sacrifice.',
      'word_meaning':
          'द्रव्य-यज्ञाः—sacrifice of wealth; तपः-यज्ञाः—sacrifice of austerity; योग-यज्ञाः—sacrifice of Yoga; तथा अपरे—and others; स्वाध्याय-ज्ञान-यज्ञाः—sacrifice of scriptural study and knowledge; च—and; यतयः—striving ascetics; संशित-व्रताः—of firm vows.',
      'commentary':
          'Krishna lists the diversity of methods, showing that **any dedicated discipline**, whether material (giving money), physical (fasting), or intellectual (studying scriptures), can be converted into a liberating sacrifice.',
    });

    // Verse 29: Sacrifice through breath regulation (Prāṇāyāma)
    await db.insert('chapter_4', {
      'verse_number': 29,
      'sanskrit':
          'अपाने जुह्वति प्राणं प्राणेऽपानं तथापरे | प्राणापानगती रुद्ध्वा प्राणायामपरायणाः || 29 ||',
      'translation':
          'Others sacrifice the outgoing breath (*prāṇa*) into the incoming breath (*apāna*); and some sacrifice the incoming breath into the outgoing breath, diligently devoted to the practice of breath regulation (*Prāṇāyāma*).',
      'word_meaning':
          'अपाने—in the incoming breath; जुह्वति—offer/sacrifice; प्राणम्—the outgoing breath; प्राणे—in the outgoing breath; अपानम्—the incoming breath; तथा अपरे—and others; प्राणापान-गती—the movement of the incoming and outgoing breaths; रुद्ध्वा—having checked/stopped; प्राणायाम-परायणाः—devoted to the practice of Prāṇāyāma.',
      'commentary':
          'This refers specifically to different methods of *Prāṇāyāma* (breath control). By harmonizing or halting the life-energy, the Yogi achieves control over the mind and senses, making the breath itself a form of sacrifice.',
    });

    // Verse 30: Sacrifice through regulated diet
    await db.insert('chapter_4', {
      'verse_number': 30,
      'sanskrit':
          'अपरे नियताहाराः प्राणान्प्राणेषु जुह्वति | सर्वेऽप्येते यज्ञविदो यज्ञक्षपितकल्मषाः || 30 ||',
      'translation':
          'Others, having regulated their diet, offer the vital airs into the vital airs. All these various performers of sacrifice are cleansed of sin by their actions.',
      'word_meaning':
          'अपरे—others; नियत-आहाराः—having regulated diet; प्राणान्—the vital airs; प्राणेषु—in the vital airs; जुह्वति—sacrifice; सर्वे अपि—all these also; एते—these; यज्ञ-विदः—knowers of sacrifice; यज्ञ-क्षपित-कल्मषाः—whose sins are destroyed by sacrifice.',
      'commentary':
          'The segment concludes by including the sacrifice of **regulated diet** (*niyatāhārāḥ*). Regardless of the specific method (*Yajña*), the spiritual outcome is the same: the burning away of karmic impurities (*kilbiṣham*).',
    });

    // Verse 31: The benefit of sacrifice
    await db.insert('chapter_4', {
      'verse_number': 31,
      'sanskrit':
          'यज्ञशिष्टामृतभुजो यान्ति ब्रह्म सनातनम् | नायं लोकोऽस्त्ययज्ञस्य कुतोऽन्यः कुरुसत्तम || 31 ||',
      'translation':
          'Those who partake of the nectar of the remnants of sacrifice attain the eternal Brahman. O best of the Kurus (Arjuna), this world is not for the non-performer of sacrifice; how then can the other world be?',
      'word_meaning':
          'यज्ञ-शिष्ट-अमृत-भुजः—those who partake of the nectarean remnants of sacrifice; यान्ति—go; ब्रह्म—the Absolute Truth; सनातनम्—eternal; न अयम्—not this; लोकः—world; अस्ति—is; अयज्ञस्य—for one who performs no sacrifice; कुतः—how; अन्यः—other (world); कुरुसत्तम—O best of the Kurus (Arjuna).',
      'commentary':
          'Every action should be an offering (*Yajña*). The "remnant" (*śiṣhṭa*) is the spiritual purity and contentment that remains after the action is dedicated. Without this sacrificial attitude, a person fails both materially and spiritually.',
    });

    // Verse 32: All sacrifices are born of action
    await db.insert('chapter_4', {
      'verse_number': 32,
      'sanskrit':
          'एवं बहुविधा यज्ञा वितता ब्रह्मणो मुखे | कर्मजान्विद्धि तान्सर्वानेवं ज्ञात्वा विमोक्ष्यसे || 32 ||',
      'translation':
          'Thus, many different kinds of sacrifices have been declared in the Vedas. Know them all to be born of action. Knowing this, you shall be liberated.',
      'word_meaning':
          'एवम्—thus; बहु-विधाः—various kinds; यज्ञाः—sacrifices; वितताः—spread out/extended; ब्रह्मणः मुखे—in the face (or mouth) of Brahman (i.e., the Vedas); कर्म-जान्—born of action; विद्धि—know; तान् सर्वान्—all of them; एवम्—thus; ज्ञात्वा—having known; विमोक्ष्यसे—you shall be liberated.',
      'commentary':
          'The essence of all these sacrifices is that they involve some form of dedicated effort (*Karma*). Understanding that all *Yajñas* are rooted in action helps the seeker connect ritual to the practical path of *Karma Yoga*.',
    });

    // Verse 33: The superiority of Knowledge-Sacrifice
    await db.insert('chapter_4', {
      'verse_number': 33,
      'sanskrit':
          'श्रेयान्द्रव्यमयाद्यज्ञाज्ज्ञानयज्ञः परन्तप | सर्वे कर्मखिलं पार्थ ज्ञाने परिसमाप्यते || 33 ||',
      'translation':
          'The sacrifice performed in knowledge (*Jñāna-Yajña*) is superior to any sacrifice performed with material objects (*dravyamaya-Yajña*), O scorcher of enemies (Arjuna). O Pārtha, all actions culminate entirely in knowledge.',
      'word_meaning':
          'श्रेयान्—superior; द्रव्य-मयात्—of material objects; यज्ञात्—than sacrifice; ज्ञान-यज्ञः—sacrifice of knowledge; परन्तप—O scorcher of enemies; सर्वे—all; कर्म—action; अखिलम्—entirely; पार्थ—O son of Pṛthā (Arjuna); ज्ञाने—in knowledge; परिसमाप्यते—culminates.',
      'commentary':
          'This is a pivotal verse: while ritual and action are necessary, they are merely preparatory. **Knowledge** is the goal and the most effective spiritual practice, as it addresses the root cause of bondage (ignorance).',
    });

    // Verse 34: How to acquire knowledge
    await db.insert('chapter_4', {
      'verse_number': 34,
      'sanskrit':
          'तद्विद्धि प्रणिपातेन परिप्रश्नेन सेवया | उपदेक्ष्यन्ति ते ज्ञानं ज्ञानिनस्तत्त्वदर्शिनः || 34 ||',
      'translation':
          'Learn the Truth by approaching a spiritual master. Inquire from him submissively, render service unto him, and the self-realized soul (*tattva-darśinaḥ*) will instruct you in that knowledge.',
      'word_meaning':
          'तत्—that; विद्धि—know; प्रणिपातेन—by prostration/humility; परिप्रश्नेन—by sincere questioning; सेवया—by service; उपदेक्ष्यन्ति—they will instruct; ते—you; ज्ञानम्—knowledge; ज्ञानिनः—the knowledgeable ones; तत्त्व-दर्शिनः—the perceivers of the Truth.',
      'commentary':
          'The three essential steps for a student are humility (*praṇipātena*), sincere inquiry (*paripraśnena*), and service (*sevayā*). Knowledge is not simply obtained from books; it must be received from one who has directly experienced the Truth (*tattva-darśinaḥ*).',
    });

    // Verse 35: The benefit of realized knowledge
    await db.insert('chapter_4', {
      'verse_number': 35,
      'sanskrit':
          'यज्ज्ञात्वा न पुनर्मोहमेवं यास्यसि पाण्डव | येन भूतान्यशेषेण द्रक्ष्यस्यात्मन्यथो मयि || 35 ||',
      'translation':
          'Having known that (Truth), O Pāṇḍava (Arjuna), you will not again fall into such delusion, for by this knowledge you will see all beings in your own Self, and thus in Me (God).',
      'word_meaning':
          'यत्—which; ज्ञात्वा—having known; न—never; पुनः—again; मोहम्—delusion; एवम्—such; यास्यसि—you will go; पाण्डव—O son of Pāṇḍu; येन—by which; भूतानि—beings; अशेषेण—completely; द्रक्ष्यसि—you will see; आत्मनि—in the Self; अथो—and; मयि—in Me (God).',
      'commentary':
          'The delusion is the sense of separation. Realized knowledge destroys this by revealing the **oneness** of all existence: the Self is in all beings, and all beings are in the Supreme Self (Krishna).',
    });

    // Verse 36: Knowledge as the destroyer of sin
    await db.insert('chapter_4', {
      'verse_number': 36,
      'sanskrit':
          'अपि चेदसि पापेभ्यः सर्वेभ्यः पापकृत्तमः | सर्वं ज्ञानप्लवेनैव वृजिनं सन्तरिष्यसि || 36 ||',
      'translation':
          'Even if you are considered the greatest of all sinners, you will cross over the entire ocean of miseries by the boat of knowledge alone.',
      'word_meaning':
          'अपि चेत्—even if; असि—you are; पापेभ्यः—than all sinners; सर्वेभ्यः—all; पाप-कृत्-तमः—the greatest sinner; सर्वम्—all; ज्ञान-प्लवेन एव—by the boat of knowledge alone; वृजिनम्—misery/sin; सन्तरिष्यसि—you will cross completely.',
      'commentary':
          'This is a powerful statement on the efficacy of knowledge. Past actions, however grievous, cannot bind the soul once the light of wisdom has dawned.',
    });

    // Verse 37: The fire of knowledge
    await db.insert('chapter_4', {
      'verse_number': 37,
      'sanskrit':
          'यथैधांसि समिद्धोऽग्निर्भस्मसात्कुरुतेऽर्जुन | ज्ञानाग्निः सर्वकर्माणि भस्मसात्कुरुते तथा || 37 ||',
      'translation':
          'Just as a blazing fire turns firewood into ashes, O Arjuna, so does the fire of knowledge burn all reactions to material activities to ashes.',
      'word_meaning':
          'यथा—just as; एधांसि—firewood; समिद्धः—blazing; अग्निः—fire; भस्मसात् कुरुते—reduces to ashes; अर्जुन—O Arjuna; ज्ञान-अग्निः—the fire of knowledge; सर्व-कर्माणि—all actions/karmic reactions; भस्मसात् कुरुते—reduces to ashes; तथा—so.',
      'commentary':
          'The image of the **fire of knowledge (*jñānāgni*)** is used to show that knowledge does not merely neutralize karma; it utterly destroys the seeds of all past actions, preventing future bondage.',
    });

    // Verse 38: The purifying nature of knowledge
    await db.insert('chapter_4', {
      'verse_number': 38,
      'sanskrit':
          'न हि ज्ञानेन सदृशं पवित्रमिह विद्यते | तत्स्वयं योगसंसिद्धः कालेनात्मनि विन्दति || 38 ||',
      'translation':
          'In this world, there is certainly nothing as purifying as knowledge. One who has attained perfection in Yoga (*yoga-saṁsiddhaḥ*) realizes that knowledge within oneself in due course of time.',
      'word_meaning':
          'न हि—certainly not; ज्ञानेन—to knowledge; सदृशम्—equal; पवित्रम्—purifier; इह—here (in this world); विद्यते—is; तत्—that; स्वयम्—oneself; योग-संसिद्धः—one who has achieved perfection in Yoga; कालेन्—in due course of time; आत्मनि—in the Self; विन्दति—realizes.',
      'commentary':
          'The person who practices *Karma Yoga* diligently and consistently (*yoga-saṁsiddhaḥ*) eventually purifies the mind, leading to the spontaneous dawning of knowledge (*kālenātmani vindati*).',
    });

    // Verse 39: The prerequisite for attaining knowledge
    await db.insert('chapter_4', {
      'verse_number': 39,
      'sanskrit':
          'श्रद्धावाँल्लभते ज्ञानं तत्परः संयतेन्द्रियः | ज्ञानं लब्ध्वा परां शान्तिमचिरेणाधिगच्छति || 39 ||',
      'translation':
          'One who possesses faith (*śraddhā*), who is dedicated to it (*tatparaḥ*), and who controls the senses (*saṁyatendriyaḥ*), attains this knowledge. Having attained knowledge, one quickly achieves the supreme peace.',
      'word_meaning':
          'श्रद्धावान्—a person with faith; लभते—attains; ज्ञानम्—knowledge; तत्परः—dedicated/devoted; संयत-इन्द्रियः—who has subdued senses; ज्ञानम्—knowledge; लब्ध्वा—having attained; पराम्—supreme; शान्तिम्—peace; अचिरेण—quickly; अधिगच्छति—achieves.',
      'commentary':
          'Knowledge is attained by three essential virtues: **faith** in the teachings, unwavering **dedication** to the path, and **self-control** which stabilizes the mind for meditation.',
    });

    // Verse 40: The fate of the doubter
    await db.insert('chapter_4', {
      'verse_number': 40,
      'sanskrit':
          'अज्ञश्चाश्रद्दधानश्च संशयात्मा विनश्यति | नायं लोकोऽस्ति न परो न सुखं संशयात्मनः || 40 ||',
      'translation':
          'But the ignorant, the faithless, and the doubting soul perishes. For the doubting person, there is happiness neither in this world nor in the next.',
      'word_meaning':
          'अज्ञः—the ignorant; च—and; अश्रद्दधानः—the faithless; च—and; संशय-आत्मा—the doubting soul; विनश्यति—perishes/falls down; न अयम्—not this; लोकः—world; अस्ति—is; न परः—nor the next; न सुखम्—nor happiness; संशय-आत्मनः—for the doubting soul.',
      'commentary':
          'The greatest impediment is **doubt (*saṁśaya*)**. It cripples action, prevents dedication, and creates inner turmoil, leading to failure in both material and spiritual endeavors.',
    });

    // Verse 41: The liberated action
    await db.insert('chapter_4', {
      'verse_number': 41,
      'sanskrit':
          'योगसंन्यस्तकर्माणं ज्ञानसंछिन्नसंशयम् | आत्मवन्तं न कर्माणि निबध्नन्ति धनञ्जय || 41 ||',
      'translation':
          'O Dhanañjaya (Arjuna), actions do not bind one who has renounced actions by Yoga, whose doubts are completely destroyed by knowledge, and who is situated in the Self (*ātmavantaṁ*).',
      'word_meaning':
          'योग-संन्यस्त-कर्माणम्—one who has renounced actions by Yoga; ज्ञान-संछिन्न-संशयम्—one whose doubts are completely cut by knowledge; आत्मवन्तम्—one who is situated in the Self; न—never; कर्माणि—actions; निबध्नन्ति—bind; धनञ्जय—O conqueror of wealth (Arjuna).',
      'commentary':
          'This summarizes the entire chapter: the combination of **Yoga** (selfless action/dedication) and **Knowledge** (destroying doubt) is the key to liberation while living and acting in the world.',
    });

    // Verse 42: Krishna’s concluding instruction
    await db.insert('chapter_4', {
      'verse_number': 42,
      'sanskrit':
          'तस्मादज्ञानसंभूतं हृत्स्थं ज्ञानसिनात्मनः | छित्त्वैनं संशयं योगमातिष्ठोत्तिष्ठ भारत || 42 ||',
      'translation':
          'Therefore, using the sword of knowledge, cut asunder this doubt born of ignorance that resides in your heart, O Bhārata (Arjuna). Take shelter of Yoga and arise (for battle).',
      'word_meaning':
          'तस्मात्—therefore; अज्ञान-संभूतम्—born of ignorance; हृत्-स्थम्—residing in the heart; ज्ञान-असिना—by the sword of knowledge; आत्मनः—of the Self; छित्त्वा—having cut; एनम्—this; संशयम्—doubt; योगम्—Yoga (Karma Yoga); आतिष्ठ—take refuge in; उत्तिष्ठ—arise/stand up; भारत—O descendant of Bharata (Arjuna).',
      'commentary':
          'The chapter concludes with a powerful, direct instruction: **doubt (*saṁśaya*)** is the obstacle, **knowledge (*jñāna*)** is the weapon, and **action (*yoga*)** is the means. Arjuna is commanded to stop hesitating and fulfill his duty with an enlightened understanding. ',
    });
  }

  Future<void> insertChapter5Verses(Database db) async {
    // Verse 1: Arjuna asks which is better: Renunciation or Action
    await db.insert('chapter_5', {
      'verse_number': 1,
      'sanskrit':
          'अर्जुन उवाच | संन्यासं कर्मणां कृष्ण पुनर्योगं च शंससि | यच्छ्रेय एतयोरेकं तन्मे ब्रूहि सुनिश्चितम् || 1 ||',
      'translation':
          'Arjuna said: O Krishna, You praised the renunciation of actions (*sanyāsaṁ*) and then again the performance of action (*yogaṁ*). Tell me decisively which of the two is more beneficial.',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; सन्न्यासं—renunciation; कर्मणाम्—of actions; कृष्ण—O Krishna; पुनः—again; योगम्—the path of action (Karma Yoga); च—and; शंससि—You praise; यत्—which; श्रेयः—more beneficial; एतयोः—of the two; एकम्—one; तत्—that; मे—unto me; ब्रूहि—please tell; सुनिश्चितम्—conclusively.',
      'commentary':
          'Arjuna confusion arises because he sees *Sanyās* (renouncing activity) and *Karma Yoga* (acting with detachment) as mutually exclusive paths. He demands a clear, final choice for attaining the highest good.',
    });

    // Verse 2: Krishna states that Karma Yoga is superior for most
    await db.insert('chapter_5', {
      'verse_number': 2,
      'sanskrit':
          'श्रीभगवानुवाच | संन्यासः कर्मयोगश्च निःश्रेयसकरौ उभौ | तयोस्तु कर्मसंन्यासात्कर्मयोगो विशिष्यते || 2 ||',
      'translation':
          'The Supreme Lord said: Both the renunciation of action (*sanyāsaḥ*) and the performance of action with devotion (*karma-yogaḥ*) lead to the supreme goal. But of the two, the Yoga of Action is superior to the mere renunciation of action.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; सन्न्यासः—renunciation; कर्मयोगः—the Yoga of action; च—and; निःश्रेयस-करौ—leading to the supreme good; उभौ—both; तयोः तु—but of those two; कर्म-सन्न्यासात्—than renunciation of action; कर्मयोगः—the Yoga of action; विशिष्यते—is superior.',
      'commentary':
          'Krishna endorses both paths but asserts the superiority of **Karma Yoga** for most seekers. While mental renunciation is the goal, external renunciation without internal purity is ineffective and difficult for the majority.',
    });

    // Verse 3: Defining the true Sanyāsī (one with detachment)
    await db.insert('chapter_5', {
      'verse_number': 3,
      'sanskrit':
          'ज्ञेयः स नित्यसंन्यासी यो न द्वेष्टि न काङ्क्षति | निर्द्वन्द्वो हि महाबाहो सुखं बन्धात्प्रमुच्यते || 3 ||',
      'translation':
          'One who neither hates nor desires should be known as a perpetual renunciate (*nitya-sanyāsī*). O mighty-armed, being free from dualities, such a person is easily liberated from bondage.',
      'word_meaning':
          'ज्ञेयः—is to be known; सः—he; नित्य-सन्न्यासी—the perpetual renunciate; यः—who; न द्वेष्टि—neither hates; न काङ्क्षति—nor desires; निर्द्वन्द्वः—free from dualities; हि—certainly; महाबाहो—O mighty-armed; सुखम्—easily; बन्धात्—from bondage; प्रमुच्यते—is completely liberated.',
      'commentary':
          'The true definition of a *Sanyāsī* is internal: freedom from **aversion** (*dveṣṭi*) and **craving** (*kāṅkṣati*). Such internal renunciation, achieved through *Karma Yoga*, is the effortless path to liberation.',
    });

    // Verse 4: The unity of Sānkhya and Yoga
    await db.insert('chapter_5', {
      'verse_number': 4,
      'sanskrit':
          'सांख्ययोगौ पृथग्बालाः प्रवदन्ति न पण्डिताः | एकमप्यास्थितः सम्यगुभयोर्विन्दते फलम् || 4 ||',
      'translation':
          'Only children (*bālāḥ*) speak of *Sānkhya* (renunciation) and *Yoga* (action) as being different, not the wise (*paṇḍitāḥ*). One who is truly established in either one obtains the result of both.',
      'word_meaning':
          'साङ्ख्य-योगौ—Sānkhya (renunciation) and Yoga (action); पृथक्—separate; बालाः—children/ignorant; प्रवदन्ति—speak; न पण्डिताः—not the wise; एकम्—one; अपि—even; आस्थितः—established; सम्यक्—properly; उभयोः—of both; विन्दते—obtains; फलम्—the result.',
      'commentary':
          'The difference is one of *practice* (lifestyle), not *goal*. When rightly performed, both lead to the same purification of the intellect and result in the same realization.',
    });

    // Verse 5: Attaining the same goal
    await db.insert('chapter_5', {
      'verse_number': 5,
      'sanskrit':
          'यत्सांख्यैः प्राप्यते स्थानं तद्योगैरापि गम्यते | एकं सांख्यं च योगं च यः पश्यति स पश्यति || 5 ||',
      'translation':
          'The supreme state that is attained by the followers of Sānkhya is also reached by the followers of Yoga. One who sees Sānkhya and Yoga as one truly sees the truth.',
      'word_meaning':
          'यत्—which; साङ्ख्यैः—by the followers of Sānkhya; प्राप्यते—is attained; स्थानम्—the goal/state; तत्—that; योगैः—by the followers of Yoga; अपि—also; गम्यते—is reached; एकम्—one; साङ्ख्यम्—Sānkhya; च—and; योगम्—Yoga; च—and; यः—who; पश्यति—sees; सः—he; पश्यति—truly sees.',
      'commentary':
          'Krishna confirms the **unity of goal** (Mokṣha). Whether one primarily focuses on knowledge (Sānkhya) or detached action (Yoga), the destination is the same supreme state.',
    });

    // Verse 6: Difficulty of mere external renunciation
    await db.insert('chapter_5', {
      'verse_number': 6,
      'sanskrit':
          'संन्यासस्तु महाबाहो दुःखमाप्तुमयोगतः | योगयुक्तो मुनिर्ब्रह्म नचिरेणाधिगच्छति || 6 ||',
      'translation':
          'Renunciation (*sanyāsaḥ*), O mighty-armed (Arjuna), is difficult to attain without the Yoga of Action. The sage (*muni*) established in *Yoga* quickly attains the Supreme.',
      'word_meaning':
          'सन्न्यासः—renunciation; तु—but; महाबाहो—O mighty-armed; दुःखम्—difficult; आप्तुम्—to attain; अयोगतः—without the path of Yoga (action); योग-युक्तः—established in Yoga; मुनिः—the sage; ब्रह्म—the Supreme; न चिरेण—without delay; अधिगच्छति—attains.',
      'commentary':
          'External renunciation without purifying the mind through selfless action (*Karma Yoga*) is extremely challenging. *Karma Yoga* acts as the necessary ladder, quickly making one fit for the final goal.',
    });

    // Verse 7: The qualities of the true Karma Yogi
    await db.insert('chapter_5', {
      'verse_number': 7,
      'sanskrit':
          'योगयुक्तो विशुद्धात्मा विजितात्मा जितेन्द्रियः | सर्वभूतात्मभूतात्मा कुर्वन्नपि न लिप्यते || 7 ||',
      'translation':
          'The Karma Yogi, whose mind is purified, who has conquered the mind and senses, and who sees the Self of all beings as his own Self, is never entangled by actions, even while acting.',
      'word_meaning':
          'योग-युक्तः—engaged in Yoga; विशुद्ध-आत्मा—of purified mind; विजित-आत्मा—who has conquered the lower self; जित-इन्द्रियः—who has conquered the senses; सर्व-भूत-आत्म-भूत-आत्मा—whose self is the Self of all beings; कुर्वन्—acting; अपि—even; न लिप्यते—is not tainted.',
      'commentary':
          'This describes the perfected Karma Yogi: they are internally pure, master of their mind, and see the unity of consciousness everywhere (*Sarva-bhūtātma-bhūtātmā*). Their external actions are thus spiritually harmless.',
    });

    // Verse 8: The non-doership attitude in daily activities (1/2)
    await db.insert('chapter_5', {
      'verse_number': 8,
      'sanskrit':
          'नैव किञ्चित्करोमीति युक्तो मन्येत तत्त्ववित् | पश्यन्शृण्वन्स्पृशञ्जिघ्रन्नश्नन्गच्छन्स्वपञ्श्वसन् || 8 ||',
      'translation':
          'The knower of truth, situated in Yoga, should think: "I am certainly not the doer of anything," even while seeing, hearing, touching, smelling, eating, moving, sleeping, and breathing.',
      'word_meaning':
          'न एव—not at all; किञ्चित्—anything; करोमि—I do; इति—thus; युक्तः—established in Yoga; मन्येत—should think; तत्त्व-वित्—the knower of truth; पश्यन्—seeing; शृण्वन्—hearing; स्पृशन्—touching; जिघ्रन्—smelling; अश्नन्—eating; गच्छन्—moving; स्वपन्—sleeping; श्वसन्—breathing.',
      'commentary':
          'The essence of mental renunciation. The enlightened mind disassociates the *Self* from the automatic functions of the body and senses. The true "I" is the detached observer, not the doer.',
    });

    // Verse 9: The non-doership attitude in daily activities (2/2)
    await db.insert('chapter_5', {
      'verse_number': 9,
      'sanskrit':
          'प्रलपन्विसृजन्गृह्णन्नुन्मिषन्निमिषन्नपि | इन्द्रियाणीन्द्रियार्थेषु वर्तन्त इति धारयन् || 9 ||',
      'translation':
          'And also while speaking, releasing, grasping, and opening or closing the eyes, the Yogi holds the conviction that it is only the senses that are engaging with their objects.',
      'word_meaning':
          'प्रलपन्—speaking; विसृजन्—releasing/excreting; गृह्णन्—grasping; उन्मिषन्—opening the eyes; निमिषन्—closing the eyes; अपि—even; इन्द्रियाणि—the senses; इन्द्रिय-अर्थेषु—in the sense objects; वर्तन्ते—are engaging; इति—thus; धारयन्—holding the conviction.',
      'commentary':
          'The non-doership attitude is applied to complex motor and physiological actions. By separating the Self from the senses, the Yogi is a detached witness to the natural interaction between matter and matter.',
    });

    // Verse 10: The analogy of the lotus leaf (Freedom from sin)
    await db.insert('chapter_5', {
      'verse_number': 10,
      'sanskrit':
          'ब्रह्मण्याधाय कर्माणि सङ्गं त्यक्त्वा करोति यः | लिप्यते न स पापेन पद्मपत्रमिवाम्भसा || 10 ||',
      'translation':
          'One who performs actions, dedicating them to the Supreme (*Brahman*) and relinquishing all attachment, remains untouched by sin, just as a lotus leaf is untouched by water.',
      'word_meaning':
          'ब्रह्मणि—unto Brahman (the Supreme); आधाय—dedicating; कर्माणि—actions; सङ्गम्—attachment; त्यक्त्वा—having abandoned; करोति—performs; यः—who; लिप्यते—is affected/smeared; न सः—he is not; पापेन—by sin; पद्म-पत्रम्—a lotus leaf; इव—like; अम्भसा—by water.',
      'commentary':
          'The core message of *Karma Yoga*. By dedicating all work to the Supreme Being and eliminating self-interest, the individual uses the *material* medium (action) to achieve *spiritual* liberation, just as the lotus leaf stays dry while being in the water.',
    });

    // Verse 11: Action without attachment for purification
    await db.insert('chapter_5', {
      'verse_number': 11,
      'sanskrit':
          'कायेन मनसा बुद्ध्या केवलैरिन्द्रियैरपि | योगिनः कर्म कुर्वन्ति सङ्गं त्यक्त्वात्मशुद्धये || 11 ||',
      'translation':
          'The Yogis perform action only with the body, mind, intellect, and even the senses, abandoning attachment, purely for the purification of the Self.',
      'word_meaning':
          'कायेन—with the body; मनसा—with the mind; बुद्ध्या—with the intellect; केवलैः—only; इन्द्रियैः—with the senses; अपि—even; योगिनः—Yogis; कर्म—action; कुर्वन्ति—perform; सङ्गम्—attachment; त्यक्त्वा—having abandoned; आत्म-शुद्धये—for the purification of the Self.',
      'commentary':
          'This verse explains the **method and motive** of the Karma Yogi. They use all instruments—physical, mental, and intellectual—to perform their duties, but the sole purpose is to cleanse the mind (*ātma-śhuddhaye*), not to gain a personal reward.',
    });

    // Verse 12: The difference between the detached and the attached performer
    await db.insert('chapter_5', {
      'verse_number': 12,
      'sanskrit':
          'युक्तः कर्मफलं त्यक्त्वा शान्तिमाप्नोति नैष्ठिकीम् | अयुक्तः कामकारेण फले सक्तो निबध्यते || 12 ||',
      'translation':
          'The Karma Yogi (*yuktaḥ*), having abandoned the fruits of action, attains **steadfast peace**; the non-Yogi (*ayuktaḥ*), driven by desire, remains attached to the fruit and becomes bound.',
      'word_meaning':
          'युक्तः—the devotee, established in Yoga; कर्म-फलम्—the result of action; त्यक्त्वा—having abandoned; शान्तिम्—peace; आप्नोति—attains; नैष्ठिकीम्—steadfast, permanent; अयुक्तः—the non-Yogi; काम-कारेण—by the impulsion of desire; फले—to the results; सक्तः—attached; निबध्यते—becomes bound.',
      'commentary':
          'This contrasts the two results of action. The detached person achieves **Mokṣha** (liberation), which brings *naiṣṭhikīm śhāntim* (firm peace). The attached person remains tied to the cycle of rebirth (*saṁsāra*) due to their desire for results.',
    });

    // Verse 13: The body as a city with nine gates (The true Sanyāsī's state)
    await db.insert('chapter_5', {
      'verse_number': 13,
      'sanskrit':
          'सर्वकर्माणि मनसा संन्यस्यास्ते सुखं वशी | नवद्वारे पुरे देही नैव कुर्वन्न कारयन् || 13 ||',
      'translation':
          'The embodied soul (*dehī*), having mentally renounced all actions, rests happily as the master in the city of nine gates (the body), neither acting nor causing action.',
      'word_meaning':
          'सर्व-कर्माणि—all actions; मनसा—mentally; सन्न्यस्य—having renounced; आस्ते—sits; सुखम्—happily; वशी—the controller; नव-द्वारे—in the nine-gated; पुरे—city; देही—the embodied soul; न एव—not at all; कुर्वन्—doing; न कारयन्—nor causing to do.',
      'commentary':
          'The **nine gates** are the two eyes, two ears, two nostrils, mouth, and the two outlets (anus and urinary opening). The enlightened soul resides in the body as a **detached owner** in a house, recognizing that all physical and mental activities belong to Prakriti (material nature), not the Self.',
    });

    // Verse 14: The Lord is not the doer
    await db.insert('chapter_5', {
      'verse_number': 14,
      'sanskrit':
          'न कर्तृत्वं न कर्माणि लोकस्य सृजति प्रभुः | न कर्मफलसंयोगं स्वभावस्तु प्रवर्तते || 14 ||',
      'translation':
          'The Lord of the World (*Prabhuḥ*) does not create the sense of doership (*kartṛtva*), nor the actions (*karmāṇi*), nor the union with the fruits of action; it is **material nature** (*svabhāvas*) that operates.',
      'word_meaning':
          'न—neither; कर्तृत्वम्—the sense of doership; न—nor; कर्माणि—actions; लोकस्य—of the world; सृजति—creates; प्रभुः—the soul (or the Lord); न—nor; कर्म-फल-संयोगम्—the connection with the fruit of action; स्वभावः—one’s own nature (material nature); तु—but; प्रवर्तते—acts.',
      'commentary':
          'The Supreme Lord is neutral and does not interfere with the law of karma. The process of action, doership, and enjoyment is entirely managed by **Prakriti** (Nature) and the individual’s inherent qualities (*guṇas*).',
    });

    // Verse 15: The Lord does not accept sin or merit
    await db.insert('chapter_5', {
      'verse_number': 15,
      'sanskrit':
          'नादत्ते कस्यचित्पापं न चैव सुकृतं विभुः | अज्ञानेनावृतं ज्ञानं तेन मुह्यन्ति जन्तवः || 15 ||',
      'translation':
          'The Omnipresent Lord (*Vibhuḥ*) does not accept the sin (*pāpaṁ*) or the merit (*sukṛtaṁ*) of anyone. Knowledge is covered by **ignorance** (*ajñānena*); hence, the living beings are deluded.',
      'word_meaning':
          'न—not; आदत्ते—accepts; कस्यचित्—of anyone; पापम्—sin; न—nor; च एव—also; सुकृतम्—merit; विभुः—the Lord; अज्ञानेन—by ignorance; आवृतम्—is covered; ज्ञानम्—knowledge; तेन—by that; मुह्यन्ति—are deluded; जन्तवः—the living beings.',
      'commentary':
          'The Lord is the detached source of consciousness, like the sun, which is not responsible for the good or bad events happening on Earth. It is *ajñāna* (ignorance) that makes a person falsely identify with the body and feel they are the one committing sin or merit.',
    });

    // Verse 16: Knowledge destroys ignorance
    await db.insert('chapter_5', {
      'verse_number': 16,
      'sanskrit':
          'ज्ञानेन तु तदज्ञानं येषां नाशितमात्मनः | तेषामादित्यवज्ज्ञानं प्रकाशयति तत्परम् || 16 ||',
      'translation':
          'But for those whose **ignorance is destroyed** by knowledge of the Self, their knowledge, shining like the sun, reveals the Supreme Reality.',
      'word_meaning':
          'ज्ञानेन—by knowledge; तु—but; तत्—that; अज्ञानम्—ignorance; येषाम्—whose; नाशितम्—is destroyed; आत्मनः—of the self; तेषाम्—their; आदित्य-वत्—like the sun; ज्ञानम्—knowledge; प्रकाशयति—illuminates; तत् परम्—the Supreme Reality.',
      'commentary':
          'When the darkness of ignorance is dispelled by the light of Self-knowledge, the true nature of the Absolute (Brahman) is revealed instantly. The Self is always luminous; ignorance only *appears* to cover it.',
    });

    // Verse 17: The characteristics of the enlightened
    await db.insert('chapter_5', {
      'verse_number': 17,
      'sanskrit':
          'तद्बुद्धयस्तदात्मानस्तन्निष्ठास्तत्परायणाः | गच्छन्त्यपुनरावृत्तिं ज्ञाननिर्धूतकल्मषाः || 17 ||',
      'translation':
          'Those whose **intellect is absorbed in That** (*tad-buddhayaḥ*), whose self is That, who are established in That, and who make That their supreme goal, attain liberation from rebirth, their sins having been purified by knowledge.',
      'word_meaning':
          'तत्-बुद्धयः—whose intellect is fixed on That (Brahman); तत्-आत्मानः—whose self is That; तत्-निष्ठाः—who are established in That; तत्-परायणाः—who make That their supreme goal; गच्छन्ति—they attain; अपुनरावृत्तिम्—non-return (Mokṣha); ज्ञान-निर्धूत-कल्मषाः—whose impurities have been cleansed by knowledge.',
      'commentary':
          'This describes the state of **Jñāna-niṣṭha** (firm establishment in knowledge). When the mind is single-pointedly fixed on the Supreme Reality, all past karmic reactions (*kalmaṣāḥ*) are dissolved, leading to *apunarāvrtti* (freedom from the cycle of birth and death).',
    });

    // Verse 18: The vision of equality (Sama-darśanam)
    await db.insert('chapter_5', {
      'verse_number': 18,
      'sanskrit':
          'विद्याविनयसम्पन्ने ब्राह्मणे गवि हस्तिनि | शुनि चैव श्वपाके च पण्डिताः समदर्शिनः || 18 ||',
      'translation':
          'The wise (*paṇḍitāḥ*), endowed with knowledge and humility, see with equal vision a learned and humble **Brāhmaṇa**, a **cow**, an **elephant**, a **dog**, and a **dog-eater** (outcaste).',
      'word_meaning':
          'विद्या-विनय-सम्पन्ने—endowed with learning and humility; ब्राह्मणे—in a Brāhmaṇa; गवि—in a cow; हस्तिनि—in an elephant; शुनि—in a dog; च एव—and also; श्व-पाके—in a dog-eater (outcaste); च—and; पण्डिताः—the wise; सम-दर्शिनः—see with equal vision.',
      'commentary':
          'The wise person sees the **same single Self** (*Ātman*) residing within all beings, regardless of their external form, social status, or level of intelligence. This is the **sama-darśanam** (vision of equality), which transcends all material differences.',
    });

    // Verse 19: The result of the equal vision
    await db.insert('chapter_5', {
      'verse_number': 19,
      'sanskrit':
          'इहैव तैर्जितः सर्गो येषां साम्ये स्थितं मनः | निर्दोषं हि समं ब्रह्म तस्माद्ब्रह्मणि ते स्थिताः || 19 ||',
      'translation':
          'Those whose minds are fixed in **equality** have already conquered rebirth in this very life. Since the Supreme is flawless and equal (*samaṁ*), they are indeed established in Brahman.',
      'word_meaning':
          'इह एव—in this very life; तैः—by them; जितः—is conquered; सर्गः—the cycle of birth and death; येषाम्—whose; साम्ये—in equality; स्थितम्—fixed; मनः—mind; निर्दोषम्—flawless; हि—certainly; समम्—equal; ब्रह्म—the Supreme; तस्मात्—therefore; ब्रह्मणि—in Brahman; ते—they; स्थिताः—are established.',
      'commentary':
          'Equality is the nature of the Supreme Reality (Brahman). By making their mind equal-minded, the Yogi achieves the qualities of Brahman, effectively ending their entanglement with the material world while still embodied. This is **Jīvanmukti** (liberation while living).',
    });

    // Verse 20: The characteristics of the stable mind
    await db.insert('chapter_5', {
      'verse_number': 20,
      'sanskrit':
          'न प्रहृष्येत्प्रियं प्राप्य नोद्विजेत्प्राप्य चाप्रियम् | स्थिरबुद्धिरसम्मूढो ब्रह्मविद्ब्रह्मणि स्थितः || 20 ||',
      'translation':
          'One who is **established in Brahman** (*brahma-vit*), with a stable intellect and free from delusion, neither rejoices upon obtaining what is pleasant nor is distressed upon encountering what is unpleasant.',
      'word_meaning':
          'न प्रहृष्येत्—should not rejoice; प्रियम्—the pleasant; प्राप्य—having obtained; न उद्विजेत्—nor be distressed; प्राप्य—having encountered; च—and; अप्रियम्—the unpleasant; स्थिर-बुद्धिः—whose intellect is steady; असम्मूढः—undeluded; ब्रह्म-वित्—the knower of Brahman; ब्रह्मणि—in Brahman; स्थितः—is established.',
      'commentary':
          'This describes the practical application of equality. The enlightened person maintains a balanced state of mind (*sthirabuddhiḥ*) in all dualities of life (pleasure/pain, honor/dishonor) because they are anchored in the changeless reality of Brahman, not the temporary world.',
    });

    // Verse 21: Realizing internal, unending bliss
    await db.insert('chapter_5', {
      'verse_number': 21,
      'sanskrit':
          'बाह्यस्पर्शेष्वसक्तात्मा विन्दत्यात्मनि यत्सुखम् | स ब्रह्मयोगयुक्तात्मा सुखमक्षयमश्नुते || 21 ||',
      'translation':
          'One whose mind is unattached to external sense contacts finds happiness in the Self. With the mind engaged in meditation on Brahman (*Brahma-yoga*), that person experiences unending happiness.',
      'word_meaning':
          'बाह्य-स्पर्शेषु—in external sense contacts; असक्त-आत्मा—one whose mind is unattached; विन्दति—finds; आत्मनि—in the Self; यत्—which; सुखम्—happiness; सः—he; ब्रह्म-योग-युक्त-आत्मा—whose mind is united with Brahman (God) through Yoga; सुखम्—happiness; अक्षयम्—unending/imperishable; अश्नुते—enjoys/experiences.',
      'commentary':
          'This contrasts the fleeting nature of worldly pleasure with the **Akṣhayam Sukham** (unending happiness) derived from the Self. True joy is found internally when the mind is fixed on Brahman.',
    });

    // Verse 22: Sense pleasures are sources of misery
    await db.insert('chapter_5', {
      'verse_number': 22,
      'sanskrit':
          'ये हि संस्पर्शजा भोगा दुःखयोनय एव ते | आद्यन्तवन्तः कौन्तेय न तेषु रमते बुधः || 22 ||',
      'translation':
          'Pleasures born of the contact of the senses with their objects are certainly sources of misery. O son of Kuntī, they have a beginning and an end; the wise person does not delight in them.',
      'word_meaning':
          'ये हि—which certainly; संस्पर्श-जाः—born of sense contact; भोगाः—enjoyments; दुःख-योनयः—sources of misery; एव ते—certainly they; आदि-अन्त-वन्तः—having a beginning and an end; कौन्तेय—O son of Kuntī; न तेषु—not in them; रमते—delights; बुधः—the wise person.',
      'commentary':
          'All material pleasures have two flaws: they are temporary (*ādi-anta-vantaḥ*) and they inevitably lead to pain and misery (*duḥkha-yonayaḥ*). Knowing this, the enlightened person automatically develops dispassion.',
    });

    // Verse 23: The measure of a true Yogi in this life
    await db.insert('chapter_5', {
      'verse_number': 23,
      'sanskrit':
          'शक्नोतीहैव यः सोढुं प्राक्शरीरविमोक्षणात् | कामक्रोधोद्भवं वेगं स युक्तः स सुखी नरः || 23 ||',
      'translation':
          'One who is able to tolerate the urges born of desire (*kāma*) and anger (*krodha*) in this very life, before giving up the body, is a Yogi and a truly happy person.',
      'word_meaning':
          'शक्नोति—is able; इह एव—in this very life; यः—who; सोढुम्—to tolerate; प्राक्—before; शरीर-विमोक्षणात्—the giving up of the body; काम-क्रोध-उद्भवम्—born of desire and anger; वेगम्—the urge/impetus; सः—that person; युक्तः—a Yogi; सः—that; सुखी—happy; नरः—man.',
      'commentary':
          'The ultimate test of spiritual realization is controlling the urgent, powerful forces of **Kāma** (lust/desire) and **Krodha** (anger). Victory over these internal urges is the mark of a happy and liberated soul while living (*jīvanmukta*).',
    });

    // Verse 24: Internal happiness leads to Brahman
    await db.insert('chapter_5', {
      'verse_number': 24,
      'sanskrit':
          'योऽन्तःसुखोऽन्तरारामस्तथान्तर्ज्योतिरेव यः | स योगी ब्रह्मनिर्वाणं ब्रह्मभूतोऽधिगच्छति || 24 ||',
      'translation':
          'One whose happiness is internal (*antaḥ-sukho*), who is active within, who rejoices within, and who is illumined within—that Yogi, being united with Brahman, attains liberation (*Brahmanirvāṇaṁ*).',
      'word_meaning':
          'यः—who; अन्तः-सुखः—whose happiness is within; अन्तर-आरामः—who enjoys within; तथा—and; अन्तः-ज्योतिः—whose light is internal; एव यः—certainly who; सः योगी—that Yogi; ब्रह्म-निर्वाणम्—absorption in Brahman; ब्रह्म-भूतः—having become Brahman; अधिगच्छति—attains.',
      'commentary':
          'This describes the perfected state. The Yogi shifts all faculties—joy, activity, and light—from the external world to the inner Self, effortlessly attaining liberation (*Brahmanirvāṇaṁ*).',
    });

    // Verse 25: The characteristics of the liberated sage
    await db.insert('chapter_5', {
      'verse_number': 25,
      'sanskrit':
          'लभन्ते ब्रह्मनिर्वाणमृषयः क्षीणकल्मषाः | छिन्नद्वैधा यतात्मानः सर्वभूतहिते रताः || 25 ||',
      'translation':
          'The sages (*ṛṣhayaḥ*) whose sins have been destroyed, whose doubts are cleared, who are disciplined in mind, and who are engaged in the welfare of all beings (*sarva-bhūta-hite*), attain liberation in Brahman.',
      'word_meaning':
          'लभन्ते—they attain; ब्रह्म-निर्वाणम्—absorption in Brahman; ऋषयः—sages; क्षीण-कल्मषाः—whose sins are destroyed; छिन्न-द्वैधाः—whose duality is cut; यत-आत्मानः—who are disciplined; सर्व-भूत-हिते—in the welfare of all beings; रताः—delighting.',
      'commentary':
          'The true sage is characterized by four traits: freedom from sin, freedom from doubt, self-control, and **compassionate action** (*Sarva-bhūta-hite ratāḥ*). This highlights that liberation does not preclude ethical service.',
    });

    // Verse 26: Assured liberation for ascetics
    await db.insert('chapter_5', {
      'verse_number': 26,
      'sanskrit':
          'कामक्रोधवियुक्तानां यतीनां यतचेतसाम् | अभितो ब्रह्मनिर्वाणं वर्तते विदितात्मनाम् || 26 ||',
      'translation':
          'Liberation in Brahman is very near for those ascetics (*yatīnāṁ*) who are free from desire and anger, who have controlled their minds, and who are self-realized.',
      'word_meaning':
          'काम-क्रोध-वियुक्तानाम्—of those free from desire and anger; यतीनाम्—of the ascetics; यत-चेतसाम्—of those whose minds are controlled; अभितः—near/around; ब्रह्म-निर्वाणम्—absorption in Brahman; वर्तते—exists; विदित-आत्मनाम्—of those who are self-realized.',
      'commentary':
          'This assures the dedicated ascetic (monk) that their path is swift. Since their obstacles (Kāma and Krodha) are removed and their goal is known (Self-realization), liberation is virtually guaranteed.',
    });

    // Verse 27: Introduction to the practice of meditation (1/3)
    await db.insert('chapter_5', {
      'verse_number': 27,
      'sanskrit':
          'स्पर्शान्कृत्वा बहिर्बाह्यांश्चक्षुश्चैवान्तरे भ्रुवोः | प्राणापानौ समौ कृत्वा नासाभ्यन्तरचारिणौ || 27 ||',
      'translation':
          'By shutting out all external sense objects, fixing the gaze between the eyebrows, and making the incoming and outgoing breaths equal as they move within the nostrils,',
      'word_meaning':
          'स्पर्शान्—sense objects; कृत्वा—having kept; बहिः—outside; बाह्यान्—external; चक्षुः—gaze/eyes; च एव—and certainly; अन्तरे—between; भ्रुवोः—the eyebrows; प्राण-अपानौ—the outgoing and incoming breaths; समौ—equal; कृत्वा—having made; नासा-अभ्यन्तर-चारिणौ—moving within the nostrils.',
      'commentary':
          'Krishna briefly describes the core mechanics of *Yoga* meditation: 1) **Pratyāhāra** (withdrawal of senses), 2) **Dhāraṇā** (fixing the gaze/concentration), and 3) **Prāṇāyāma** (breath control).',
    });

    // Verse 28: Introduction to the practice of meditation (2/3)
    await db.insert('chapter_5', {
      'verse_number': 28,
      'sanskrit':
          'यत इन्द्रियमनोबुद्धिर्मुनिर्मोक्षपरायणः | विगतेच्छाभयक्रोधो यः सदा मुक्त एव सः || 28 ||',
      'translation':
          'The sage (*muni*), who controls the senses, mind, and intellect, and has liberation as the supreme goal, being free from desire, fear, and anger, is eternally liberated.',
      'word_meaning':
          'यत-इन्द्रिय-मनो-बुद्धिः—who has controlled the senses, mind, and intellect; मुनिः—the sage; मोक्ष-परायणः—whose supreme goal is liberation; विगत-इच्छा-भय-क्रोधः—free from desire, fear, and anger; यः—who; सदा—always; मुक्तः—liberated; एव सः—certainly he.',
      'commentary':
          'This describes the attitude during meditation: the inner instruments must be controlled, and the motive must be solely liberation (*Mokṣha*). Such a person achieves the status of being eternally liberated (*sadā mukta eva saḥ*).',
    });

    // Verse 29: The concluding knowledge (The Object of Meditation)
    await db.insert('chapter_5', {
      'verse_number': 29,
      'sanskrit':
          'भोक्तारं यज्ञतपसां सर्वलोकमहेश्वरम् | सुहृदं सर्वभूतानां ज्ञात्वा मां शान्तिमृच्छति || 29 ||',
      'translation':
          'Knowing Me as the **Supreme Enjoyer** (*Bhoktāraṁ*) of all sacrifices and austerities, the **Great Lord** (*Maheśhvaram*) of all worlds, and the **Friend** (*Suhṛdaṁ*) of all living beings, the sage attains peace.',
      'word_meaning':
          'भोक्तारम्—the enjoyer/recipient; यज्ञ-तपसाम्—of sacrifices and austerities; सर्व-लोक-महेश्वरम्—the Great Lord of all worlds; सुहृदम्—the friend; सर्व-भूतानाम्—of all living beings; ज्ञात्वा—having known; माम्—Me; शान्तिम्—peace; ऋच्छति—attains.',
      'commentary':
          'This is the final, ultimate knowledge (*Jñāna*) of the chapter: realization of the three roles of the Supreme Lord (Krishna) as the **Recipient of action**, the **Controller of the cosmos**, and the **Impartial Friend**. This knowledge destroys delusion and leads to permanent peace.',
    });
  }

  Future<void> insertChapter6Verses(Database db) async {
    // Verse 1: The true Sannyāsī (Renunciate) and Yogi
    await db.insert('chapter_6', {
      'verse_number': 1,
      'sanskrit':
          'श्रीभगवानुवाच | अनाश्रितः कर्मफलं कार्यं कर्म करोति यः | स संन्यासी च योगी च न निरग्निर्न चाक्रियः || 1 ||',
      'translation':
          'The Supreme Lord said: He who performs the obligatory duty (*kāryaṁ karma*) without depending on the fruits of action is a Sannyāsī and a Yogi—not he who merely abandons the fire sacrifice (*niragni*) or refrains from action (*akriyaḥ*).',
      'word_meaning':
          'अनाश्रितः—without taking shelter of/not depending on; कर्म-फलम्—the fruit of action; कार्यम्—obligatory; कर्म—action; स सन्न्यासी च योगी च—he is a Sannyāsi and a Yogi; न निरग्निः न च अक्रियः—not one who has given up the fire sacrifice, nor one who does no work.',
      'commentary':
          'Krishna begins by redefining the **Sannyāsī** and **Yogi**. True renunciation is internal (detachment from results), not external (abandonment of duties). The detached worker is the true sage.',
    });

    // Verse 2: The unity of Sannyāsa and Yoga
    await db.insert('chapter_6', {
      'verse_number': 2,
      'sanskrit':
          'यं सन्न्यासमिति प्राहुर्योगं तं विद्धि पाण्डव | न ह्यसन्न्यस्तसङ्कल्पो योगी भवति कश्चन || 2 ||',
      'translation':
          'O son of Pāṇḍu, know that which is called Sannyāsa (renunciation) to be non-different from Yoga, for no one becomes a Yogi without renouncing worldly desires (*saṅkalpa*).',
      'word_meaning':
          'यं सन्न्यासम्—that which is renunciation; योगम् तं विद्धि—know that to be Yoga; न हि—for certainly not; असन्न्यस्त-सङ्कल्पः—one who has not renounced desires/intentions; योगी भवति कश्चन—anyone becomes a Yogi.',
      'commentary':
          'The fundamental requirement for both paths is the internal renunciation of egoistic desires and mental resolutions (*saṅkalpa*). The paths are different in method but identical in principle.',
    });

    // Verse 3: Action and Tranquility as means to the same goal
    await db.insert('chapter_6', {
      'verse_number': 3,
      'sanskrit':
          'आरुरुक्षोर्मुनेर्योगं कर्म कारणमुच्यते | योगारूढस्य तस्यैव शमः कारणमुच्यते || 3 ||',
      'translation':
          'For the aspirant (*ārurukṣhu*) who wishes to ascend to Yoga, action without attachment is said to be the means. For the sage who has already attained Yoga (*yogārūḍha*), tranquility (*śamaḥ*) in meditation is said to be the means.',
      'word_meaning':
          'आरुरुक्षोः—of the aspirant; योगम् कर्म कारणम्—action is the means for Yoga; योग-आरूढस्य तस्य एव—for that very person who has attained Yoga; शमः कारणम्—tranquility/cessation of action is the means.',
      'commentary':
          'This defines the two stages of the Yogi: The beginner (*Ārurukṣhu*) uses selfless **action** (*karma*) for purification. The advanced sage (*Yogārūḍha*) uses **tranquility** (*śamaḥ*) for realization.',
    });

    // Verse 4: Definition of one elevated in Yoga
    await db.insert('chapter_6', {
      'verse_number': 4,
      'sanskrit':
          'यदा हि नेन्द्रियार्थेषु न कर्मस्वनुषज्जते | सर्वसङ्कल्पसन्न्यासी योगारूढस्तदोच्यते || 4 ||',
      'translation':
          'When one is neither attached to sense objects nor to actions, having renounced all desires/intentions (*sarva-saṅkalpa-sannyāsī*), he is then said to be elevated in Yoga.',
      'word_meaning':
          'यदा हि न—when certainly not; इन्द्रिय-अर्थेषु—to sense objects; न कर्मसु—nor to actions; अनुषज्जते—is attached; सर्व-सङ्कल्प-सन्न्यासी—one who has completely renounced desires; योगारूढः तदा उच्यते—then he is called elevated in Yoga.',
      'commentary':
          'The state of the *Yogārūḍha* is marked by non-attachment not just to results, but to the objects and activities themselves, indicating complete internal freedom.',
    });

    // Verse 5: Elevate the self by the self (Mind as friend or enemy)
    await db.insert('chapter_6', {
      'verse_number': 5,
      'sanskrit':
          'उद्धरेदात्मनात्मानं नात्मानमवसादयेत् | आत्मैव ह्यात्मनो बन्धुरात्मैव रिपुरात्मनः || 5 ||',
      'translation':
          'One must uplift the self by the self, and must not degrade the self; for the mind is certainly the friend of the Self, and the mind is also the enemy of the Self.',
      'word_meaning':
          'उद्धरेत्—one must uplift; आत्मना आत्मानम्—the self by the self (mind by the mind); न अवसादयेत्—should not degrade; आत्मा एव हि बन्धुः—the mind is certainly the friend; आत्मा एव रिपुः—the mind is also the enemy.',
      'commentary':
          'This powerful verse highlights the critical role of **self-effort** and **willpower**. The mind (*ātmā*) is the sole agent for either bondage or liberation, depending on whether it is controlled or uncontrolled.',
    });

    // Verse 6: Conquering the mind
    await db.insert('chapter_6', {
      'verse_number': 6,
      'sanskrit':
          'बन्धुरात्मात्मनस्तस्य येनात्मैवात्मना जितः | अनात्मनस्तु शत्रुत्वे वर्तेतात्मैव शत्रुवत् || 6 ||',
      'translation':
          'For him who has conquered the mind, it is the best of friends. But for one who has failed to control the mind, the mind remains hostile, acting as an enemy.',
      'word_meaning':
          'बन्धुः आत्मा आत्मनः—the mind is the friend of the self; येन आत्मा एव आत्मना जितः—by whom the mind itself is conquered by the self; अनात्मनः तु—but for one who has not conquered the mind; शत्रुत्वे वर्तेत—acts as an enemy; आत्मा एव शत्रु-वत्—the mind alone acts like an enemy.',
      'commentary':
          'The controlled mind acts as a spiritual guide, while the uncontrolled mind is the source of all afflictions and pulls one toward sense-gratification and ruin.',
    });

    // Verse 7: The result of mental conquest (Equanimity)
    await db.insert('chapter_6', {
      'verse_number': 7,
      'sanskrit':
          'जितात्मनः प्रशान्तस्य परमात्मा समाहितः | शीतोष्णसुखदुःखेषु तथा मानापमानयोः || 7 ||',
      'translation':
          'When one has conquered the mind and attained perfect peace, their consciousness is steadily established amidst all dualities: cold and heat, pleasure and pain, as well as honor and dishonor.',
      'word_meaning':
          'जित-आत्मनः—of one who has conquered the mind; प्रशान्तस्य—of one who is perfectly peaceful; परमात्मा समाहितः—the Supreme Self remains fully concentrated; शीतोष्ण-सुख-दुःखेषु—in cold, heat, happiness, and distress; तथा मान-अपमानयोः—as well as in honor and dishonor.',
      'commentary':
          'The reward of conquering the mind is immediate: **inner peace** (*praśāntasya*). This peace enables the Yogi to maintain the spiritual vision of equality (*sama*) in all conditions and dualities.',
    });

    // Verse 8: The characteristics of the steady Yogi
    await db.insert('chapter_6', {
      'verse_number': 8,
      'sanskrit':
          'ज्ञानविज्ञानतृप्तात्मा कूटस्थो विजितेन्द्रियः | युक्त इत्युच्यते योगी समलोष्टाश्मकाञ्चनः || 8 ||',
      'translation':
          'The Yogi whose self is satisfied by theoretical knowledge (*jñāna*) and realized knowledge (*vijñāna*), who is immutable and has conquered the senses, is called **Yukta** (established in Yoga), viewing clods of dirt, stones, and gold as equal.',
      'word_meaning':
          'ज्ञान-विज्ञान-तृप्त-आत्मा—whose self is satisfied by theoretical and realized knowledge; कूटस्थः—unshakable/immutable; विजित-इन्द्रियः—one who has conquered the senses; युक्तः इति उच्यते—is called Yukta (established in Yoga); सम-लोष्ट्र-अश्म-काञ्चनः—one who regards dirt, stone, and gold as equal.',
      'commentary':
          'The true Yogi is internally fulfilled (*tṛptātmā*) and externally detached. Their equal vision (*sama-darśana*) is based on the spiritual realization that all material objects are temporary, regardless of their perceived value.',
    });

    // Verse 9: Equanimity towards all beings
    await db.insert('chapter_6', {
      'verse_number': 9,
      'sanskrit':
          'सुहृन्मित्रार्युदासीनमध्यस्थद्वेष्यबन्धुषु | साधुष्वपि च पापेषु समबुद्धिर्विशिष्यते || 9 ||',
      'translation':
          'He is superior who is of equal mind towards well-wishers, friends, enemies, neutrals, arbiters, the objects of hatred, relatives, as well as the righteous (*sādhu*) and the unrighteous (sinner).',
      'word_meaning':
          'सुहृत्—well-wisher; मित्र—friend; अरि—enemy; उदासीन—neutral; मध्यस्थ—arbiter; द्वेष्य—object of hatred; बन्धुषु—relatives; साधुषु अपि च पापेषु—and also the righteous and the sinners; सम-बुद्धिः विशिष्यते—is superior due to equal-mindedness.',
      'commentary':
          'The highest spiritual test is ethical and social. The Yogi maintains an impartial, equal consciousness (*sama-buddhi*) toward all people, based on seeing the same divine Self residing within every being.',
    });

    // Verse 10: The necessity of solitude and discipline for Dhyāna Yoga
    await db.insert('chapter_6', {
      'verse_number': 10,
      'sanskrit':
          'योगी युञ्जीत सततमात्मानं रहसि स्थितः | एकाकी यतचित्तात्मा निराशिरपरिग्रहः || 10 ||',
      'translation':
          'The Yogi should constantly engage the mind in meditation, remaining in seclusion (*rahasi*) and alone, with a controlled mind and body, free from desires, and without possessions.',
      'word_meaning':
          'योगी युञ्जीत सततम्—the Yogi should constantly concentrate; आत्मानम्—the mind/self; रहसि स्थितः एकाकी—remaining in a solitary place, alone; यत-चित्त-आत्मा—with controlled mind and body; निराशिरपरिग्रहः—free from desires and without possessions.',
      'commentary':
          'This introduces the strict practical requirements for *Dhyāna Yoga* (meditation). Solitude, freedom from desires (*nirāśīḥ*), and control over the mind/body are foundational steps for the inner practice.',
    });

    // Verse 11: Setting the place and seat for meditation
    await db.insert('chapter_6', {
      'verse_number': 11,
      'sanskrit':
          'शुचौ देशे प्रतिष्ठाप्य स्थिरमासनमात्मनः | नात्युच्छ्रितं नातिनीचं चैलाजिनकुशोत्तरम् || 11 ||',
      'translation':
          'In a clean place, one should establish a stable seat for oneself, neither too high nor too low, covered successively with cloth, deerskin, and Kuśa grass.',
      'word_meaning':
          'शुचौ देशे—in a clean place; प्रतिष्ठाप्य—having established; स्थिरम्—stable; आसनम्—seat; आत्मनः—one’s own; न अति-उच्छ्रितम्—not too high; न अति-नीचम्—nor too low; चैल-अजिन-कुश-उत्तरम्—covered with cloth, deerskin, and Kuśa grass.',
      'commentary':
          'Krishna gives minute instructions on the physical setting. The purity of the environment and the stability of the posture (*āsana*) are necessary to minimize physical distractions and support mental calmness.',
    });

    // Verse 12: Fixing the mind for purification
    await db.insert('chapter_6', {
      'verse_number': 12,
      'sanskrit':
          'तत्रैकाग्रं मनः कृत्वा यतचित्तेन्द्रियक्रियः | उपविश्यासने युञ्ज्याद्योगमात्मविशुद्धये || 12 ||',
      'translation':
          'Being seated there, having made the mind single-pointed, and controlling the actions of the mind and senses, one should practice Yoga for the purification of the heart.',
      'word_meaning':
          'तत्र—there; एकाग्रम्—single-pointed; मनः—mind; कृत्वा—having made; यत-चित्त-इन्द्रिय-क्रियः—controlling the activities of the mind and senses; उपविश्य—sitting; आसने—on the seat; युञ्ज्यात्—should practice; योगम्—Yoga; आत्म-विशुद्धये—for self-purification.',
      'commentary':
          'The purpose of the physical preparations is established: to achieve **Eka-āgram** (single-pointedness) of the mind and senses, which is the direct means for inner purification (*ātma-viśhuddhaye*).',
    });

    // Verse 13: Maintaining the proper posture
    await db.insert('chapter_6', {
      'verse_number': 13,
      'sanskrit':
          'समं कायशिरोग्रीवं धारयन्नचलं स्थिरः | सम्पश्यन्नासिकाग्रं स्वं दिशश्चानवलोकयन् || 13 ||',
      'translation':
          'Holding the body, head, and neck straight, motionless, and steady, fixing the gaze at the tip of the nose, without looking around in any direction,',
      'word_meaning':
          'समम्—straight/even; काय-शिरः-ग्रीवम्—body, head, and neck; धारयन्—holding; अचलम्—motionless; स्थिरः—steady; सम्-पश्यन्—seeing fully; नासिका-अग्रम्—the tip of the nose; स्वम्—own; दिशः—directions; च—and; अनवलोकयन्—without looking.',
      'commentary':
          'This describes the physical posture (*Āsana*) for meditation. A straight spine helps the flow of vital energy (*prāṇa*), and fixing the gaze (often practiced symbolically at the tip of the nose) prevents visual distraction.',
    });

    // Verse 14: Attitude during meditation
    await db.insert('chapter_6', {
      'verse_number': 14,
      'sanskrit':
          'प्रशान्तात्मा विगतभीर्ब्रह्मचारिव्रते स्थितः | मनः संयम्य मच्चित्तो युक्त आसीत मत्परः || 14 ||',
      'translation':
          'Remaining serene, fearless, firm in the vow of celibacy (*brahmacharya*), and controlling the mind, the Yogi should sit in meditation, absorbed in Me and making Me the supreme goal.',
      'word_meaning':
          'प्रशान्त-आत्मा—serene; विगत-भीः—fearless; ब्रह्मचारि-व्रते—in the vow of celibacy; स्थितः—situated; मनः—mind; संयम्य—controlling; मत्-चित्तः—with mind absorbed in Me; युक्तः—disciplined; आसीत—should sit; मत्-परः—making Me the supreme goal.',
      'commentary':
          'The mental attitude requires freedom from **fear** and the maintenance of **Brahmacharya** (celibacy/purity). The goal is single-pointed devotion to God (*mat-cittaḥ*) while subduing the mind.',
    });

    // Verse 15: The result of sustained practice
    await db.insert('chapter_6', {
      'verse_number': 15,
      'sanskrit':
          'युञ्जन्नेवं सदात्मानं योगी नियतमानसः | शान्तिं निर्वाणपरमां मत्संस्थामधिगच्छति || 15 ||',
      'translation':
          'Thus constantly engaging the mind (in meditation), the Yogi, with a disciplined mind, attains the supreme peace that culminates in liberation (*Nirvāṇa*) and resides in Me.',
      'word_meaning':
          'युञ्जन्—engaging; एवम्—thus; सदा—constantly; आत्मानम्—the self/mind; योगी—the Yogi; नियत-मानसः—with controlled mind; शान्तिम्—peace; निर्वाण-परमाम्—culminating in liberation; मत्-संस्थाम्—residing in Me; अधिगच्छति—attains.',
      'commentary':
          'Consistent practice leads to the highest state of tranquility, which is qualified as **Nirvāṇa-paramāṁ Śhāntiṁ** (supreme peace leading to liberation). This is the cessation of suffering through union with the Supreme.',
    });

    // Verse 16: Moderation in food and sleep is necessary
    await db.insert('chapter_6', {
      'verse_number': 16,
      'sanskrit':
          'नात्यश्नतस्तु योगोऽस्ति न चैकान्तमनश्नतः | न चातिस्वप्नशीलस्य जाग्रतो नैव चार्जुन || 16 ||',
      'translation':
          'O Arjuna, Yoga is not possible for one who eats too much, nor for one who eats too little; nor for one who sleeps too much, nor for one who stays awake too long.',
      'word_meaning':
          'न अति-अश्नतः—not of one who eats too much; तु—but; योगः—Yoga; अस्ति—is; न च एकान्तम्—nor exclusively; अनश्नतः—of one who starves; न च अति-स्वप्न-शीलस्य—nor of one who sleeps too much; जाग्रतः—of one who stays awake; न एव च—nor indeed; अर्जुन—O Arjuna.',
      'commentary':
          'This establishes the need for **moderation** (*yukta*). Extremes in vital bodily functions (eating, sleeping) disrupt the mental balance, making the steadying of the mind impossible.',
    });

    // Verse 17: The ideal of balanced conduct
    await db.insert('chapter_6', {
      'verse_number': 17,
      'sanskrit':
          'युक्ताहारविहारस्य युक्तचेष्टस्य कर्मसु | युक्तस्वप्नावबोधस्य योगो भवति दुःखहा || 17 ||',
      'translation':
          'For the person whose eating and recreation are regulated, whose actions are regulated, and whose sleep and wakefulness are regulated, Yoga becomes the destroyer of all sorrows.',
      'word_meaning':
          'युक्त-आहार-विहारस्य—whose eating and recreation are regulated; युक्त-चेष्टस्य—whose actions are regulated; कर्मसु—in work; युक्त-स्वप्न-अवबोधस्य—whose sleep and wakefulness are regulated; योगः—Yoga; भवति—becomes; दुःख-हा—destroyer of sorrow.',
      'commentary':
          'The principle of **Yukta** (regulated/balanced) applies to every aspect of life. A balanced lifestyle creates a balanced mind, which is essential for the attainment of Yoga and the destruction of suffering (*duḥkha*).',
    });

    // Verse 18: The definition of the established Yogi (Vimukta)
    await db.insert('chapter_6', {
      'verse_number': 18,
      'sanskrit':
          'यदा विनियतं चित्तमात्मन्येवावतिष्ठते | निःस्पृहः सर्वकामेभ्यो युक्त इत्युच्यते तदा || 18 ||',
      'translation':
          'When the perfectly disciplined mind (*vinīyataṁ chittaṁ*) becomes fixed solely on the Self and is completely free from all material desires, then one is said to be truly established in Yoga (*Yukta*).',
      'word_meaning':
          'यदा—when; वि-नियतम्—perfectly disciplined; चित्तम्—mind; आत्मनि एव—only in the Self; अवतिष्ठते—becomes fixed; निःस्पृहः—free from longing; सर्व-कामेभ्यः—from all material desires; युक्तः—established in Yoga; इति—thus; उच्यते—is called; तदा—then.',
      'commentary':
          'This is a precise definition of the meditative state. True establishment in Yoga is not a temporary trance but a permanent state where the disciplined mind is effortlessly fixed on the Self, devoid of any external longing.',
    });

    // Verse 19: Analogy of the lamp (The steady mind)
    await db.insert('chapter_6', {
      'verse_number': 19,
      'sanskrit':
          'यथा दीपो निवातस्थो नेङ्गते सोपमा स्मृता | योगिनो यतचित्तस्य युञ्जतो योगमात्मनः || 19 ||',
      'translation':
          'Just as a lamp in a windless place does not flicker, that is the analogy used for a Yogi whose mind is controlled and is engaged in the Yoga of the Self.',
      'word_meaning':
          'यथा—just as; दीपः—a lamp; निवात-स्थः—situated in a windless place; न इङ्गते—does not waver; सा उपमा—that is the analogy; स्मृता—is considered; योगिनः—of the Yogi; यत-चित्तस्य—whose mind is controlled; युञ्जतः—engaging; योगम्—Yoga; आत्मनः—of the Self.',
      'commentary':
          'The **steady lamp** is the classical metaphor for a mind free from all internal disturbances (*vāsanas*). Only a perfectly steady mind can illuminate the truth of the Self.',
    });

    // Verse 20: Experiencing ultimate spiritual bliss (Samādhi begins)
    await db.insert('chapter_6', {
      'verse_number': 20,
      'sanskrit':
          'यत्रोपरमते चित्तं निरुद्धं योगसेवया | यत्र चैवात्मनात्मानं पश्यन्नात्मनि तुष्यति || 20 ||',
      'translation':
          'In the state where the mind, restrained by the practice of Yoga, attains cessation (stillness), and where the person, seeing the Self by the Self, finds contentment in the Self alone,',
      'word_meaning':
          'यत्र—where; उपरमते—attains cessation/stillness; चित्तम्—the mind; निरुद्धम्—restrained; योग-सेवया—by the practice of Yoga; यत्र—where; च एव—and certainly; आत्मना—by the Self (the purified mind); आत्मानम्—the Self; पश्यन्—seeing; आत्मनि—in the Self; तुष्यति—is content.',
      'commentary':
          'This describes the initial phase of **Samādhi** (*yogic trance*). The cessation of mental activity reveals the Self, leading to pure, self-generated contentment.',
    });

    // Verse 21: The nature of Infinite Bliss
    await db.insert('chapter_6', {
      'verse_number': 21,
      'sanskrit':
          'सुखमात्यन्तिकं यत्तद् बुद्धिग्राह्यमतीन्द्रियम् | वेत्ति यत्र न चैवायं स्थितश्चलति तत्त्वतः || 21 ||',
      'translation':
          'The Yogi experiences that supreme, infinite bliss, which is grasped by the pure intellect and is beyond the reach of the senses; and established in that state, one never deviates from the Truth.',
      'word_meaning':
          'सुखम्—bliss; आत्यन्तिकम्—supreme/infinite; यत् तत्—that which; बुद्धि-ग्राह्यम्—grasped by the intellect; अति-इन्द्रियम्—transcending the senses; वेत्ति—experiences; यत्र—where; न च एव अयम्—nor certainly this; स्थितः—established; चलति—deviates; तत्त्वतः—from the Truth.',
      'commentary':
          'The culmination of meditation is the experience of **Ātyantikaṁ Sukhaṁ** (absolute bliss). This joy is intuitive and non-sensory (*atīndriyam*), making the Yogi permanently established in reality.',
    });

    // Verse 22: The incomparable gain
    await db.insert('chapter_6', {
      'verse_number': 22,
      'sanskrit':
          'यं लब्ध्वा चापरं लाभं मन्यते नाधिकं ततः | यस्मिन्स्थितो न दुःखेन गुरुणापि विचाल्यते || 22 ||',
      'translation':
          'Having gained which, one considers no other gain to be superior; established in which, one is not moved even by the heaviest of sorrows.',
      'word_meaning':
          'यम्—which (spiritual bliss); लब्ध्वा—having obtained; च—and; अपरम्—other; लाभम्—gain; मन्यते—considers; न अधिकम्—not superior; ततः—than that; यस्मिन्—in which; स्थितः—established; न दुःखेन—not by sorrow; गुरुणा अपि—even by heavy; विचाल्यते—is moved/shaken.',
      'commentary':
          'The bliss of *Samādhi* is so profound that all worldly gains and material sorrows become trivial in comparison. This state provides an inner shield against the inevitable miseries of embodied life.',
    });

    // Verse 23: Definition of Yoga as cessation of pain
    await db.insert('chapter_6', {
      'verse_number': 23,
      'sanskrit':
          'तं विद्याद् दुःखसंयोगवियोगं योगसञ्ज्ञितम् | स निश्चयेन योक्तव्यो योगोऽनिर्विण्णचेतसा || 23 ||',
      'translation':
          'Know this disassociation from the contact of pain to be Yoga. This Yoga must be practiced with firm determination and a mind unbewildered (*anirviṇṇa-cetasā*).',
      'word_meaning':
          'तम्—that; विद्यात्—should be known; दुःख-संयोग-वियोगम्—disassociation from the contact of pain; योग-सञ्ज्ञितम्—designated as Yoga; सः—that; निश्चयेन—with firm conviction; योक्तव्यः—should be practiced; योगः—Yoga; अनिर्विण्ण-चेतसा—by a mind not depressed/unbewildered.',
      'commentary':
          'Yoga is defined here as the state of **absolute freedom from pain** (*duḥkha-saṁyoga-viyogaṁ*). Achieving this requires unwavering determination and enthusiasm, maintained through constant practice.',
    });

    // Verse 24: The practice of mental withdrawal
    await db.insert('chapter_6', {
      'verse_number': 24,
      'sanskrit':
          'सङ्कल्पप्रभवान्कामांस्त्यक्त्वा सर्वानशेषतः | मनसैवेन्द्रियग्रामं विनियम्य समन्ततः || 24 ||',
      'translation':
          'Completely abandoning all desires born of self-will (*saṅkalpa*), and restraining the entire group of senses with the mind from all directions,',
      'word_meaning':
          'सङ्कल्प-प्रभवान्—born of self-will/mental conception; कामान्—desires; त्यक्त्वा—having abandoned; सर्वान्—all; अशेषतः—completely; मनसा एव—by the mind alone; इन्द्रिय-ग्रामम्—the group of senses; वि-नियम्य—restraining completely; समन्ततः—from all sides.',
      'commentary':
          'This provides the method for achieving inner stillness. Desires are generated by mental conception (*saṅkalpa*); thus, the practice requires using the mind (*manasā*) as the instrument to withdraw the senses, stopping the mental generation of desires.',
    });

    // Verse 25: Gradual control of the mind
    await db.insert('chapter_6', {
      'verse_number': 25,
      'sanskrit':
          'शनैः शनैरुपरमेद् बुद्ध्या धृतिगृहीतया | आत्मसंस्थं मनः कृत्वा न किञ्चिदपि चिन्तयेत् || 25 ||',
      'translation':
          'One should gradually achieve stillness, guided by the intellect held by firm conviction. Fixing the mind solely in the Self, one should not think of anything else at all.',
      'word_meaning':
          'शनैः शनैः—gradually, slowly; उपरमेत्—should withdraw; बुद्ध्या—by the intellect; धृति-गृहीतया—held by firm conviction; आत्म-संस्थम्—fixed in the Self; मनः—mind; कृत्वा—having made; न किञ्चित्—not anything; अपि—even; चिन्तयेत्—should think.',
      'commentary':
          'Meditation is a slow process (*śhanaiḥ śhanaiḥ*) requiring persistence and firm resolve (*dhṛiti*). The goal is to bring the restless mind to a complete halt (*na kiñcidapi chintayet*), resting it entirely in the Self.',
    });

    // Verse 26: Bringing the wandering mind back to the Self
    await db.insert('chapter_6', {
      'verse_number': 26,
      'sanskrit':
          'यतो यतो निश्चरति मनश्चञ्चलमस्थिरम् | ततस्ततो नियम्यैतदात्मन्येव वशं नयेत् || 26 ||',
      'translation':
          'Whenever and wherever the restless and unsteady mind wanders, one should withdraw it from those objects and bring it back under the control of the Self.',
      'word_meaning':
          'यतः यतः—from whatever/wherever; निश्चरति—wanders out; मनः—the mind; चञ्चलम्—fickle; अस्थिरम्—unsteady; ततः ततः—from there and there; नियम्य—restraining; एतत्—this; आत्मनि एव—unto the Self alone; वशम्—control; नयेत्—should bring.',
      'commentary':
          'This gives the practical technique for handling the turbulent mind. The process is not about permanent success, but persistent effort: constant vigilance and gently redirecting the wandering mind back to the object of meditation (the Self).',
    });

    // Verse 27: The result: Supreme happiness
    await db.insert('chapter_6', {
      'verse_number': 27,
      'sanskrit':
          'प्रशान्तमनसं ह्येनं योगिनं सुखमुत्तमम् | उपैति शान्तरजसं ब्रह्मभूतमकल्मषम् || 27 ||',
      'translation':
          'Supreme happiness certainly comes to the Yogi whose mind is completely peaceful, whose passion is subdued, who is free from sin, and who has become one with Brahman.',
      'word_meaning':
          'प्रशान्त-मनसम्—whose mind is peaceful; हि एनम्—certainly him; योगिनम्—the Yogi; सुखम् उत्तमम्—supreme happiness; उपैति—attains; शान्त-रजसम्—whose passion (Rajo-guṇa) is quieted; ब्रह्म-भूतम्—having become one with Brahman; अ-कल्मषम्—free from sin.',
      'commentary':
          'The achievement of **Samādhi** results in the *highest happiness* (*sukham uttamam*) through the cessation of **Rajas** (passion/agitation) and the realization of one\'s true nature as Brahman.',
    });

    // Verse 28: Experience of oneness with Brahman
    await db.insert('chapter_6', {
      'verse_number': 28,
      'sanskrit':
          'युञ्जन्नेवं सदात्मानं योगी विगतकल्मषः | सुखेन ब्रह्मसंस्पर्शमत्यन्तं सुखमश्नुते || 28 ||',
      'translation':
          'Thus constantly engaging the mind, the Yogi, free from sin, easily attains the boundless happiness of contact with Brahman.',
      'word_meaning':
          'युञ्जन्—engaging; एवम्—thus; सदा—constantly; आत्मानम्—the self/mind; योगी—the Yogi; विगत-कल्मषः—free from sin; सुखेन—easily; ब्रह्म-संस्पर्शम्—contact with Brahman; अत्यन्तम्—unlimited; सुखम्—happiness; अश्नुते—enjoys.',
      'commentary':
          'The result of sustained meditation is direct experience (*saṁsparśam*) of the Supreme Reality, leading to infinite bliss. This contact is described as easy (*sukhena*) because it is the soul returning to its natural state.',
    });

    // Verse 29: The vision of unity (Samādhi)
    await db.insert('chapter_6', {
      'verse_number': 29,
      'sanskrit':
          'सर्वभूतस्थमात्मानं सर्वभूतानि चात्मनि | ईक्षते योगयुक्तात्मा सर्वत्र समदर्शनः || 29 ||',
      'translation':
          'The soul established in Yoga sees the Self in all beings and all beings in the Self; the Yogi sees everything with an equal vision.',
      'word_meaning':
          'सर्व-भूत-स्थम्—dwelling in all beings; आत्मानम्—the Self; सर्व-भूतानि—all beings; च आत्मनि—and in the Self; ईक्षते—sees; योग-युक्त-आत्मा—the soul established in Yoga; सर्वत्र—everywhere; सम-दर्शनः—one who sees equally.',
      'commentary':
          'This is the hallmark of the perfectly realized Yogi: the vision of **unity** (*sama-darśanaḥ*). They perceive the single, non-dual Self (*Ātman*) as the essence of all creation.',
    });

    // Verse 30: The consequence of unity
    await db.insert('chapter_6', {
      'verse_number': 30,
      'sanskrit':
          'यो मां पश्यति सर्वत्र सर्वं च मयि पश्यति | तस्याहं न प्रणश्यामि स च मे न प्रणश्यति || 30 ||',
      'translation':
          'He who sees Me everywhere and sees everything in Me, I am never lost to him, nor is he ever lost to Me.',
      'word_meaning':
          'यः—who; माम्—Me; पश्यति—sees; सर्वत्र—everywhere; सर्वम्—everything; च—and; मयि—in Me; पश्यति—sees; तस्य—to him; अहम्—I; न प्रणश्यामि—am not lost; सः च—nor is he; मे—to Me; न प्रणश्यति—is lost.',
      'commentary':
          'This concludes the description of the ultimate unified consciousness. The Yogi who achieves the vision of the Self in all beings has an eternal, unbreakable bond with the Supreme Lord (Krishna).',
    });

    // Verse 31: The realized Yogi abides in God perpetually
    await db.insert('chapter_6', {
      'verse_number': 31,
      'sanskrit':
          'सर्वभूतस्थितं यो मां भजत्येकत्वमास्थितः | सर्वथा वर्तमानोऽपि स योगी मयि वर्तते || 31 ||',
      'translation':
          'He who, established in unity, worships Me dwelling in all beings, that Yogi abides in Me in all circumstances, whatever his mode of life.',
      'word_meaning':
          'सर्व-भूत-स्थितम्—situated in all beings; यः—who; माम्—Me; भजति—worships/serves; एकत्वम्—oneness; आस्थितः—established; सर्वथा—in all respects; वर्तमानः—being situated; अपि—even; सः योगी—that Yogi; मयि—in Me; वर्तते—remains.',
      'commentary':
          'This describes the perfected state (*Jīvanmukta*). The Yogi maintains an **"always-on" connection** with the Supreme, recognizing the unity of consciousness everywhere. Their external actions (*sarvathā vartamānaḥ*) do not break this inner absorption.',
    });

    // Verse 32: The measure of a perfect Yogi
    await db.insert('chapter_6', {
      'verse_number': 32,
      'sanskrit':
          'आत्मौपम्येन सर्वत्र समं पश्यति योऽर्जुन | सुखं वा यदि वा दुःखं स योगी परमो मतः || 32 ||',
      'translation':
          'O Arjuna, that Yogi is considered supreme who, by comparison with their own self, sees equality everywhere—whether in happiness or in sorrow—in all beings.',
      'word_meaning':
          'आत्म-औपम्येन—by comparison with one’s own self; सर्वत्र—everywhere; समम्—equal; पश्यति—sees; यः—who; अर्जुन—O Arjuna; सुखम् वा—whether happiness; यदि वा—or whether; दुःखम्—sorrow; सः योगी—that Yogi; परमः—supreme; मतः—is considered.',
      'commentary':
          'The ultimate ethical benchmark for a Yogi is **empathy** (*ātmaupamyena*). By relating the joys and sorrows of others to their own experience, the supreme Yogi acts as a universal well-wisher.',
    });

    // Verse 33: Arjuna expresses doubt: The mind is restless
    await db.insert('chapter_6', {
      'verse_number': 33,
      'sanskrit':
          'अर्जुन उवाच | योऽयं योगस्त्वया प्रोक्तः साम्येन मधुसूदन | एतस्याहं न पश्यामि चञ्चलत्वात्स्थितिं स्थिराम् || 33 ||',
      'translation':
          'Arjuna said: O Madhusūdana, this system of Yoga that You have described, based on equanimity (*sāmyena*), appears impractical and unsustainable to me, due to the mind’s restlessness (*chañcalatvāt*).',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; यः अयम्—which this; योगः—Yoga; त्वया—by You; प्रोक्तः—declared; साम्येन—with equanimity; मधुसूदन—O Madhusūdana; एतस्य—of this; अहम्—I; न पश्यामि—do not see; चञ्चलत्वात्—due to restlessness; स्थितिम् स्थिराम्—steady continuity.',
      'commentary':
          'Arjuna acknowledges the ideal but questions its practical viability, introducing the primary psychological obstacle to meditation: the restless and unsteady nature of the mind.',
    });

    // Verse 34: The mind is difficult to control (Analogy of the wind)
    await db.insert('chapter_6', {
      'verse_number': 34,
      'sanskrit':
          'चञ्चलं हि मनः कृष्ण प्रमाथि बलवद्दृढम् | तस्याहं निग्रहं मन्ये वायोरिव सुदुष्करम् || 31 ||',
      'translation':
          'O Kṛṣhṇa, the mind is indeed restless, turbulent, obstinate, and very powerful. Controlling it, I think, is more difficult than controlling the wind.',
      'word_meaning':
          'चञ्चलम्—restless; हि—certainly; मनः—mind; कृष्ण—O Kṛṣhṇa; प्रमाथि—turbulent; बलवत्—strong/powerful; दृढम्—obstinate; तस्य—its; अहम्—I; निग्रहम्—control/subduing; मन्ये—I think; वायोः—of the wind; इव—like; सु-दुष्करम्—very difficult.',
      'commentary':
          'Arjuna compares the mind’s elusiveness and power to the wind, asserting that subduing it is virtually impossible for an ordinary human.',

      // NOTE: The sloka number here (31) seems to be a common transcription error in some texts for 34. Using 34 for consistency.
    });

    // Verse 35: Krishna’s assurance: Mind can be controlled
    await db.insert('chapter_6', {
      'verse_number': 35,
      'sanskrit':
          'श्रीभगवानुवाच | असंशयं महाबाहो मनो दुर्निग्रहं चलम् | अभ्यासेन तु कौन्तेय वैराग्येण च गृह्यते || 35 ||',
      'translation':
          'The Supreme Lord said: O mighty-armed (Arjuna), undoubtedly the mind is restless and difficult to curb. But it can be controlled by **practice** (*abhyāsa*) and **detachment** (*vairāgya*).',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; असंशयम्—undoubtedly; महाबाहो—O mighty-armed; मनः—mind; दुर्निग्रहम्—difficult to curb; चलम्—restless; अभ्यासेन—by practice; तु—but; कौन्तेय—O son of Kuntī; वैराग्येण—by detachment; च—and; गृह्यते—is controlled.',
      'commentary':
          'Krishna agrees with Arjuna premise but offers the solution: the two indispensable pillars of mental mastery are **Abhyāsa** (consistent effort) and **Vairāgya** (dispassion/detachment from sense objects).',
    });

    // Verse 36: When is Yoga unattainable?
    await db.insert('chapter_6', {
      'verse_number': 36,
      'sanskrit':
          'असंयतात्मना योगो दुष्प्राप इति मे मतिः | वश्यात्मना तु यतता शक्योऽवाप्तुमुपायतः || 36 ||',
      'translation':
          'Yoga is difficult to attain for one whose mind is uncontrolled—this is My judgment. But by one whose mind is controlled and who strives by proper means, it is possible to attain it.',
      'word_meaning':
          'असंयत-आत्मना—by the one whose mind is uncontrolled; योगः—Yoga; दुष्प्रापः—difficult to attain; इति—thus; मे—My; मतिः—opinion; वश्य-आत्मना—by the one whose mind is subdued; तु—but; यतता—by striving; शक्यः—possible; अवाप्तुम्—to attain; उपायतः—by proper means.',
      'commentary':
          'This reinforces that the difficulty is conditional: the untrained mind fails, but the disciplined mind, applying the right methods (*upāyataḥ*), is certain to succeed.',
    });

    // Verse 37: Arjuna's second doubt: The unsuccessful Yogi
    await db.insert('chapter_6', {
      'verse_number': 37,
      'sanskrit':
          'अर्जुन उवाच | अयतिः श्रद्धयोपेतो योगाच्चलितमानसः | अप्राप्य योगसंसिद्धिं कां गतिं कृष्ण गच्छति || 37 ||',
      'translation':
          'Arjuna said: O Kṛṣhṇa, what destination does the unsuccessful spiritual aspirant meet—one who possesses faith (*śraddhā*) but whose mind is not controlled and deviates from the path of Yoga before attaining perfection?',
      'word_meaning':
          'अयतिः—the one who strives but lacks control; श्रद्धा-उपेतः—possessing faith; योगात्—from Yoga; चलित-मानसः—whose mind deviates; अप्राप्य—without attaining; योग-संसिद्धिम्—perfection in Yoga; काम् गतिम्—what destination; कृष्ण—O Kṛṣhṇa; गच्छति—attains.',
      'commentary':
          'Arjuna, being practical, asks about the fate of the sincere but unsuccessful seeker. Does their effort go to waste, or is there a guarantee of progress?',
    });

    // Verse 38: The fear of total loss
    await db.insert('chapter_6', {
      'verse_number': 38,
      'sanskrit':
          'कच्चिन्नोभयविभ्रष्टश्छिन्नाभ्रमिव नश्यति | अप्रतिष्ठो महाबाहो विमूढो ब्रह्मणः पथि || 38 ||',
      'translation':
          'O mighty-armed (Arjuna), does he not perish like a scattered cloud, having lost his position on both the material and spiritual paths, and having no firm foundation?',
      'word_meaning':
          'कच्चित् न—does he not; उभय-विभ्रष्टः—fallen from both (paths); छिन्न-अभ्रम्—a scattered cloud; इव—like; नश्यति—perishes; अप्रतिष्ठः—without firm foundation; महाबाहो—O mighty-armed; विमूढः—bewildered; ब्रह्मणः पथि—on the path to Brahman.',
      'commentary':
          'The fear is expressed using the analogy of a **scattered cloud**—neither attaining heaven (through prescribed action) nor liberation (through Yoga). Arjuna worries about the ultimate safety of the endeavor.',
    });

    // Verse 39: Arjuna asks Krishna to resolve the doubt
    await db.insert('chapter_6', {
      'verse_number': 39,
      'sanskrit':
          'एतन्मे संशयं कृष्ण छेत्तुमर्हस्यशेषतः | त्वदन्यः संशयस्यास्य न ह्यन्योऽस्ति मोहिता || 39 ||',
      'translation':
          'O Kṛṣhṇa, You should dispel this doubt of mine completely, for there is no one other than You who can remove this bewilderment.',
      'word_meaning':
          'एतत्—this; मे—my; संशयम्—doubt; कृष्ण—O Kṛṣhṇa; छेत्तुम्—to dispel/cut; अर्हसि—You should; अशेषतः—completely; त्वत् अन्यः—other than You; संशयस्य—of the doubt; अस्य—this; न हि अन्यः अस्ति—there is no other; मोहिनः—the dispeller of delusion.',
      'commentary':
          'Arjuna recognizes Krishna\'s divine authority as the ultimate Guru, capable of cutting away the confusion. This formal submission highlights the gravity of the question.',
    });

    // Verse 40: Krishna’s Great Assurance
    await db.insert('chapter_6', {
      'verse_number': 40,
      'sanskrit':
          'श्रीभगवानुवाच | पार्थ नैवेह नामुत्र विनाशस्तस्य विद्यते | न हि कल्याणकृत्कश्चिद्दुर्गतिं तात गच्छति || 40 ||',
      'translation':
          'The Supreme Lord said: O Pārtha, the one who treads the spiritual path never meets with destruction, neither in this world nor in the next. My dear friend, one who strives for goodness never comes to grief.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; पार्थ—O Pārtha; न एव—never; इह—in this world; न अमुत्र—nor in the next world; विनाशः—destruction; तस्य—his; विद्यते—is found; न हि—never; कल्याण-कृत्—one who performs auspicious deeds; कश्चित्—anyone; दुर्गतिम्—evil destiny/grief; तात—my dear one; गच्छति—attains.',
      'commentary':
          'This is Krishna’s **Great Assurance**. The effort expended on the path of Yoga is never wasted. Spiritual investment is always safe, protected by God, and ensures that the seeker will not suffer a bad fate.',
    });

    // Verse 41: Rebirth of the unsuccessful Yogi (in a pious family)
    await db.insert('chapter_6', {
      'verse_number': 41,
      'sanskrit':
          'प्राप्य पुण्यकृतां लोकानुषित्वा शाश्वतीः समाः | शुचीनां श्रीमतां गेहे योगभ्रष्टोऽभिजायते || 41 ||',
      'translation':
          'The unsuccessful Yogi, upon death, goes to the worlds of the virtuous. After dwelling there for many ages, he is again reborn into a family of pure and prosperous people.',
      'word_meaning':
          'प्राप्य—having attained; पुण्य-कृताम्—of the virtuous; लोकान्—abodes; उषित्वा—after dwelling; शाश्वतीः—many; समाः—years; शुचीनाम्—of the pure/pious; श्री-मताम्—of the prosperous; गेहे—in the house; योग-भ्रष्टः—one who has fallen from Yoga; अभिजायते—takes birth.',
      'commentary':
          'Krishna gives the assurance: spiritual effort is never wasted. The *Yogabhraṣhṭa* (fallen Yogi) is granted a superior birth (*śhuchīnāṁ śhrī-matāṁ gehe*) where external conditions favor the resumption of their spiritual journey.',
    });

    // Verse 42: Rebirth in a family of Yogis (The superior destination)
    await db.insert('chapter_6', {
      'verse_number': 42,
      'sanskrit':
          'अथवा योगिनामेव कुले भवति धीमताम् | एतद्धि दुर्लभतरं लोके जन्म यदीदृशम् || 42 ||',
      'translation':
          'Else, if they have developed detachment through long practice, they are born into a family of Yogis endowed with divine wisdom. Such a birth is indeed very difficult to attain in this world.',
      'word_meaning':
          'अथवा—else; योगिनाम्—of the Yogis; एव—certainly; कुले—in the family; भवति—takes birth; धीमताम्—of the wise; एतत् हि—this certainly; दुर्लभतरम्—more difficult to attain; लोके—in the world; जन्म—birth; यत् ईदृशम्—which is of this kind.',
      'commentary':
          'For those with greater spiritual momentum, they bypass the enjoyment of heaven and are directly reborn into an enlightened family. This is the rarest and most conducive environment for quick realization.',
    });

    // Verse 43: Revival of past wisdom
    await db.insert('chapter_6', {
      'verse_number': 43,
      'sanskrit':
          'तत्र तं बुद्धिसंयोगं लभते पौर्वदेहिकम् | यतते च ततो भूयः संसिद्धौ कुरुनन्दन || 43 ||',
      'translation':
          'Taking such a birth, O descendant of the Kurus, he revives the divine consciousness (*buddhi-saṁyogaṁ*) from his previous life and strives again for perfect accomplishment.',
      'word_meaning':
          'तत्र—there; तम्—that; बुद्धि-संयोगम्—connection with the intellect (divine consciousness); लभते—obtains; पौर्व-देहिकम्—of the previous body; यतते—strives; च—and; ततः—from there; भूयः—again; संसिद्धौ—for perfection; कुरुनन्दन—O descendant of the Kurus.',
      'commentary':
          'The essence of spiritual continuity. The assets earned in past lives (spiritual intelligence and tendencies) are awakened, allowing the seeker to resume the journey exactly where they left off.',
    });

    // Verse 44: The compelling force of past efforts
    await db.insert('chapter_6', {
      'verse_number': 44,
      'sanskrit':
          'पूर्वाभ्यासेन तेनैव ह्रियते ह्यवशोऽपि सः | जिज्ञासुरपि योगस्य शब्दब्रह्मातिवर्तते || 44 ||',
      'translation':
          'By the force of that previous practice alone, he is carried forward, even against his will. Such an inquisitive Yogi naturally rises beyond the ritualistic principles of the Vedas.',
      'word_meaning':
          'पूर्व-अभ्यासेन—by previous practice; तेन एव—by that alone; ह्रियते—is carried; हि—certainly; अवशः अपि—even helplessly; सः—he; जिज्ञासुः अपि—even an inquirer; योगस्य—of Yoga; शब्द-ब्रह्म—the ritualistic portions of the Vedas; अतिवर्तते—transcends.',
      'commentary':
          'Past spiritual *abhyāsa* (practice) is the most powerful *saṁskāra* (impression). It acts as a compelling force, driving the soul toward the goal of Yoga and naturally transcending mere rituals.',
    });

    // Verse 45: The attainment of the Supreme Goal
    await db.insert('chapter_6', {
      'verse_number': 45,
      'sanskrit':
          'प्रयत्नाद्यतमानस्तु योगी संशुद्धकिल्बिषः | अनेकजन्मसंसिद्धस्ततो याति परां गतिम् || 45 ||',
      'translation':
          'The Yogi who diligently strives becomes completely purified of all sins and, attaining perfection over many lifetimes, reaches the supreme destination.',
      'word_meaning':
          'प्रयत्नात्—with effort; यतमानः—striving; तु—but; योगी—the Yogi; संशुद्ध-किल्बिषः—completely cleansed of sins; अनेक-जन्म-संसिद्धः—attaining perfection over many births; ततः—then; याति—reaches; पराम् गतिम्—the supreme destination.',
      'commentary':
          'This assures the aspirant that persistent effort over lifetimes, guided by the accumulated spiritual merit, guarantees the final goal of supreme liberation (*parāṁ gatim*).',
    });

    // Verse 46: The superiority of the Yogi
    await db.insert('chapter_6', {
      'verse_number': 46,
      'sanskrit':
          'तपस्विभ्योऽधिको योगी ज्ञानिभ्योऽपि मतोऽधिकः | कर्मिभ्यश्चाधिको योगी तस्माद्योगी भवार्जुन || 46 ||',
      'translation':
          'The Yogi is superior to the ascetic (*tapasvī*), superior even to the philosopher (*jñānī*), and superior to the ritualistic worker (*karmī*). Therefore, O Arjuna, strive to be a Yogi.',
      'word_meaning':
          'तपस्विभ्यः—than the ascetics; अधिकः—superior; योगी—the Yogi; ज्ञानिभ्यः अपि—even than the philosophers; मतः—is considered; अधिकः—superior; कर्मिभ्यः—than the ritualistic performers; च—and; अधिकः—superior; योगी—the Yogi; तस्मात्—therefore; योगी भव—be a Yogi; अर्जुन—O Arjuna.',
      'commentary':
          'Krishna concludes the chapter on *Dhyāna Yoga* by declaring the Yogi (one who integrates knowledge, action, and devotion) superior to those who practice only one aspect (austerity, pure intellect, or ritual).',
    });

    // Verse 47: The highest form of Yogi (Bhakti Yoga)
    await db.insert('chapter_6', {
      'verse_number': 47,
      'sanskrit':
          'योगिनामपि सर्वेषां मद्गतेनान्तरात्मना | श्रद्धावान्भजते यो मां स मे युक्ततमो मतः || 47 ||',
      'translation':
          'And among all Yogis, the one who worships Me with full faith, with his inner self merged in Me, is considered by Me to be the **most completely united** (*yuktatamaḥ*).',
      'word_meaning':
          'योगिनाम् अपि—even of all Yogis; सर्वेषाम्—all; मत्-गतेन—merged in Me; अन्तर्-आत्मना—with the inner self; श्रद्धावान्—full of faith; भजते—worships/serves; यः—who; माम्—Me; सः—he; मे—by Me; युक्त-तमः—most completely united; मतः—is deemed.',
      'commentary':
          'This final verse of the chapter is the climax of *Dhyāna Yoga*, revealing that the **highest form of Yoga is Bhakti (devotion)**. The most perfect Yogi is the one who practices meditation while fixing their mind and heart on the Supreme Lord, Krishna, with complete faith.',
    });
  }

  Future<void> insertChapter7Verses(Database db) async {
    // Verse 1: Krishna introduces the highest knowledge (Jñāna and Vijñāna)
    await db.insert('chapter_7', {
      'verse_number': 1,
      'sanskrit':
          'श्रीभगवानुवाच | मय्यासक्तमनाः पार्थ योगं युञ्जन्मदाश्रयः | असंशयं समग्रं मां यथा ज्ञास्यसि तच्छृणु || 1 ||',
      'translation':
          'The Supreme Lord said: Now listen, O Pārtha (Arjuna), how, with the mind attached exclusively to Me and surrendering to Me through the practice of Yoga, you can know Me completely, free from doubt.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; मयि—to Me; आसक्त-मनाः—with the mind attached; पार्थ—O Pārtha; योगम्—Bhakti Yoga; युञ्जन्—practicing; मत्-आश्रयः—surrendering to Me; असंशयम्—free from doubt; समग्रम्—completely; माम्—Me; यथा—how; ज्ञास्यसि—you shall know; तत्—that; शृणु—listen.',
      'commentary':
          'Krishna introduces the concept of knowing God **completely** (*samagraṁ*) through **Bhakti Yoga** (Yoga practiced with attachment and surrender to God). This complete knowledge removes all doubts (*asaṁśhayaṁ*).',
    });

    // Verse 2: The necessity of this comprehensive knowledge
    await db.insert('chapter_7', {
      'verse_number': 2,
      'sanskrit':
          'ज्ञानं तेऽहं सविज्ञानमिदं वक्ष्याम्यशेषतः | यज्ज्ञात्वा नेह भूयोऽन्यज्ज्ञातव्यमवशिष्यते || 2 ||',
      'translation':
          'I shall now reveal to you fully this knowledge (*jñāna*) along with realization (*vijñāna*), knowing which nothing else remains to be known in this world.',
      'word_meaning':
          'ज्ञानम्—knowledge (theoretical); ते—to you; अहम्—I; स-विज्ञानम्—with realization (practical); इदम्—this; वक्ष्यामि—I shall declare; अशेषतः—without remainder; यत् ज्ञात्वा—having known which; न इह—not here; भूयः—again; अन्यत्—anything else; ज्ञातव्यम्—to be known; अवशिष्यते—remains.',
      'commentary':
          'The knowledge (*Jñāna*) being offered is comprehensive, covering both the philosophical truth and its experiential realization (*Vijñāna*). It is the final answer, leaving no scope for further inquiry.',
    });

    // Verse 3: The rarity of perfected souls
    await db.insert('chapter_7', {
      'verse_number': 3,
      'sanskrit':
          'मनुष्याणां सहस्रेषु कश्चिद्यतति सिद्धये | यततामपि सिद्धानां कश्चिन्मां वेत्ति तत्त्वतः || 3 ||',
      'translation':
          'Among thousands of persons, hardly one strives for perfection; and among those who have achieved perfection, hardly one knows Me in truth.',
      'word_meaning':
          'मनुष्याणाम्—among men; सहस्रेषु—among thousands; कश्चित्—someone; यतति—strives; सिद्धये—for perfection; यतताम्—of those who strive; अपि—even; सिद्धानाम्—of the perfected; कश्चित्—someone; माम्—Me; वेत्ति—knows; तत्त्वतः—in truth.',
      'commentary':
          'Krishna establishes the difficulty of the path to emphasize the value of the knowledge being revealed. Striving for perfection is rare, and achieving perfect knowledge of God is even rarer.',
    });

    // Verse 4: The eightfold material energy (Aparā Prakṛti)
    await db.insert('chapter_7', {
      'verse_number': 4,
      'sanskrit':
          'भूमिरापोऽनलो वायुः खं मनो बुद्धिरेव च | अहङ्कार इतीयं मे भिन्ना प्रकृतिरष्टधा || 4 ||',
      'translation':
          'Earth, water, fire, air, space (*khaṁ*), mind (*manas*), intellect (*buddhi*), and ego (*ahaṅkāra*)—these are the eight components of My separate material energy.',
      'word_meaning':
          'भूमिः—earth; आपः—water; अनलः—fire; वायुः—air; खम्—space/ether; मनः—mind; बुद्धिः—intellect; एव च—and also; अहङ्कारः—ego; इति—thus; इयम्—this; मे—My; भिन्ना—separated/inferior; प्रकृतिः—material energy; अष्टधा—eightfold.',
      'commentary':
          'Krishna begins explaining His energies, dividing them into eight categories of the **inferior (*aparā*) material nature**. This includes the five gross elements and the three subtle components of the mind (mind, intellect, and ego).',
    });

    // Verse 5: The superior energy (Parā Prakṛti - The Soul)
    await db.insert('chapter_7', {
      'verse_number': 5,
      'sanskrit':
          'अपरेयमितस्त्वन्यां प्रकृतिं विद्धि मे पराम् | जीवभूतां महाबाहो ययेदं धार्यते जगत् || 5 ||',
      'translation':
          'Such is My inferior energy. But beyond it, O mighty-armed (Arjuna), I have a superior energy. This is the life-force (*jīva-bhūtā*), which comprises the embodied souls who sustain this universe.',
      'word_meaning':
          'अपरा—inferior; इयम्—this; इतः तु—but other than this; अन्याम्—another; प्रकृतिम्—energy; विद्धि—know; मे—My; पराम्—superior; जीव-भूताम्—the soul-energy; यया—by which; इदम्—this; धार्यते—is sustained; जगत्—the universe.',
      'commentary':
          'The **superior (*parā*) energy** is the consciousness, the embodied soul (*jīva-bhūtā*). This consciousness uses the material energy as a vehicle and is the ultimate sustaining power behind the material universe.',
    });

    // Verse 6: Krishna as the source of all existence
    await db.insert('chapter_7', {
      'verse_number': 6,
      'sanskrit':
          'एतद्योनीनि भूतानि सर्वाणीत्युपधारय | अहं कृत्स्नस्य जगतः प्रभवः प्रलयस्तथा || 6 ||',
      'translation':
          'Know that all living beings originate from these two energies of Mine. I am the source of the entire creation, and into Me it again dissolves.',
      'word_meaning':
          'एतत्-योनीनि—whose source is these two (energies); भूतानि—beings; सर्वाणि—all; इति—thus; उपधारय—know/understand; अहम्—I; कृत्स्नस्य—of the entire; जगतः—universe; प्रभवः—the source/origin; प्रलयः—dissolution; तथा—and also.',
      'commentary':
          'Krishna defines Himself as the **efficient and material cause** of the universe. He is the ultimate origin and dissolution point for both the conscious (Parā) and unconscious (Aparā) energies.',
    });

    // Verse 7: Nothing is higher than the Lord
    await db.insert('chapter_7', {
      'verse_number': 7,
      'sanskrit':
          'मत्तः परतरं नान्यत्किञ्चिदस्ति धनञ्जय | मयि सर्वमिदं प्रोतं सूत्रे मणिगणा इव || 7 ||',
      'translation':
          'O Dhanañjaya, there is no truth superior to Me. Everything rests in Me, just as beads are strung on a thread.',
      'word_meaning':
          'मत्तः—than Me; पर-तरम्—superior; न अन्यत्—no other; किञ्चित्—anything; अस्ति—is; धनञ्जय—O Dhanañjaya; मयि—in Me; सर्वम्—all; इदम्—this; प्रोतम्—is strung; सूत्रे—on a thread; मणि-गणाः—jewels/beads; इव—like.',
      'commentary':
          'This is a central statement of the Gita, confirming Krishna\'s status as the **Absolute Supreme Reality**. The thread (*sūtra*) is the Lord, and the beads (*maṇigaṇāḥ*) are the universe and all living beings, indicating simultaneous unity and difference.',
    });

    // Verse 8: Krishna as the essence of creation (The Immanent God 1/3)
    await db.insert('chapter_7', {
      'verse_number': 8,
      'sanskrit':
          'रसोऽहमप्सु कौन्तेय प्रभास्मि शशिसूर्ययोः | प्रणवः सर्ववेदेषु शब्दः खे पौरुषं नृषु || 8 ||',
      'translation':
          'O son of Kuntī, I am the **taste in water**, the radiance of the sun and the moon, the sacred syllable **Om** in the Vedic mantras, the sound in ether (*kha*), and the ability (*pauruṣhaṁ*) in human beings.',
      'word_meaning':
          'रसः—taste; अहम्—I am; अप्सु—in water; कौन्तेय—O son of Kuntī; प्रभा—radiance; अस्मि—I am; शशि-सूर्ययोः—of the moon and the sun; प्रणवः—the syllable Om; सर्व-वेदेषु—in all the Vedas; शब्दः—sound; खे—in ether/space; पौरुषम्—ability/manliness; नृषु—in men.',
      'commentary':
          'Krishna is revealed as the **essence** (*rasa*) or the intrinsic quality of everything fundamental in creation. He is the life-giving, enjoyable, and essential element in all physical and metaphysical existence.',
    });

    // Verse 9: Krishna as the essence of creation (The Immanent God 2/3)
    await db.insert('chapter_7', {
      'verse_number': 9,
      'sanskrit':
          'पुण्यो गन्धः पृथिव्यां च तेजश्चास्मि विभावसौ | जीवनं सर्वभूतेषु तपश्चास्मि तपस्विषु || 9 ||',
      'translation':
          'I am the pure **fragrance of the earth**, the brilliance in fire, the **life-force in all beings**, and the penance (*tapas*) of the ascetics.',
      'word_meaning':
          'पुण्यः—pure; गन्धः—fragrance; पृथिव्याम्—in the earth; च—and; तेजः—brilliance; च अस्मि—and I am; विभावसौ—in fire; जीवनम्—life/life-force; सर्व-भूतेषु—in all beings; तपः—penance; च अस्मि—and I am; तपस्विषु—in the ascetics.',
      'commentary':
          'Continuing the *Vibhūti* (opulence) theme, Krishna shows He is the pure, desirable quality in the elements (fragrance of earth, brilliance of fire) and the inner power behind spiritual practice (*tapas*).',
    });

    // Verse 10: Krishna as the eternal seed
    await db.insert('chapter_7', {
      'verse_number': 10,
      'sanskrit':
          'बीजं मां सर्वभूतानां विद्धि पार्थ सनातनम् | बुद्धिर्बुद्धिमतामस्मि तेजस्तेजस्विनामहम् || 10 ||',
      'translation':
          'O Pārtha, know Me to be the **eternal seed** (*bījaṁ sanātanaṁ*) of all beings. I am the **intellect** (*buddhi*) of the intelligent, and the **splendor** (*tejas*) of the splendid.',
      'word_meaning':
          'बीजम्—the seed; माम्—Me; सर्व-भूतानाम्—of all beings; विद्धि—know; पार्थ—O Pārtha; सनातनम्—eternal; बुद्धिः—the intellect; बुद्धि-मताम्—of the intelligent; अस्मि—I am; तेजः—splendor/power; तेजस्विनाम्—of the splendid; अहम्—I.',
      'commentary':
          'Krishna is the **origin** (*bījam*) and the **power** (*buddhi*, *tejas*) behind creation. Everything phenomenal arises from Him, establishing His complete, uncaused, and pervasive nature.',
    });

    // Verse 11: Krishna as strength and Dharma-aligned desire
    await db.insert('chapter_7', {
      'verse_number': 11,
      'sanskrit':
          'बलं बलवतां चाहं कामरागविवर्जितम् | धर्माविरुद्धो भूतेषु कामोऽस्मि भरतर्षभ || 11 ||',
      'translation':
          'O best of the Bhāratas (Arjuna), in strong persons, I am their strength devoid of desire and passion. I am the desire in beings that is consistent with *Dharma* (righteous duty).',
      'word_meaning':
          'बलम्—strength; बलवताम्—of the strong; च अहम्—and I am; काम-राग-विवर्जितम्—devoid of desire and passion; धर्म-अविरुद्धः—unopposed to *Dharma* (righteousness); भूतेषु—in beings; कामः—desire; अस्मि—I am; भरतर्षभ—O best of the Bhāratas.',
      'commentary':
          'Krishna shows He is the source of pure, ethical power. He is the life-sustaining desire (like the desire for survival or procreation) that remains within the bounds of moral and scriptural principles.',
    });

    // Verse 12: Origin of the three Guṇas
    await db.insert('chapter_7', {
      'verse_number': 12,
      'sanskrit':
          'ये चैव सात्त्विका भावा राजसास्तामसाश्च ये | मत्त एवेति तान्विद्धि न त्वहं तेषु ते मयि || 12 ||',
      'translation':
          'Know that all states of being—be they of goodness (*sattva*), passion (*rajas*), or ignorance (*tamas*)—are manifested by My energy. They are in Me, but I am not in them; they depend on Me.',
      'word_meaning':
          'ये च एव—and whatever; सात्त्विकाः—in the mode of goodness; भावाः—states of being; राजसाः—in the mode of passion; तामसाः—in the mode of ignorance; च ये—and which; मत्तः एव—from Me alone; इति—thus; तान् विद्धि—know them; न तु अहम्—but I am not; तेषु—in them; ते—they; मयि—in Me.',
      'commentary':
          'All forms and manifestations in the material world, including the three *guṇas*, originate from Krishna. He is the transcendent source, meaning He is unaffected by the properties of the *guṇas* that govern them.',
    });

    // Verse 13: The veil of Māyā
    await db.insert('chapter_7', {
      'verse_number': 13,
      'sanskrit':
          'त्रिभिर्गुणमयैर्भावैरेभिः सर्वमिदं जगत् | मोहितं नाभिजानाति मामेभ्यः परमव्ययम् || 13 ||',
      'translation':
          'Deluded by these states of material nature, which are comprised of the three *guṇas*, the world is unable to know Me, the imperishable and transcendent, who is distinct from them.',
      'word_meaning':
          'त्रिभिः गुणमयैः—composed of the three *guṇas*; भावैः—by states of being; एभिः—by these; सर्वम्—all; इदम्—this; जगत्—universe; मोहितम्—deluded; न अभिजानाति—does not know; माम्—Me; एभ्यः—than these; परम्—transcendent; अव्ययम्—imperishable.',
      'commentary':
          'The *guṇas* create a veil of illusion (*Māyā*) that covers the vision of the living entity. This delusion prevents the soul from recognizing Krishna\'s true nature as the eternal Supreme Person.',
    });

    // Verse 14: Overcoming Māyā through surrender
    await db.insert('chapter_7', {
      'verse_number': 14,
      'sanskrit':
          'दैवी ह्येषा गुणमयी मम माया दुरत्यया | मामेव ये प्रपद्यन्ते मायामेतां तरन्ति ते || 14 ||',
      'translation':
          'Verily, this divine illusion (*Māyā*) of Mine, made up of the *guṇas*, is difficult to cross over. But those who surrender unto Me cross over this illusion easily.',
      'word_meaning':
          'दैवी हि—certainly divine; एषा—this; गुण-मयी—composed of the *guṇas*; मम—My; माया—illusory energy; दुरत्यया—difficult to cross over; माम् एव—unto Me alone; ये—who; प्रपद्यन्ते—surrender; मायाम् एताम्—this illusion; तरन्ति—they cross over; ते—they.',
      'commentary':
          'Krishna states that *Māyā* is divine, meaning it is also His energy, making it formidable. The only sure path to transcendence is complete **surrender (*prapadyante*)** to the source of *Māyā* (Krishna) Himself.',
    });

    // Verse 15: Four types of miscreants who do not surrender
    await db.insert('chapter_7', {
      'verse_number': 15,
      'sanskrit':
          'न मां दुष्कृतिनो मूढाः प्रपद्यन्ते नराधमाः | माययापहृतज्ञाना आसुरं भावमाश्रिताः || 15 ||',
      'translation':
          'Those miscreants who are foolish, the lowest of mankind, whose knowledge is stolen by illusion (*Māyā*), and who partake of the demoniac nature, do not surrender unto Me.',
      'word_meaning':
          'न माम्—not unto Me; दुष्कृतिनः—the miscreants; मूढाः—the foolish; प्रपद्यन्ते—surrender; नर-अधमाः—the lowest of mankind; मायया—by Māyā; अपहृत-ज्ञानाः—whose knowledge is stolen; आसुरम्—demoniac; भावम्—nature; आश्रिताः—taking refuge in.',
      'commentary':
          'Krishna lists the four kinds of unfortunate souls who reject the path of surrender, all characterized by a lack of spiritual intelligence (*jñāna*), which has been stolen by *Māyā*.',
    });

    // Verse 16: Four types of virtuous people who worship Him
    await db.insert('chapter_7', {
      'verse_number': 16,
      'sanskrit':
          'चतुर्विधा भजन्ते मां जनाः सुकृतिनोऽर्जुन | आर्तो जिज्ञासुरर्थार्थी ज्ञानी च भरतर्षभ || 16 ||',
      'translation':
          'Four kinds of virtuous men (*sukṛtino*) render devotional service unto Me, O Arjuna: the distressed, the desirer of wealth, the inquisitive, and he who is searching for knowledge.',
      'word_meaning':
          'चतुः-विधाः—four kinds; भजन्ते—worship/serve; माम्—Me; जनाः—people; सुकृतिनः—virtuous/pious; अर्जुन—O Arjuna; आर्तः—the distressed; जिज्ञासुः—the inquisitive; अर्थ-अर्थी—the desirer of wealth; ज्ञानी—the knower; च भरतर्षभ—and O best of the Bhāratas.',
      'commentary':
          'This contrasts with the previous verse. These four categories, though beginning with different material or partial motives, are all pious (*sukṛtino*) and are guaranteed spiritual progress because they worship Krishna.',
    });

    // Verse 17: The superiority of the Jñānī (Wise) devotee
    await db.insert('chapter_7', {
      'verse_number': 17,
      'sanskrit':
          'तेषां ज्ञानी नित्ययुक्त एकभक्तिर्विशिष्यते | प्रियो हि ज्ञानिनोऽत्यर्थमहं स च मम प्रियः || 17 ||',
      'translation':
          'Of these, the wise man (*jñānī*) who is always united with Me through single-pointed devotion is the best. For I am exceedingly dear to him, and he is dear to Me.',
      'word_meaning':
          'तेषाम्—of these; ज्ञानी—the wise man; नित्य-युक्तः—always united; एक-भक्तिः—with single-pointed devotion; विशिष्यते—is superior; प्रियः—dear; हि—certainly; ज्ञानिनः—to the wise man; अत्यर्थम्—exceedingly; अहम्—I; सः च—and he; मम प्रियः—is dear to Me.',
      'commentary':
          'The *jñānī* is superior because their devotion is *akaitava* (unmotivated by material gain) and based on realized knowledge, leading to a profound, mutual love with the Lord.',
    });

    // Verse 18: The Jñānī is situated in God
    await db.insert('chapter_7', {
      'verse_number': 18,
      'sanskrit':
          'उदाराः सर्व एवैते ज्ञानी त्वात्मैव मे मतम् | आस्थितः स हि युक्तात्मा मामेवानुत्तमां गतिम् || 18 ||',
      'translation':
          'All these devotees are indeed great souls, but the wise devotee (*jñānī*) is situated in Me. They are engaged in My transcendental service, knowing Me to be the highest goal.',
      'word_meaning':
          'उदाराः—noble/magnanimous; सर्व एव—all indeed; एते—these; ज्ञानी तु—but the wise man; आत्मा एव—the very self; मे मतम्—My opinion; आस्थितः—situated; सः हि—he certainly; युक्त-आत्मा—whose mind is united; माम् एव—Me alone; अनुत्तमाम् गतिम्—the unsurpassed goal.',
      'commentary':
          'The wise devotee is considered Krishna\'s own Self (*ātmaiva*) because their inner consciousness is perfectly aligned with the Lord\'s will, making the Lord their sole and ultimate refuge (*anuttamām gatim*).',
    });

    // Verse 19: The rarity of complete surrender
    await db.insert('chapter_7', {
      'verse_number': 19,
      'sanskrit':
          'बहूनां जन्मनामन्ते ज्ञानवान्मां प्रपद्यते | वासुदेवः सर्वमिति स महात्मा सुदुर्लभः || 19 ||',
      'translation':
          'After many births and deaths, he who is truly in knowledge surrenders unto Me, knowing **"Vāsudeva is everything."** Such a great soul is very rare (*sudurlabhaḥ*).',
      'word_meaning':
          'बहूनाम्—many; जन्मनाम्—of births; अन्ते—at the end; ज्ञानवान्—one who is knowledgeable; माम्—Me; प्रपद्यते—surrenders; वासुदेवः—Vāsudeva (Krishna); सर्वम्—everything; इति—thus; सः महात्मा—that great soul; सु-दुर्लभः—very rare.',
      'commentary':
          'True surrender comes only after long spiritual evolution, when the identity of *Vāsudeva* (Krishna) as the single source, sustainer, and goal of all existence is fully realized. This state of realization is the culmination of all endeavors.',
    });

    // Verse 20: The reason for worshipping other deities
    await db.insert('chapter_7', {
      'verse_number': 20,
      'sanskrit':
          'कामैस्तैस्तैर्हृतज्ञानाः प्रपद्यन्तेऽन्यदेवताः | तं तं नियममास्थाय प्रकृत्या नियताः स्वया || 20 ||',
      'translation':
          'Those whose wisdom has been carried away by **various material desires** surrender to the celestial gods. Following their own nature, they worship the *devatās*, practicing corresponding rituals.',
      'word_meaning':
          'कामः—desires; तैः तैः—various; हृत-ज्ञानाः—whose knowledge is stolen; प्रपद्यन्ते—surrender; अन्य-देवताः—to other celestial gods; तम् तम्—corresponding; नियमम्—regulations; आस्थाय—following; प्रकृत्या—by nature; नियताः—controlled; स्वया—by their own.',
      'commentary':
          'This returns to the theme of *Māyā*. People with unfulfilled, temporary desires have their intelligence veiled, leading them to worship temporary celestial beings (*devatās*) instead of the Supreme Lord for quick, material results.',
    });

    // Verse 21: Krishna is the giver of faith in other forms
    await db.insert('chapter_7', {
      'verse_number': 21,
      'sanskrit':
          'यो यो यां यां तनुं भक्तः श्रद्धयार्चितुमिच्छति | तस्य तस्याचलां श्रद्धां तामेव विदधाम्यहम् || 21 ||',
      'translation':
          'Whichever celestial form a devotee seeks to worship with faith, I steady the faith of such a devotee in that very form.',
      'word_meaning':
          'यः यः—whoever; याम् याम्—whichever; तनुम्—form; भक्तः—devotee; श्रद्धया—with faith; अर्चितुम्—to worship; इच्छति—desires; तस्य तस्य—to him; अचलाम्—steady; श्रद्धाम्—faith; ताम् एव—in that very form; विदधामि—bestow; अहम्—I.',
      'commentary':
          'Krishna reveals His universal role: He is the source of all faith (*śraddhā*). Even when devotees worship other deities for material goals, it is Krishna alone who sanctions their faith and grants the power to achieve their finite desires.',
    });

    // Verse 22: Krishna grants the reward through the chosen form
    await db.insert('chapter_7', {
      'verse_number': 22,
      'sanskrit':
          'स तया श्रद्धया युक्तस्तस्याराधनमीहते | लभते च ततः कामान्मयैव विहितान्हि तान् || 22 ||',
      'translation':
          'Endowed with that faith, the devotee engages in the worship of that form and obtains the objects of their desire, which are granted by Me alone.',
      'word_meaning':
          'सः—he; तया—by that faith; युक्तः—united; तस्य—his; आराधनम्—worship; ईहते—desires; लभते—attains; च—and; ततः—from that; कामान्—desires; मया एव—by Me alone; विहितान्—arranged/granted; हि—certainly; तान्—them.',
      'commentary':
          'This reinforces the concept that all results, even those obtained from demigods, are ultimately sanctioned by the Supreme Lord. Krishna is the *dispenser* of results for all actions.',
    });

    // Verse 23: The temporary nature of material rewards
    await db.insert('chapter_7', {
      'verse_number': 23,
      'sanskrit':
          'अन्तवत्तु फलं तेषां तद्भवत्यल्पमेधसाम् | देवान्देवयजो यान्ति मद्भक्ता यान्ति मामपि || 23 ||',
      'translation':
          'But the reward achieved by those of small intelligence (*alpa-medhasām*) is temporary. Worshippers of the *devatās* go to the *devatās*, but My devotees attain Me.',
      'word_meaning':
          'अन्त-वत्—having an end/temporary; तु—but; फलम्—the result; तेषाम्—of those; तत्—that; भवति—is; अल्प-मेधसाम्—of those of small intelligence; देवान्—the demigods; देव-यजः—worshippers of demigods; यान्ति—attain; मत्-भक्ताः—My devotees; यान्ति—attain; माम्—Me; अपि—also.',
      'commentary':
          'This is a crucial contrast between spiritual and material goals. Worship based on finite desires yields **temporary results** (*antavat*), while devotion to Krishna, the Supreme, yields the **eternal goal**.',
    });

    // Verse 24: The delusion of the unmanifest (Avyakta)
    await db.insert('chapter_7', {
      'verse_number': 24,
      'sanskrit':
          'अव्यक्तं व्यक्तिमापन्नं मन्यन्ते मामबुद्धयः | परं भावमजानन्तो ममाव्ययमनुत्तमम् || 24 ||',
      'translation':
          'Unintelligent men (*abuddhayaḥ*), who do not know My supreme, imperishable, and unsurpassed nature, think that I, the unmanifest, have assumed this manifest human form.',
      'word_meaning':
          'अव्यक्तम्—unmanifest; व्यक्तिम्—manifest form; आपन्नम्—having attained; मन्यन्ते—they think; माम्—Me; अबुद्धयः—the unintelligent; परम्—supreme; भावम्—nature; अजानन्तः—not knowing; मम—My; अव्ययम्—imperishable; अनुत्तमम्—unsurpassed.',
      'commentary':
          'Ignorant people mistake Krishna’s divine, transcendental manifestation for an ordinary, material birth (*janma*). They fail to grasp that the unmanifest Absolute can voluntarily appear in a visible form without losing its supreme nature.',
    });

    // Verse 25: The Lord is hidden by Yogamāyā
    await db.insert('chapter_7', {
      'verse_number': 25,
      'sanskrit':
          'नाहं प्रकाशः सर्वस्य योगमायासमावृतः | मूढोऽयं नाभिजानाति लोको मामजमव्ययम् || 25 ||',
      'translation':
          'I am not manifest to everyone, being veiled by My internal divine power, **Yoga-māyā**. This bewildered world does not recognize Me as the unborn and imperishable.',
      'word_meaning':
          'न अहम्—not I; प्रकाशः—visible/manifest; सर्वस्य—to all; योग-माया-समावृतः—covered by the power of *Yoga-māyā*; मूढः अयम्—this bewildered; लोकः—world; न अभिजानाति—does not recognize; माम्—Me; अजम्—unborn; अव्ययम्—imperishable.',
      'commentary':
          'The Lord is hidden from common perception not by external material illusion, but by His own deliberate, internal energy, **Yoga-māyā**. Only those whom He chooses to reveal Himself to can recognize Him.',
    });

    // Verse 26: The omniscience of the Lord
    await db.insert('chapter_7', {
      'verse_number': 26,
      'sanskrit':
          'वेदाहं समतीतानि वर्तमानानि चार्जुन | भविष्याणि च भूतानि मां तु वेद न कश्चन || 26 ||',
      'translation':
          'O Arjuna, I know all beings that have passed, all that are present, and all that are yet to come. But no one knows Me.',
      'word_meaning':
          'वेद अहम्—I know; समतीतानि—the past; वर्तमानानि—the present; च—and; अर्जुन—O Arjuna; भविष्याणि—the future; च—and; भूतानि—beings; माम् तु—but Me; वेद—knows; न कश्चन—no one.',
      'commentary':
          'This establishes Krishna\'s **Omniscience** across all three times (past, present, future). This knowledge is a divine prerogative; no living being can truly comprehend Him without His grace.',
    });

    // Verse 27: The delusion of dualities
    await db.insert('chapter_7', {
      'verse_number': 27,
      'sanskrit':
          'इच्छाद्वेषसमुत्थेन द्वन्द्वमोहेन भारत | सर्वभूतानि संमोहं सर्गे यान्ति परन्तप || 27 ||',
      'translation':
          'O descendant of Bharata (Arjuna), all beings are born into delusion, bewildered by the dualities (*dvandva-mohena*) arising from desire (*icchā*) and hatred (*dveṣa*).',
      'word_meaning':
          'इच्छा-द्वेष-समुत्थेन—arising from desire and hatred; द्वन्द्व-मोहेन—by the delusion of dualities; भारत—O descendant of Bharata; सर्व-भूतानि—all beings; संमोहम्—delusion; सर्गे—at the time of creation (or birth); यान्ति—attain; परन्तप—O chastiser of the enemy.',
      'commentary':
          'The delusion begins at the moment of creation/birth. The primary agents of this delusion are the feelings of **attraction (*icchā*) and aversion (*dveṣa*)**, which force the soul to seek or reject objects, blinding them to the ultimate reality.',
    });

    // Verse 28: The path for freedom from delusion
    await db.insert('chapter_7', {
      'verse_number': 28,
      'sanskrit':
          'येषां त्वन्तगतं पापं जनानां पुण्यकर्मणाम् | ते द्वन्द्वमोहनिर्मुक्ता भजन्ते मां दृढव्रताः || 28 ||',
      'translation':
          'But those persons whose sins have been completely eradicated by virtuous actions (*puṇya-karmaṇām*) become free from the delusion of dualities and worship Me with firm resolve.',
      'word_meaning':
          'येषाम् तु—but those whose; अन्त-गतम्—completely ended; पापम्—sin; जनानाम्—of persons; पुण्य-कर्मणाम्—of auspicious actions; ते—they; द्वन्द्व-मोह-निर्मुक्ताः—freed from the delusion of dualities; भजन्ते—worship; माम्—Me; दृढ-व्रताः—with firm vows.',
      'commentary':
          'Virtuous actions performed selflessly (Karma Yoga) purify the mind and destroy sin. This purity alone allows the soul to transcend dualities and engage in steadfast, unwavering devotion (*dṛḍha-vratāḥ*).',
    });

    // Verse 29: Final refuge and knowledge of the Absolute
    await db.insert('chapter_7', {
      'verse_number': 29,
      'sanskrit':
          'जरामरणमोक्षाय मामाश्रित्य यतन्ति ये | ते ब्रह्म तद्विदुः कृत्स्नमध्यात्मं कर्म चाखिलम् || 29 ||',
      'translation':
          'Those who strive for liberation from old age and death, taking refuge in Me, know the complete **Brahman**, the **Self** (*adhyātma*), and the nature of **action** (*karma*) in its entirety.',
      'word_meaning':
          'जरा-मरण-मोक्षाय—for liberation from old age and death; माम्—Me; आश्रित्य—taking refuge in; यतन्ति—they strive; ये—who; ते—they; ब्रह्म—the Absolute; तत् विदुः—they know that; कृत्स्नम्—completely; अध्यात्मम्—the knowledge of the Self; कर्म च अखिलम्—and all action in its entirety.',
      'commentary':
          'The ultimate goal is freedom from the cycle of suffering (*jarā-maraṇa-mokṣāya*). Surrendering to Krishna (*mām āśhritya*) grants not only liberation but also comprehensive knowledge of the Absolute (*Brahman*), the individual Self, and the law of *Karma*.',
    });

    // Verse 30: Knowledge at the time of death (The conclusion of Chapter 7)
    await db.insert('chapter_7', {
      'verse_number': 30,
      'sanskrit':
          'साधिभूताधिदैवं मां साधियज्ञं च ये विदुः | प्रयाणकालेऽपि च मां ते विदुर्युक्तचेतसः || 30 ||',
      'translation':
          'Those who know Me (*māṁ viduḥ*) as the Supreme Being governing all material manifestation (*adhibhūta*), the cosmic deities (*adhidaiva*), and all sacrifices (*adhiyajña*), remain steadfast in consciousness and know Me even at the time of death.',
      'word_meaning':
          'स-अधिभूत-अधिदैवम्—along with the material and cosmic manifestations; माम्—Me; स-अधियज्ञम्—along with all sacrifices; च ये—and who; विदुः—know; प्रयाण-काले—at the time of departure/death; अपि च—even; माम्—Me; ते—they; विदुः—know; युक्त-चेतसः—whose minds are steadily absorbed.',
      'commentary':
          'This provides the final benefit of true knowledge: the enlightened mind remembers the Lord at the crucial moment of death (*Prayāṇa-kāle*), which is the guarantee of eternal liberation. This sets the stage for Chapter 8, where Arjuna asks for the definitions of these terms (*Adhibhūta, Adhidaiva, Adhiyajña*).',
    });
  }

  Future<void> insertChapter8Verses(Database db) async {
    // Verse 1: Arjuna's questions (Part 1/2)
    await db.insert('chapter_8', {
      'verse_number': 1,
      'sanskrit':
          'अर्जुन उवाच | किं तद्ब्रह्म किमध्यात्मं किं कर्म पुरुषोत्तम | अधिभूतं च किं प्रोक्तमधिदैवं किमुच्यते || 1 ||',
      'translation':
          'Arjuna said: O Supreme Divine Personality (Puruṣhottama), what is that **Brahman** (Absolute Reality)? What is **Adhyātma** (the individual soul)? And what is **Karma** (the law of action)? What is said to be **Adhibhūta** (the material manifestation), and who is called **Adhidaiva** (the Lord of the celestial beings)?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; किम्—what; तत्—that; ब्रह्म—Brahman; किम्—what; अध्यात्मम्—the individual soul; किम्—what; कर्म—the principle of karma; पुरुष-उत्तम—O Supreme Divine Personality (Krishna); अधिभूतम्—the material manifestation; च किम्—and what; प्रोक्तम्—is called; अधिदैवम्—the Lord of the celestial beings; किम् उच्यते—is said to be.',
      'commentary':
          'Arjuna begins Chapter 8 with seven questions seeking definitions for the metaphysical terms Krishna used at the end of Chapter 7, specifically seeking to understand the relationship between the Lord and the cosmos.',
    });

    // Verse 2: Arjuna's questions (Part 2/2) - The crucial question
    await db.insert('chapter_8', {
      'verse_number': 2,
      'sanskrit':
          'अधियज्ञः कथं कोऽत्र देहेऽस्मिन्मधुसूदन | प्रयाणकाले च कथं ज्ञेयोऽसि नियतात्मभिः || 2 ||',
      'translation':
          'Who is **Adhiyajña** (the Lord of all sacrifices) in this body, and how is He situated here, O Madhusūdana? And at the time of death (*prayāṇa-kāle*), how are You to be known by those of controlled minds?',
      'word_meaning':
          'अधियज्ञः—Adhiyajña; कथम्—how; कः—who; अत्र देहे—here in this body; अस्मिन्—this; मधुसूदन—O Madhusūdana; प्रयाण-काले—at the time of departure (death); च कथम्—and how; ज्ञेयः—to be known; असि—are You; नियत-आत्मभिः—by those of controlled minds.',
      'commentary':
          'The seventh and most critical question is about the remembrance of God at the moment of death, which governs the soul\'s ultimate destination. This sets the central theme for the entire chapter.',
    });

    // Verse 3: Krishna answers: Brahman, Adhyātma, and Karma
    await db.insert('chapter_8', {
      'verse_number': 3,
      'sanskrit':
          'श्रीभगवानुवाच | अक्षरं ब्रह्म परमं स्वभावोऽध्यात्ममुच्यते | भूतभावोद्भवकरो विसर्गः कर्मसंज्ञितः || 3 ||',
      'translation':
          'The Supreme Lord said: **Brahman** is the Imperishable Supreme Entity; **Adhyātma** is one’s own essential nature (the individual soul); the creative force that causes beings to spring forth into manifestation is called **Karma** (action).',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; अक्षरम्—imperishable; ब्रह्म—Brahman; परमम्—supreme; स्वभावः—one’s own nature; अध्यात्मम्—Adhyātma; उच्यते—is called; भूत-भाव-उद्भव-करः—the cause of the manifestation of living beings; विसर्गः—creation/offering; कर्म-संज्ञितः—designated as Karma.',
      'commentary':
          'Krishna defines the three most abstract terms: Brahman is the ultimate reality; Adhyātma is the individual soul\'s core identity; and Karma refers to the subtle creative impulse that leads to the birth of living entities.',
    });

    // Verse 4: Krishna answers: Adhibhūta, Adhidaiva, and Adhiyajña
    await db.insert('chapter_8', {
      'verse_number': 4,
      'sanskrit':
          'अधिभूतं क्षरो भावः पुरुषश्चाधिदैवतम् | अधियज्ञोऽहमेवात्र देहे देहभृतां वर || 4 ||',
      'translation':
          'O best of the embodied souls, the perishable physical manifestation is called **Adhibhūta**; the cosmic controller (Universal Form of God) is **Adhidaiva**; and I, who dwell in the heart of every living being, am called **Adhiyajña** (the Lord of all sacrifices) in this body.',
      'word_meaning':
          'अधिभूतम्—Adhibhūta; क्षरः—perishable; भावः—nature; पुरुषः—the universal form of God; च अधिदैवतम्—and Adhidaiva; अधियज्ञः—Adhiyajña; अहम् एव—I alone am; अत्र देहे—here in this body; देह-भृताम् वर—O best of the embodied.',
      'commentary':
          'Krishna completes the definitions: Adhibhūta (the mutable physical world), Adhidaiva (the animating cosmic principle), and Adhiyajña (the Supreme Lord residing in the heart as the witness and receiver of sacrifice).',
    });

    // Verse 5: The law of remembrance at death
    await db.insert('chapter_8', {
      'verse_number': 5,
      'sanskrit':
          'अन्तकाले च मामेव स्मरन्मुक्त्वा कलेवरम् | यः प्रयाति स मद्भावं याति नास्त्यत्र संशयः || 5 ||',
      'translation':
          'One who, at the time of death (*anta-kāle*), relinquishes the body while remembering Me alone, certainly attains My nature (*mad-bhāvaṁ*). There is no doubt about this.',
      'word_meaning':
          'अन्त-काले—at the time of the end (death); च—and; माम् एव—Me alone; स्मरन्—remembering; मुक्त्वा—having given up; कलेवरम्—the body; यः—who; प्रयाति—departs; सः—he; मद्-भावम्—My nature; याति—attains; न अस्ति—there is no; अत्र—here; संशयः—doubt.',
      'commentary':
          'This is the cornerstone verse for the chapter: the state of one\'s consciousness at the moment of death determines their next destination. Remembering God leads directly to the divine abode.',
    });

    // Verse 6: The general principle of death
    await db.insert('chapter_8', {
      'verse_number': 6,
      'sanskrit':
          'यं यं वापि स्मरन्भावं त्यजत्यन्ते कलेवरम् | तं तमेवैति कौन्तेय सदा तद्भावभावितः || 6 ||',
      'translation':
          'O son of Kuntī, whatever state of being one remembers upon relinquishing the body at the time of death, that state alone one attains, being always absorbed in that contemplation.',
      'word_meaning':
          'यम् यम्—whatever; वा अपि—or; स्मरन्—remembering; भावम्—state of being; त्यजति—gives up; अन्ते—at the end; कलेवरम्—the body; तम् तम् एव—that very state; एति—attains; कौन्तेय—O son of Kuntī; सदा—always; तत्-भाव-भावितः—being absorbed in that state.',
      'commentary':
          'This provides the philosophical reason for Verse 5: The focus of the mind throughout life creates the dominant impression (*bhāva*) that manifests at death. The object of one\'s lifelong thought becomes the destination.',
    });

    // Verse 7: The command for constant remembrance and action
    await db.insert('chapter_8', {
      'verse_number': 7,
      'sanskrit':
          'तस्मात्सर्वेषु कालेषु मामनुस्मर युध्य च | मय्यर्पितमनोबुद्धिर्मामेवैष्यस्यसंशयः || 7 ||',
      'translation':
          'Therefore, always remember Me and also perform your duty of fighting. With your mind and intellect dedicated to Me, you will certainly attain Me; of this, there is no doubt.',
      'word_meaning':
          'तस्मात्—therefore; सर्वेषु कालेषु—at all times; माम्—Me; अनुस्मर—remember constantly; युध्य—fight; च—and; मयि—unto Me; अर्पित-मनः-बुद्धिः—with mind and intellect surrendered; माम् एव—Me alone; एष्यसि—you will attain; असंशयः—without doubt.',
      'commentary':
          'Krishna gives the synthesis of *Bhakti* and *Karma Yoga* one final time: the key is to integrate the spiritual goal (remembrance) with the material duty (action), ensuring that the mind and intellect are fixed on God even while engaged in worldly affairs.',
    });

    // Verse 8: The path of practice (Abhyāsa)
    await db.insert('chapter_8', {
      'verse_number': 8,
      'sanskrit':
          'अभ्यासयोगयुक्तेन चेतसा नान्यगामिना | परमं पुरुषं दिव्यं याति पार्थानुचिन्तयन् || 8 ||',
      'translation':
          'O Pārtha, by constantly engaging the mind in thinking of Me, without deviation, and practicing the Yoga of meditation (*abhyāsa-yoga*), one attains the Supreme Divine Personality.',
      'word_meaning':
          'अभ्यास-योग-युक्तेन—by one who is engaged in the Yoga of constant practice; चेतसा—with the mind; न अन्य-गामिना—not moving toward anything else; परमम्—Supreme; पुरुषम्—Personality; दिव्यम्—Divine; याति—attains; पार्थ—O Pārtha; अनुचिन्तयन्—contemplating/thinking constantly.',
      'commentary':
          'The method to achieve remembrance at death is **Abhyāsa Yoga** (disciplined, non-wavering practice). This requires constantly redirecting the mind to the object of meditation.',
    });

    // Verse 9: Description of the Supreme Being (Object of Meditation)
    await db.insert('chapter_8', {
      'verse_number': 9,
      'sanskrit':
          'कविं पुराणमनुशासितार- मणोरणीयांसमनुस्मरेद्यः | सर्वस्य धातारमचिन्त्यरूप- मादित्यवर्णं तमसः परस्तात् || 9 ||',
      'translation':
          'The Yogi should meditate on the Omniscient, the most ancient, the Controller, subtler than the subtlest, the Support of all, the possessor of an inconceivable divine form, brighter than the sun, and beyond all darkness.',
      'word_meaning':
          'कविम्—the Omniscient/seer; पुराणम्—the most ancient; अनुशासितारम्—the controller; अणोः अणीयांसम्—subtler than the subtlest; अनुस्मरेत्—should remember; यः—who; सर्वस्य धातारम्—the maintainer of all; अचिन्त्य-रूपम्—of an inconceivable form; आदित्य-वर्णम्—brighter than the sun; तमसः—darkness; परस्तात्—beyond.',
      'commentary':
          'Krishna provides a meditative description of the Supreme Being, using eight powerful attributes that affirm His greatness, transcendence, and infinite power.',
    });

    // Verse 10: The process of yogic departure at death
    await db.insert('chapter_8', {
      'verse_number': 10,
      'sanskrit':
          'प्रयाणकाले मनसाचलेन भक्त्या युक्तो योगबलेन चैव | भ्रुवोर्मध्ये प्राणं आवेश्य सम्यक् स तं परं पुरुषमुपैति दिव्यम् || 10 ||',
      'translation':
          'One who, at the time of death, with an unmoving mind attained by the practice of Yoga, fixes the life-airs (*prāṇa*) between the eyebrows, and steadily remembers the Divine Lord with great devotion, certainly attains the Supreme Divine Personality.',
      'word_meaning':
          'प्रयाण-काले—at the time of departure (death); मनसा अचलेन—with an unmoving mind; भक्त्या युक्तः—united with devotion; योग-बलेन—by the power of Yoga; च एव—and certainly; भ्रुवोः मध्ये—between the eyebrows; प्राणम्—the life-breath; आवेश्य—fixing; सम्यक्—steadily; सः—he; तम्—that; परम् पुरुषम्—Supreme Personality; उपैति—attains; दिव्यम्—Divine.',
      'commentary':
          'This integrates *Dhyāna Yoga* with the moment of death. By using the spiritual power (*yoga-balena*) developed through life, the Yogi controls the mind and concentrates the life-force, guaranteeing union with the Supreme Lord.',
    });

    // Verse 11: Introduction to the path of Akṣhara (The Imperishable)
    await db.insert('chapter_8', {
      'verse_number': 11,
      'sanskrit':
          'यदक्षरं वेदविदो वदन्ति विशन्ति यद्यतयो वीतरागाः | यदिच्छन्तो ब्रह्मचर्यं चरन्ति तत्ते पदं सङ्ग्रहेण प्रवक्ष्ये || 11 ||',
      'translation':
          'That which is declared imperishable (*Akṣharaṁ*) by the knowers of the Vedas, that which **dispassionate ascetics** enter, and desiring which they practice celibacy (*brahmacharyaṁ*); that goal I shall briefly explain to you.',
      'word_meaning':
          'यत् अक्षरम्—which is the Imperishable; वेद-विदः—knowers of the Vedas; वदन्ति—declare; विशन्ति—enter; यत्—which; यतयः—sages/ascetics; वीत-रागाः—free from attachment; यत् इच्छन्तः—desiring which; ब्रह्मचर्यम्—celibacy; चरन्ति—practice; तत् ते—that to you; पदम्—goal; सङ्ग्रहेण—briefly; प्रवक्ष्ये—I shall explain.',
      'commentary':
          'Krishna introduces the path to the **impersonal Brahman** (*Akṣhara*)—a path characterized by intense austerity, renunciation, and celibacy, traditionally considered arduous.',
    });

    // Verse 12: The yogic process of controlling the body at death (1/2)
    await db.insert('chapter_8', {
      'verse_number': 12,
      'sanskrit':
          'सर्वद्वाराणि संयम्य मनो हृदि निरुध्य च | मूर्ध्न्याधायात्मनः प्राणमास्थितो योगधारणाम् || 12 ||',
      'translation':
          'Restraining all the gates of the body, confining the mind in the heart, and then fixing the life-breath (*prāṇa*) in the head, engaging in steadfast yogic concentration,',
      'word_meaning':
          'सर्व-द्वाराणि—all gates (of the body/senses); संयम्य—restraining; मनः—mind; हृदि—in the heart; निरुध्य—confining; च—and; मूर्ध्नि—in the head; आधाय—fixing; आत्मनः—one\'s own; प्राणम्—life-breath; आस्थितः—established; योग-धारणाम्—in yogic concentration.',
      'commentary':
          'Krishna describes the physical practice (*Dhāraṇā*) used by Yogis for conscious departure at death: withdrawing the senses, concentrating the mind, and elevating the life-force (*prāṇa*) to the crown of the head.',
    });

    // Verse 13: The culmination: Chanting Om and remembering Krishna
    await db.insert('chapter_8', {
      'verse_number': 13,
      'sanskrit':
          'ओमित्येकाक्षरं ब्रह्म व्याहरन्मामनुस्मरन् | यः प्रयाति त्यजन्देहं स याति परमां गतिम् || 13 ||',
      'translation':
          'One who departs, leaving the body while chanting the single syllable **Om** (*Brahma*) and remembering Me, attains the Supreme Goal.',
      'word_meaning':
          'ओम् इति—the syllable Om; एक-अक्षरम्—the one syllable; ब्रह्म—Brahman; व्याहरन्—uttering; माम्—Me; अनुस्मरन्—remembering constantly; यः प्रयाति—who departs; त्यजन् देहम्—leaving the body; सः याति—he attains; परमाम् गतिम्—the Supreme Goal.',
      'commentary':
          'This combines the practices: the impersonal path uses the mantra **Om** (the sound vibration of Brahman), while the personal path uses **remembrance of Krishna**. Either practice, performed at the moment of death, leads to the highest state.',
    });

    // Verse 14: The superior ease of Bhakti Yoga
    await db.insert('chapter_8', {
      'verse_number': 14,
      'sanskrit':
          'अनन्यचेताः सततं यो मां स्मरति नित्यशः | तस्याहं सुलभः पार्थ नित्ययुक्तस्य योगिनः || 14 ||',
      'translation':
          'O Pārtha, I am easily attainable by that ever-steadfast Yogi who constantly remembers Me daily, not thinking of anything else.',
      'word_meaning':
          'अनन्य-चेताः—whose mind is undeviated/single-pointed; सततम्—constantly; यः माम्—who Me; स्मरति—remembers; नित्यशः—daily; तस्य अहम्—to him I; सुलभः—easily attainable; पार्थ—O Pārtha; नित्य-युक्तस्य—of the constantly united; योगिनः—Yogi.',
      'commentary':
          'Krishna gently guides Arjuna back to **Bhakti Yoga**, asserting that the path of personal devotion is **easier (*sulabhaḥ*)** than the difficult Yogic austerities, provided the devotion is **exclusive (*ananya-cetāḥ*)** and constant.',
    });

    // Verse 15: The goal of the great souls
    await db.insert('chapter_8', {
      'verse_number': 15,
      'sanskrit':
          'मामुपेत्य पुनर्जन्म दुःखालयमशाश्वतम् | नाप्नुवन्ति महात्मानः संसिद्धिं परमां गताः || 15 ||',
      'translation':
          'Having attained Me, the great souls (*mahātmānaḥ*)—who have reached the highest perfection—never return to this miserable, temporary abode of repeated birth.',
      'word_meaning':
          'माम् उपेत्य—having attained Me; पुनः जन्म—rebirth; दुःख-आलयम्—abode of sorrow; अ-शाश्वतम्—temporary; न आप्नुवन्ति—they do not attain; महा-आत्मानः—the great souls; संसिद्धिम्—perfection; पराम्—supreme; गताः—attained.',
      'commentary':
          'The ultimate destination achieved through remembering God is permanent liberation. The material world is clearly labeled as an **abode of sorrow (*duḥkhālayam*)** and is temporary, contrasting sharply with the eternal spiritual world.',
    });

    // Verse 16: The limitations of material abodes
    await db.insert('chapter_8', {
      'verse_number': 16,
      'sanskrit':
          'आब्रह्मभुवनाल्लोकाः पुनरावर्तिनोऽर्जुन | मामुपेत्य तु कौन्तेय पुनर्जन्म न विद्यते || 16 ||',
      'translation':
          'O Arjuna, all the worlds, from the realm of Brahmā downward, are places of repeated return (*punarāvartino*). But upon attaining Me, O son of Kuntī, there is no rebirth.',
      'word_meaning':
          'आ-ब्रह्म-भुवनात्—from the abode of Brahmā; लोकाः—worlds; पुनः-आवर्तिनः—subject to return; अर्जुन—O Arjuna; माम् उपेत्य—upon attaining Me; तु—but; कौन्तेय—O son of Kuntī; पुनः जन्म—rebirth; न विद्यते—does not exist.',
      'commentary':
          'This establishes the supremacy of Krishna’s abode. Since all material realms are subject to creation and dissolution (Verse 18), only the spiritual realm (Krishna\'s abode) offers permanent freedom from the cycle of time and decay.',
    });

    // Verse 17: The scale of cosmic time (Brahmā's Day)
    await db.insert('chapter_8', {
      'verse_number': 17,
      'sanskrit':
          'सहस्रयुगपर्यन्तमहर्यद्ब्रह्मणो विदुः | रात्रिं युगसहस्रान्तां तेऽहोरात्रविदो जनाः || 17 ||',
      'translation':
          'Those who know that Brahmā’s day lasts for a thousand epochs (*yugas*) and that his night also extends for a thousand *yugas*—they are the knowers of the cosmic cycle of day and night.',
      'word_meaning':
          'सहस्र-युग-पर्यन्तम्—ending in one thousand *yugas*; अहः—day; यत्—which; ब्रह्मणः—of Brahmā; विदुः—they know; रात्रिम्—night; युग-सहस्र-अन्ताम्—ending in one thousand *yugas*; ते—they; अहो-रात्र-विदः—knowers of day and night; जनाः—people.',
      'commentary':
          'This provides the scale of time in the material universe. One day (and night) of Brahmā, the creator, encompasses billions of human years, emphasizing the immense duration of the material cycles.',
    });

    // Verse 18: Manifestation during Brahmā's Day
    await db.insert('chapter_8', {
      'verse_number': 18,
      'sanskrit':
          'अव्यक्ताद्व्यक्तयः सर्वाः प्रभवन्त्यहरागमे | रात्र्यागमे प्रलीयन्ते तत्रैवाव्यक्तसंज्ञके || 18 ||',
      'translation':
          'At the beginning of Brahmā’s day, all manifested beings issue forth from the unmanifest state; and at the coming of his night, they are dissolved again into that same state, known as the unmanifest.',
      'word_meaning':
          'अव्यक्तात्—from the unmanifest; व्यक्तयः—manifestations; सर्वाः—all; प्रभवन्ति—come forth; अहर्-आगमे—at the coming of the day; रात्रि-आगमे—at the coming of the night; प्रलीयन्ते—are dissolved; तत्र एव—into that very; अव्यक्त-संज्ञके—called the unmanifest.',
      'commentary':
          'The material world undergoes cyclical creation and dissolution, driven by the cosmic clock of Brahmā. Manifestation and dissolution are continuous, natural processes for everything within the material energy.',
    });

    // Verse 19: Repeated dissolution and creation
    await db.insert('chapter_8', {
      'verse_number': 19,
      'sanskrit':
          'भूतग्रामः स एवायं भूत्वा भूत्वा प्रलीयते | रात्र्यागमेऽवशः पार्थ प्रभवत्यहरागमे || 19 ||',
      'translation':
          'The multitude of beings, repeatedly coming into existence, dissolve helplessly at the coming of night, O Pārtha, and come forth again at the coming of day.',
      'word_meaning':
          'भूत-ग्रामः—the multitude of beings; सः एव अयम्—that same; भूत्वा भूत्वा—repeatedly coming into being; प्रलीयते—is dissolved; रात्रि-आगमे—at the coming of night; अवशः—helplessly; पार्थ—O Pārtha; प्रभवति—comes forth; अहर्-आगमे—at the coming of day.',
      'commentary':
          'The key word is **helplessly (*avaśhaḥ*)**. The multitude of living beings are swept along by the current of cosmic time, repeatedly taking birth and dying without conscious control.',
    });

    // Verse 20: The transcendental, eternal reality
    await db.insert('chapter_8', {
      'verse_number': 20,
      'sanskrit':
          'परस्तस्मात्तु भावोऽन्योऽव्यक्तोऽव्यक्तात्सनातनः | यः स सर्वेषु भूतेषु नश्यत्सु न विनश्यति || 20 ||',
      'translation':
          'But beyond this unmanifest (material) nature, there is yet another, the **Eternal Unmanifest** (*Sanātanaḥ Avyaktaḥ*). That supreme spiritual reality does not perish when all these material beings perish.',
      'word_meaning':
          'परः—superior; तस्मात् तु—but than that; भावः—nature; अन्यः—other; अव्यक्तः—unmanifest; अव्यक्तात्—than the unmanifest; सनातनः—eternal; यः सः—which that; सर्वेषु भूतेषु—in all beings; नश्यत्सु—perishing; न विनश्यति—does not perish.',
      'commentary':
          'This contrasts the **lower unmanifest** (the subtle material cause of creation) with the **higher, eternal unmanifest** (the Supreme Spiritual Reality). This spiritual reality is the true goal, as it is beyond the temporal cycles of the material world.',
    });

    // Verse 21: The Supreme Abode (Paramā Gati)
    await db.insert('chapter_8', {
      'verse_number': 21,
      'sanskrit':
          'अव्यक्तोऽक्षर इत्युक्तस्तमाहुः परमां गतिम् | यं प्राप्य न निवर्तन्ते तद्धाम परमं मम || 21 ||',
      'translation':
          'This **Unmanifest Imperishable** is declared the highest goal. That is My Supreme Abode, reaching which they never return.',
      'word_meaning':
          'अव्यक्तः—the unmanifest; अक्षरः—the imperishable; इति उक्तः—thus called; तम् आहुः—they call that; पराम् गतिम्—the supreme destination/goal; यम् प्राप्य—having reached which; न निवर्तन्ते—they do not return; तत् धाम—that abode; परमम्—supreme; मम—My.',
      'commentary':
          'The *Sanātanaḥ Avyaktaḥ* (Eternal Unmanifest) introduced in Verse 20 is identified here as the **Supreme Abode** (*dhāma*) of Krishna, the ultimate destination from which there is no return to the cycle of rebirth. It is both unmanifest and imperishable.',
    });

    // Verse 22: Attaining the Supreme through devotion
    await db.insert('chapter_8', {
      'verse_number': 22,
      'sanskrit':
          'पुरुषः स परः पार्थ भक्त्या लभ्यस्त्वनन्यया | यस्यान्तःस्थानि भूतानि येन सर्वमिदं ततम् || 22 ||',
      'translation':
          'That Supreme Person (*Puruṣha*), O Pārtha, within whom all beings reside and by whom this entire universe is pervaded, is attained only through **exclusive devotion** (*ananyayā bhaktyā*).',
      'word_meaning':
          'पुरुषः—Person; सः परः—that Supreme; पार्थ—O Pārtha; भक्त्या—by devotion; लभ्यः—is attainable; तु—but; अनन्यया—exclusive/undivided; यस्य—whose; अन्तः-स्थानि—situated within; भूतानि—beings; येन—by whom; सर्वम्—all; इदम्—this; ततम्—is pervaded.',
      'commentary':
          'This is a crucial verse re-emphasizing the **personal aspect** of the Absolute Truth. The Supreme *Puruṣha* is the source and container of all creation, yet is only accessible via unswerving, single-pointed devotion (*ananyā bhakti*), making the path of love superior to the path of arduous austerity.',
    });

    // Verse 23: Introduction to the two paths of departure
    await db.insert('chapter_8', {
      'verse_number': 23,
      'sanskrit':
          'यत्र काले त्वनावृत्तिमावृत्तिं चैव योगिनः | प्रयाता यान्ति तं कालं वक्ष्यामि भरतर्षभ || 23 ||',
      'translation':
          'O best of the Bharatas, I shall now declare to you the time when Yogis depart—at which they either return (to rebirth) or do not return.',
      'word_meaning':
          'यत्र काले—at which time; तु—indeed; अनावृत्तिम्—non-return; आवृत्तिम्—return; च एव—and also; योगिनः—Yogis; प्रयाताः—departing; यान्ति—go; तम् कालम्—that time; वक्ष्यामि—I shall speak; भरतर्षभ—O best of the Bharatas (Arjuna).',
      'commentary':
          'Krishna begins the description of *Kāla* (time) as it relates to the soul\'s destination, explaining the conditions that lead to liberation versus return.',
    });

    // Verse 24: The path of light (Shukla Gati) – Path of no return
    await db.insert('chapter_8', {
      'verse_number': 24,
      'sanskrit':
          'अग्निर्ज्योतिरहः शुक्लः षण्मासा उत्तरायणम् | तत्र प्रयाता गच्छन्ति ब्रह्म ब्रह्मविदो जनाः || 24 ||',
      'translation':
          'Fire, light, smoke-free time, the bright fortnight, the six months of the northern passage of the sun (*uttarāyaṇa*)—departing then, the knowers of Brahman go to Brahman and do not return.',
      'word_meaning':
          'अग्निः—fire; ज्योतिः—light; अहः—day; शुक्लः—the bright fortnight (waxing moon); षण्मासाः—six months; उत्तरायणम्—northern passage (of the sun); तत्र—there/then; प्रयाताः—departed; गच्छन्ति—go; ब्रह्म—to Brahman; ब्रह्म-विदः—knowers of Brahman; जनाः—people.',
      'commentary':
          'This path is symbolic of **Knowledge** (*Jñāna*) and is referred to as the path of light (*Śukla Gati* or *Arcis Mārga*). These periods (fire, light, day, etc.) are guiding deities or influences that enable the soul to reach Brahman and attain liberation.',
    });

    // Verse 25: The path of darkness (Kṛṣhṇa Gati) – Path of return
    await db.insert('chapter_8', {
      'verse_number': 25,
      'sanskrit':
          'धूमो रात्रिस्तथा कृष्णः षण्मासा दक्षिणायनम् | तत्र चान्द्रमसं ज्योतिर्योगी प्राप्य निवर्तते || 25 ||',
      'translation':
          'Smoke, night, the dark fortnight (waning moon), the six months of the southern passage of the sun (*dakṣhiṇāyana*)—departing then, the Yogi attains the lunar light (*Cāndramasaṁ Jyoti*), and returns to rebirth.',
      'word_meaning':
          'धूमः—smoke; रात्रिः—night; तथा—similarly; कृष्णः—the dark fortnight; षण्मासाः—six months; दक्षिणायनम्—southern passage (of the sun); तत्र—then; चान्द्रमसम्—lunar; ज्योतिः—light; योगी—Yogi; प्राप्य—having attained; निवर्तते—returns (to earth).',
      'commentary':
          'This is the path of darkness (*Kṛṣhṇa Gati* or *Dhūma Mārga*), symbolic of ritualistic action (*Karma*). Souls on this path reach the lunar realms (heavenly planets) to enjoy the fruits of their pious deeds, but must eventually return to the mortal world upon the exhaustion of their merit.',
    });

    // Verse 26: The two eternal paths
    await db.insert('chapter_8', {
      'verse_number': 26,
      'sanskrit':
          'शुक्लकृष्णे गती ह्येते जगतः शाश्वते मते | एकया यात्यनावृत्तिमन्ययावर्तते पुनः || 26 ||',
      'translation':
          'These two paths—the path of light (*Śukla*) and the path of darkness (*Kṛṣhṇa*)—are considered the world’s two eternal ways. By one, one attains non-return; by the other, one returns again.',
      'word_meaning':
          'शुक्ल-कृष्णे—light and dark; गती—paths; हि—indeed; एते—these two; जगतः—of the world; शाश्वते—eternal; मते—are considered; एकया—by one; याति—goes; अनावृत्तिम्—non-return; अन्यया—by the other; आवर्तते—returns; पुनः—again.',
      'commentary':
          'The two paths represent two eternal laws: the law of liberation through transcendental knowledge/devotion, and the law of cyclical return through material action/enjoyment. They are not dependent on fate, but on the soul\'s attachment and practice.',
    });

    // Verse 27: The Yogi is not bewildered by these paths
    await db.insert('chapter_8', {
      'verse_number': 27,
      'sanskrit':
          'नैते सृती पार्थ जानन्योगी मुह्यति कश्चन | तस्मात्सर्वेषु कालेषु योगयुक्तो भवार्जुन || 27 ||',
      'translation':
          'A Yogi who knows these two paths, O Pārtha, is never bewildered. Therefore, O Arjuna, be steadfastly established in Yoga at all times.',
      'word_meaning':
          'न एते—not these two; सृती—paths; पार्थ—O Pārtha; जानन्—knowing; योगी—Yogi; मुह्यति—is bewildered; कश्चन—ever; तस्मात्—therefore; सर्वेषु कालेषु—at all times; योग-युक्तः—fixed in Yoga; भव—be; अर्जुन—O Arjuna.',
      'commentary':
          'The *Yogi* (practitioner of devotion) is unconcerned with the auspiciousness of the moment of death because their continuous remembrance of God (Verse 14) is sufficient to guarantee the path of non-return. The focus shifts back from *when* to depart, to **how** to live: constantly engaged in *Yoga* (union with Krishna).',
    });

    // Verse 28: Conclusion and glorification of the Yogi
    await db.insert('chapter_8', {
      'verse_number': 28,
      'sanskrit':
          'वेदेषु यज्ञेषु तपःसु चैव दानेषु यत्पुण्यफलं प्रदिष्टम् | अत्येति तत्सर्वमिदं विदित्वा योगी परं स्थानमुपैति चाद्यम् || 28 ||',
      'translation':
          'The Yogi, knowing this truth, surpasses the results of merit declared for the study of the Vedas, for sacrifices, for austerities, and for charities. He attains the Supreme, Primeval Abode.',
      'word_meaning':
          'वेदेषु—in the Vedas (study); यज्ञेषु—in sacrifices; तपःसु—in austerities; च एव—and also; दानेषु—in charities; यत् पुण्य-फलम्—the result of merit; प्रदिष्टम्—declared; अत्येति—surpasses; तत् सर्वम्—all that; इदम् विदित्वा—knowing this (truth); योगी—Yogi; परम् स्थानम्—the Supreme Abode; उपैति—attains; च आद्यम्—and primeval/original.',
      'commentary':
          'This final verse concludes the chapter by glorifying the path of *Bhakti-Yoga* (devotion). The fruit of devotion—attaining the Supreme Abode (Verse 21)—is shown to be far superior to the temporary heavenly results gained from religious rituals, penances, and charity mentioned in the Vedas. The "truth" known by the Yogi is the entirety of Chapter 8, particularly the non-returning nature of the Supreme Abode.',
    });
  }

  Future<void> insertChapter9Verses(Database db) async {
    // Verse 1: The Supreme Secret Revealed
    await db.insert('chapter_9', {
      'verse_number': 1,
      'sanskrit':
          'श्रीभगवानुवाच | इदं तु ते गुह्यतमं प्रवक्ष्याम्यनसूयवे | ज्ञानं विज्ञानसहितं यज्ज्ञात्वा मोक्ष्यसेऽशुभात् || 1 ||',
      'translation':
          'The Supreme Lord said: Since you are not envious, I shall now declare to you this **most confidential knowledge** (*guhyatamaṁ*), along with its realization (*vijñāna*), knowing which you will be freed from the inauspicious.',
      'word_meaning':
          'श्रीभगवान् उवाच—The Supreme Lord said; इदम्—this; तु—indeed; ते—to you; गुह्य-तमम्—the most confidential; प्रवक्ष्यामि—I shall speak; अनसूयवे—to one who is non-envious; ज्ञानम्—knowledge; विज्ञान-सहितम्—along with realization; यत् ज्ञात्वा—knowing which; मोक्ष्यसे—you will be freed; अशुभात्—from inauspiciousness (the bondage of *saṁsāra*).',
      'commentary':
          'Krishna introduces this chapter as the central, most profound teaching of the Gita. **Non-enviousness** (*anasūyave*) is the essential qualification for receiving this supreme knowledge of *Bhakti* (devotion).',
    });

    // Verse 2: The King of Knowledge
    await db.insert('chapter_9', {
      'verse_number': 2,
      'sanskrit':
          'राजविद्या राजगुह्यं पवित्रमिदमुत्तमम् | प्रत्यक्षावगमं धर्म्यं सुसुखं कर्तुमव्ययम् || 2 ||',
      'translation':
          'This knowledge is the **King of all sciences** (*Rāja-Vidyā*), the **King of all secrets** (*Rāja-Guhyam*), the supreme purifier. It is known by direct experience, is in accordance with *Dharma*, is **easy to practice**, and is everlasting.',
      'word_meaning':
          'राज-विद्या—king of knowledge; राज-गुह्यम्—king of secrets; पवित्रम्—purifier; इदम् उत्तमम्—this is supreme; प्रत्यक्ष-अवगमम्—known by direct experience; धर्म्यम्—in accordance with *Dharma*; सु-सुखम्—very joyous/easy; कर्तुम्—to practice; अव्ययम्—imperishable.',
      'commentary':
          'The practice of *Bhakti-Yoga* is extolled over all other forms of knowledge. Its unique qualities are that it is verifiable by **direct experience** (*pratyakṣhāvagamaṁ*) and is **joyously easy to perform** (*su-sukhaṁ kartum*), unlike the difficult austerities of other paths.',
    });

    // Verse 3: Consequences of Lack of Faith
    await db.insert('chapter_9', {
      'verse_number': 3,
      'sanskrit':
          'अश्रद्दधानाः पुरुषा धर्मस्यास्य परन्तप | अप्राप्य मां निवर्तन्ते मृत्युसंसारवर्त्मनि || 3 ||',
      'translation':
          'O scorcher of foes (Arjuna), men who lack faith in this *Dharma* (the path of devotion) fail to attain Me. They return to the path of the cycle of death and rebirth.',
      'word_meaning':
          'अश्रद्दधानाः—lacking faith; पुरुषाः—persons; धर्मस्य अस्य—in this *Dharma* (religious principle/path); परन्तप—O scorcher of foes; अप्राप्य माम्—failing to attain Me; निवर्तन्ते—they return; मृत्यु-संसार-वर्त्मनि—to the path of death and rebirth.',
      'commentary':
          '**Faith** (*śhraddhā*) is the foundation of spiritual life. Without sincere belief in the path of devotion, one cannot transcend the cycle of *saṁsāra* (repeated birth and death).',
    });

    // Verse 4: Immanence and Transcendence (The Paradox)
    await db.insert('chapter_9', {
      'verse_number': 4,
      'sanskrit':
          'मया ततमिदं सर्वं जगदव्यक्तमूर्तिना | मत्स्थानि सर्वभूतानि न चाहं तेष्ववस्थितः || 4 ||',
      'translation':
          'This entire universe is pervaded by Me in My **unmanifest form**. All beings are situated in Me, yet **I am not situated in them**.',
      'word_meaning':
          'मया—by Me; ततम्—pervaded; इदम् सर्वम्—all this; जगत्—universe; अव्यक्त-मूर्तिना—by the unmanifest form; मत्-स्थानि—situated in Me; सर्व-भूतानि—all beings; न च अहम्—nor am I; तेषु—in them; अवस्थितः—situated.',
      'commentary':
          'Krishna describes His paradoxical and mysterious relationship with creation. He is the support (immanent) and source of all things, yet He remains completely independent, unaffected, and transcendent.',
    });

    // Verse 5: The Divine Opulence (*Yoga Aiśhvara*)
    await db.insert('chapter_9', {
      'verse_number': 5,
      'sanskrit':
          'न च मत्स्थानि भूतानि पश्य मे योगमैश्वरम् | भूतभृन्न च भूतस्थो ममात्मा भूतभावनः || 5 ||',
      'translation':
          'Nor are the beings truly situated in Me (in a limited sense). **Behold My Divine Opulence** (*Yoga Aiśhvaraṁ*): I am the **maintainer of all beings** and the **origin of all beings**, yet My Self is not dwelling in them.',
      'word_meaning':
          'न च—nor indeed; मत्-स्थानि—situated in Me; भूतानि—beings; पश्य—behold; मे—My; योगम् ऐश्वरम्—divine opulence/mystic power; भूत-भृत्—supporter of beings; न च—nor; भूत-स्थः—situated in beings; मम आत्मा—My Self; भूत-भावनः—origin of beings.',
      'commentary':
          'This verse resolves the paradox by declaring the relationship to be **transcendental** (*Yoga Aiśhvaraṁ*). The support He provides is not material or physically dependent; it is a display of His inconceivable power, allowing Him to remain detached.',
    });

    // Verse 6: Analogy of the Wind
    await db.insert('chapter_9', {
      'verse_number': 6,
      'sanskrit':
          'यथाकाशस्थितो नित्यं वायुः सर्वत्रगो महान् | तथा सर्वाणि भूतानि मत्स्थानीत्युपधारय || 6 ||',
      'translation':
          'Just as the mighty wind, which moves everywhere, always rests in the space (*ākāśha*), similarly, know that all beings rest in Me.',
      'word_meaning':
          'यथा—just as; आकाश-स्थितः—situated in the space; नित्यम्—always; वायुः—wind; सर्वत्र-गः—moving everywhere; महान्—great/mighty; तथा—similarly; सर्वाणि भूतानि—all beings; मत्-स्थानि—situated in Me; इति उपधारय—thus you should know.',
      'commentary':
          'This analogy clarifies the concept of transcendental support. The space contains the wind but is not affected by its movement. Similarly, Krishna sustains creation without being bound or affected by the activities of the created beings.',
    });

    // Verse 7: Cyclical Creation and Dissolution
    await db.insert('chapter_9', {
      'verse_number': 7,
      'sanskrit':
          'सर्वभूतानि कौन्तेय प्रकृतिं यान्ति मामिकाम् | कल्पक्षये पुनस्तानि कल्पादौ विसृजाम्यहम् || 7 ||',
      'translation':
          'O son of Kuntī, at the end of a *Kalpa* (Brahmā’s day), all beings enter My *Prakṛiti* (material nature). At the beginning of the next *Kalpa*, I send them forth again.',
      'word_meaning':
          'सर्व-भूतानि—all beings; कौन्तेय—O son of Kuntī; प्रकृतिम्—material nature; यान्ति—enter; मामिकाम्—My own; कल्प-क्षये—at the end of the *Kalpa*; पुनः—again; तानि—them; कल्प-आदौ—at the beginning of the *Kalpa*; विसृजामि—I send forth/create; अहम्—I.',
      'commentary':
          'Krishna is the ultimate controller of the cycles of creation and dissolution. His *Prakṛiti* (material energy) acts as the reservoir where all souls rest during the period of dissolution.',
    });

    // Verse 8: Control over Prakṛiti
    await db.insert('chapter_9', {
      'verse_number': 8,
      'sanskrit':
          'प्रकृतिं स्वामवष्टभ्य विसृजामि पुनः पुनः | भूतग्राममिमं कृत्स्नमवशं प्रकृतेर्वशात् || 8 ||',
      'translation':
          'Resorting to My own *Prakṛiti*, I repeatedly create this entire multitude of beings, which are **helpless**, being under the control of *Prakṛiti*.',
      'word_meaning':
          'प्रकृतिम्—material nature; स्वाम्—My own; अवष्टभ्य—resorting to; विसृजामि—I create; पुनः पुनः—repeatedly; भूत-ग्रामम्—multitude of beings; इमम्—this; कृत्स्नम्—entire; अवशम्—helpless; प्रकृतेः वशात्—under the control of *Prakṛiti*.',
      'commentary':
          'The souls are driven by their own past actions (*karma*) and are thus born again through the agency of *Prakṛiti*. They are **helpless** (*avaśham*) to stop this cycle unless they surrender to the Divine.',
    });

    // Verse 9: The Non-binding Nature of Action
    await db.insert('chapter_9', {
      'verse_number': 9,
      'sanskrit':
          'न च मां तानि कर्माणि निबध्नन्ति धनञ्जय | उदासीनवदासीनमसक्तं तेषु कर्मसु || 9 ||',
      'translation':
          'O Dhanañjaya (Arjuna), these acts (of creation) do not bind Me. I remain unattached to these actions, sitting as though **indifferent** or neutral.',
      'word_meaning':
          'न च माम्—nor Me; तानि कर्माणि—those activities; निबध्नन्ति—bind; धनञ्जय—O conqueror of wealth (Arjuna); उदासीन-वत्—as though neutral/indifferent; आसीनम्—seated; असक्तम्—unattached; तेषु कर्मसु—in those activities.',
      'commentary':
          'Since Krishna has no selfish desire or egoistic motivation (*asaktaṁ*) in the act of creation, He incurs no *karma*. He acts merely as the impartial witness or supervisor (*udāsīnavat*), remaining pure and unbound.',
    });

    // Verse 10: The Supervising Energy
    await db.insert('chapter_9', {
      'verse_number': 10,
      'sanskrit':
          'मयाध्यक्षेण प्रकृतिः सूयते सचराचरम् | हेतुनानेन कौन्तेय जगद्विपरिवर्तते || 10 ||',
      'translation':
          'Under My **supervision** (*mayādhyakṣheṇa*), *Prakṛiti* (material nature) gives birth to all moving and non-moving things. Because of this principle, O son of Kuntī, the universe revolves.',
      'word_meaning':
          'मया अध्यक्षेण—by My supervision; प्रकृतिः—material nature; सूयते—gives birth; स-चर-अचरम्—all moving and non-moving things; हेतुना अनेन—because of this reason; कौन्तेय—O son of Kuntī; जगत्—the universe; विपरिवर्तते—revolves.',
      'commentary':
          'This finalizes the explanation of the creative mechanism. Krishna is not the direct doer but the activating force. His mere presence or "glance" activates His material energy (*Prakṛiti*), causing the universe to manifest and revolve.',
    });

    // Verse 11: The Misunderstanding of the Foolish
    await db.insert('chapter_9', {
      'verse_number': 11,
      'sanskrit':
          'अवजानन्ति मां मूढा मानुषीं तनुमाश्रितम् | परं भावमजानन्तो मम भूतमहेश्वरम् || 11 ||',
      'translation':
          'Fools (*mūḍhāḥ*) deride Me when I descend in a human form, not knowing My **Supreme Nature** as the **Great Lord of all beings**.',
      'word_meaning':
          'अवजानन्ति—they disrespect/deride; माम्—Me; मूढाः—fools; मानुषीम्—human; तनुम्—form; आश्रितम्—assuming; परम् भावम्—the supreme nature; अजानन्तः—not knowing; मम—My; भूत-महेश्वरम्—the Great Lord of beings.',
      'commentary':
          'This is a crucial verse addressing the appearance of the Supreme in a form like a human. The ignorant mistake Krishna for an ordinary historical figure because they cannot perceive the **transcendental** nature and power (*paraṁ bhāvam*) behind the human guise.',
    });

    // Verse 12: The Fate of the Demons
    await db.insert('chapter_9', {
      'verse_number': 12,
      'sanskrit':
          'मोघाशा मोघकर्माणो मोघज्ञाना विचेतसः | राक्षसीमासुरीं चैव प्रकृतिं मोहिनीं श्रिताः || 12 ||',
      'translation':
          'These deluded persons possess **vain hopes**, **vain actions**, and **vain knowledge**. They are senseless and are subject to the deluding nature of **demons** and **ogres** (*rākṣhasīm āsurīṁ prakṛitiṁ*).',
      'word_meaning':
          'मोघ-आशाः—vain hopes; मोघ-कर्माणः—vain actions; मोघ-ज्ञानाः—vain knowledge; विचेतसः—senseless/deluded; राक्षसीम्—demonic (ogre-like); आसुरीम्—demoniac; च एव—and also; प्रकृतिम्—nature; मोहिनीम्—deluding; श्रिताः—resorting to.',
      'commentary':
          'The result of deriding the Lord is spiritual degradation. Persons with this outlook are driven by worldly desires, and their efforts in spirituality, philosophy, or social work are ultimately fruitless (*mogha*), as they are based on a fundamental misapprehension of the Divine.',
    });

    // Verse 13: The Nature of the Great Souls
    await db.insert('chapter_9', {
      'verse_number': 13,
      'sanskrit':
          'महात्मानस्तु मां पार्थ दैवीं प्रकृतिमाश्रिताः | भजन्त्यनन्यमनसो ज्ञात्वा भूतादिमव्ययम् || 13 ||',
      'translation':
          'But the **Great Souls** (*Mahātmānaḥ*), O Pārtha, who are sheltered in My **Divine Nature** (*daivīṁ prakṛitiṁ*), worship Me with an **undivided mind**, knowing Me to be the **Imperishable Source of all beings**.',
      'word_meaning':
          'महा-आत्मानः—the great souls; तु—but; माम्—Me; पार्थ—O Pārtha; दैवीम्—divine; प्रकृतिम्—nature; आश्रिताः—resorting to; भजन्ति—worship; अनन्य-मनसः—with undivided minds; ज्ञात्वा—knowing; भूत-आदिम्—source of all beings; अव्ययम्—imperishable.',
      'commentary':
          'In contrast to the *mūḍhāḥ*, the *mahātmānaḥ* are guided by the *Daivī Prakṛiti* (Divine Nature). They worship Krishna with exclusive, single-minded devotion (*ananya-manasaḥ*), recognizing His true, eternal identity.',
    });

    // Verse 14: The Forms of Worship
    await db.insert('chapter_9', {
      'verse_number': 14,
      'sanskrit':
          'सततं कीर्तयन्तो मां यतन्तश्च दृढव्रताः | नमस्यन्तश्च मां भक्त्या नित्ययुक्ता उपासते || 14 ||',
      'translation':
          'Always **glorifying Me** (*kīrtayanto māṁ*), striving with firm resolve, bowing down to Me with devotion, and constantly united (in *Yoga*), they worship Me.',
      'word_meaning':
          'सततम्—constantly; कीर्तयन्तः—glorifying/chanting; माम्—Me; यतन्तः—striving; च—and; दृढ-व्रताः—with firm vows; नमस्यन्तः—bowing down; च माम्—and Me; भक्त्या—with devotion; नित्य-युक्ताः—constantly engaged in *Yoga*; उपासते—they worship.',
      'commentary':
          'This verse describes the practical activities of *Bhakti-Yoga*: glorification (chanting), determined effort (austerity), and reverence (prostrations). These are not casual acts but a constant, integral part of the devotee\'s life.',
    });

    // Verse 15: The Path of Knowledge (*Jñāna-Yajña*)
    await db.insert('chapter_9', {
      'verse_number': 15,
      'sanskrit':
          'ज्ञानयज्ञेन चाप्यन्ये यजन्तो मामुपासते | एकत्वेन पृथक्त्वेन बहुधा विश्वतोमुखम् || 15 ||',
      'translation':
          'Others, sacrificing with the **sacrifice of knowledge** (*Jñāna-Yajñena*), also worship Me: as the one unit (non-dualists), as distinct individuals (dualists), and in My manifold form facing everywhere (the universal form).',
      'word_meaning':
          'ज्ञान-यज्ञेन—by the sacrifice of knowledge; च अपि अन्ये—and also others; यजन्तः—sacrificing; माम्—Me; उपासते—worship; एकत्वेन—in oneness; पृथक्त्वेन—in distinctness; बहुधा—in manifold ways; विश्वतः-मुखम्—whose face is everywhere (the universal form).',
      'commentary':
          'This acknowledges other valid paths of worship (*Jñāna-Yoga*) that utilize knowledge as the means of sacrifice. The object of their worship is still the Supreme, but their approach differs: some see identity with the Divine (*Ekatvena*), and others see distinction (*Pṛithaktvena*).',
    });

    // Verse 16: Krishna is the Ritual and the Object
    await db.insert('chapter_9', {
      'verse_number': 16,
      'sanskrit':
          'अहं क्रतुरहं यज्ञः स्वधाहमहमौषधम् | मन्त्रोऽहमहमेवाज्यमहमग्निरहं हुतम् || 16 ||',
      'translation':
          'I am the **ritual** (*Kratu*), I am the **sacrifice** (*Yajña*), I am the **offering** to ancestors (*Svadha*), I am the **healing herb** (*Auṣhadham*), I am the **Mantra**, I am the **ghee** (*Ājyam*), I am the **fire** (*Agni*), and I am the **act of offering** (*Hutam*).',
      'word_meaning':
          'अहम्—I; क्रतुः—the Vedic ritual; अहम् यज्ञः—I am the sacrifice; स्वधा—offering to ancestors; अहम्—I; अहम् औषधम्—I am the herb; मन्त्रः—mantra/chant; अहम्—I; अहम् एव—I am indeed; आज्यम्—ghee/oblation; अहम् अग्निः—I am the fire; अहम् हुतम्—I am the offering.',
      'commentary':
          'Krishna asserts His complete identity with every component of the Vedic sacrificial system. He is the material used, the process, the sacred words, the result, and the goal—affirming His all-encompassing nature.',
    });

    // Verse 17: Krishna is the Source and Sustainer
    await db.insert('chapter_9', {
      'verse_number': 17,
      'sanskrit':
          'पिताहमस्य जगतो माता धाता पितामहः | वेद्यं पवित्रमोङ्कार ऋक्साम यजुरेव च || 17 ||',
      'translation':
          'I am the **Father** of this universe, the **Mother**, the **Sustainer** (*Dhātā*), and the **Grandfather**. I am the knowable object, the **Purifier**, the syllable **Om**, and the three Vedas: the **Ṛk**, the **Sāma**, and the **Yajus**.',
      'word_meaning':
          'पिता—father; अहम्—I; अस्य—of this; जगतः—universe; माता—mother; धाता—sustainer; पितामहः—grandfather; वेद्यम्—the knowable; पवित्रम्—the purifier; ओङ्कारः—the syllable Om; ऋक् साम यजुः एव च—and also the Ṛg, Sāma, and Yajur Vedas.',
      'commentary':
          'This continues the description of Divine supremacy, identifying Krishna as the progenitor (Father and Grandfather), the ultimate source of nourishment (Mother and Sustainer), and the essence of all sacred knowledge (*Om* and the Vedas).',
    });

    // Verse 18: Krishna is the Goal
    await db.insert('chapter_9', {
      'verse_number': 18,
      'sanskrit':
          'गतिर्भर्ता प्रभुः साक्षी निवासः शरणं सुहृत् | प्रभवः प्रलयः स्थानं निधानं बीजमव्ययम् || 18 ||',
      'translation':
          'I am the **Goal** (*Gati*), the **Supporter** (*Bhartā*), the **Lord** (*Prabhu*), the **Witness** (*Sākṣhī*), the **Abode** (*Nivāsa*), the **Refuge** (*Śharaṇaṁ*), and the **most dear Friend** (*Suhṛt*). I am the **Origin** (*Prabhava*), the **Dissolution** (*Pralaya*), the **Foundation** (*Sthānaṁ*), the **Treasure-house** (*Nidhānaṁ*), and the **Imperishable Seed** (*Bījam Avyayam*).',
      'word_meaning':
          'गतिः—goal/destination; भर्ता—supporter; प्रभुः—lord/master; साक्षी—witness; निवासः—abode; शरणम्—refuge; सुहृत्—dear friend; प्रभवः—origin; प्रलयः—dissolution; स्थानम्—foundation; निधानम्—treasure-house; बीजम् अव्ययम्—the imperishable seed.',
      'commentary':
          'This is a magnificent list of the Lord\'s attributes, spanning His roles in relation to the individual soul (Refuge, Friend) and the cosmos (Origin, Dissolution, Seed). The term **Suhṛt** (most dear friend) is particularly significant in the context of *Bhakti* as it emphasizes His unconditional benevolence.',
    });

    // Verse 19: The Heat and Rain
    await db.insert('chapter_9', {
      'verse_number': 19,
      'sanskrit':
          'तपाम्यहमहं वर्षं निगृह्णाम्युत्सृजामि च | अमृतं चैव मृत्युश्च सदसच्चाहमर्जुन || 19 ||',
      'translation':
          'I give heat, and I withhold and send forth the rain. I am **Immortality** (*Amṛtaṁ*) and also **Death** (*Mṛityuḥ*). I am the **Existent** (*Sat*) and the **Non-existent** (*Asat*), O Arjuna.',
      'word_meaning':
          'तपामि—I give heat; अहम्—I; अहम्—I; वर्षम्—the rain; निगृह्णामि—I withhold; उत्सृजामि—I send forth; च—and; अमृतम्—immortality/nectar; च एव—and also; मृत्युः—death; सत्—the manifest/existent; असत्—the unmanifest/non-existent; च अहम्—and I.',
      'commentary':
          'Krishna controls the natural forces and the fundamental dualities of existence. By being both **Immortality** (the spiritual goal) and **Death** (the mechanism of time), He demonstrates His comprehensive control over all phases of material existence.',
    });

    // Verse 20: Seeking Heavenly Rewards
    await db.insert('chapter_9', {
      'verse_number': 20,
      'sanskrit':
          'त्रैविद्या मां सोमपाः पूतपापा यज्ञैरिष्ट्वा स्वर्गतिं प्रार्थयन्ते | ते पुण्यमासाद्य सुरेन्द्रलोक-मश्नन्ति दिव्यान्दिवि देवभोगान् || 20 ||',
      'translation':
          'Those who follow the teachings of the **three Vedas** (*Traividyāḥ*), drink the *Soma* juice, and are purified of sin, worship Me through sacrifices and pray for the path to heaven. Having reached the virtuous abode of the king of the gods, they enjoy divine celestial pleasures.',
      'word_meaning':
          'त्रै-विद्याः—the knowers of the three Vedas; माम्—Me; सोम-पाः—Soma-drinkers; पूत-पापाः—purified of sin; यज्ञैः—by sacrifices; इष्ट्वा—worshipping; स्वर्ग-गतिम्—the path to heaven; प्रार्थयन्ते—pray for; ते—they; पुण्यम्—meritorious; आसाद्य—having reached; सुर-इन्द्र-लोकम्—the world of the king of the gods (Indra); अश्नन्ति—they enjoy; दिव्यान्—divine; दिवि—in heaven; देव-भोगान्—celestial pleasures.',
      'commentary':
          'This verse describes the ritualistic worship of the Vedas (*Karma Kāṇḍa*). While these acts purify one and are technically a form of worship to Krishna (as He is the recipient of all sacrifices, Verse 16), the goal is limited to **heavenly enjoyment**, which is temporary and not the supreme liberation.',
    });

    // Verse 21: The consequence of seeking heavenly pleasures
    await db.insert('chapter_9', {
      'verse_number': 21,
      'sanskrit':
          'ते तं भुक्त्वा स्वर्गलोकं विशालं क्षीणे पुण्ये मर्त्यलोकं विशन्ति | एवं त्रयीधर्ममनुप्रपन्ना गतागतं कामकामा लभन्ते || 21 ||',
      'translation':
          'Having enjoyed the vast pleasures of the heavenly world, their stock of merits being exhausted, they return to the mortal world. Thus, those who desire enjoyments, abiding by the injunctions of the three Vedas, attain only the state of coming and going (rebirth).',
      'word_meaning':
          'ते—they; तम्—that; भुक्त्वा—having enjoyed; स्वर्ग-लोकम्—heavenly world; विशालम्—vast; क्षीणे—being exhausted; पुण्ये—merit; मर्त्य-लोकम्—the mortal world; विशन्ति—enter; एवम्—thus; त्रयी-धर्मम्—the injunctions of the three Vedas; अनुप्रपन्नाः—following; गत-आगतम्—coming and going (rebirth); काम-कामांः—those who desire enjoyments; लभन्ते—attain.',
      'commentary':
          'This contrasts the limited results of *Karma Kāṇḍa* (ritualistic section of the Vedas) with the goal of liberation. Heavenly enjoyment is temporary; the exhaustion of merit (*puṇyaṁ*) inevitably forces the soul back into the cycle of *saṁsāra*.',
    });

    // Verse 22: The unique promise to the pure devotee
    await db.insert('chapter_9', {
      'verse_number': 22,
      'sanskrit':
          'अनन्याश्चिन्तयन्तो मां ये जनाः पर्युपासते | तेषां नित्याभियुक्तानां योगक्षेमं वहाम्यहम् || 22 ||',
      'translation':
          'But those persons who worship Me with **exclusive devotion** (*ananyāśh chintayanto*), constantly fixed in Me—I personally **carry what they lack and preserve what they already possess** (*yoga-kṣhemaṁ vahāmyaham*).',
      'word_meaning':
          'अनन्याः—exclusive/without any other object; चिन्तयन्तः—contemplating; माम्—Me; ये जनाः—those persons; पर्युपासते—worship fully; तेषाम्—for them; नित्य-अभियुक्तानाम्—constantly devoted; योग-क्षेमम्—gain of new things and preservation of existing things; वहामि—I carry; अहम्—I.',
      'commentary':
          'This is Krishna’s famous promise to the pure devotee. For one who dedicates their mind entirely to God, the Lord takes personal, direct responsibility for their material and spiritual welfare (*yoga-kṣhemaṁ*), removing the need for them to worry about these things.',
    });

    // Verse 23: Worship of other deities is indirect worship of Krishna
    await db.insert('chapter_9', {
      'verse_number': 23,
      'sanskrit':
          'येऽप्यन्यदेवता भक्ता यजन्ते श्रद्धयान्विताः | तेऽपि मामेव कौन्तेय यजन्त्यविधिपूर्वकम् || 23 ||',
      'translation':
          'O son of Kuntī, even those devotees who, with faith, worship other deities, also worship Me alone, though by an **improper method** (*avidhi-pūrvakam*).',
      'word_meaning':
          'ये अपि—even those who; अन्य-देवताः—other deities; भक्ताः—devotees; यजन्ते—worship; श्रद्धया अन्विताः—endowed with faith; ते अपि—they also; माम् एव—Me alone; कौन्तेय—O son of Kuntī; यजन्ति—worship; अविधि-पूर्वकम्—by an improper method/wrong procedure.',
      'commentary':
          'This confirms the ultimate unity of all worship. Because Krishna is the source of all power (Verse 12), all offerings flow eventually to Him, though the process is incomplete and indirect.',
    });

    // Verse 24: Krishna is the supreme recipient
    await db.insert('chapter_9', {
      'verse_number': 24,
      'sanskrit':
          'अहं हि सर्वयज्ञानां भोक्ता च प्रभुरेव च | न तु मामभिजानन्ति तत्त्वेनातश्च्यवन्ति ते || 24 ||',
      'translation':
          'For I alone am the **Enjoyer and the Lord** of all sacrifices. But because they do not recognize My true nature, they fall from the proper path.',
      'word_meaning':
          'अहम् हि—I certainly; सर्व-यज्ञानाम्—of all sacrifices; भोक्ता—the enjoyer/recipient; च—and; प्रभुः—the Lord; एव च—certainly; न तु माम्—but not Me; अभिजानन्ति—they know; तत्त्वेन—in truth; अतः—therefore; च्यवन्ति—they fall; ते—they.',
      'commentary':
          'Ignorant worship leads to material bondage because the worshipper fails to recognize the Supreme Recipient and Controller of the *Yajña*. This leads to instability and return from heaven (*chyavanti te*).',
    });

    // Verse 25: The destination according to worship
    await db.insert('chapter_9', {
      'verse_number': 25,
      'sanskrit':
          'यान्ति देवव्रता देवान्पितॄन्यान्ति पितृव्रताः | भूतानि यान्ति भूतेज्या यान्ति मद्याजिनोऽपि माम् || 25 ||',
      'translation':
          'Worshippers of the celestial gods go to the gods; worshippers of the ancestors go to the ancestors; worshippers of spirits go to the spirits; but those who **worship Me attain Me**.',
      'word_meaning':
          'यान्ति—attain; देव-व्रताः—those who vow to the *devatās*; देवान्—the *devatās* (celestial beings); पितॄन्—the ancestors; यान्ति—attain; पितृ-व्रताः—those who vow to the ancestors; भूतानि—ghosts/spirits; यान्ति—attain; भूत-इज्याः—worshippers of spirits; यान्ति—attain; मत्-याजिनः—My worshippers; अपि—also; माम्—Me.',
      'commentary':
          'This establishes the direct relationship between the object of worship and the destination. Since Krishna is the Supreme Reality, those who worship Him attain the highest, permanent goal, unlike the worshippers of temporary entities.',
    });

    // Verse 26: The simplicity of Bhakti (Offering a leaf)
    await db.insert('chapter_9', {
      'verse_number': 26,
      'sanskrit':
          'पत्रं पुष्पं फलं तोयं यो मे भक्त्या प्रयच्छति | तदहं भक्त्युपहृतमश्नामि प्रयतात्मनः || 26 ||',
      'translation':
          'If one offers Me with love and devotion a **leaf, a flower, a fruit, or water**, I accept it, offered by the striving soul with devotion.',
      'word_meaning':
          'पत्रम्—a leaf; पुष्पम्—a flower; फलम्—a fruit; तोयम्—water; यः—who; मे—to Me; भक्त्या—with devotion; प्रयच्छति—offers; तत्—that; अहम्—I; भक्ति-उप-हृतम्—offered with devotion; अश्नामि—I accept/eat; प्रयत्-आत्मनः—of the striving soul.',
      'commentary':
          'Krishna emphasizes the **simplicity and accessibility** of *Bhakti-Yoga*. The value of the offering is not in its material worth but in the **devotion (*bhaktyā*)** and the purity of heart (*prayatātmanaḥ*) with which it is presented.',
    });

    // Verse 27: Dedicating all action to Krishna
    await db.insert('chapter_9', {
      'verse_number': 27,
      'sanskrit':
          'यत्करोषि यदश्नासि यज्जुहोषि ददासि यत् | यत्तपस्यसि कौन्तेय तत्कुरुष्व मदर्पणम् || 27 ||',
      'translation':
          'Whatever you do, whatever you eat, whatever you offer as oblation to the fire, whatever you bestow as a gift, and whatever austerities you perform, O son of Kuntī, **do it as an offering to Me**.',
      'word_meaning':
          'यत् करोषि—whatever you do; यत् अश्नासि—whatever you eat; यत् जुहोषि—whatever you offer into the fire; ददासि यत्—whatever you give; यत् तपस्यसि—whatever austerity you practice; कौन्तेय—O son of Kuntī; तत् कुरुष्व—do that; मत्-अर्पणम्—as an offering to Me.',
      'commentary':
          'This integrates *Bhakti-Yoga* and *Karma Yoga*. All actions in life are sanctified and made non-binding when the motive is changed from self-interest to dedication (*mad-arpaṇam*) to the Divine.',
    });

    // Verse 28: Freedom from karmic bondage
    await db.insert('chapter_9', {
      'verse_number': 28,
      'sanskrit':
          'शुभाशुभफलैरेवं मोक्ष्यसे कर्मबन्धनैः | संन्यासयोगयुक्तात्मा विमुक्तो मामुपैष्यसि || 28 ||',
      'translation':
          'By this dedication, you will be freed from the bondage of actions, both good and bad, which yield auspicious and inauspicious results. With your mind established in the Yoga of renunciation, you will be liberated and attain Me.',
      'word_meaning':
          'शुभ-अशुभ-फलैः—from the results (fruits) that are auspicious and inauspicious; एवम्—thus; मोक्ष्यसे—you will be freed; कर्म-बन्धनैः—from the bonds of *karma*; संन्यास-योग-युक्त-आत्मा—whose mind is established in the Yoga of renunciation; विमुक्तः—liberated; माम् उपैष्यसि—you shall attain Me.',
      'commentary':
          'Action performed without selfish motive breaks the chain of *karma* created by both sin (inauspicious) and merit (auspicious). This liberation is achieved through the spiritual intelligence cultivated by *Bhakti-Yoga*.',
    });

    // Verse 29: Krishna’s impartiality and love for the devotee
    await db.insert('chapter_9', {
      'verse_number': 29,
      'sanskrit':
          'समोऽहं सर्वभूतेषु न मे द्वेष्योऽस्ति न प्रियः | ये भजन्ति तु मां भक्त्या मयि ते तेषु चाप्यहम् || 29 ||',
      'translation':
          'I am equally disposed to all living beings; I am neither inimical nor partial to anyone. But those devotees who worship Me with love reside in Me, and I also reside in them.',
      'word_meaning':
          'समः—equal/impartial; अहम्—I; सर्व-भूतेषु—to all beings; न मे—not to Me; द्वेष्यः—object of hatred; अस्ति—is; न प्रियः—nor beloved; ये—who; भजन्ति—worship; तु माम्—but Me; भक्त्या—with devotion; मयि—in Me; ते—they; तेषु च अपि अहम्—and I also in them.',
      'commentary':
          'Krishna is inherently impartial (*samaḥ*) but reciprocates based on the devotee\'s effort. The bond of love is mutual: the devotee resides in the Lord by fixing their mind, and the Lord resides in the devotee by showering His grace.',
    });

    // Verse 30: The power of devotion to purify the sinner
    await db.insert('chapter_9', {
      'verse_number': 30,
      'sanskrit':
          'अपि चेत्सुदुराचारो भजते मामनन्यभाक् | साधुरेव स मन्तव्यः सम्यग्व्यवसितो हि सः || 30 ||',
      'translation':
          'Even if a person commits the most despicable deeds, if he constantly worships Me with **exclusive devotion**, he is to be considered righteous, for he has made the proper spiritual resolve.',
      'word_meaning':
          'अपि चेत्—even if; सु-दुराचारः—of extremely bad conduct/sinful; भजते—worships; माम्—Me; अनन्य-भाक्—with exclusive devotion; साधुः—righteous; एव सः—certainly he; मन्तव्यः—is to be considered; सम्यक्—rightly; व्यवसितः—resolved; हि सः—certainly he.',
      'commentary':
          'This offers immense hope: **devotion is the greatest purifier**. Sincere surrender and resolute faith (*samyag vyavasito hi saḥ*) are more important than past conduct, ensuring a quick return to righteousness.',
    });

    // Verse 31: The Swift Purification
    await db.insert('chapter_9', {
      'verse_number': 31,
      'sanskrit':
          'क्षिप्रं भवति धर्मात्मा शश्वच्छान्तिं निगच्छति | कौन्तेय प्रतिजानीहि न मे भक्तः प्रणश्यति || 31 ||',
      'translation':
          'He quickly becomes righteous (*dharmātmā*) and attains eternal peace. O son of Kuntī, **know this for certain**: **My devotee never perishes**.',
      'word_meaning':
          'क्षिप्रम्—quickly; भवति—becomes; धर्म-आत्मा—a righteous soul; शश्वत्-शान्तिम्—eternal peace; निगच्छति—attains; कौन्तेय—O son of Kuntī; प्रतिजानीहि—declare/know for certain; न—not; मे—My; भक्तः—devotee; प्रणश्यति—perishes.',
      'commentary':
          'This verse contains one of the most emphatic declarations in the Gita: a solemn promise (*pratijānīhi*) that the Lord’s devotee is protected and assured of eternal liberation. The transformation from a sinful state to a righteous one is rapid when powered by *Ananyā Bhakti* (exclusive devotion).',
    });

    // Verse 32: The Universal Accessibility of the Supreme Goal
    await db.insert('chapter_9', {
      'verse_number': 32,
      'sanskrit':
          'मां हि पार्थ व्यपाश्रित्य येऽपि स्युः पापयोनयः | स्त्रियो वैश्यास्तथा शूद्रास्तेऽपि यान्ति परां गतिम् || 32 ||',
      'translation':
          'O Pārtha, taking **shelter in Me** (*vyapāśhritya*), even those who may be born from the wombs of sin (*pāpa-yonayaḥ*)—including women, *vaiśhyas* (merchants), and *śhūdras* (workers)—also attain the **Supreme Goal**.',
      'word_meaning':
          'माम् हि—Me, indeed; पार्थ—O Pārtha; व्यपाश्रित्य—having taken shelter; ये अपि—even those who; स्युः—may be; पाप-योनयः—born from the wombs of sin; स्त्रियः—women; वैश्याः—*vaiśhyas* (traders); तथा—and also; शूद्राः—*śhūdras* (laborers); ते अपि—they also; यान्ति—attain; पराम् गतिम्—the Supreme Goal.',
      'commentary':
          'This is a landmark statement on spiritual equality. Krishna explicitly rejects all material distinctions based on birth, gender, or social class as barriers to liberation. The only qualification for attaining the Supreme Goal (*parāṁ gatim*) is sincere surrender and devotion (*vyapāśhritya*).',
    });

    // Verse 33: The Duty of the Righteous
    await db.insert('chapter_9', {
      'verse_number': 33,
      'sanskrit':
          'किं पुनर्ब्राह्मणाः पुण्या भक्ता राजर्षयस्तथा | अनित्यमसुखं लोकमिमं प्राप्य भजस्व माम् || 33 ||',
      'translation':
          'Then how much more easily can the holy *Brāhmaṇas* and the devoted royal sages (*Rājarṣayaḥ*) attain the goal! Since you have received this temporary and unhappy world, therefore **worship Me**.',
      'word_meaning':
          'किम् पुनः—what then to speak of; ब्राह्मणाः—*Brāhmaṇas* (priestly class); पुण्याः—holy; भक्ताः—devotees; राज-ऋषयः—royal sages; तथा—similarly; अनित्यम्—impermanent; असुखम्—unhappy; लोकम्—world; इमम्—this; प्राप्य—having obtained; भजस्व माम्—worship Me.',
      'commentary':
          'If the previous verse promised salvation to those facing social barriers, this verse highlights the duty of those already on the auspicious path. Krishna reminds Arjuna that even those born in favorable circumstances must dedicate themselves to *Bhakti* because this world is inherently temporary (*anityam*) and full of suffering (*asukhaṁ*).',
    });

    // Verse 34: The Concluding Command and Essence of Bhakti-Yoga
    await db.insert('chapter_9', {
      'verse_number': 34,
      'sanskrit':
          'मन्मना भव मद्भक्तो मद्याजी मां नमस्कुरु | मामेवैष्यसि युक्त्वैवमात्मानं मत्परायणः || 34 ||',
      'translation':
          'Fix your **mind on Me** (*manmanā bhava*); be **devoted to Me** (*madbhakto*); **worship Me** (*madyājī*); and **offer obeisance to Me** (*māṁ namaskuru*). Having thus united your entire self with Me as your Supreme Goal (*matparāyaṇaḥ*), you shall **surely come to Me**.',
      'word_meaning':
          'मत्-मनाः—with your mind fixed on Me; भव—be; मत्-भक्तः—My devotee; मत्-याजी—My worshipper; माम्—to Me; नमस्कुरु—offer obeisance; माम् एव—Me alone; एष्यसि—you shall come; युक्त्व एवम्—thus uniting (your self); आत्मानम्—the self/mind; मत्-परायणः—having Me as the supreme goal.',
      'commentary':
          'This is the most celebrated concluding verse of Chapter 9, often considered the essence of *Bhakti-Yoga* and the **Four-Fold Instruction**. It summarizes the practical method of devotion: internal focus (mind), emotional relationship (devotion), physical actions (worship/obeisance), and complete surrender (Supreme Goal), guaranteeing eternal union with the Divine.',
    });
  }

  Future<void> insertChapter10Verses(Database db) async {
    // Verse 1: Krishna continues the discourse
    await db.insert('chapter_10', {
      'verse_number': 1,
      'sanskrit':
          'श्रीभगवानुवाच | भूय एव महाबाहो शृणु मे परमं वचः | यत्तेऽहं प्रीयमाणाय वक्ष्यामि हितकाम्यया || 1 ||',
      'translation':
          'The Supreme Lord said: Listen again to My supreme teachings, O mighty-armed (Arjuna). Desiring your welfare because you are My beloved confidant, I shall reveal them to you.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; भूयः एव—again, verily; महा-बाहो—O mighty-armed; शृणु—hear; मे—My; परमम्—supreme/divine; वचः—utterance/teachings; यत् ते—which to you; अहम्—I; प्रीयमाणाय—to the beloved one/one taking delight; वक्ष्यामि—I shall say; हित-काम्यया—desiring welfare.',
      'commentary':
          'Krishna continues the most confidential instruction (*paramaṁ vacaḥ*) without being asked, motivated by Arjuna\'s pure devotion and delight (*prīyamāṇāya*) in hearing His glories. This sets the affectionate tone for the *Vibhūti Yog*.',
    });

    // Verse 2: The Lord's origin is unknown
    await db.insert('chapter_10', {
      'verse_number': 2,
      'sanskrit':
          'न मे विदुः सुरगणाः प्रभवं न महर्षयः | अहमादिर्हि देवानां महर्षीणां च सर्वशः || 2 ||',
      'translation':
          'Neither the celestial gods (*sura-gaṇāḥ*) nor the great sages (*maharṣhayaḥ*) know My origin or opulence, for I am the absolute origin of all the gods and the great sages.',
      'word_meaning':
          'न मे—not My; विदुः—know; सुर-गणाः—the celestial gods; प्रभवम्—origin/opulence; न महर्षयः—nor the great sages; अहम्—I; आदिः—origin; हि—certainly; देवानाम्—of the gods; महर्षीणाम्—of the great sages; च सर्वशः—and in all respects.',
      'commentary':
          'Krishna establishes His position as the ultimate, uncreated source. Since all beings, even the highest gods and sages, originate from Him, they cannot fully comprehend His beginning or divine power.',
    });

    // Verse 3: The knower of the Lord's divinity is liberated
    await db.insert('chapter_10', {
      'verse_number': 3,
      'sanskrit':
          'यो मामजमनादिं च वेत्ति लोकमहेश्वरम् | असम्मूढः स मर्त्येषु सर्वपापैः प्रमुच्यते || 3 ||',
      'translation':
          'One among mortals who knows Me as the **unborn, beginningless**, and the **Supreme Lord of the universe**, is free from illusion and released from all sins.',
      'word_meaning':
          'यः—who; माम्—Me; अजम्—unborn; अनादिम्—beginningless; च—and; वेत्ति—knows; लोक-महेश्वरम्—the Supreme Lord of the universe; असम्मूढः—undeluded; सः—he; मर्त्येषु—among mortals; सर्व-पापैः—from all sins; प्रमुच्यते—is released.',
      'commentary':
          'Realizing Krishna’s unique, eternal nature (unborn, beginningless) is the antidote to delusion. This knowledge purifies the soul and severs the bonds of *karma* (*sarva-pāpaiḥ pramućhyate*).',
    });

    // Verse 4: The Lord is the source of all human qualities (Part 1/2)
    await db.insert('chapter_10', {
      'verse_number': 4,
      'sanskrit':
          'बुद्धिर्ज्ञानमसंमोहः क्षमा सत्यं दमः शमः | सुखं दुःखं भवोऽभावो भयं चाभयमेव च || 4 ||',
      'translation':
          'Intellect, knowledge, clarity of thought, forgiveness, truthfulness, control over the senses, control over the mind, joy, sorrow, birth, death, fear, and courage,',
      'word_meaning':
          'बुद्धिः—intellect; ज्ञानम्—knowledge; असंमोहः—clarity of thought/freedom from delusion; क्षमा—forgiveness; सत्यम्—truthfulness; दमः—control over the senses; शमः—control over the mind; सुखम्—joy; दुःखम्—sorrow; भवः—birth; अभावः—death/non-birth; भयम्—fear; च अभयम्—and courage; एव च—certainly.',
      'commentary':
          'This begins the list of divine attributes manifested in living beings. All dualities of human experience—from abstract virtues (*buddhi*, *kṣamā*) to existential conditions (*sukhaṁ*, *duḥkhaṁ*)—are extensions of the Lord\'s power.',
    });

    // Verse 5: The Lord is the source of all human qualities (Part 2/2)
    await db.insert('chapter_10', {
      'verse_number': 5,
      'sanskrit':
          'अहिंसा समता तुष्टिस्तपो दानं यशोऽयशः | भवन्ति भावा भूतानां मत्त एव पृथग्विधाः || 5 ||',
      'translation':
          'Non-violence, equanimity, contentment, austerity, charity, fame, and infamy—these various qualities of living beings arise solely from Me.',
      'word_meaning':
          'अहिंसा—non-violence; समता—equanimity; तुष्टिः—contentment; तपः—austerity; दानम्—charity; यशः—fame; अयशः—infamy; भवन्ति—arise; भावाः—qualities/dispositions; भूतानाम्—of living beings; मत्तः एव—from Me alone; पृथक्-विधाः—various kinds.',
      'commentary':
          'All temperaments and outcomes, positive (*yaśhaḥ*) or negative (*ayaśhaḥ*), proceed from the Lord. There is no independent source of existence, virtue, or fate outside of His divine power.',
    });

    // Verse 6: The ancient progenitors of mankind
    await db.insert('chapter_10', {
      'verse_number': 6,
      'sanskrit':
          'महर्षयः सप्त पूर्वे चत्वारो मनवस्तथा | मद्भावा मानसा जाता येषां लोक इमाः प्रजाः || 6 ||',
      'translation':
          'The seven great sages (*maharṣhayaḥ*), the four great saints before them, and the fourteen Manus were all born from My mind, inheriting My nature. From them, all the inhabitants of the world descended.',
      'word_meaning':
          'महर्षयः—great sages; सप्त—seven; पूर्वे—before; चत्वारः—four; मनवः—Manus; तथा—similarly; मत्-भावाः—born with My nature; मानसाः—born from the mind; जाताः—born; येषाम्—from whom; लोके—in the world; इमाः—these; प्रजाः—progeny/inhabitants.',
      'commentary':
          'This establishes Krishna as the ultimate Father of creation, operating through the intellect (mind). All beings, including the ancient patriarchs (Sages and Manus), are secondary creations dependent on His will.',
    });

    // Verse 7: The result of knowing Krishna's divine opulence
    await db.insert('chapter_10', {
      'verse_number': 7,
      'sanskrit':
          'एतां विभूतिं योगं च मम यो वेत्ति तत्त्वतः | सोऽविकम्पेन योगेन युज्यते नात्र संशयः || 7 ||',
      'translation':
          'Those who truly know My divine opulence (*vibhūtiṁ*) and mystic power (*yogaṁ*) become united with Me through **unwavering *Bhakti* Yoga**; of this, there is no doubt.',
      'word_meaning':
          'एताम्—this; विभूतिम्—opulence/glory; योगम्—mystic power; च—and; मम—My; यः—who; वेत्ति—knows; तत्त्वतः—in truth; सः—he; अविकम्पेन—unwavering; योगेन—by Yoga; युज्यते—is united; न अत्र—not here; संशयः—doubt.',
      'commentary':
          'This assures that intellectual appreciation of Krishna\'s power (*vibhūti*) combined with the method of meditation/union (*yogaṁ*) leads to firm, unshakeable devotion (*avikampena yogena*).',
    });

    // Verse 8: Krishna is the ultimate source
    await db.insert('chapter_10', {
      'verse_number': 8,
      'sanskrit':
          'अहं सर्वस्य प्रभवो मत्तः सर्वं प्रवर्तते | इति मत्वा भजन्ते मां बुधा भावसमन्विताः || 8 ||',
      'translation':
          'I am the **origin of all creation**; everything proceeds from Me. The wise who know this perfectly worship Me with great faith and devotion.',
      'word_meaning':
          'अहम्—I; सर्वस्य—of all; प्रभवः—the source/origin; मत्तः—from Me; सर्वम्—everything; प्रवर्तते—proceeds/manifests; इति—thus; मत्वा—having understood; भजन्ते—worship; माम्—Me; बुधाः—the wise/intelligent; भाव-समन्विताः—with intense emotion/devotion.',
      'commentary':
          'This is the philosophical culmination of the *Vibhūti Yoga*. Knowing Krishna as the single, conscious source of all existence (*Ahaṁ sarvasya prabhavaḥ*) inspires true wisdom and intense devotion (*bhāva-samanvitāḥ*).',
    });

    // Verse 9: The mutual joy of the devotees
    await db.insert('chapter_10', {
      'verse_number': 9,
      'sanskrit':
          'मच्चित्ता मगतप्राणा बोधयन्तः परस्परम् | कथयन्तश्च मां नित्यं तुष्यन्ति च रमन्ति च || 9 ||',
      'translation':
          'With their **minds fixed on Me** (*mac-cittā*) and their lives surrendered to Me, My devotees remain ever content in Me. They derive great satisfaction and bliss by enlightening one another about Me and conversing about My glories.',
      'word_meaning':
          'मत्-चित्ताः—whose minds are fixed on Me; मत्-गत-प्राणाः—whose lives are surrendered to Me; बोधयन्तः—enlightening; परस्परम्—one another; कथयन्तः—conversing; च माम्—and Me; नित्यम्—constantly; तुष्यन्ति—they feel contentment; च रमन्ति—and they rejoice; च—and.',
      'commentary':
          'The sign of the true devotee is not isolated austerity, but communal, joyful interaction. Their happiness comes from sharing the knowledge of the Divine (*bodhayantaḥ parasparam*)—this is the highest spiritual pleasure.',
    });

    // Verse 10: The bestowal of divine knowledge
    await db.insert('chapter_10', {
      'verse_number': 10,
      'sanskrit':
          'तेषां सततयुक्तानां भजतां प्रीतिपूर्वकम् | ददामि बुद्धियोगं तं येन मामुपयान्ति ते || 10 ||',
      'translation':
          'To those whose minds are always united with Me in loving devotion and who worship Me with great affection, I give the **divine knowledge** (*buddhi-yogaṁ*) by which they can attain Me.',
      'word_meaning':
          'तेषाम्—to them; सतत-युक्तानाम्—constantly united; भजताम्—worshipping; प्रीति-पूर्वकम्—with love; ददामि—I give; बुद्धि-योगम्—divine knowledge/Yoga of intellect; तम्—that; येन—by which; माम्—Me; उपयान्ति—they attain; ते—they.',
      'commentary':
          'This is a promise of divine grace. For the sincere devotee who consistently engages in loving worship (*prīti-pūrvakam*), the Lord guides their intellect from within, giving them the realization necessary for the final union.',
    });

    // Ensure this code block extends your existing insertChapter10Verses function.

    // Verse 11: Divine Grace (Granting the Lamp of Knowledge)
    await db.insert('chapter_10', {
      'verse_number': 11,
      'sanskrit':
          'तेषामेवानुकम्पार्थमहमज्ञानजं तमः | नाशयाम्यात्मभावस्थो ज्ञानदीपेन भास्वता || 11 ||',
      'translation':
          'Out of pure compassion for them, I, dwelling within their hearts, destroy the darkness born of **ignorance** by the luminous **Lamp of Knowledge**.',
      'word_meaning':
          'तेषाम् एव—for them only; अनुकम्पा-अर्थम्—for the purpose of showing compassion; अहम्—I; अज्ञान-जम्—born of ignorance; तमः—darkness; नाशयामि—I destroy; आत्म-भाव-स्थः—dwelling in their hearts; ज्ञान-दीपेन—by the lamp of knowledge; भास्वता—luminous.',
      'commentary':
          'This is a promise of divine grace. For the devotee fixed in loving worship, the Lord acts as the inner Guru (*Ātma-bhāva-sthaḥ*), granting the light of wisdom (*jñāna-dīpena*) to dispel the fundamental darkness of ignorance (*ajñāna-jaṁ tamaḥ*).',
    });

    // Verse 12: Arjuna accepts and confirms Krishna's supremacy (Part 1/2)
    await db.insert('chapter_10', {
      'verse_number': 12,
      'sanskrit':
          'अर्जुन उवाच | परं ब्रह्म परं धाम पवित्रं परमं भवान् | पुरुषं शाश्वतं दिव्यमादिदेवमजं विभुम् || 12 ||',
      'translation':
          'Arjuna said: You are the **Supreme Brahman**, the Supreme Abode, the Supreme Purifier, the Eternal Divine Person (*Puruṣhaṁ śhāśhvataṁ*), the Primal God (*Ādidevaṁ*), the Unborn, and the Greatest.',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; परम् ब्रह्म—Supreme Brahman; परम् धाम—Supreme Abode; पवित्रम्—Purifier; परमम्—Supreme; भवान्—You; पुरुषम्—Person; शाश्वतम्—eternal; दिव्यम्—divine; आदि-देवम्—the Primal God; अजम्—unborn; विभुम्—greatest.',
      'commentary':
          'Arjuna begins his statement of acceptance and praise (*stuti*), affirming that Krishna possesses all six divine opulences (*Bhagas*). He specifically refers to Krishna as the **Supreme *Puruṣha***, integrating both the personal and absolute aspects of God.',
    });

    // Verse 13: Arjuna confirms the statement of the Sages (Part 2/2)
    await db.insert('chapter_10', {
      'verse_number': 13,
      'sanskrit':
          'आहुस्त्वामृषयः सर्वे देवर्षिर्नारदस्तथा | असितो देवलो व्यासः स्वयं चैव ब्रवीषि मे || 13 ||',
      'translation':
          'All the sages, including the divine sage **Nārada**, as well as Asita, Devala, and Vyāsa, proclaim this about You, and now You are declaring it to me Yourself.',
      'word_meaning':
          'आहुः—proclaim; त्वाम्—You; ऋषयः सर्वे—all the sages; देव-ऋषिः—the divine sage; नारदः—Nārada; तथा—and also; असितः—Asita; देवलः—Devala; व्यासः—Vyāsa; स्वयम् च एव—and You Yourself; ब्रवीषि—are speaking; मे—to me.',
      'commentary':
          'Arjuna substantiates his faith not just with his personal experience but by citing the authoritative statements of great, contemporary spiritual masters and divine sages, showing the consistent, unbroken line of revealed truth.',
    });

    // Verse 14: Arjuna's complete acceptance
    await db.insert('chapter_10', {
      'verse_number': 14,
      'sanskrit':
          'सर्वमेतदृतं मन्ये यन्मां वदसि केशव | न हि ते भगवन्व्यक्तिं विदुर्देवा न दानवाः || 14 ||',
      'translation':
          'I totally accept everything You have told me as the Truth. O Lord (Bhagavān), neither the celestial gods nor the demons (*Dānavāḥ*) can understand Your true manifestation (*vyaktiṁ*).',
      'word_meaning':
          'सर्वम् एतत्—all this; ऋतम्—truth; मन्ये—I accept; यत् माम्—which to me; वदसि—You tell; केशव—O Keśhava; न हि—certainly not; ते—Your; भगवन्—O Lord; व्यक्तिम्—manifestation/true identity; विदुः—know; देवाः—gods; न दानवाः—nor the demons.',
      'commentary':
          'Arjuna accepts the absolute reality of Krishna’s words (*ṛitaṁ manye*). He acknowledges that since Krishna is the ultimate source, His manifestation is beyond the comprehension of all created beings, confirming Krishna’s supremacy.',
    });

    // Verse 15: Krishna knows Himself
    await db.insert('chapter_10', {
      'verse_number': 15,
      'sanskrit':
          'स्वयमेवात्मनात्मानं वेत्थ त्वं पुरुषोत्तम | भूतभावन भूतेश देवदेव जगत्पते || 15 ||',
      'translation':
          'Indeed, You alone know Yourself by Your own power, O Supreme Person (*Puruṣhottama*), the Creator and Controller of all beings, the God of gods, and the Lord of the universe!',
      'word_meaning':
          'स्वयम् एव—You Yourself alone; आत्मना—by Your own Self; आत्मानम्—Your Self; वेत्थ—You know; त्वम्—You; पुरुष-उत्तम—O Supreme Person; भूत-भावन—O Creator of all beings; भूत-ईश—O Controller of all beings; देव-देव—O God of gods; जगत्-पते—O Lord of the universe.',
      'commentary':
          'Arjuna confirms that Krishna is the only competent source of this knowledge. By addressing Krishna with titles like *Puruṣhottama* and *Jagajpate*, Arjuna expresses full conviction in His omnipotence.',
    });

    // Verse 16: Arjuna's request for Vibhūtis (Glories)
    await db.insert('chapter_10', {
      'verse_number': 16,
      'sanskrit':
          'वक्तुमर्हस्यशेषेण दिव्या ह्यात्मविभूतयः | याभिर्विभूतिभिर्लोकानिमांस्त्वं व्याप्य तिष्ठसि || 16 ||',
      'translation':
          'Please describe Your divine glories (*divyā hyātma-vibhūtayaḥ*) in full, by which You remain pervading all these worlds.',
      'word_meaning':
          'वक्तुम् अर्हसि—You should speak; अशेषेण—in full; दिव्याः हि—indeed the divine; आत्म-विभूतयः—Your divine opulences; याभिः—by which; विभूतिभिः—opulences; लोकान्—worlds; इमान्—these; त्वम्—You; व्याप्य—pervading; तिष्ठसि—remain.',
      'commentary':
          'Arjuna asks for the Vibhūtis not out of curiosity, but to facilitate constant meditation. By knowing the most magnificent manifestations, the Yogi can more easily focus the mind on Krishna while observing the world.',
    });

    // Verse 17: How to meditate on the Lord
    await db.insert('chapter_10', {
      'verse_number': 17,
      'sanskrit':
          'कथं विद्यामहं योगिंस्त्वां सदा परिचिन्तयन् | केषु केषु च भावेषु चिन्त्योऽसि भगवन्मया || 17 ||',
      'translation':
          'O Master of Yoga, how may I know You and always think of You? And while meditating, in what specific forms should I think of You, O Lord?',
      'word_meaning':
          'कथम्—how; विद्याम्—may I know; अहम्—I; योगिन्—O Master of Yoga; त्वाम्—You; सदा—always; परिचिन्तयन्—meditating; केषु केषु च—and in which specific; भावेषु—manifestations/aspects; चिन्त्यः—to be thought of; असि—are You; भगवन्—O Lord; मया—by me.',
      'commentary':
          'Arjuna seeks practical guidance for *Dhyāna Yoga*. He asks for the most prominent, identifiable forms (*bhāveṣhu*) of Krishna that can act as focal points for the mind.',
    });

    // Verse 18: The desire to hear without end
    await db.insert('chapter_10', {
      'verse_number': 18,
      'sanskrit':
          'विस्तरेणात्मनो योगं विभूतिं च जनार्दन | भूयः कथय तृप्तिर्हि श्रृण्वतो नास्ति मेऽमृतम् || 18 ||',
      'translation':
          'O Janārdana, tell me in detail Your yogic power and opulence again, for I never tire of hearing Your nectar-like words.',
      'word_meaning':
          'विस्तरेण—in detail; आत्मनः—Your; योगम्—mystic power; विभूतिम्—opulence; च जनार्दन—and O Janārdana; भूयः—again; कथय—narrate; तृप्तिः—satisfaction; हि—certainly; शृण्वतः—to the one hearing; न अस्ति—there is no; मे—My; अमृतम्—nectar.',
      'commentary':
          'The greatness of spiritual discourse is that it is like nectar (*amṛitam*)—it satiates but does not cause fatigue. Arjuna expresses his insatiable desire to hear the Lord\'s glories (*Vibhūti*).',
    });

    // Verse 19: Krishna agrees to speak
    await db.insert('chapter_10', {
      'verse_number': 19,
      'sanskrit':
          'श्रीभगवानुवाच | हन्त ते कथयिष्यामि दिव्या ह्यात्मविभूतयः | प्राधान्यतः कुरुश्रेष्ठ नास्त्यन्तो विस्तरस्य मे || 19 ||',
      'translation':
          'The Supreme Lord said: Very well! I shall describe to you My divine glories, O best of the Kurus (Arjuna), but only the principal ones, for there is no end to My expanse.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; हन्त—well/yes; ते—to you; कथयिष्यामि—I shall describe; दिव्याः हि—indeed the divine; आत्म-विभूतयः—My own opulences; प्राधान्यतः—principally/chiefly; कुरु-श्रेष्ठ—O best of the Kurus; न अस्ति अन्तः—there is no end; विस्तरस्य—to the expanse; मे—My.',
      'commentary':
          'Krishna agrees, but sets a limit: He can only describe the *prādhānyataḥ* (principal/chief) manifestations. This emphasizes the infinite nature of God—His glory is limitless (*nāstyanto vistarasya me*).',
    });

    // Verse 20: Krishna begins the list of Vibhūtis (The Inner Self)
    await db.insert('chapter_10', {
      'verse_number': 20,
      'sanskrit':
          'अहमात्मा गुडाकेश सर्वभूताशयस्थितः | अहमादिश्च मध्यं च भूतानामन्त एव च || 20 ||',
      'translation':
          'O Arjuna (Guḍākeśa), I am the **Self seated in the hearts of all creatures**. I am the **beginning, the middle, and the very end of beings**.',
      'word_meaning':
          'अहम् आत्मा—I am the Self; गुडाकेश—O conqueror of sleep/ignorance (Arjuna); सर्व-भूत-आशय-स्थितः—situated in the heart of all creatures; अहम्—I; आदिः—the beginning; च—and; मध्यम्—middle; च—and; भूतानाम्—of all beings; अन्तः—the end; एव च—certainly also.',
      'commentary':
          'Krishna initiates the list of Vibhūtis not with an external object, but with the **Ātman** (Self), the most immediate and profound manifestation within the individual. He is the eternal, continuous presence (*ādiśh cha madhyaṁ cha anta eva cha*) in all life.',
    });

    await db.insert('chapter_10', {
      'verse_number': 21,
      'sanskrit':
          'आदित्यानामहं विष्णुर्ज्योतिषां रविरंशुमान् | मरीचिर्मरुतामस्मि नक्षत्राणामहं शशी || 21 ||',
      'translation':
          'Amongst the twelve sons of Aditi (*Ādityas*) I am **Vishnu**; amongst luminous objects (*jyotiṣhāṁ*) I am the radiant **Sun** (*Ravi*). Know Me to be **Marīchi** amongst the wind gods (*Maruts*), and the **Moon** (*Śhaśhī*) amongst the stars.',
      'word_meaning':
          'आदित्यानाम्—among the *Adityas*; अहम्—I; विष्णुः—Vishnu; ज्योतिषाम्—among luminous objects; रविः—the sun; अंशुमान्—radiant; मरीचिः—Marīchi; मरुताम्—of the *Maruts* (wind gods); अस्मि—I am; नक्षत्राणाम्—among the stars; अहम्—I; शशी—the moon.',
      'commentary':
          'Krishna begins the direct list of Vibhūtis. Vishnu is the most excellent of the Adityas, the radiant Sun is the chief of all light sources, Marīchi is the chief of the winds, and the Moon is the most pleasing light of the night sky.',
    });

    // Verse 22: Vibhūtis in the Vedas, gods, senses, and beings
    await db.insert('chapter_10', {
      'verse_number': 22,
      'sanskrit':
          'वेदानां सामवेदोऽस्मि देवानामस्मि वासवः | इन्द्रियाणां मनश्चास्मि भूतानामस्मि चेतना || 22 ||',
      'translation':
          'Amongst the Vedas, I am the **Sāma Veda**; amongst the celestial gods, I am **Vāsava** (Indra). Among the senses, I am the **mind** (*Manas*); and in all living beings, I am **Consciousness** (*Chetanā*).',
      'word_meaning':
          'वेदानाम्—of the Vedas; साम-वेदः—the Sāma Veda; अस्मि—I am; देवानाम्—of the gods; अस्मि—I am; वासवः—Vāsava (Indra); इन्द्रियाणाम्—of the senses; मनः—the mind; च अस्मि—and I am; भूतानाम्—of living beings; अस्मि—I am; चेतना—consciousness/sentience.',
      'commentary':
          'The *Sāma Veda* is considered the most melodious and profound Veda. The Mind (*Manas*) is the subtle master of the ten senses (five knowledge, five action), and **Consciousness** (*Chetanā*) is the essential principle of life.',
    });

    // Verse 23: Vibhūtis in destructive forces, mountains, priests, and water bodies
    await db.insert('chapter_10', {
      'verse_number': 23,
      'sanskrit':
          'रुद्राणां शङ्करश्चास्मि वित्तेशो यक्षरक्षसाम् | वसूनां पावकश्चास्मि मेरुः शिखरिणामहम् || 23 ||',
      'translation':
          'Amongst the eleven Rudras, I am **Śhaṅkara** (Lord Śhiva); amongst the *Yakṣhas* and *Rākṣhasas* (demi-gods/demons), I am the Lord of wealth, **Vitteśho** (Kubera). Amongst the Vasus, I am **Pāvaka** (Fire), and among mountains, I am **Meru**.',
      'word_meaning':
          'रुद्राणाम्—of the Rudras; शङ्करः—Śhaṅkara (Śhiva); च अस्मि—and I am; वित्त-ईशः—the Lord of wealth (Kubera); यक्ष-रक्षसाम्—of the *Yakṣhas* and *Rākṣhasas*; वसूनाम्—of the Vasus; पावकः—Pāvaka (Fire); च अस्मि—and I am; मेरुः—Mount Meru; शिखरिणाम्—of mountains; अहम्—I.',
      'commentary':
          'Krishna reveals Himself in the most powerful aspects of destruction (Śhiva) and stability (Mount Meru), showing that both creation and dissolution are controlled by Him.',
    });

    // Verse 24: Vibhūtis in priests, generals, and large water bodies
    await db.insert('chapter_10', {
      'verse_number': 24,
      'sanskrit':
          'पुरोधसां च मुख्यं मां विद्धि पार्थ बृहस्पतिम् | सेनानीनामहं स्कन्दः सरसामस्मि सागरः || 24 ||',
      'translation':
          'Amongst priests, know Me to be the chief, **Bṛihaspati**; amongst generals, I am **Skanda** (Kārttikeya). And among all reservoirs of water, I am the **Ocean** (*Sāgaraḥ*).',
      'word_meaning':
          'पुरोधसाम्—of the chief priests; च मुख्यम्—and the chief; माम्—Me; विद्धि—know; पार्थ—O Pārtha; बृहस्पतिम्—Bṛihaspati; सेनानीनाम्—of the generals; अहम्—I; स्कन्दः—Skanda; सरसाम्—of water bodies; अस्मि—I am; सागरः—the ocean.',
      'commentary':
          'Bṛihaspati is the guru of the gods, representing the highest wisdom and spiritual guidance. Skanda is the perfect general. The ocean is the largest and most complete water body, representing vastness and depth.',
    });

    // Verse 25: Vibhūtis in sages, sounds, rituals, and fixed things
    await db.insert('chapter_10', {
      'verse_number': 25,
      'sanskrit':
          'महर्षीणां भृगुरहं गिरामस्म्येकमक्षरम् | यज्ञानां जपयज्ञोऽस्मि स्थावराणां हिमालयः || 25 ||',
      'translation':
          'Amongst the great sages (*Maharṣhis*), I am **Bhṛigu**; amongst utterances, I am the **single syllable Om** (*ekam akṣharam*). Among sacrifices, I am the **sacrificing of chanting** (*Japa-Yajña*), and amongst immovable things, I am the **Himālaya**.',
      'word_meaning':
          'महर्षीणाम्—of the great sages; भृगुः—Bhṛigu; अहम्—I; गिराम्—of utterances/words; अस्मि—I am; एकम् अक्षरम्—the single syllable (Om); यज्ञानाम्—of sacrifices; जप-यज्ञः—sacrifice of chanting; अस्मि—I am; स्थावराणाम्—of immovable things; हिमालयः—the Himālaya.',
      'commentary':
          'The *Japa-Yajña* (repetition of sacred names) is hailed as the superior sacrifice, being easier and more spiritual than external rituals. The Himalaya represents immovable stability and spiritual power.',
    });

    // Verse 26: Vibhūtis in trees, Narada, music, and realized beings
    await db.insert('chapter_10', {
      'verse_number': 26,
      'sanskrit':
          'अश्वत्थः सर्ववृक्षाणां देवर्षीणां च नारदः | गन्धर्वाणां चित्ररथः सिद्धानां कपिलो मुनिः || 26 ||',
      'translation':
          'Amongst all trees, I am the **Aśhvatthā** (banyan tree); amongst divine sages (*Devarṣhis*), I am **Nārada**. Amongst the celestial singers (*Gandharvas*), I am **Chitraratha**, and amongst the perfected beings (*Siddhas*), I am the sage **Kapila**.',
      'word_meaning':
          'अश्वत्थः—Aśhvatthā (banyan); सर्व-वृक्षाणाम्—of all trees; देव-ऋषीणाम्—of the divine sages; च—and; नारदः—Nārada; गन्धर्वाणाम्—of the Gandharvas; चित्ररथः—Chitraratha; सिद्धानाम्—of the perfected beings; कपिलः मुनिः—the sage Kapila.',
      'commentary':
          'The Banyan tree is vast and long-lived, representing the Lord\'s pervasiveness. Nārada is the supreme devotee and messenger between the gods and mortals. Kapila is the original propounder of the Sānkhya philosophy.',
    });

    // Verse 27: Vibhūtis in horses, elephants, and humans
    await db.insert('chapter_10', {
      'verse_number': 27,
      'sanskrit':
          'उच्चैःश्रवसमश्वानां विद्धि माममृतोद्भवम् | ऐरावतं गजेन्द्राणां नराणां च नराधिपम् || 27 ||',
      'translation':
          'Among horses, know Me to be **Uchchaiḥśhravā** (born from the churning of the ocean of milk); among lordly elephants, **Airāvata**; and among human beings, the **King** (*Narādhipam*).',
      'word_meaning':
          'उच्चैः-श्रवसम्—Uchchaiḥśhravā; अश्वानाम्—of horses; विद्धि माम्—know Me; अमृत-उद्भवम्—born from the nectar (of the ocean); ऐरावतम्—Airāvata; गज-इन्द्राणाम्—of the kingly elephants; नराणाम्—of men; च—and; नर-अधिपम्—the king/monarch.',
      'commentary':
          'The Lord is the source of all majesty and excellence. The King (*narādhipam*) is the most visible and powerful manifestation of God\'s ruling power on Earth.',
    });

    // Verse 28: Vibhūtis in weapons, cows, and progenitors
    await db.insert('chapter_10', {
      'verse_number': 28,
      'sanskrit':
          'आयुधानामहं वज्रं धेनूनामस्मि कामधुक् | प्रजनश्चास्मि कन्दर्पः सर्पाणामस्मि वासुकिः || 28 ||',
      'translation':
          'Amongst weapons, I am the **thunderbolt** (*Vajra*); amongst cows, I am **Kāmadhuk** (the wish-fulfilling cow); I am **Kandarpa** (the God of love) for procreation; and amongst serpents, I am **Vāsuki**.',
      'word_meaning':
          'आयुधानाम्—of weapons; अहम्—I; वज्रम्—the thunderbolt; धेनूनाम्—of cows; अस्मि—I am; कामधुक्—Kāmadhuk (wish-fulfilling cow); प्रजनः—procreation; च अस्मि—and I am; कन्दर्पः—Kandarpa (Cupid); सर्पाणाम्—of serpents; अस्मि—I am; वासुकिः—Vāsuki.',
      'commentary':
          'Krishna is the ultimate force behind power (*Vajra*), fulfillment (*Kāmadhuk*), and even procreation (*Kandarpa*), showing that the fundamental creative urge (*kāma*) is divine when used for the perpetuation of life.',
    });

    // Verse 29: Vibhūtis in snakes, deities, and ancestors
    await db.insert('chapter_10', {
      'verse_number': 29,
      'sanskrit':
          'अनन्तश्चास्मि नागानां वरुणो यादसामहम् | पितॄणामर्यमा चास्मि यमः संयमतामहम् || 29 ||',
      'translation':
          'Amongst the Nāgas (multi-headed snakes), I am **Ananta**; amongst water deities, I am **Varuṇa**. Amongst the ancestors (*Pitṛis*), I am **Aryamā**, and amongst those who administer punishment, I am **Yama** (the Lord of Death).',
      'word_meaning':
          'अनन्तः च अस्मि—and I am Ananta; नागानाम्—of the Nāgas (divine snakes); वरुणः—Varuṇa; यादसाम्—of water deities; अहम्—I; पितॄणाम्—of the ancestors; अर्यमा—Aryamā; च अस्मि—and I am; यमः—Yama; संयमताम्—of the controllers/punishers; अहम्—I.',
      'commentary':
          'Krishna is manifest in the most powerful mythical beings and the essential cosmic laws of order: the foundational space (*Ananta*), the law of justice (*Yama*), and the maintenance of ancestral tradition (*Aryamā*).',
    });

    // Verse 30: Vibhūtis in demons, wild animals, and time
    await db.insert('chapter_10', {
      'verse_number': 30,
      'sanskrit':
          'प्रह्लादश्चास्मि दैत्यानां कालः कलयतामहम् | मृगाणां च मृगेन्द्रोऽहं वैनतेयश्च पक्षिणाम् || 30 ||',
      'translation':
          'Amongst the demons (*Daityas*), I am **Prahlāda**; amongst controllers, I am **Time** (*Kālaḥ*). Among wild animals, I am the **Lion** (*Mṛigendraḥ*), and amongst birds, I am **Vainateya** (Garuḍa).',
      'word_meaning':
          'प्रह्लादः च अस्मि—and I am Prahlāda; दैत्यानाम्—of the demons; कालः—Time; कलयताम्—of those who measure/control; अहम्—I; मृगाणाम्—of wild animals; च मृग-इन्द्रः—and the King of animals (Lion); अहम्—I; वैनतेयः च—and Vainateya (Garuḍa); पक्षिणाम्—of birds.',
      'commentary':
          'Prahlāda is unique as the greatest devotee born into a demon family. **Time** (*Kālaḥ*) is the supreme controller and destroyer of all existence, demonstrating Krishna\'s ultimate, irresistible force.',
    });

    // Verse 31: Vibhūtis in purification, warriors, aquatics, and rivers
    await db.insert('chapter_10', {
      'verse_number': 31,
      'sanskrit':
          'पवनः पवतामस्मि रामः शस्त्रभृतामहम् | झषाणां मकरश्चास्मि स्रोतसामस्मि जाह्नवी || 31 ||',
      'translation':
          'Amongst purifiers, I am the **Wind** (*Pāvanaḥ*); amongst wielders of weapons, I am **Rāma**. Among water creatures, I am the **Shark** (*Makara*), and of flowing rivers, I am the **Jāhnavī** (Ganges).',
      'word_meaning':
          'पवनः—wind; पवताम्—of all that purifies; अस्मि—I am; रामः—Rāma; शस्त्र-भृताम्—of the carriers of weapons; अहम्—I am; झषाणाम्—of all aquatics; मकरः—the shark; च अस्मि—and I am; स्रोतसाम्—of flowing rivers; अस्मि—I am; जाह्नवी—the Ganges.',
      'commentary':
          'Krishna identifies with **Lord Rāma**, the perfect wielder of weapons and upholder of *Dharma*, and the **Ganges** (Jāhnavī), revered as the holiest of all rivers for its unmatched purifying power.',
    });

    // Verse 32: Vibhūtis in creation, knowledge, and speech
    await db.insert('chapter_10', {
      'verse_number': 32,
      'sanskrit':
          'सर्गाणामादिरन्तश्च मध्यं चैवाहमर्जुन | अध्यात्मविद्या विद्यानां वादः प्रवदतामहम् || 32 ||',
      'translation':
          'Amongst creations, O Arjuna, I am the **beginning, the middle, and also the end**. Among sciences, I am the **Science of the Self** (*Adhyātma Vidyā*), and among debating forms, I am the logical **Conclusion** (*Vādaḥ*).',
      'word_meaning':
          'सर्गाणाम्—of creations; आदिः—the beginning; अन्तः—the end; च मध्यम्—and the middle; च एव—and also; अहम्—I; अर्जुन—O Arjuna; अध्यात्म-विद्या—spiritual knowledge; विद्यानाम्—of sciences; वादः—argument/logical conclusion; प्रवदताम्—of speakers/debators; अहम्—I.',
      'commentary':
          'Krishna returns to His fundamental role as the cosmic timeline (beginning, middle, and end) and affirms the supremacy of **spiritual knowledge** (*Adhyātma Vidyā*) over all material disciplines.',
    });

    // Verse 33: Vibhūtis in letters, compound words, and time
    await db.insert('chapter_10', {
      'verse_number': 33,
      'sanskrit':
          'अक्षराणामकारोऽस्मि द्वन्द्वः सामासिकस्य च | अहमेवाक्षयः कालो धाताहं विश्वतोमुखः || 33 ||',
      'translation':
          'Amongst letters, I am the letter **A** (*akāraḥ*); amongst compound words, I am the **copulative compound** (*dvandvaḥ*). I am also **Imperishable Time** (*Akṣhayaḥ Kālo*), and I am the Creator (*Dhātā*) whose face is everywhere.',
      'word_meaning':
          'अक्षराणाम्—of letters; अकारः—the letter "A"; अस्मि—I am; द्वन्द्वः—the copulative compound; सामासिकस्य—of compound words; च—and; अहम् एव—I alone am; अक्षयः कालः—imperishable Time; धाता—the creator; अहम्—I; विश्वतः-मुखः—whose face is everywhere.',
      'commentary':
          'The letter **A** is the root sound of all language. The *Dvandva* compound, which joins two equal elements, symbolizes the integration and inclusiveness of the Lord. He is also the unstoppable current of Time.',
    });

    // Verse 34: Vibhūtis in destructive forces, creation, and feminine qualities
    await db.insert('chapter_10', {
      'verse_number': 34,
      'sanskrit':
          'मृत्युः सर्वहरश्चाहमुद्भवश्च भविष्यताम् | कीर्तिः श्रीर्वाक् च नारीणां स्मृतिर्मेधा धृतिः क्षमा || 34 ||',
      'translation':
          'I am the all-devouring **Death** (*Mṛityuḥ*) and the source of all things that are yet to be born (*Udbhavaḥ*). Amongst feminine qualities, I am **Fame** (*Kīrtiḥ*), **Prosperity** (*Śhrīḥ*), **Speech** (*Vāk*), **Memory** (*Smṛitiḥ*), **Intelligence** (*Medhā*), **Steadfastness** (*Dhṛitiḥ*), and **Forgiveness** (*Kṣhamā*).',
      'word_meaning':
          'मृत्युः—Death; सर्व-हरः—all-devouring; च अहम्—and I am; उद्भवः—the source/birth; च भविष्यताम्—and of future things; कीर्तिः—fame; श्रीः—prosperity; वाक् च—and speech; नारीणाम्—among women; स्मृतिः—memory; मेधा—intelligence; धृतिः—steadfastness; क्षमा—forgiveness.',
      'commentary':
          'Krishna controls both ultimate destruction and future creation. He is the essence of the seven feminine divine qualities that are the highest and most powerful expressions of *Prakṛiti* in human nature.',
    });

    // Verse 35: Vibhūtis in hymns, poetry, and seasons
    await db.insert('chapter_10', {
      'verse_number': 35,
      'sanskrit':
          'बृहत्साम तथा साम्नां गायत्री छन्दसामहम् | मासानां मार्गशीर्षोऽहमृतूनां कुसुमाकरः || 35 ||',
      'translation':
          'Amongst the hymns of the Sāma Veda, I am the **Bṛihat-Sāma**; amongst meters, I am the **Gāyatrī** mantra. Amongst months, I am **Mārgaśhīrṣha** (November-December), and amongst seasons, I am the flower-bearing **Spring** (*Kusumākaraḥ*).',
      'word_meaning':
          'बृहत्-साम—the Bṛihat-Sāma (hymn); तथा—and; साम्नाम्—of the Sāma hymns; गायत्री—Gāyatrī; छन्दसाम्—of meters; अहम्—I; मासानाम्—of months; मार्गशीर्षः—Mārgaśhīrṣha (the month); अहम्—I; ऋतूनाम्—of seasons; कुसुम-आकरः—flower-bearing (Spring).',
      'commentary':
          'The *Bṛihat-Sāma* and *Gāyatrī* are considered the most sacred parts of the Vedas. Mārgaśhīrṣha is considered the most pleasant and spiritually potent time of the year in the ancient Indian calendar.',
    });

    // Verse 36: Vibhūtis in negative forces, leadership, and knowledge
    await db.insert('chapter_10', {
      'verse_number': 36,
      'sanskrit':
          'द्यूतं छलयतामस्मि तेजस्तेजस्विनामहम् | जयोऽस्मि व्यवसायोऽस्मि सत्त्वं सत्त्ववतामहम् || 36 ||',
      'translation':
          'I am the **gambling** (*Dyūtaṁ*) of the cheats; I am the **splendor** (*Tejas*) of the splendid. I am **Victory** (*Jayaḥ*), I am **Determination** (*Vyavasāyaḥ*), and I am the **goodness** (*Sattvaṁ*) of the virtuous.',
      'word_meaning':
          'द्यूतम्—gambling; छलयताम्—of cheats; अस्मि—I am; तेजः—splendor; तेजस्विनाम्—of the splendid; अहम्—I; जयः—victory; अस्मि—I am; व्यवसायः—determination; अस्मि—I am; सत्त्वम्—goodness; सत्त्व-वताम्—of the virtuous; अहम्—I.',
      'commentary':
          'Krishna even includes the most destructive power—gambling—as His manifestation in the realm of deceit. More importantly, He is the positive force behind success, determination, and all spiritual virtues.',
    });

    // Verse 37: Vibhūtis in the Vṛṣhṇi clan, Pāṇḍavas, and sages
    await db.insert('chapter_10', {
      'verse_number': 37,
      'sanskrit':
          'वृष्णीनां वासुदेवोऽस्मि पाण्डवानां धनञ्जयः | मुनीनामप्यहं व्यासः कवीनामुशना कविः || 37 ||',
      'translation':
          'Amongst the descendants of Vṛṣhṇi, I am **Vāsudeva** (Krishna); amongst the Pāṇḍavas, I am **Dhanañjaya** (Arjuna). Among the sages, I am **Vyāsa**, and amongst the great thinkers, I am **Uśhanā**.',
      'word_meaning':
          'वृष्णीनाम्—of the Vṛṣhṇi clan; वासुदेवः—Vāsudeva (Krishna); अस्मि—I am; पाण्डवानाम्—of the Pāṇḍavas; धनञ्जयः—Dhanañjaya (Arjuna); मुनीनाम्—of the silent sages; अपि अहम्—I am also; व्यासः—Vyāsa; कवीनाम्—of the great thinkers/poets; उशना कविः—Uśhanā (Śhukrāchārya).',
      'commentary':
          'Krishna points to Himself and to Arjuna as the highest example in their respective clans. Vyāsa is the compiler of the Vedas and the author of the *Mahābhārata*, representing supreme scriptural knowledge.',
    });

    // Verse 38: Vibhūtis in control, punishment, and knowledge
    await db.insert('chapter_10', {
      'verse_number': 38,
      'sanskrit':
          'दण्डो दमयतामस्मि नीतिरस्मि जिगीषताम् | मौनं चैवास्मि गुह्यानां ज्ञानं ज्ञानवतामहम् || 38 ||',
      'translation':
          'Amongst means of control, I am the **Rod of Punishment** (*Daṇḍa*); amongst those seeking victory, I am **Ethics** (*Nītiḥ*). I am the **Silence** (*Maunam*) of secrets, and I am the **Knowledge** (*Jñānaṁ*) of the knowledgeable.',
      'word_meaning':
          'दण्डः—punishment; दमयताम्—of those who control/subdue; अस्मि—I am; नीतिः—ethics/statecraft; अस्मि—I am; जिगीषताम्—of those desiring victory; मौनम्—silence; च एव अस्मि—and I am; गुह्यानाम्—of secrets; ज्ञानम्—knowledge; ज्ञान-वताम्—of the knowledgeable; अहम्—I.',
      'commentary':
          'The ultimate principles of governance (*Daṇḍa* and *Nīti*) are manifestations of the Lord. **Silence** is the essence of true secrecy, and **knowledge** is the inherent power of the learned.',
    });

    // Verse 39: Krishna is the source of all existence
    await db.insert('chapter_10', {
      'verse_number': 39,
      'sanskrit':
          'यच्चापि सर्वभूतानां बीजं तदहमर्जुन | न तदस्ति विना यत्स्यान्मया भूतं चराचरम् || 39 ||',
      'translation':
          'O Arjuna, I am also the **seed** of all beings. There is nothing, whether moving or non-moving, that can exist without Me.',
      'word_meaning':
          'यत् च अपि—and also whichever; सर्व-भूतानाम्—of all beings; बीजम्—the seed; तत् अहम्—that I am; अर्जुन—O Arjuna; न तत् अस्ति—not that exists; विना—without; यत् स्यात्—which may be; मया—Me; भूतम्—being; चर-अचरम्—moving and non-moving.',
      'commentary':
          'This returns to the fundamental truth of creation. As the eternal, conscious seed, Krishna is the essential substratum; everything else is merely a dependent manifestation.',
    });

    // Verse 40: The infinitesimality of the opulences
    await db.insert('chapter_10', {
      'verse_number': 40,
      'sanskrit':
          'नान्तोऽस्ति मम दिव्यानां विभूतीनां परन्तप | एष तूद्देशतः प्रोक्तो विभूतेर्विस्तरो मया || 40 ||',
      'translation':
          'O scorcher of foes (Arjuna), there is **no end** to My divine opulences. What I have declared to you is merely a brief statement of My expanse.',
      'word_meaning':
          'न अन्तः—there is no end; अस्ति—is; मम—My; दिव्यानाम्—divine; विभूतीनाम्—of opulences; परन्तप—O scorcher of foes; एषः तु—this indeed; उद्देशतः—as an indication/briefly; प्रोक्तः—spoken; विभूतेः—of opulence; विस्तरः—the expanse; मया—by Me.',
      'commentary':
          'Krishna concludes the detailed enumeration by stating that the lists provided are merely representative. His full glory is infinite and cannot be captured in words.',
    });

    // Verse 41: The spark of divine splendor
    await db.insert('chapter_10', {
      'verse_number': 41,
      'sanskrit':
          'यद्यद्विभूतिमत्सत्त्वं श्रीमदूर्जितमेव वा | तत्तदेवावगच्छ त्वं मम तेजोंऽशसम्भवम् || 41 ||',
      'translation':
          'Whatever being or object is glorious, beautiful, or powerful, know that it has sprung from but a **spark of My splendor**.',
      'word_meaning':
          'यत् यत्—whatever; विभूति-मत्—glorious; सत्त्वम्—being/existence; श्री-मत्—beautiful/opulent; ऊर्जितम्—powerful; एव वा—or certainly; तत् तत् एव—that alone; अवगच्छ—know; त्वम्—you; मम—My; तेजः-अंश-सम्भवम्—born of a fraction of My splendor.',
      'commentary':
          'This provides the ultimate method for *Vibhūti Yoga*: Whenever you see anything magnificent, powerful, or beautiful in the world, recognize it immediately as a tiny, temporary **fraction** (*aṁśā*) of the Supreme Lord\'s infinite power.',
    });

    // Verse 42: Conclusion of the Vibhūti Yoga
    await db.insert('chapter_10', {
      'verse_number': 42,
      'sanskrit':
          'अथवा बहुनैतेन किं ज्ञातेन तवार्जुन | विष्टभ्याहमिदं कृत्स्नमेकांशेन स्थितो जगत् || 42 ||',
      'translation':
          'But what need is there for all this detailed knowledge, O Arjuna? I pervade and sustain this entire universe merely with **one single fraction of My Self** (*ekāṁśhena*).',
      'word_meaning':
          'अथवा—or else; बहुना—much; एतेन—by this; किम्—what; ज्ञातेन—by knowing; तव अर्जुन—your, O Arjuna; विष्टभ्य—firmly pervading/sustaining; अहम्—I; इदम् कृत्स्नम्—this entire; एक-अंशेन—by a single fraction; स्थितः—I am situated; जगत्—universe.',
      'commentary':
          'Krishna brings the discourse to a powerful close. The entire cosmos, with all its infinite wonders, is sustained by only a tiny fraction of the Lord’s power. This affirms His true nature is beyond all material manifestation.',
    });
  }

  Future<void> insertChapter11Verses(Database db) async {
    // Verse 1: Arjuna acknowledges the dispelled delusion
    await db.insert('chapter_11', {
      'verse_number': 1,
      'sanskrit':
          'अर्जुन उवाच | मदनुग्रहाय परमं गुह्यमध्यात्मसञ्ज्ञितम् | यत्त्वयोक्तं वचस्तेन मोहोऽयं विगतो मम || 1 ||',
      'translation':
          'Arjuna said: Having heard the supremely confidential spiritual knowledge, which You have revealed **out of compassion for me**, my delusion (*mohaḥ*) is now dispelled.',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; मत्-अनुग्रहाय—out of compassion to me; परमम्—supreme; गुह्यम्—confidential; अध्यात्म-सञ्ज्ञितम्—concerning the Self; यत् त्वया—which by You; उक्तम्—spoken; वचः—words; तेन—by that; मोहः अयम्—this illusion; विगतः—is dispelled; मम—my.',
      'commentary':
          'Arjuna acknowledges that the philosophical teachings of the previous chapters—particularly the nature of the *Ātman* and the *Vibhūtis*—have worked. His original delusion (*moha*), rooted in attachment to the body (Ch. 1), is gone.',
    });

    // Verse 2: Confirming the knowledge received
    await db.insert('chapter_11', {
      'verse_number': 2,
      'sanskrit':
          'भवाप्ययौ हि भूतानां श्रुतौ विस्तरशो मया | त्वत्तः कमलपत्राक्ष माहात्म्यमपि चाव्ययम् || 2 ||',
      'translation':
          'O Lotus-eyed One, I have heard from You in detail about the appearance and disappearance of all living beings, and also about Your eternal, imperishable glory (*Māhātmyam*).',
      'word_meaning':
          'भव-अप्ययौ—creation and dissolution; हि—certainly; भूतानाम्—of beings; श्रुतौ—have been heard; विस्तरशः—in detail; मया—by me; त्वत्तः—from You; कमल-पत्र-अक्ष—O lotus-eyed one; माहात्म्यम्—glory; अपि च—and also; अव्ययम्—imperishable.',
      'commentary':
          'Arjuna confirms that he has grasped the concepts of cosmic cycles (Ch. 7 & 8) and divine opulence (Ch. 10). The knowledge is intellectual, but he now seeks direct realization of the speaker\'s identity.',
    });

    // Verse 3: Arjuna's request for the Cosmic Form
    await db.insert('chapter_11', {
      'verse_number': 3,
      'sanskrit':
          'एवमेतद्यथात्थ त्वमात्मानं परमेश्वर | द्रष्टुमिच्छामि ते रूपमैश्वरं पुरुषोत्तम || 3 ||',
      'translation':
          'O Supreme Lord (*Parameśhvara*), You are exactly what You declare Yourself to be. Now, O **Greatest of Persons** (*Puruṣhottama*), I desire to see Your divine **Cosmic Form** (*aiśhvaraṁ rūpaṁ*).',
      'word_meaning':
          'एवम् एतत्—this is indeed so; यथा आत्थ—just as You have spoken; त्वम्—You; आत्मानम्—Your Self; परमेश्वर—O Supreme Lord; द्रष्टुम् इच्छामि—I desire to see; ते—Your; रूपम्—form; ऐश्वरम्—divine/sovereign; पुरुषोत्तम—O Greatest of Persons.',
      'commentary':
          'This is the key request of the chapter. Arjuna faith is complete, but he wants visual, direct proof to substantiate the abstract knowledge of Krishna\'s universal power, proving that the abstract *Brahman* is identical with the historical person, Krishna.',
    });

    // Verse 4: Conditional Request
    await db.insert('chapter_11', {
      'verse_number': 4,
      'sanskrit':
          'मन्यसे यदि तच्छक्यं मया द्रष्टुमिति प्रभो | योगेश्वर ततो मे त्वं दर्शयात्मानमव्ययम् || 4 ||',
      'translation':
          'O Lord (*Prabhu*), if You think that it can be seen by me, then, O **Master of all mystic powers** (*Yogeśhvara*), show me Your imperishable Self.',
      'word_meaning':
          'मन्यसे—You think; यदि—if; तत् शक्यम्—that is possible; मया—by me; द्रष्टुम्—to be seen; इति—thus; प्रभो—O Lord; योगेश्वर—O Master of all mystic powers; ततः—then; मे—to me; त्वम्—You; दर्शय—show; आत्मानम्—Your Self; अव्ययम्—imperishable.',
      'commentary':
          'Arjuna prudently qualifies his request, recognizing that a human mind and eyes cannot sustain the vision of the infinite Divine Form. He asks permission based on his worthiness, addressing Krishna as the controller of all power (*Yogeśhvara*).',
    });

    // Verse 5: Krishna's response: Behold My forms
    await db.insert('chapter_11', {
      'verse_number': 5,
      'sanskrit':
          'श्रीभगवानुवाच | पश्य मे पार्थ रूपाणि शतशोऽथ सहस्रशः | नानाविधानि दिव्यानि नानावर्णाकृतीनि च || 5 ||',
      'translation':
          'The Supreme Lord said: Behold, O Pārtha, My hundreds and thousands of wonderful forms (*rūpāṇi*), of various kinds, divine, and of diverse colors and shapes.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; पश्य—behold; मे—My; पार्थ—O Pārtha; रूपाणि—forms; शतशः—hundreds; अथ—and also; सहस्रशः—thousands; नाना-विधानि—of various kinds; दिव्यानि—divine; नाना-वर्ण-आकृतीनि—of various colors and shapes; च—and.',
      'commentary':
          'Krishna immediately agrees, using terms (*śhataśho’tha sahasraśhaḥ*) that emphasize the sheer multiplicity and infinite variability of His forms.',
    });

    // Verse 6: Enumeration of the celestial groups
    await db.insert('chapter_11', {
      'verse_number': 6,
      'sanskrit':
          'पश्यादित्यान्वसून्रुद्रानश्विनौ मरुतस्तथा | बहून्यदृष्टपूर्वाणि पश्याश्चर्याणि भारत || 6 ||',
      'translation':
          'Behold in Me, O descendant of Bharata, the **Ādityas** (sons of Aditi), the **Vasus**, the **Rudras**, the **two Aśhvinī Kumāras**, and the **Maruts** (wind gods). Behold many more wonders never seen before.',
      'word_meaning':
          'पश्य—behold; आदित्यान्—the Ādityas; वसून्—the Vasus; रुद्रान्—the Rudras; अश्विनौ—the two Aśhvinī Kumāras; मरुतः—the Maruts; तथा—and also; बहूनि—many; अदृष्ट-पूर्वाणि—never seen before; पश्य—behold; आश्चर्याणि—wonders; भारत—O descendant of Bharata.',
      'commentary':
          'Krishna names the primary celestial deities who govern the cosmos. The Cosmic Form is a direct manifestation of all these powers and beings assembled in one place, showing the universality of the Lord.',
    });

    // Verse 7: The entire cosmos in one place
    await db.insert('chapter_11', {
      'verse_number': 7,
      'sanskrit':
          'इहैकस्थं जगत्कृत्स्नं पश्याद्य सचराचरम् | मम देहे गुडाकेश यच्चान्यद्द्रष्टुमिच्छसि || 7 ||',
      'translation':
          'Behold now, O Guḍākeśa (Arjuna), the entire universe—with everything moving and non-moving—assembled together in one place here within My body. Whatever else you wish to see, observe it all within this Universal Form.',
      'word_meaning':
          'इह—here; एक-स्थम्—assembled in one place; जगत्—universe; कृत्स्नम्—entire; पश्य—behold; अद्य—now; स-चर-अचरम्—with the moving and non-moving; मम देहे—in My body; गुडाकेश—O Guḍākeśa; यत् च अन्यत्—and whatever else; द्रष्टुम्—to see; इच्छसि—you desire.',
      'commentary':
          'The Cosmic Form is described as the container of all existence (*jagatkṛitsnam*). Krishna offers a complete vision, reassuring Arjuna that if there is anything specific he seeks, he will see it within this Form.',
    });

    // Verse 8: The Divine Eye is necessary
    await db.insert('chapter_11', {
      'verse_number': 8,
      'sanskrit':
          'न तु मां शक्यसे द्रष्टुमनेनैव स्वचक्षुषा | दिव्यं ददामि ते चक्षुः पश्य मे योगमैश्वरम् || 8 ||',
      'translation':
          'But you are not able to see Me with these ordinary eyes of yours. I grant you the **divine eye** (*divyaṁ chakṣhuḥ*); behold My supreme, sovereign, mystic power.',
      'word_meaning':
          'न तु—but not; माम्—Me; शक्यसे—are you able; द्रष्टुम्—to see; अनेन एव—with these only; स्व-चक्षुषा—your own eyes; दिव्यम्—divine; ददामि—I give; ते—to you; चक्षुः—eye; पश्य—behold; मे—My; योगम् ऐश्वरम्—divine mystic power.',
      'commentary':
          'The material senses are incapable of perceiving the Absolute Truth. Therefore, Krishna grants Arjuna the **Divya Chakṣhu** (Divine Eye)—a temporary, supernatural ability—to make the transcendental experience possible.',
    });

    // Verse 9: Sañjaya begins the description
    await db.insert('chapter_11', {
      'verse_number': 9,
      'sanskrit':
          'सञ्जय उवाच | एवमुक्त्वा ततो राजन्महायोगेश्वरो हरिः | दर्शयामास पार्थाय परमं रूपमैश्वरम् || 9 ||',
      'translation':
          'Sañjaya said: Having spoken thus, O King (Dhritarashtra), the great Lord of Yoga (*Mahāyogeśhvaro*) Hari then revealed the Supreme, Sovereign Form to Pārtha (Arjuna).',
      'word_meaning':
          'सञ्जयः उवाच—Sañjaya said; एवम् उक्त्वा—having spoken thus; ततः—then; राजन्—O King; महा-योग-ईश्वरः—the great Master of Yoga; हरिः—Hari (Krishna); दर्शयामास—revealed; पार्थाय—to Arjuna; परमम्—supreme; रूपम्—form; ऐश्वरम्—divine/sovereign.',
      'commentary':
          'The narrative shifts back to Sañjaya, the divine narrator, who confirms that Krishna used His inherent power, addressing Him as **Mahāyogeśhvaro** to highlight His capacity to perform this miracle.',
    });

    // Verse 10: The initial description of the Viśhwarūpa (Cosmic Form)
    await db.insert('chapter_11', {
      'verse_number': 10,
      'sanskrit':
          'अने कवक्त्रनयनमनेकाद्भुतदर्शनम् | अनेकदिव्याभरणं दिव्यानेकोद्यतायुधम् || 10 ||',
      'translation':
          'The Form possessed many mouths and eyes, displaying many wonderful sights; adorned with numerous divine ornaments, and holding many uplifted celestial weapons.',
      'word_meaning':
          'अनेक-वक्त्र-नयनम्—having many mouths and eyes; अनेक-अद्भुत-दर्शनम्—displaying many wonderful sights; अनेक-दिव्य-आभरणम्—adorned with numerous divine ornaments; दिव्य-अनेक-उद्यत-आयुधम्—holding many uplifted celestial weapons.',
      'commentary':
          'Sañjaya begins the direct description. The sheer multiplicity (many mouths, many eyes) signifies the Lord\'s omniscience and omnipresence, transcending the limits of the normal human body.',
    });

    // Verse 11: Further opulence of the Form
    await db.insert('chapter_11', {
      'verse_number': 11,
      'sanskrit':
          'दिव्यमाल्याम्बरधरं दिव्यगन्धानुलेपनम् | सर्वाश्चर्यमयं देवमनन्तं विश्वतोमुखम् || 11 ||',
      'translation':
          'Wearing divine garlands and apparel, smeared with heavenly scents, full of all wonders, the brilliant, infinite, and all-pervading Divine Form.',
      'word_meaning':
          'दिव्य-माल्य-अम्बर-धरम्—wearing divine garlands and apparel; दिव्य-गन्ध-अनुलेपनम्—smeared with heavenly scents; सर्व-आश्चर्य-मयम्—full of all wonders; देवम्—brilliant/divine; अनन्तम्—infinite; विश्वतः-मुखम्—whose face is everywhere.',
      'commentary':
          'The Form is not merely immense but is characterized by divine beauty and fragrance, indicating its spiritual, non-material nature. **Viśhvato-mukham** (facing everywhere) reiterates the Lord’s all-encompassing presence.',
    });

    // Verse 12: Comparison of the Form's radiance
    await db.insert('chapter_11', {
      'verse_number': 12,
      'sanskrit':
          'दिवि सूर्यसहस्रस्य भवेद्युगपदुत्थिता | यदि भाः सदृशी सा स्याद् भासस्तस्य महात्मनः || 12 ||',
      'translation':
          'If the brilliance of a thousand suns were to burst forth simultaneously in the sky, that might perhaps be comparable to the radiance of that Supreme Soul.',
      'word_meaning':
          'दिवि—in the sky; सूर्य-सहस्रस्य—of a thousand suns; भवेत्—might be; युगपत्—simultaneously; उत्थिता—burst forth; यदि—if; भाः—radiance; सदृशी—comparable; सा—that; स्यात्—might be; भासः—to the radiance; तस्य—of that; महा-आत्मनः—Supreme Soul.',
      'commentary':
          'The immensity of the Form is illustrated through light. The simultaneous radiance of **a thousand suns** is used as a metaphor, indicating that the Lord\'s spiritual energy is overwhelmingly brilliant and beyond mortal sensory capacity.',
    });

    // Verse 13: Arjuna sees the universal unity
    await db.insert('chapter_11', {
      'verse_number': 13,
      'sanskrit':
          'तत्रैकस्थं जगत्कृत्स्नं प्रविभक्तमनेकधा | अपश्यद्देवदेवस्य शरीरे पाण्डवस्तदा || 13 ||',
      'translation':
          'Arjuna then saw the entire cosmos—divided into many parts—all gathered together and resting in one place within the body of the God of gods.',
      'word_meaning':
          'तत्र—there; एक-स्थम्—in one place; जगत् कृत्स्नम्—the entire universe; प्रविभक्तम्—divided; अनेकधा—into many ways; अपश्यत्—saw; देव-देवस्य—of the God of gods; शरीरे—in the body; पाण्डवः—Arjuna; तदा—then.',
      'commentary':
          'This is Arjuna\'s initial perception. He realizes that the philosophical truth—that the cosmos (*jagat*) is contained within the Absolute (Krishna)—is visually literal. He sees the unity of existence despite its myriad forms (*anekadhā*).',
    });

    // Verse 14: Arjuna's reaction of humility
    await db.insert('chapter_11', {
      'verse_number': 14,
      'sanskrit':
          'ततः स विस्मयाविष्टो हृष्टरोमा धनञ्जयः | प्रणम्य शिरसा देवं कृताञ्जलिरभाषत || 14 ||',
      'translation':
          'Then, Dhanañjaya (Arjuna), filled with wonder (*vismayāviṣhṭo*) and with hair standing on end (due to ecstasy), bowed his head to the Divine Lord and, joining his palms (in supplication), began to speak.',
      'word_meaning':
          'ततः—then; सः—he; विस्मय-आविष्टः—filled with wonder; हृष्ट-रोमा—with hair standing on end; धनञ्जयः—Arjuna; प्रणम्य—bowing down; शिरसा—with the head; देवम्—the Divine Lord; कृत-अञ्जलिः—with joined palms; अभाषत—spoke.',
      'commentary':
          'The immediate effect of the vision is overwhelming awe (*vismaya*) and spiritual ecstasy (*hṛiṣhṭa-romā*). Arjuna immediately abandons his position as a friend and assumes the role of a humbled devotee (*kṛitāñjaliḥ*) before the Supreme.',
    });

    // Verse 15: Arjuna describes the gods and sages
    await db.insert('chapter_11', {
      'verse_number': 15,
      'sanskrit':
          'पश्यामि देवांस्तव देव देहे सर्वान्स्तथा भूतविशेषसङ्घान् | ब्रह्माणमीशं कमल आसनस्थ-मृषींश्च सर्वानुरगांश्च दिव्यान् || 15 ||',
      'translation':
          'Arjuna said: O Lord, I see all the gods in Your body, as well as the diverse hosts of beings; Brahmā seated on the lotus seat, all the great sages, and the divine serpents.',
      'word_meaning':
          'पश्यामि—I see; देवान्—gods; तव देहे—in Your body; सर्वान्—all; तथा—also; भूत-विशेष-सङ्घान्—diverse hosts of beings; ब्रह्माणम्—Brahmā; ईशम्—Śhiva; कमल-आसन-स्थम्—seated on the lotus seat; ऋषीन् च सर्वान्—and all the sages; उरगान् च दिव्यान्—and the divine serpents.',
      'commentary':
          'Arjuna begins his direct description, highlighting that he sees the entire cosmic hierarchy—from the creator Brahmā to the highest sages and divine serpents—all contained within Krishna’s singular body, confirming Krishna\'s position as *Deva-Deva* (God of gods).',
    });

    // Verse 16: The immeasurable form
    await db.insert('chapter_11', {
      'verse_number': 16,
      'sanskrit':
          'अने कबाहूदरवक्त्रनेत्रं पश्यामि त्वा सर्वतोऽनन्तरूपम् | नान्तं न मध्यं न पुनस्तवादिं पश्यामि विश्वेश्वर विश्वरूप || 16 ||',
      'translation':
          'O Lord of the Universe (*Viśhveśhvara*), O Universal Form (*Viśhwarūpa*), I see You everywhere with unlimited arms, stomachs, faces, and eyes. I see neither Your beginning, nor Your middle, nor Your end.',
      'word_meaning':
          'अनेक-बाहु-उदर-वक्त्र-नेत्रम्—with unlimited arms, stomachs, mouths, and eyes; पश्यामि—I see; त्वा—You; सर्वतः—everywhere; अनन्त-रूपम्—of infinite form; न अन्तम्—neither the end; न मध्यम्—nor the middle; न पुनः—nor again; तव आदिम्—Your beginning; पश्यामि—I see; विश्वेश्वर—O Lord of the Universe; विश्वरूप—O Universal Form.',
      'commentary':
          'The Form is described as **Ananta-rūpam** (infinite in form) and boundless in all directions. The lack of beginning, middle, or end confirms its eternal and absolute nature, transcending the limits of material time and space.',
    });

    // Verse 17: The dazzling brilliance of the Form
    await db.insert('chapter_11', {
      'verse_number': 17,
      'sanskrit':
          'किरीटिनं गदिनं चक्रिणं च तेजोराशिं सर्वतो दीप्तिमन्तम् | पश्यामि त्वां दुर्निरीक्ष्यं समन्ताद् दीप्तानलार्कद्युतिमप्रमेयम् || 17 ||',
      'translation':
          'I see You with a crown, mace, and discus, a mass of effulgence glowing everywhere, hard to behold, shining like a blazing fire and the sun, and immeasurable.',
      'word_meaning':
          'किरीटिनम्—crowned; गदिनम्—with a mace; चक्रिणम्—with a discus; च—and; तेजः-राशिम्—a mass of splendor; सर्वतः—everywhere; दीप्तिमन्तम्—shining; पश्यामि—I see; त्वाम्—You; दुर्निरीक्ष्यम्—difficult to look at; समन्तात्—from all sides; दीप्त-अनल-अर्क-द्युतिम्—radiance of blazing fire and the sun; अप्रमेयम्—immeasurable.',
      'commentary':
          'The Form is equipped with the traditional weapons of Vishnu, signifying divine power. Its radiance is intensely concentrated, making it painful to view (*durnirīkṣhyam*), confirming that the vision is truly transcendental.',
    });

    // Verse 18: Krishna as the ultimate knowable reality
    await db.insert('chapter_11', {
      'verse_number': 18,
      'sanskrit':
          'त्वमक्षरं परमं वेदितव्यं त्वमस्य विश्वस्य परं निधानम् | त्वमव्ययः शाश्वतधर्मगोप्ता सनातनस्त्वं पुरुषो मतो मे || 18 ||',
      'translation':
          'You are the supreme, **Imperishable** (*Akṣharaṁ*), the ultimate entity to be known. You are the supreme **refuge** of this universe. You are the eternal protector of everlasting *Dharma*, and I believe You to be the **Eternal Person** (*Sanātanaḥ Puruṣhaḥ*).',
      'word_meaning':
          'त्वम्—You; अक्षरम्—imperishable; परमम्—supreme; वेदितव्यम्—the knowable; त्वम्—You; अस्य विश्वस्य—of this universe; परम्—supreme; निधानम्—refuge/foundation; त्वम्—You; अव्ययः—eternal; शाश्वत-धर्म-गोप्ता—the protector of eternal *Dharma*; सनातनः त्वम्—You are the eternal; पुरुषः—Person; मतः मे—my settled conviction.',
      'commentary':
          'Arjuna expresses his complete realization based on the vision. He identifies Krishna as the philosophical goal: the **Akṣhara** (Ch. 8), the foundation of all (*paramṁ nidhānam*), and the maintainer of universal righteousness (*dharma-goptā*).',
    });

    // Verse 19: Further description of the Form’s power
    await db.insert('chapter_11', {
      'verse_number': 19,
      'sanskrit':
          'अनादिमध्यान्तमनन्तवीर्य-मनन्तबाहुं शशिसूर्यनेत्रम् | पश्यामि त्वां दीप्तहुताशवक्त्रं स्वतेजसा विश्वमिदं तपन्तम् || 19 ||',
      'translation':
          'I see You without beginning, middle, or end, possessing infinite energy and unlimited arms. Your eyes are the sun and the moon, and Your mouth is like a blazing fire, scorching this universe with Your own radiance.',
      'word_meaning':
          'अनादि-मध्य-अन्तम्—without beginning, middle, or end; अनन्त-वीर्यम्—infinite valor/energy; अनन्त-बाहुम्—unlimited arms; शशि-सूर्य-नेत्रम्—whose eyes are the sun and the moon; पश्यामि—I see; त्वाम्—You; दीप्त-हुताश-वक्त्रम्—whose mouth is like a blazing fire; स्व-तेजसा—by Your own splendor; विश्वम्—the universe; इदम्—this; तपन्तम्—scorching.',
      'commentary':
          'The vision intensifies, focusing on the Form\'s cosmic functionality. The sun and moon are merely the Lord\'s eyes, and His immense radiance is so potent it appears to be scorching the very universe.',
    });

    // Verse 20: The Form fills all space
    await db.insert('chapter_11', {
      'verse_number': 20,
      'sanskrit':
          'द्यावापृथिव्योरिदमन्तरं हि व्याप्तं त्वयैकेन दिशश्च सर्वाः | दृष्ट्वाद्भुतं रूपमुग्रं तवेदं लोकत्रयं प्रव्यथितं महात्मन् || 20 ||',
      'translation':
          'The space between heaven and earth is filled by You alone, as are all directions. O Great Soul (*Mahātman*), seeing this wondrous, terrible Form of Yours, the three worlds are trembling with fear.',
      'word_meaning':
          'द्यावा-पृथिव्योः—of heaven and earth; इदम् अन्तरम्—this space between; हि—certainly; व्याप्तम्—pervaded; त्वया एकेन—by You alone; दिशः च सर्वाः—and all directions; दृष्ट्वा—having seen; अद्भुतम्—wondrous; रूपम्—form; उग्रम्—terrible; तव—Your; इदम्—this; लोक-त्रयम्—the three worlds; प्रव्यथितम्—are trembling/agitated; महा-आत्मन्—O Great Soul.',
      'commentary':
          'The overwhelming reality of the *Viśhwarūpa* fills every dimension, leaving no empty space. The Form is simultaneously wondrous and terrifying (*ugraṁ*), causing the entire material cosmos to shake with fear and awe.',
    });

    // Verse 21: Arjuna describes the gods' reaction (Fear and praise)
    await db.insert('chapter_11', {
      'verse_number': 21,
      'sanskrit':
          'अमी हि त्वां सुरसङ्घा विशन्ति केचिद्भीताः प्राञ्जलयो गृणन्ति | स्वस्तीत्युक्त्वा महर्षिसिद्धसङ्घाः स्तुवन्ति त्वां स्तुतिभिः पुष्कलाभिः || 21 ||',
      'translation':
          'Verily, these hosts of celestial beings (*sura-saṅghāḥ*) are entering into You. Some, frightened, praise You with folded hands. Hosts of great sages and perfected beings (*siddha-saṅghāḥ*) are extolling You with elaborate, sublime hymns, proclaiming, "May all be well!"',
      'word_meaning':
          'अमी हि—these certainly; त्वाम्—You; सुर-सङ्घाः—host of celestial gods; विशन्ति—are entering; केचित्—some; भीताः—frightened; प्राञ्जलः—with folded hands; गृणन्ति—praise; स्वस्ति—auspiciousness; इति उक्त्वा—saying thus; महर्षि-सिद्ध-सङ्घाः—hosts of great sages and perfected beings; स्तुवन्ति—are praising; त्वाम्—You; स्तुतिभिः—with hymns; पुष्कलाभिः—sublime/profuse.',
      'commentary':
          'Arjuna observes the dual reaction to the Cosmic Form: the *Devas* (celestial beings) are entering the Form, driven by the cosmic dissolution, while the *Siddhas* and *Maharṣhis* (enlightened beings) are praising it, recognizing the Form as the inevitable divine process.',
    });

    // Verse 22: The entry of the Rudras and celestial beings
    await db.insert('chapter_11', {
      'verse_number': 22,
      'sanskrit':
          'रुद्रादित्या वसवो ये च साध्या विश्वेऽश्विनौ मरुतश्चोष्मपाश्च | गन्धर्वयक्षासुरसिद्धसङ्घा वीक्षन्ते त्वां विस्मिताश्चैव सर्वे || 22 ||',
      'translation':
          'The Rudras, Ādityas, Vasus, Sādhyas, Viśhve Devas, twin Aśhvinī Kumāras, Maruts, and Pitṛis (*Uṣhmapāśh*—ancestors)—the hosts of Gandharvas, Yakṣhas, Asuras, and Siddhas—are all gazing at You in sheer amazement.',
      'word_meaning':
          'रुद्र-आदित्याः—Rudras and Adityas; वसवः—Vasus; ये च साध्याः—and the Sadhyas; विश्वे—Visve Devas; अश्विनौ—two Asvini Kumāras; मरुतः—Maruts; च ऊष्मपाः च—and the Pitṛis (ancestors); गन्धर्व-यक्ष-असुर-सिद्ध-सङ्घाः—hosts of Gandharvas, Yakshas, Asuras, and Siddhas; वीक्षन्ते—are gazing; त्वाम्—You; विस्मिताः च एव सर्वे—and all are amazed.',
      'commentary':
          'The enumeration confirms that every class of higher being in the universe, from the heavenly rulers to the enlightened sages and even the demons, is present and utterly overwhelmed by the magnitude of the *Viśhwarūpa*.',
    });

    // Verse 23: The terrifying aspect of the Form
    await db.insert('chapter_11', {
      'verse_number': 23,
      'sanskrit':
          'रूपं महत्ते बहुवक्त्रनेत्रं महाबाहो बहुबाहूरुपादम् | बहूदरं बहुदंष्ट्राकरालं दृष्ट्वा लोकाः प्रव्यथितास्तथाहम् || 23 ||',
      'translation':
          'O Mighty-armed One, seeing Your colossal Form—with many mouths, eyes, arms, thighs, and feet, and with many terrifying teeth—the worlds are trembling with fear, and so am I.',
      'word_meaning':
          'रूपम् महत् ते—Your immense Form; बहु-वक्त्र-नेत्रम्—with many mouths and eyes; महा-बाहो—O Mighty-armed One; बहु-बाहु-ऊरु-पादम्—with many arms, thighs, and feet; बहु-उदरम्—many stomachs; बहु-दंष्ट्रा-करालम्—terrible with many fangs; दृष्ट्वा—having seen; लोकाः—worlds; प्रव्यथिताः—are trembling; तथा अहम्—and so am I.',
      'commentary':
          'Arjuna’s awe turns to genuine fear. The description focuses on the physical terror: the many faces and teeth suggest the Lord is actively consuming the universe, fulfilling His role as Time (*Kāla*).',
    });

    // Verse 24: Fear due to the vastness
    await db.insert('chapter_11', {
      'verse_number': 24,
      'sanskrit':
          'नभःस्पृशं दीप्तमनेकवर्णं व्यात्ताननं दीप्तविशालनेत्रम् | दृष्ट्वा हि त्वां प्रव्यथितान्तरात्मा धृतिं न विन्दामि शमं च विष्णो || 24 ||',
      'translation':
          'O Viṣhṇu, seeing Your Form touching the sky, shining, with gaping mouths, and huge, blazing eyes, my inner self is shaken with fear. I find neither courage (*dhṛitiṁ*) nor peace (*śhamaṁ*).',
      'word_meaning':
          'नभः-स्पृशम्—touching the sky; दीप्तम्—shining/blazing; अनेक-वर्णम्—many colors; व्यात्त-आननम्—gaping mouth; दीप्त-विशाल-नेत्रम्—huge, blazing eyes; दृष्ट्वा हि—seeing certainly; त्वाम्—You; प्रव्यथित-अन्तरात्मा—inner self shaken with fear; धृतिम्—courage; न विन्दामि—I do not find; शमम् च—and peace; विष्णो—O Viṣhṇu.',
      'commentary':
          'The sight of the Form is too immense and overwhelming for the human mind. Arjuna loses both his mental strength (*dhṛiti*) and the inner peace (*śhama*) he had attained through Yoga, confirming that the ultimate reality is truly terrifying without the lens of personal devotion.',
    });

    // Verse 25: The consuming mouths
    await db.insert('chapter_11', {
      'verse_number': 25,
      'sanskrit':
          'दंष्ट्राकरालानि च ते मुखानि दृष्ट्वैव कालानलसन्निभानि | दिशो न जाने न लभे च शर्म प्रसीद देवेश जगन्निवास || 25 ||',
      'translation':
          'Seeing Your faces terrible with fangs, blazing like the fire of destruction (*kālānala*), I lose all sense of direction and find no comfort. Be gracious, O Lord of the gods, O Refuge of the universe.',
      'word_meaning':
          'दंष्ट्रा-करालानि—terrible with fangs; च ते—and Your; मुखानि—mouths; दृष्ट्वा एव—seeing only; काल-अनल-सन्निभानि—resembling the fire of destruction; दिशः—directions; न जाने—I do not know; न लभे—nor find; च शर्म—and peace; प्रसीद—be gracious; देव-ईश—O Lord of the gods; जगत्-निवास—O Refuge of the universe.',
      'commentary':
          'Arjuna sees the destruction principle embodied. He addresses Krishna as the **Refuge of the universe** (*Jagannivāsa*) even as the vision causes him immense panic, desperately clinging to the protective aspect of the Lord.',
    });

    // Verse 26: Seeing the warriors entering the Form
    await db.insert('chapter_11', {
      'verse_number': 26,
      'sanskrit':
          'अमी च त्वां धृतराष्ट्रस्य पुत्राः सर्वे सहैवावनिपालसङ्घैः | भीष्मो द्रोणः सूतपुत्रस्तथासौ सहास्मदीयैरपि योधमुख्यैः || 26 ||',
      'translation':
          'All the sons of Dhritarashtra, along with the hosts of kings, Bhīṣhma, Droṇa, and the son of Sūta (Karṇa)—and also the chief warriors from our side—',
      'word_meaning':
          'अमी च—and these; त्वाम्—You; धृतराष्ट्रस्य पुत्राः—sons of Dhritarashtra; सर्वे—all; सह एव—along with; अवनिपाल-सङ्घैः—hosts of kings; भीष्मः—Bhishma; द्रोणः—Drona; सूत-पुत्रः—son of Sūta (Karṇa); तथा असौ—and also he; सह अस्मदीयैः—along with ours; अपि—even; योध-मुख्यैः—chief warriors.',
      'commentary':
          'Arjuna’s personal fear is confirmed: he sees all the main protagonists of the war, including his most revered elders and adversaries, being drawn into the Cosmic Form. The war’s outcome is not dependent on his action, but is a divine certainty.',
    });

    // Verse 27: Rushing into the mouths
    await db.insert('chapter_11', {
      'verse_number': 27,
      'sanskrit':
          'वक्त्राणि ते त्वरमाणा विशन्ति दंष्ट्राकरालानि भयानकानि | केचिद्विलग्ना दशनान्तरेषु सन्दृश्यन्ते चूर्णितैरुत्तमाङ्गैः || 27 ||',
      'translation':
          'They are rapidly rushing into Your fearful mouths, which are terrible with fangs. Some are seen trapped between Your teeth, with their heads crushed to powder.',
      'word_meaning':
          'वक्त्राणि—mouths; ते—Your; त्वरमाणाः—hastening/rushing; विशन्ति—are entering; दंष्ट्रा-करालानि—terrible with fangs; भयानकानि—fearful; केचित्—some; विलग्नाः—stuck; दशनान्तरेषु—between the teeth; सन्दृश्यन्ते—are seen; चूर्णितैः—crushed; उत्तम-अङ्गैः—with heads.',
      'commentary':
          'This gruesome visual confirms that the battle is already won by Time (Krishna). The warriors are not fighting freely; they are being driven by Destiny into the Form’s gaping mouth, like insects drawn to a destructive light.',
    });

    // Verse 28: Analogy of the rivers and the ocean
    await db.insert('chapter_11', {
      'verse_number': 28,
      'sanskrit':
          'यथा नदीनां बहवोऽम्बुवेगाः समुद्रमेवाभिमुखा द्रवन्ति | तथा तवामी नरलोकवीरा विशन्ति वक्त्राण्यभिविज्वलन्ति || 28 ||',
      'translation':
          'Just as the many streams of rivers naturally flow swiftly toward the ocean, similarly, these heroes of the mortal world are rushing into Your blazing mouths.',
      'word_meaning':
          'यथा—just as; नदीनाम्—of rivers; बहवः—many; अम्बु-वेगाः—currents of water; समुद्रम् एव—the ocean alone; अभिमुखाः—facing towards; द्रवन्ति—flow; तथा—similarly; तव—Your; अमी—these; नर-लोक-वीराः—heroes of the mortal world; विशन्ति—enter; वक्त्राणि—mouths; अभिविज्वलन्ति—blazing brilliantly.',
      'commentary':
          'The analogy of rivers rushing to the sea reinforces the **inevitability** of the cosmic process. The heroes’ deaths are predestined, like water flowing downhill. This removes Arjuna’s burden of choice and free will regarding the immediate battlefield outcome.',
    });

    // Verse 29: Analogy of the moths and the fire
    await db.insert('chapter_11', {
      'verse_number': 29,
      'sanskrit':
          'यथा प्रदीप्तं ज्वलनं पतङ्गा विशन्ति नाशाय समृद्धवेगाः | तथैव नाशाय विशन्ति लोकास्तवापि वक्त्राणि समृद्धवेगाः || 29 ||',
      'translation':
          'Just as moths rush into a blazing fire to perish, hastening toward destruction, similarly, all these people are rapidly entering Your mouths for their annihilation.',
      'word_meaning':
          'यथा—just as; प्रदीप्तम्—blazing; ज्वलनम्—fire; पतङ्गाः—moths; विशन्ति—enter; नाशाय—for destruction; समृद्ध-वेगाः—with full speed; तथा एव—in the same way; नाशाय—for destruction; विशन्ति—enter; लोकाः—people/worlds; तव अपि—Your also; वक्त्राणि—mouths; समृद्ध-वेगाः—with full speed.',
      'commentary':
          'The second analogy emphasizes the **unconscious nature** of the destruction. The warriors are drawn by their own *karma* (like moths to a flame), seeking their own doom, further emphasizing that Arjuna is merely a detached observer of destiny.',
    });

    // Verse 30: The Lord consumes the worlds
    await db.insert('chapter_11', {
      'verse_number': 30,
      'sanskrit':
          'लेलिह्यसे ग्रसमानः समन्ताल् लोकान्समग्रान्वदनैर्ज्वलद्भिः | तेजोभिरापूर्य जगत्समग्रं भासस्तवोग्राः प्रतपन्ति विष्णो || 30 ||',
      'translation':
          'O Viṣhṇu, You are consuming all worlds from every side with Your flaming mouths, licking them up. Your fierce radiance fills the entire universe and is intensely scorching.',
      'word_meaning':
          'लेलिह्यसे—You are licking; ग्रसमानः—devouring; समन्तात्—from all sides; लोकान् समग्रान्—all the worlds; वदनैः—with mouths; ज्वलद्भिः—blazing; तेजोभिः—with radiance; आपूर्य—filling; जगत् समग्रम्—the entire universe; भासः—radiance; तव—Your; उग्राः—terrible/fierce; प्रतपन्ति—are scorching; विष्णो—O Viṣhṇu.',
      'commentary':
          'This final description of the Cosmic Form as a devouring force prepares Arjuna for the revelation that follows: the identity of the terrifying form is **Time (Kāla)**.',
    });

    // Verse 31: Arjuna asks for the Form's identity
    await db.insert('chapter_11', {
      'verse_number': 31,
      'sanskrit':
          'आख्याहि मे को भवानुग्ररूपो नमोऽस्तु ते देववर प्रसीद | विज्ञातुमिच्छामि भवन्तमाद्यं न हि प्रजानामि तव प्रवृत्तिम् || 31 ||',
      'translation':
          'Tell me, **who are You** in this fierce form? Salutations to You, O Supreme Deity! Be gracious. I wish to know You, the Primal Being, for I do not understand Your current dreadful mission.',
      'word_meaning':
          'आख्याहि—tell; मे—me; कः—who; भवान्—You; उग्र-रूपः—of fierce form; नमः अस्तु ते—salutations be to You; देव-वर—O best of the gods; प्रसीद—be gracious; विज्ञातुम् इच्छामि—I wish to know; भवन्तम्—You; आद्यम्—the Primal Being; न हि—I certainly do not; प्रजानामि—understand; तव—Your; प्रवृत्तिम्—mission/activity.',
      'commentary':
          'Arjuna is no longer interested in philosophy; he is paralyzed by the terrifying sight. He desperately asks the identity and purpose of the Form, using the term **ugra-rūpo** (fierce form) and admitting he cannot understand its mission (*pravṛittiṁ*).',
    });

    // Verse 32: Krishna reveals His identity as Time
    await db.insert('chapter_11', {
      'verse_number': 32,
      'sanskrit':
          'श्रीभगवानुवाच | कालोऽस्मि लोकक्षयकृत्प्रवृद्धो लोकान्समाहर्तुमिह प्रवृत्तः | ऋतेऽपि त्वां न भविष्यन्ति सर्वे येऽवस्थिताः प्रत्यनीकेषु योधाः || 32 ||',
      'translation':
          'The Supreme Lord said: **I am Time** (*Kālaḥ*), the great destroyer of worlds, and I have come to consume all people here. Even without your action, all the warriors standing arrayed in the opposing armies shall cease to exist.',
      'word_meaning':
          'कालः—Time; अस्मि—I am; लोक-क्षय-कृत्—destroyer of the worlds; प्रवृद्धः—great/mighty; लोकान्—people/worlds; समाहर्तुम्—to consume/withdraw; इह—here; प्रवृत्तः—engaged; ऋते अपि—even without; त्वाम्—you; न भविष्यन्ति—shall not remain; सर्वे—all; ये—who; अवस्थिताः—situated; प्रत्यनीकेषु—in the opposing armies; योधाः—warriors.',
      'commentary':
          'This is the climax of the vision. Krishna confirms the terrifying Form\'s identity as the unstoppable force of **Time** (*Kālaḥ*). He explicitly removes Arjuna\'s delusion of doership by stating the outcome is predestined; the warriors are already consumed by Time.',
    });

    // Verse 33: Krishna commands Arjuna to become His instrument
    await db.insert('chapter_11', {
      'verse_number': 33,
      'sanskrit':
          'तस्मात्त्वमुत्तिष्ठ यशो लभस्व जित्वा शत्रून्भुङ्क्ष्व राज्यं समृद्धम् | मयैवैते निहताः पूर्वमेव निमित्तमात्रं भव सव्यसाचिन् || 33 ||',
      'translation':
          'Therefore, arise! Achieve glory, conquer your enemies, and enjoy a prosperous kingdom. **By Me alone** have they already been destroyed; be merely **My instrument** (*nimitta-mātraṁ*), O expert archer.',
      'word_meaning':
          'तस्मात्—therefore; त्वम्—you; उत्तिष्ठ—arise; यशः—fame/glory; लभस्व—obtain; जित्वा—conquering; शत्रून्—enemies; भुङ्क्ष्व—enjoy; राज्यम्—kingdom; समृद्धम्—prosperous; मया एव—by Me alone; एते—these; निहताः—destroyed; पूर्वम् एव—already; निमित्त-मात्रम्—mere instrument; भव—be; सव्य-साचिन्—O expert archer (Arjuna).',
      'commentary':
          'This is Krishna’s final instruction on the battlefield. Since the deed is already done by God, Arjuna is commanded to perform the action without the burden of ego, acting only as the Divine\'s **instrument** (*nimitta-mātraṁ*) for the sake of setting an example.',
    });

    // Verse 34: Specific enemies to be slain
    await db.insert('chapter_11', {
      'verse_number': 34,
      'sanskrit':
          'द्रोणं च भीष्मं च जयद्रथं च कर्णं तथान्यानपि योधवीरान् | मया हतांस्त्वं जहि मा व्यथिष्ठा युध्यस्व जेतासि रणे सपत्नान् || 34 ||',
      'translation':
          'Droṇa, Bhīṣhma, Jayadratha, Karṇa, and other great warriors—who have already been slain by Me—you must kill. Do not be distressed. Fight, and you will conquer your enemies in battle.',
      'word_meaning':
          'द्रोणम् च—Droṇa and; भीष्मम् च—Bhīṣhma and; जयद्रथम् च—Jayadratha and; कर्णम्—Karṇa; तथा अन्यान् अपि—and also others; योध-वीरान्—heroic warriors; मया हतान्—slain by Me; त्वम्—you; जहि—kill; मा व्यथिष्ठाः—do not be distressed; युध्यस्व—fight; जेता असि—you shall conquer; रणे—in battle; सपत्नान्—enemies.',
      'commentary':
          'Krishna names the main adversaries, confirming their fate. The command is to perform the duty of a Kshatriya without the emotional distress (*mā vyathiṣhṭhāḥ*), knowing the battle\'s spiritual purpose and preordained conclusion.',
    });

    // Verse 35: Sañjaya's observation of Arjuna's terror
    await db.insert('chapter_11', {
      'verse_number': 35,
      'sanskrit':
          'सञ्जय उवाच | एतच्छ्रुत्वा वचनं केशवस्य कृताञ्जलिर्वेपमानः किरीटी | नमस्कृत्वा भूय एवाह कृष्णं सगद्गदं भीतभीतः प्रणम्य || 35 ||',
      'translation':
          'Sañjaya said: Having heard these words of Keśhava (Krishna), Arjuna (the crowned one), trembling with joined palms, offered obeisance and, overwhelmed with fear, spoke again to Krishna in a stammering voice.',
      'word_meaning':
          'सञ्जयः उवाच—Sañjaya said; एतत् श्रुत्वा—having heard this; वचनम्—words; केशवस्य—of Keśhava; कृत-अञ्जलिः—with folded hands; वेपमानः—trembling; किरीटी—Arjuna (the crowned one); नमस्-कृत्वा—offering obeisance; भूयः एव आह—again spoke; कृष्णम्—to Krishna; स-गद्गदम्—with stammering voice; भीत-भीतः—overwhelmed by fear; प्रणम्य—bowing.',
      'commentary':
          'Arjuna is physically and mentally shattered by the vision of Time. His response is not immediate courage but paralyzed terror, evident in his trembling (*vepamānaḥ*) and stammering (*sagadgadaṁ*) voice, setting up his final prayer.',
    });

    // Verse 36: Arjuna praises Krishna (The first prayer)
    await db.insert('chapter_11', {
      'verse_number': 36,
      'sanskrit':
          'स्थाने हृषीकेश तव प्रकीर्त्या जगत्प्रहृष्यत्यनुरज्यते च | रक्षांसि भीतानि दिशो द्रवन्ति सर्वे नमस्यन्ति च सिद्धसङ्घाः || 36 ||',
      'translation':
          'Arjuna said: Rightly, O Hṛiṣhīkeśha, does the world rejoice and become attached upon hearing Your glorification. Frightened *Rākṣhasas* (demons) flee in all directions, and the hosts of perfected beings (*Siddha-saṅghāḥ*) all bow down to You.',
      'word_meaning':
          'स्थाने—it is right; हृषीकेश—O Hṛiṣhīkeśha; तव—Your; प्रकीर्त्या—by glorification; जगत्—the world; प्रहृष्यति—rejoices greatly; अनुरज्यते—is attached; च—and; रक्षांसि—demons; भीतानि—frightened; दिशः—directions; द्रवन्ति—flee; सर्वे—all; नमस्यन्ति—bow down; च—and; सिद्ध-सङ्घाः—hosts of perfected beings.',
      'commentary':
          'Arjuna begins his final prayer (*Stuti*), describing the effect of the Lord\'s presence. The world naturally divides: the righteous rejoice and are drawn in, while the evil (*Rākṣhasas*) flee in terror, confirming the justice of the Lord\'s terrifying form.',
    });

    // Verse 37: Arjuna glorifies Krishna's essential nature
    await db.insert('chapter_11', {
      'verse_number': 37,
      'sanskrit':
          'कस्माच्च ते न नमेरन्महात्मन् गरीयसे ब्रह्मणोऽप्यादिकर्त्रे | अनन्त देवेश जगन्निवास त्वमक्षरं सदसत्तत्परं यत् || 37 ||',
      'translation':
          'Why would they not bow down to You, O Great Soul (*Mahātman*), who are the primordial creator, greater than Brahmā? O Infinite One, O Lord of the gods, O Refuge of the universe, You are the Imperishable (*Akṣharaṁ*), the Existent (*Sat*), the Non-existent (*Asat*), and the transcendent beyond both!',
      'word_meaning':
          'कस्मात् च—and why; ते—to You; न नमेरन्—should they not bow; महात्मन्—O Great Soul; गरीयसे—greater; ब्रह्मणः अपि—even than Brahmā; आदि-कर्त्रे—the original creator; अनन्त—O Infinite One; देव-ईश—O Lord of the gods; जगत्-निवास—O Refuge of the universe; त्वम्—You; अक्षरम्—Imperishable; सत् असत्—the existent and the non-existent; तत् परम्—that which is beyond; यत्—which.',
      'commentary':
          'Arjuna recognizes that Krishna is the source of Brahmā (the creator) and the metaphysical ground of reality, encompassing all three aspects of reality: the perishable (*Sat*), the imperishable (*Akṣharaṁ*), and the truth beyond both.',
    });

    // Verse 38: Krishna is the Primal Being
    await db.insert('chapter_11', {
      'verse_number': 38,
      'sanskrit':
          'त्वमादिदेवः पुरुषः पुराण-स्त्वमस्य विश्वस्य परं निधानम् | वेत्तासि वेद्यं च परं च धाम त्वया ततं विश्वमनन्तरूप || 38 ||',
      'translation':
          'You are the **Primal God** (*Ādidevaḥ*), the **Ancient Person** (*Puruṣhaḥ Purāṇaḥ*), the supreme **refuge** of this universe, the knower, the knowable, and the supreme abode. O infinite-formed One, You pervade the entire universe.',
      'word_meaning':
          'त्वम्—You; आदि-देवः—the Primal God; पुरुषः पुराणः—the Ancient Person; त्वम्—You; अस्य विश्वस्य—of this universe; परम् निधानम्—the supreme refuge/foundation; वेत्ता असि—You are the knower; वेद्यम्—the knowable; च परम् च धाम—and the supreme abode; त्वया—by You; ततम्—pervaded; विश्वम्—universe; अनन्त-रूप—O infinite-formed One.',
      'commentary':
          'Arjuna uses a cascade of Upanishadic titles, confirming that Krishna is the ultimate metaphysical principle that is the source of all knowledge (knower and knowable) and the substratum of the entire cosmos.',
    });

    // Verse 39: Krishna is the cosmic forces
    await db.insert('chapter_11', {
      'verse_number': 39,
      'sanskrit':
          'वायुर्यमोऽग्निर्वरुणः शशाङ्कः प्रजापतिस्त्वं प्रपितामहश्च | नमो नमस्तेऽस्तु सहस्रकृत्वः पुनश्च भूयोऽपि नमो नमस्ते || 39 ||',
      'translation':
          'You are **Vāyu** (the wind), **Yama** (death), **Agni** (fire), **Varuṇa** (water), **Śhaśhāṅka** (the moon), **Prajāpati** (the progenitor), and **Prapitāmaha** (the great-grandfather). **Salutations** to You a thousand times, and again and again!',
      'word_meaning':
          'वायुः—Vāyu (wind); यमः—Yama (death); अग्निः—Agni (fire); वरुणः—Varuṇa (water); शशाङ्कः—Śhaśhāṅka (moon); प्रजापतिः—Prajāpati (progenitor); त्वम्—You; प्रपितामहः—the great-grandfather; च—and; नमः नमः ते अस्तु—salutations to You; सहस्र-कृत्वः—a thousand times; पुनश्च—and again; भूयः अपि—more again; नमः ते—salutations to You.',
      'commentary':
          'Krishna is identified with the principal cosmic deities and forces that control the universe, demonstrating His role as the controlling power behind nature. Arjuna repeats his obeisances (*Namo Namaste*) out of sheer terror and reverence.',
    });

    // Verse 40: Salutations from all directions
    await db.insert('chapter_11', {
      'verse_number': 40,
      'sanskrit':
          'नमः पुरस्तादथ पृष्ठतस्ते नमोऽस्तु ते सर्वत एव सर्व | अनन्तवीर्यामितविक्रमस्त्वं सर्वं समाप्नोषि ततोऽसि सर्वः || 40 ||',
      'translation':
          'Salutations to You from the **front** and the **rear**! Salutations to You from **all sides**, O All-encompassing One! O Lord of infinite power and immeasurable might, You pervade everything; thus, You are everything.',
      'word_meaning':
          'नमः—salutations; पुरस्तात्—from the front; अथ पृष्ठतः—and from the rear; ते—to You; नमः अस्तु ते—salutations be to You; सर्वतः एव—indeed from all sides; सर्व—O All-encompassing One; अनन्त-वीर्य—of infinite power; अमित-विक्रमः—immeasurable valor; त्वम्—You; सर्वम्—everything; समाप्नोषि—pervade; ततः—thus; असि सर्वः—You are everything.',
      'commentary':
          'Arjuna honors Krishna in all dimensions, acknowledging that the Lord\'s pervasive presence (*samāpnoṣhi*) means that every direction and every point in space is Him. The conclusion is logical: since He pervades all (*sarvam samāpnóṣi*), **He is everything** (*tato ’si sarvaḥ*).',
    });

    // Ensure this code block extends your existing insertChapter11Verses function.

    // Verse 41: Arjuna apologizes for disrespect (1/2)
    await db.insert('chapter_11', {
      'verse_number': 41,
      'sanskrit':
          'सखेति मत्वा प्रसभं यदुक्तं हे कृष्ण हे यादव हे सखेति | अजानता महिमानं तवेदं मया प्रमादात्प्रणयेन वापि || 41 ||',
      'translation':
          'Thinking of You merely as a friend, I rashly addressed You as "O Kṛṣhṇa," "O Yādava," or "O Friend." I did this unknowingly, ignorant of Your greatness, out of **carelessness** (*pramādāt*) or perhaps out of **affection** (*praṇayena*).',
      'word_meaning':
          'सखा—friend; इति—thus; मत्वा—having thought; प्रसभम्—rashly/presumptuously; यत् उक्तम्—whatever was said; हे कृष्ण—O Krishna; हे यादव—O Yādava; हे सखे इति—O friend; अजानता—not knowing; महिमानम्—greatness; तव—Your; इदम्—this; मया—by me; प्रमादात्—out of negligence; प्रणयेन—out of affection; वा अपि—or also.',
      'commentary':
          'Arjuna begins his apology, admitting his familiarity led to disrespect, rooted in **ignorance** of Krishna\'s true divine status. He offers two possible motives for his past offenses: heedlessness (*pramādāt*) and sincere affection (*praṇayena*). This humility is a vital trait of a true devotee.',
    });

    // Verse 42: Arjuna apologizes for disrespect (2/2)
    await db.insert('chapter_11', {
      'verse_number': 42,
      'sanskrit':
          'यच्चावहासार्थमसत्कृतोऽसि विहारशय्यासनभोजनेषु | एकोऽथवाप्यच्युत तत्समक्षं तत्क्षामये त्वामहमप्रमेयम् || 42 ||',
      'translation':
          'And in whatever ways I may have shown disrespect to You—while jesting (*avahāsārthaṁ*), or while playing, resting, sitting, or eating, whether alone or in the presence of others—O Eternal Lord (*Achyuta*), I beg forgiveness from You, the Immeasurable.',
      'word_meaning':
          'यत् च—and whatever; अवहास-अर्थम्—for the sake of jest; असत्-कृतः असि—you were shown disrespect; विहार-शय्या-आसन-भोजनेषु—while playing, reclining, sitting, or eating; एकः—alone; अथवा अपि—or even; अच्युत—O Eternal Lord; तत्-समक्षम्—in the presence of that (friends); तत्—for all that; क्षामये—I beg forgiveness; त्वाम्—You; अहम्—I; अप्रमेयम्—the Immeasurable.',
      'commentary':
          'Arjuna covers every possible scenario of disrespect, including public mockery, recognizing that even unintentional slights against the Supreme are serious offenses. He addresses Krishna as **Achyuta** (the infallible one) and **Aprameyam** (the immeasurable), demonstrating his newfound awe.',
    });

    // Verse 43: Krishna is the ultimate object of worship
    await db.insert('chapter_11', {
      'verse_number': 43,
      'sanskrit':
          'पितासि लोकस्य चराचरस्य त्वमस्य पूज्यश्च गुरुर्गरीयान् | न त्वत्समोऽस्त्यभ्यधिकः कुतोऽन्यो लोकत्रयेऽप्यप्रतिमप्रभाव || 43 ||',
      'translation':
          'You are the **Father** of this moving and non-moving world, the **Guru** who is worthy of worship, and the **Weightier** (*garīyān*) than any. There is none equal to You in the three worlds—how, then, could anyone be greater, O Lord of incomparable power?',
      'word_meaning':
          'पिता असि—You are the Father; लोकस्य—of the world; चर-अचरस्य—moving and non-moving; त्वम्—You; अस्य—of this; पूज्यः—worshipable; च—and; गुरुः—Guru/teacher; गरीयान्—weightier/greater; न त्वत्-समः—there is none equal to You; अस्ति—is; अभ्यधिकः—greater; कुतः अन्यः—how then another; लोक-त्रये अपि—even in the three worlds; अप्रतिम-प्रभाव—O Lord of incomparable power.',
      'commentary':
          'Arjuna now formally establishes Krishna’s divinity. He acknowledges Krishna as the ultimate source of existence (Father) and knowledge (Guru), declaring the Lord\'s absolute supremacy: **No one is equal to Him, and no one is greater**.',
    });

    // Verse 44: Arjuna begs for grace
    await db.insert('chapter_11', {
      'verse_number': 44,
      'sanskrit':
          'तस्मात्प्रणम्य प्रणिधाय कायं प्रसादये त्वामहमीशमीड्यम् | पितेव पुत्रस्य सखेव सख्युः प्रियः प्रियायार्हसि देव सोढुम् || 44 ||',
      'translation':
          'Therefore, bowing down and prostrating my body, I seek Your grace, O Adorable Lord (*Īśham īḍyaṁ*). O God, You should bear with me, just as a **father forgives his son, a friend forgives his friend, or a lover forgives his beloved**.',
      'word_meaning':
          'तस्मात्—therefore; प्रणम्य—bowing down; प्रणिधाय—prostrating; कायम्—the body; प्रसादये—I seek the grace; त्वाम्—You; अहम्—I; ईशम् ईड्यम्—the adorable Lord; पिता इव—like a father; पुत्रस्य—of a son; सखा इव—like a friend; सख्युः—of a friend; प्रियः—beloved; प्रियायै—to the beloved; अर्हसि—You should; देव—O God; सोढुम्—forgive/tolerate.',
      'commentary':
          'This deeply emotional plea for grace is central to *Bhakti-Yoga*. Arjuna uses three key relationships—Father/Son, Friend/Friend, and Lover/Beloved—to ask for unconditional forgiveness, seeking protection not as a warrior, but as a devoted child.',
    });

    // Verse 45: Arjuna requests the return to the gentle form
    await db.insert('chapter_11', {
      'verse_number': 45,
      'sanskrit':
          'अदृष्टपूर्वं हृषितोऽस्मि दृष्ट्वा भयेन च प्रव्यथितं मनो मे | तदेव मे दर्शय देव रूपं प्रसीद देवेश जगन्निवास || 45 ||',
      'translation':
          'Having seen that which was never seen before, I am delighted, but my mind is severely shaken with fear. O Lord of the gods, O Refuge of the universe, please **show me that gentle form** again and be gracious.',
      'word_meaning':
          'अदृष्ट-पूर्वम्—never seen before; हृषितः अस्मि—I am delighted; दृष्ट्वा—having seen; भयेन च—and by fear; प्रव्यथितम्—greatly distressed; मनः मे—my mind; तत् एव—that very; मे—to me; दर्शय—show; देव—O God; रूपम्—form; प्रसीद—be gracious; देव-ईश—O Lord of the gods; जगत्-निवास—O Refuge of the universe.',
      'commentary':
          'Arjuna expresses the duality of his experience: initial *hṛiṣhito* (delight) quickly overwhelmed by *bhaya* (fear). He asks Krishna to revert to the familiar, gentle, and beautiful form (*Saumya Rūpa*) of Viṣhṇu or the two-armed friend.',
    });

    // Verse 46: The request for the Four-Armed Form
    await db.insert('chapter_11', {
      'verse_number': 46,
      'sanskrit':
          'किरीटिनं गदिनं चक्रहस्त-मिच्छामि त्वां द्रष्टुमहं तथैव | तेनैव रूपेण चतुर्भुजेन सहस्रबाहो भव विश्वमूर्ते || 46 ||',
      'translation':
          'O Universal Form, I wish to see You again in the form with the **crown, mace, and disc**. O thousand-armed One, appear in that **Four-Armed Form**.',
      'word_meaning':
          'किरीटिनम्—crowned; गदिनम्—with a mace; चक्र-हस्तम्—with a discus in hand; इच्छामि—I desire; त्वाम्—You; द्रष्टुम्—to see; अहम्—I; तथा एव—similarly; तेन एव—by that very; रूपेण—form; चतुः-भुजेन—four-armed; सहस्र-बाहो—O thousand-armed One; भव—be; विश्व-मूर्ते—O Universal Form.',
      'commentary':
          'Arjuna seeks the intermediate form: the majestic, four-armed Viṣhṇu form. This form, complete with divine weapons, retains the power of the *Viśhwarūpa* but offers a gentle, reassuring focus of devotion, suitable for contemplation.',
    });

    // Verse 47: Krishna agrees to the request
    await db.insert('chapter_11', {
      'verse_number': 47,
      'sanskrit':
          'श्रीभगवानुवाच | मया प्रसन्नेन तवार्जुनेदं रूपं परं दर्शितमात्मयोगात् | तेजोमयं विश्वमनन्तमाद्यं यन्मे त्वदन्येन न दृष्टपूर्वम् || 47 ||',
      'translation':
          'The Supreme Lord said: O Arjuna, being pleased with you, I have shown you—through My own mystic power (*ātma-yogāt*)—this Supreme, effulgent, universal, infinite, and primal Form which no one but you has seen before.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; मया—by Me; प्रसन्नेन—being pleased; तव अर्जुन—to you, O Arjuna; इदम्—this; रूपम् परम्—Supreme Form; दर्शितम्—shown; आत्म-योगात्—by My own mystic power; तेजः-मयम्—full of splendor; विश्वम्—universal; अनन्तम्—infinite; आद्यम्—primal; यत् मे—which My; त्वत् अन्येन—by anyone other than you; न दृष्ट-पूर्वम्—not seen before.',
      'commentary':
          'Krishna confirms that the *Viśhwarūpa* was shown purely out of divine grace (*prasannena*) and through His own inherent power (*ātma-yogāt*). He emphasizes the rarity of the vision to underline the unique relationship and spiritual stature of Arjuna.',
    });

    // Verse 48: The rarity of the vision
    await db.insert('chapter_11', {
      'verse_number': 48,
      'sanskrit':
          'न वेदयज्ञाध्ययनैर्न दानै-र्न च क्रियाभिर्न तपोभिरुग्रैः | एवंरूपः शक्योऽहं नृलोके द्रष्टुं त्वदन्येन कुरुप्रवीर || 48 ||',
      'translation':
          'O greatest warrior of the Kurus, not by the study of the Vedas, nor by sacrifices, nor by charity, nor by ritualistic actions, nor by severe austerities, can I, in this form, be seen by anyone other than you in the mortal world.',
      'word_meaning':
          'न वेद-यज्ञ-अध्ययनैः—not by study of Vedas and sacrifices; न दानैः—nor by charity; न च क्रियाभिः—nor by ritualistic actions; न तपःभिः उग्रैः—nor by severe austerities; एवम्-रूपः—of this form; शक्यः—possible; अहम्—I; नृ-लोके—in the mortal world; द्रष्टुम्—to be seen; त्वत् अन्येन—by anyone other than you; कुरु-प्रवीर—O greatest warrior of the Kurus.',
      'commentary':
          'This statement elevates the value of the vision above all other spiritual practices (*Karma, Tapa, Dāna*), indicating that pure devotion (*Bhakti*) is the only qualification for obtaining the Lord’s direct, transcendental sight.',
    });

    // Verse 49: Krishna asks Arjuna to be calm
    await db.insert('chapter_11', {
      'verse_number': 49,
      'sanskrit':
          'मा ते व्यथा मा च विमूढभावो दृष्ट्वा रूपं घोरमीदृङ्ममेदम् | व्यपेतभीः प्रीतमनाः पुनस्त्वं तदेव मे रूपमिदं प्रपश्य || 49 ||',
      'translation':
          'Be free from distress and confusion, having seen this terrifying Form of Mine. With a calm mind and cheerful heart, behold again My former gentle form.',
      'word_meaning':
          'मा ते व्यथा—let there not be distress; मा च विमूढ-भावः—nor bewildered feeling; दृष्ट्वा—having seen; रूपम् घोरम्—fierce form; ईदृक् मम इदम्—such as this of Mine; व्यपेत-भीः—fearless; प्रीत-मनाः—with a happy mind; पुनः त्वम्—again you; तत् एव—that very; मे—My; रूपम्—form; इदम्—this; प्रपश्य—behold.',
      'commentary':
          'Krishna responds directly to Arjuna’s fear, commanding him to overcome the terror and bewilderment (*vimūḍha-bhāvo*). The command to be **fearless** (*vyapeta-bhīḥ*) is the prerequisite for enjoying the gentle vision.',
    });

    // Verse 50: Krishna resumes the four-armed form
    await db.insert('chapter_11', {
      'verse_number': 50,
      'sanskrit':
          'सञ्जय उवाच | इत्यर्जुनं वासुदेवस्तथोक्त्वा स्वकं रूपं दर्शयामास भूयः | आश्वासयामास च भीतमेनं भूत्वा पुनः सौम्यवपुर्महात्मा || 50 ||',
      'translation':
          'Sañjaya said: Having thus spoken to Arjuna, Vāsudeva (Krishna) showed His own form (*svakaṁ rūpaṁ*) again. The Great Soul (*Mahātma*) reassured the terrified Arjuna by resuming His gentle, beautiful form.',
      'word_meaning':
          'सञ्जयः उवाच—Sañjaya said; इति अर्जुनम्—thus to Arjuna; वासुदेवः—Vāsudeva (Krishna); तथा उक्त्वा—having spoken thus; स्वकम् रूपम्—His own form; दर्शयामास—showed; भूयः—again; आश्वासयामास—reassured; च—and; भीतम् एनम्—this frightened one; भूत्वा—becoming; पुनः—again; सौम्य-वपुः—of gentle form; महा-आत्मा—the Great Soul.',
      'commentary':
          'The narrative returns to Sañjaya, confirming the transition. Krishna first showed the four-armed Viṣhṇu form (*svakaṁ rūpaṁ*), as requested, and then the gentle, two-armed human form (*saumya-vapuḥ*), using His divine power to calm and reassure the devotee.',
    });

    // Verse 51: Arjuna's relief
    await db.insert('chapter_11', {
      'verse_number': 51,
      'sanskrit':
          'अर्जुन उवाच | दृष्ट्वेदं मानुषं रूपं तव सौम्यं जनार्दन | इदानीमस्मि संवृत्तः सचेताः प्रकृतिं गतः || 51 ||',
      'translation':
          'Arjuna said: O Janārdana, seeing this gentle human form of Yours, I have now become composed and have returned to my normal, natural state.',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; दृष्ट्वा—having seen; इदम्—this; मानुषम्—human; रूपम्—form; तव—Your; सौम्यम्—gentle; जनार्दन—O Janārdana; इदानीम्—now; अस्मि—I am; संवृत्तः—composed; स-चेताः—with a clear mind; प्रकृतिम्—natural state; गतः—attained.',
      'commentary':
          'Arjuna expresses his immense relief. The return to the gentle, familiar form restores his sanity, demonstrating that the personal relationship with God is the most comforting and accessible path for the human soul.',
    });

    // Verse 52: The difficulty of seeing the gentle form
    await db.insert('chapter_11', {
      'verse_number': 52,
      'sanskrit':
          'श्रीभगवानुवाच | सुदुर्दर्शमिदं रूपं दृष्टवानसि यन्मम | देवा अप्यस्य रूपस्य नित्यं दर्शनकाङ्क्षिणः || 52 ||',
      'translation':
          'The Supreme Lord said: This form of Mine that you have seen is **extremely difficult to behold**. Even the celestial gods constantly long to see this form.',
      'word_meaning':
          'सु-दुर्दर्शम्—extremely difficult to see; इदम्—this; रूपम्—form; दृष्टवान् असि—you have seen; यत् मम—which is Mine; देवाः अपि—even the gods; अस्य रूपस्य—of this form; नित्यम्—constantly; दर्शन-काङ्क्षिणः—desirous of seeing.',
      'commentary':
          'Krishna emphasizes that even the gentle *Viṣhṇu* form (which Arjuna saw before the two-armed Kṛṣhṇa form) is rarely seen, even by the *Devas*. This elevates Arjuna\'s merit and confirms that his vision was a unique act of grace.',
    });

    // Verse 53: The true way to see God
    await db.insert('chapter_11', {
      'verse_number': 53,
      'sanskrit':
          'नाहं वेदैर्न तपसा न दानेन न चेज्यया | शक्य एवंविधो द्रष्टुं दृष्टवानसि मां यथा || 53 ||',
      'translation':
          'I cannot be seen in the way you have seen Me, merely by study of the Vedas, nor by austerity, nor by charity, nor by ritualistic worship.',
      'word_meaning':
          'न अहम्—not I; वेदैः—by the Vedas; न तपसा—nor by austerity; न दानेन—nor by charity; न च इज्यया—nor by ritualistic worship; शक्यः—possible; एवम्-विधः—of this kind; द्रष्टुम्—to be seen; दृष्टवान् असि—you have seen; माम् यथा—Me as.',
      'commentary':
          'Krishna states clearly that the direct, personal vision is not attainable through **ritualistic (*karma-kāṇḍa*)** or **ascetic (*tapa*)** practices. A superior method is necessary.',
    });

    // Verse 54: The only way: Exclusive Devotion
    await db.insert('chapter_11', {
      'verse_number': 54,
      'sanskrit':
          'भक्त्या त्वनन्यया शक्य अहमेवंविधोऽर्जुन | ज्ञातुं द्रष्टुं च तत्त्वेन प्रवेष्टुं च परन्तप || 54 ||',
      'translation':
          'But **exclusive devotion** (*bhaktyā tvananyayā*), O Arjuna, makes it possible to truly know Me, to see Me, and to enter into Me.',
      'word_meaning':
          'भक्त्या तु—but by devotion; अनन्यया—exclusive/undivided; शक्यः—possible; अहम्—I; एवम्-विधः—in this form; अर्जुन—O Arjuna; ज्ञातुम्—to know; द्रष्टुम्—to see; च तत्त्वेन—and in reality; प्रवेष्टुम् च—and to enter; परन्तप—O scorcher of foes.',
      'commentary':
          'This is the climax of the chapter: the Lord is accessible only through **Ananyā Bhakti**. Devotion enables three stages of realization: **knowing** (intellectual knowledge), **seeing** (direct vision), and **entering** (attaining liberation and union).',
    });

    // Verse 55: Conclusion of the chapter and the essence of Bhakti Yoga
    await db.insert('chapter_11', {
      'verse_number': 55,
      'sanskrit':
          'मत्कर्मकृन्मत्परमो मद्भक्तः सङ्गवर्जितः | निर्वैरः सर्वभूतेषु यः स मामेति पाण्डव || 55 ||',
      'translation':
          'O Pāṇḍava, he who performs all his duties for My sake (*mat-karmakṛit*), considers Me the Supreme Goal (*mat-paramaḥ*), is devoted to Me, is free from attachment, and is without malice toward all beings—that devotee certainly **attains Me**.',
      'word_meaning':
          'मत्-कर्म-कृत्—one who works for Me; मत्-परमः—having Me as the Supreme; मत्-भक्तः—My devotee; सङ्ग-वर्जितः—free from attachment; निर्वैरः—without malice; सर्व-भूतेषु—toward all beings; यः सः—who that person; माम् एति—attains Me; पाण्डव—O Pāṇḍava.',
      'commentary':
          'This final verse summarizes the five characteristics of the perfect *Bhakti Yogi*: 1) **Action as service**, 2) **Goal as God**, 3) **Pure Devotion**, 4) **Detachment**, and 5) **Universal Benevolence**. This fusion of action, knowledge, and devotion is the most assured path to liberation.',
    });
  }

  Future<void> insertChapter12Verses(Database db) async {
    // Start of Chapter 12: Bhakti Yoga

    // Verse 1: Arjuna's Question
    await db.insert('chapter_12', {
      'verse_number': 1,
      'sanskrit':
          'अर्जुन उवाच | एवं सततयुक्ता ये भक्तास्त्वां पर्युपासते | ये चाप्यक्षरमव्यक्तं तेषां के योगवित्तमाः || 1 ||',
      'translation':
          'Arjuna inquired: Among those devotees who are ever-steadfast and worship Your **personal form** (*tvāṁ*), and those who worship the **imperishable, unmanifest** (*akṣharam avyaktaṁ*) Brahman—who among them are more perfect in **Yoga** (*yogavittamāḥ*)?',
      'word_meaning':
          'अर्जुन उवाच—Arjuna said; एवम्—thus; सतत-युक्ताः—ever-steadfast; ये—those who; भक्ताः—devotees; त्वाम्—You (personal form); पर्युपासते—worship; ये च अपि—and those also; अक्षरम्—the imperishable; अव्यक्तम्—the unmanifest; तेषाम्—of them; के—who; योग-वित्-तमाः—most perfect in Yoga.',
      'commentary':
          'Arjuna seeks clarity on the two main paths of Yoga: worship of the **Saguṇa** (personal, with attributes) and **Nirguṇa** (impersonal, without attributes) Brahman, a critical inquiry for all spiritual seekers.',
    });

    // Verse 2: Krishna's Answer: Personal Devotion is Best
    await db.insert('chapter_12', {
      'verse_number': 2,
      'sanskrit':
          'श्रीभगवानुवाच | मय्यावेश्य मनो ये मां नित्ययुक्ता उपासते | श्रद्धया परयोपेताः ते मे युक्ततमा मताः || 2 ||',
      'translation':
          'The Supreme Lord said: Those who fix their mind on Me, and constantly engage in My worship with supreme **faith** (*śhraddhayā parayopetāḥ*), those, I consider to be the **most perfect** (*yuktatamā*) in Yoga.',
      'word_meaning':
          'श्रीभगवान् उवाच—the Supreme Lord said; मयि—on Me; आवेश्य—fixing; मनः—mind; ये—those who; माम्—Me; नित्य-युक्ताः—ever-steadfast; उपासते—worship; श्रद्धया—with faith; परया—supreme; उपेताः—possessed; ते—they; मे—by Me; युक्त-तमाः—most perfect in Yoga; मताः—are considered.',
      'commentary':
          'Krishna declares that the devotees of His personal form are superior, emphasizing the necessity of **supreme faith** (*parayā śhraddhayā*) and fixing the **mind and heart** exclusively on Him.',
    });

    // Verse 3-4: The Path of the Impersonal
    await db.insert('chapter_12', {
      'verse_number': 3,
      'sanskrit':
          'ये त्वक्षरमनिर्देश्यमव्यक्तं पर्युपासते | सर्वत्रगमचिन्त्यं च कूटस्थमचलं ध्रुवम् || 3 ||',
      'translation':
          'But those who worship the imperishable, the indefinable (*anirdeśhyam*), the unmanifest, the all-pervading, the unthinkable, the unchanging (*kūṭastham*), the eternal, and the immovable...',
      'word_meaning':
          'ये तु—but those who; अक्षरम्—the imperishable; अनिर्र्देश्यम्—indefinable; अव्यक्तम्—the unmanifest; पर्युपासते—worship; सर्वत्र-गम्—all-pervading; अचिन्त्यम् च—and unthinkable; कूटस्थम्—unchanging/fixed; अचलम्—immovable; ध्रुवम्—eternal.',
      'commentary':
          'Krishna lists the attributes of the Nirguṇa Brahman, the object of contemplation for the *Jñāna Yogis*. This is a description of the formless, ultimate Reality that lies beyond the reach of the senses and mind.',
    });

    // Verse 4: The qualities of the Impersonal Worshipper
    await db.insert('chapter_12', {
      'verse_number': 4,
      'sanskrit':
          'संनियम्येन्द्रियग्रामं सर्वत्र समबुद्धयः | ते प्राप्नुवन्ति मामेव सर्वभूतहिते रताः || 4 ||',
      'translation':
          '...by restraining all the senses (*sanniyamyendriya-grāmaṁ*), being equal-minded everywhere, and engaging in the welfare of all beings (*sarva-bhūta-hite ratāḥ*)—they also certainly attain Me.',
      'word_meaning':
          'संनियम्य—restraining perfectly; इन्द्रिय-ग्रामम्—the multitude of senses; सर्वत्र—everywhere; सम-बुद्धयः—of equal intellect; ते—they; प्राप्नुवन्ति—attain; माम् एव—Me alone; सर्व-भूत-हिते—in the welfare of all beings; रताः—engaged.',
      'commentary':
          'Krishna confirms that the path of the impersonal also leads to Him, provided the aspirant adheres to strict ethical and mental discipline: **sense control, equanimity, and universal benevolence**.',
    });

    // Verse 5: The Difficulty of the Impersonal Path
    await db.insert('chapter_12', {
      'verse_number': 5,
      'sanskrit':
          'क्लेशोऽधिकतरस्तेषामव्यक्तासक्तचेतसाम् | अव्यक्ता हि गतिर्दुःखं देहवद्भिरवाप्यते || 5 ||',
      'translation':
          'The tribulation (*kleśha*) is greater for those whose minds are attached to the unmanifest; for the goal of the unmanifest is **exceedingly difficult** for embodied beings (*dehavadbhir*) to reach.',
      'word_meaning':
          'क्लेशः—difficulty/tribulation; अधिकतरः—greater; तेषाम्—for them; अव्यक्त-आसक्त-चेतसाम्—whose minds are attached to the unmanifest; अव्यक्ता—unmanifest; हि—for; गतिः—path/goal; दुःखम्—with difficulty; देह-वद्भिः—by the embodied; अवाप्यते—is attained.',
      'commentary':
          'This is the critical verse explaining why the personal path is superior for most: the human body (*dehavadbhir*) is inherently limited by the senses and mind, making it very difficult to fix consciousness on something that is formless and abstract.',
    });

    // Verse 6: The Path of Exclusive Devotion
    await db.insert('chapter_12', {
      'verse_number': 6,
      'sanskrit':
          'ये तु सर्वाणि कर्माणि मयि संन्यस्य मत्पराः | अनन्येनैव योगेन मां ध्यायन्त उपासते || 6 ||',
      'translation':
          'But those who, dedicating all their actions to Me, regarding Me as the supreme goal (*mat-parāḥ*), worship Me, meditating with **exclusive devotion** (*ananyenaiva yogena*)—',
      'word_meaning':
          'ये तु—but those who; सर्वाणि—all; कर्माणि—actions; मयि—in Me; संन्यस्य—renouncing/dedicating; मत्-पराः—having Me as the supreme goal; अनन्येन एव—with exclusive; योगेन—Yoga/devotion; माम्—Me; ध्यायन्तः—meditating; उपासते—worship.',
      'commentary':
          'This verse defines the qualities of the ideal *Bhakta* (devotee): complete surrender of **action** (*karmāṇi*), **goal** (*mat-parāḥ*), and **mind** (*dhyāyantaḥ*), all performed with undivided devotion.',
    });

    // Verse 7: The Lord is the Swift Deliverer
    await db.insert('chapter_12', {
      'verse_number': 7,
      'sanskrit':
          'तेषामहं समुद्धर्ता मृत्युसंसारसागरात् | भवामि नचिरात्पार्थ मय्यावेशितचेतसाम् || 7 ||',
      'translation':
          'For them, whose consciousness is fixed in Me, O Pārtha, I swiftly become the **deliverer** (*samuddhartā*) from the ocean of death and transmigration (*mṛityu-saṁsāra-sāgarāt*).',
      'word_meaning':
          'तेषाम्—for them; अहम्—I; समुद्धर्ता—the deliverer; मृत्यु-संसार-सागरात्—from the ocean of death and transmigration; भवामि—I become; न चिरात्—without delay/swiftly; पार्थ—O son of Pṛithā (Arjuna); मयि—in Me; आवेशित-चेतसाम्—whose consciousness is fixed.',
      'commentary':
          'This is Krishna’s great promise to the devotees of the personal path: because their mind is focused on a defined object, the Lord can personally and **swiftly** intervene to grant them liberation, rescuing them from the cycle of rebirth.',
    });

    // Verse 8: The ultimate practice: Mind and Intellect
    await db.insert('chapter_12', {
      'verse_number': 8,
      'sanskrit':
          'मय्येव मन आधत्स्व मयि बुद्धिं निवेशय | निवसिष्यसि मय्येव अत ऊर्ध्वं न संशयः || 8 ||',
      'translation':
          'Fix your **mind** (*mana*) on Me alone; surrender your **intellect** (*buddhi*) to Me. Thereafter, you will live in Me alone. Of this, there is no doubt.',
      'word_meaning':
          'मयि एव—on Me alone; मनः—mind; आधत्स्व—fix; मयि—in Me; बुद्धिम्—intellect; निवेशय—surrender; निवसिष्यसि—you will dwell; मयि एव—in Me alone; अतः ऊर्ध्वम्—thereafter; न संशयः—no doubt.',
      'commentary':
          'Krishna lays out the full extent of surrender: the **mind** (emotions, will) and the **intellect** (reason, decision-making) must be fixed on the Lord. The result is immediate and certain liberation.',
    });

    // Verse 9: The path of Practice (Abhyāsa-Yoga)
    await db.insert('chapter_12', {
      'verse_number': 9,
      'sanskrit':
          'अथ चित्तं समाधातुं न शक्नोषि मयि स्थिरम् | अभ्यासयोगेन ततो मामिच्छाप्तुं धनञ्जय || 9 ||',
      'translation':
          'If, however, you are unable to fix your mind steadily in Me, O Dhananjaya, then seek to attain Me through the **Yoga of Practice** (*abhyāsa-yogena*).',
      'word_meaning':
          'अथ—if; चित्तम्—mind; समाधातुम्—to fix; न शक्नोषि—you are unable; मयि—in Me; स्थिरम्—steadily; अभ्यास-योगेन—by the Yoga of Practice; ततः—then; माम्—Me; इच्छ—seek; आप्तुम्—to attain; धनञ्जय—O conqueror of wealth (Arjuna).',
      'commentary':
          'Recognizing the difficulty of perfect, immediate surrender, Krishna introduces a gradual path: **Abhyāsa-Yoga** (constant spiritual practice) to train the mind to focus on the Divine.',
    });

    // Verse 10: The path of working for God
    await db.insert('chapter_12', {
      'verse_number': 10,
      'sanskrit':
          'अभ्यासेऽप्यसमर्थोऽसि मत्कर्मपरमो भव | मदर्थमपि कर्माणि कुर्वन् सिद्धिमवाप्स्यसि || 10 ||',
      'translation':
          'If you are unable to practice even **Abhyāsa** (constant practice), be intent on **performing actions for My sake** (*mat-karma-paramo bhava*); even by performing actions for Me, you shall attain perfection (*siddhiṁ*).',
      'word_meaning':
          'अभ्यासे अपि—even in practice; असमर्थः असि—you are unable; मत्-कर्म-परमः—intent on doing work for Me; भव—be; मत्-अर्थम्—for My sake; अपि—even; कर्माणि—actions; कुर्वन्—doing; सिद्धिम—perfection; अवाप्स्यसि—you will attain.',
      'commentary':
          'This offers the most accessible path for the beginner: **Karma-Yoga infused with Bhakti**. By dedicating the fruits and intent of all daily work to the Lord, one purifies the mind and progresses toward liberation.',
    });

    // Start of Chapter 12: Bhakti Yoga - Continuation

    // Verse 11: The path of renouncing the fruit of action
    await db.insert('chapter_12', {
      'verse_number': 11,
      'sanskrit':
          'अथैतदप्यशक्तोऽसि कर्तुं मद्योगमाश्रितः | सर्वकर्मफलत्यागं ततः कुरु यतात्मवान् || 11 ||',
      'translation':
          'If you are unable to follow even this path (working for Me) in devotion, then, taking refuge in My Yoga, **renounce the fruit of all action** (*sarva-karma-phala-tyāgaṁ*), being self-controlled (*yata-ātmavān*).',
      'word_meaning':
          'अथ—if; एतत्—this (work for God); अपि—even; अशक्तः असि—you are unable; कर्तुम्—to do; मत्-योगम्—My Yoga; आश्रितः—taking shelter of; सर्व-कर्म-फल-त्यागम्—renunciation of the fruits of all actions; ततः—then; कुरु—do; यत-आत्म-वान्—being self-controlled.',
      'commentary':
          'Krishna outlines the fourth, more subtle level of practice: if one cannot dedicate action to Him, they must at least perform their duty without attachment to the results (**Karma Yoga**).',
    });

    // Verse 12: Gradation of Practice
    await db.insert('chapter_12', {
      'verse_number': 12,
      'sanskrit':
          'श्रेयो हि ज्ञानमभ्यासाज्ज्ञानाद्ध्यानं विशिष्यते | ध्यानात्कर्मफलत्यागस्त्यागाच्छान्तिरनन्तरम् || 12 ||',
      'translation':
          'Better indeed is **knowledge** (*jñānaṁ*) than mere practice (*abhyāsāt*); better than knowledge is **meditation** (*dhyānaṁ*); but superior to meditation is the **renunciation of the fruit of action** (*karma-phala-tyāgaḥ*), for peace immediately follows renunciation.',
      'word_meaning':
          'श्रेयः—better; हि—indeed; ज्ञानम्—knowledge; अभ्यासात्—than practice; ज्ञानात्—than knowledge; ध्यानम्—meditation; विशिष्यते—is superior; ध्यानात्—than meditation; कर्म-फल-त्यागः—renunciation of the fruits of action; त्यागात्—from renunciation; शान्तिः—peace; अनन्तरम्—immediately.',
      'commentary':
          'This famous verse establishes a hierarchy: Practice (effort) → Knowledge (understanding) → Meditation (mental focus) → Renunciation of Fruit (non-attachment). The final step leads directly to **supreme peace** (*śhāntiḥ*).',
    });

    // Verse 13: Qualities of the Dear Devotee (Part 1)
    await db.insert('chapter_12', {
      'verse_number': 13,
      'sanskrit':
          'अद्वेष्टा सर्वभूतानां मैत्रः करुण एव च | निर्ममो निरहंकारः समदुःखसुखः क्षमी || 13 ||',
      'translation':
          'He who does not hate any creature (*adveṣhṭā sarva-bhūtānāṁ*), who is friendly (*maitraḥ*) and compassionate (*karuṇaḥ*), who is free from the feeling of "I" and "Mine" (*nirmamo nirahaṅkāraḥ*), balanced in pleasure and pain, and forgiving (*kṣhamī*);',
      'word_meaning':
          'अद्वेष्टा—not hateful; सर्व-भूतानाम्—to all living beings; मैत्रः—friendly; करुणः—compassionate; एव च—and also; निर्ममः—without "mine-ness"; निरहंकारः—without ego; सम-दुःख-सुखः—equal in sorrow and happiness; क्षमी—forgiving.',
      'commentary':
          'Krishna begins detailing the divine qualities of a **Bhakta** who is dear to Him. The emphasis here is on outward virtue: **universal love, humility, and inner equilibrium**.',
    });

    // Verse 14: Qualities of the Dear Devotee (Part 2)
    await db.insert('chapter_12', {
      'verse_number': 14,
      'sanskrit':
          'संतुष्टः सततं योगी यतात्मा दृढनिश्चयः | मय्यर्पितमनोबुद्धिर्यो मद्भक्तः स मे प्रियः || 14 ||',
      'translation':
          'Always content (*santuṣhṭaḥ*), a Yogi, having subdued the mind, possessing firm conviction (*dṛiḍha-niśhchayaḥ*), with his **mind and intellect dedicated to Me** (*mayy arpita-mano-buddhiḥ*)—that devotee is dear to Me.',
      'word_meaning':
          'सन्तुष्टः—content; सततम्—always; योगी—a yogi (steadfast); यत-आत्मा—self-controlled; दृढ-निश्चयः—firmly convinced; मयि—in Me; अर्पित—dedicated; मनः-बुद्धिः—mind and intellect; यः—who; मत्-भक्तः—My devotee; सः—he; मे प्रियः—is dear to Me.',
      'commentary':
          'This verse highlights inner virtues: **contentment, self-control, unwavering faith, and complete surrender of the mind and intellect** to the Lord.',
    });

    // Verse 15: Qualities of the Dear Devotee (Part 3)
    await db.insert('chapter_12', {
      'verse_number': 15,
      'sanskrit':
          'यस्मान्नोद्विजते लोको लोकान्नोद्विजते च यः | हर्षामर्षभयोद्वेगैर्मुक्तो यः स च मे प्रियः || 15 ||',
      'translation':
          'He by whom the world is not agitated (*no dvijate lokaḥ*), and who is not agitated by the world (*lokān no dvijate*), who is free from joy (*harṣha*), envy (*amarṣha*), fear (*bhaya*), and anxiety (*udvega*); he is dear to Me.',
      'word_meaning':
          'यस्मात्—from whom; न—not; उद्विजते—is agitated; लोकः—the world; लोकात्—from the world; न—not; उद्विजते—is agitated; च—and; यः—who; हर्ष-अमर्ष-भय-उद्वेगैः—from joy, envy, fear, and anxiety; मुक्तः—free; यः—who; सः च—that person; मे प्रियः—is dear to Me.',
      'commentary':
          'The quality described here is **imperturbability**. A dear devotee neither causes disturbance to the world nor is disturbed by its dualities and emotions.',
    });

    // Verse 16: Qualities of the Dear Devotee (Part 4)
    await db.insert('chapter_12', {
      'verse_number': 16,
      'sanskrit':
          'अनपेक्षः शुचिर्दक्ष उदासीनो गतव्यथः | सर्वारम्भपरित्यागी यो मद्भक्तः स मे प्रियः || 16 ||',
      'translation':
          'He who is desireless (*anapekṣhaḥ*), pure (*śhuchiḥ*), expert (*dakṣhaḥ*), indifferent (to results - *udāsīnaḥ*), free from distress (*gata-vyathaḥ*), and who renounces all endeavors (*sarvārambha-parityāgī*); that devotee is dear to Me.',
      'word_meaning':
          'अनपेक्षः—having no desires; शुचिः—pure; दक्षः—expert; उदासीनः—indifferent; गत-व्यथः—free from distress; सर्व-आरम्भ-परित्यागी—renouncer of all undertakings for fruit; यः—who; मत्-भक्तः—My devotee; सः—he; मे प्रियः—is dear to Me.',
      'commentary':
          'This focuses on the internal discipline of **non-craving and purity**. **Expert** (*dakṣhaḥ*) here refers to proficiency in spiritual practice, not merely worldly skill. **Renouncing all endeavors** means giving up selfish, motivated actions.',
    });

    // Verse 17: Qualities of the Dear Devotee (Part 5)
    await db.insert('chapter_12', {
      'verse_number': 17,
      'sanskrit':
          'यो न हृष्यति न द्वेष्टि न शोचति न काङ्क्षति | शुभाशुभपरित्यागी भक्तिमान्यः स मे प्रियः || 17 ||',
      'translation':
          'He who neither rejoices (*na hṛiṣhyati*) nor hates (*na dveṣhṭi*), neither grieves (*na śhochati*) nor desires (*na kāṅkṣhati*), and who has renounced both auspicious and inauspicious outcomes (*śhubhāśhubha-parityāgī*); that person, full of devotion (*bhaktimān*), is dear to Me.',
      'word_meaning':
          'यः—who; न—not; हृष्यति—rejoices; न—not; द्वेष्टि—hates; न—not; शोचति—grieves; न—not; काङ्क्षति—desires; शुभ-अशुभ-परित्यागी—renouncer of good and bad results; भक्ति-मान्—devoted; यः—who; सः—he; मे प्रियः—is dear to Me.',
      'commentary':
          'A devotee dear to Krishna transcends the **four basic emotional reactions**: happiness (*hṛiṣhyati*), hatred (*dveṣhṭi*), sorrow (*śhochati*), and desire (*kāṅkṣhati*), by remaining detached from all worldly results.',
    });

    // Verse 18: Qualities of the Dear Devotee (Part 6)
    await db.insert('chapter_12', {
      'verse_number': 18,
      'sanskrit':
          'समः शत्रौ च मित्रे च तथा मानापमानयोः | शीतोष्णसुखदुःखेषु समः सङ्गविवर्जितः || 18 ||',
      'translation':
          'He who is the same to foe and friend (*samaḥ śhatrau cha mitre cha*), and in honor and dishonor (*mānāpamānayoḥ*), the same in cold and heat, pleasure and pain (*śhītoṣhṇa-sukha-duḥkheṣhu*), and free from attachment (*saṅga-vivarjitaḥ*);',
      'word_meaning':
          'समः—equal; शत्रौ—in foe; च—and; मित्रे—in friend; च—and; तथा—also; मान-अपमानयोः—in honor and dishonor; शीत-उष्ण-सुख-दुःखेषु—in cold, heat, pleasure, and pain; समः—equal; सङ्ग-विवर्जितः—free from attachment.',
      'commentary':
          'This highlights **equanimity** towards the great external dualities of life: relationships (friend/foe), social status (honor/dishonor), and natural conditions (hot/cold, pleasure/pain).',
    });

    // Verse 19: Qualities of the Dear Devotee (Part 7)
    await db.insert('chapter_12', {
      'verse_number': 19,
      'sanskrit':
          'तुल्यनिन्दास्तुतिर्मौनी सन्तुष्टो येन केनचित् | अनिकेतः स्थिरमतिर्भक्तिमान्मे प्रियो नरः || 19 ||',
      'translation':
          'He who is equal in condemnation and praise (*tulya-nindā-stutiḥ*), who is silent (*maunī*), content with whatever comes (*santuṣhṭo yena kena chit*), unattached to a home (*aniketaḥ*), and steady in mind (*sthira-matiḥ*)—that devotee is dear to Me.',
      'word_meaning':
          'तुल्य-निन्दा-स्तुतिः—equal in defamation and praise; मौनी—silent (controlled in speech); सन्तुष्टः—content; येन केन चित्—with anything whatsoever; अनिकेतः—having no fixed home/unattached to a dwelling; स्थिर-मतिः—steady-minded; भक्ति-मान्—devoted; मे प्रियः—is dear to Me; नरः—that person.',
      'commentary':
          'Here the focus shifts to social and personal habits: detachment from others’ opinions, controlled speech (*maunī*), simplicity, and inner stability. **Aniketaḥ** (unattached to a home) signifies detachment from all transient things.',
    });

    // Verse 20: The Conclusion of Bhakti Yoga
    await db.insert('chapter_12', {
      'verse_number': 20,
      'sanskrit':
          'ये तु धर्म्यामृतमिदं यथोक्तं पर्युपासते | श्रद्दधाना मत्परमा भक्तास्तेऽतीव मे प्रियाः || 20 ||',
      'translation':
          'But those who follow this **immortal dharma** (*dharmya-amṛitam idaṁ*), as stated by Me, with faith (*śhraddhādhānāḥ*) and considering Me as the supreme goal (*mat-paramāḥ*)—those devotees are **exceedingly dear** (*atīva me priyāḥ*) to Me.',
      'word_meaning':
          'ये तु—but those who; धर्म्य-अमृतम्—the immortal dharma/path of righteousness; इदम्—this; यथा-उक्तम्—as said (by Me); पर्युपासते—worship/follow; श्रद्दधानाः—with faith; मत्-परमाः—considering Me as the supreme goal; भक्ताः—devotees; ते—they; अतीव—exceedingly; मे—to Me; प्रियाः—dear.',
      'commentary':
          'This concluding verse summarizes the chapter: the path of devotion (**Bhakti Yoga**) is the **immortal dharma** that leads to the ultimate spiritual goal. Those who follow it with supreme faith and dedication are the most beloved by the Lord.',
    });
  }

  Future<void> insertChapter13Verses(Database db) async {
    // Start of Chapter 13: Kṣhetra Kṣhetrajña Vibhāg Yog

    // Verse 1 (Arjuna Uvaca - present in many editions): Arjuna’s Query
    await db.insert('chapter_13', {
      'verse_number': 1,

      'sanskrit':
          'प्रकृतिं पुरुषं चैव क्षेत्रं क्षेत्रज्ञमेव च | एतद्वेदितुमिच्छामि ज्ञानं ज्ञेयं च केशव || 1 ||',
      'translation':
          'Arjuna said: O Keshava (Krishna), I wish to know **Prakriti** (Matter) and **Puruṣha** (Spirit), **Kṣhetra** (the Field) and **Kṣhetrajña** (the Knower of the Field), **Jñāna** (Knowledge), and **Jñeya** (the object of knowledge).',
      'word_meaning':
          'प्रकृतिम्—material nature; पुरुषम्—the spirit/enjoyer; च एव—and also; क्षेत्रम्—the field; क्षेत्रज्ञम्—the knower of the field; एव च—and also; एतत्—all this; वेदितुम्—to understand; इच्छामि—I wish; ज्ञानम्—knowledge; ज्ञेयम्—the object of knowledge; च—and; केशव—O Keshava (Krishna).',
      'commentary':
          'Arjuna poses six key metaphysical questions, setting the stage for Krishna’s discourse on the difference between the physical body/nature and the eternal soul/consciousness. This verse is omitted in some editions, making Krishna’s reply the official start.',
    });

    // Verse 2 (Shree Bhagavān Uvācha): The Definition of the Field and its Knower
    await db.insert('chapter_13', {
      'verse_number': 2,

      'sanskrit':
          'इदं शरीरं कौन्तेय क्षेत्रमित्यभिधीयते | एतद्यो वेत्ति तं प्राहुः क्षेत्रज्ञ इति तद्विदः || 2 ||',
      'translation':
          'The Supreme Lord said: O son of Kunti (Arjuna), this **body** (*idam śharīraṁ*) is called the **Field** (*Kṣhetra*), and he who **knows** (*vetti*) it is called the **Knower of the Field** (*Kṣhetrajña*) by those who know the truth.',
      'word_meaning':
          'इदम्—this; शरीरम्—body; कौन्तेय—O son of Kunti; क्षेत्रम्—the field; इति—thus; अभिधीयते—is designated; एतत्—this; यः—who; वेत्ति—knows; तम्—him; प्राहुः—they call; क्षेत्रज्ञः—the knower of the field; इति—thus; तत्-विदः—the knowers of both.',
      'commentary':
          'The body, along with the mind and intellect, is the "field" where we sow the seeds of our **karma** and reap the results. The soul (individual *ātmā*) is the knower/witness of this field.',
    });

    // Verse 3: The Supreme Knower of all Fields
    await db.insert('chapter_13', {
      'verse_number': 3,
      'sanskrit':
          'क्षेत्रज्ञं चापि मां विद्धि सर्वक्षेत्रेषु भारत | क्षेत्रक्षेत्रज्ञयोर्ज्ञानं यत्तज्ज्ञानं मतं मम || 3 ||',
      'translation':
          'Know Me to be the **Knower of the Field** (*Kṣhetrajña*) in **all fields** (*sarva-kṣhetreṣhu*), O scion of Bharata (Arjuna). The understanding of the Field and the Knower of the Field—that is true knowledge, in My opinion.',
      'word_meaning':
          'क्षेत्रज्ञम्—the Knower of the Field; च अपि—and also; माम्—Me; विद्धि—know; सर्व-क्षेत्रेषु—in all fields; भारत—O scion of Bharata; क्षेत्र-क्षेत्रज्ञयोः—of the Field and the Knower of the Field; ज्ञानम्—knowledge; यत्—which; तत्—that; ज्ञानम्—knowledge; मतम्—opinion; मम—My.',
      'commentary':
          'Krishna reveals there are two knowers: the individual soul (*jīva*) and the Supreme Soul (God/Paramātmā) who resides in all bodies. The ultimate spiritual goal is to know the distinction between the Field (matter) and both the individual and Supreme Knower (spirit).',
    });

    // Verse 4: Authority of Scripture
    await db.insert('chapter_13', {
      'verse_number': 4,
      'sanskrit':
          'तत्क्षेत्रं यच्च यादृक्च यद्विकारि यतश्च यत् | स च यो यत्प्रभावश्च तत्समासेन शृणु मे || 4 ||',
      'translation':
          'Listen, and I will briefly explain what that Field is, what its nature is, how changes occur in it, from where it arose, who the Knower of the Field is, and what His powers are.',
      'word_meaning':
          'तत्—that; क्षेत्रम्—Field; यत् च—and what; यादृक् च—and of what nature; यत्-विकारि—with what modifications; यतः च—and from what source; यत्—what; सः च—and He; यः—who; यत्-प्रभावः च—and what His powers are; तत्—that; समासेन—briefly; शृणु—hear; मे—from Me.',
      'commentary':
          'Krishna promises a concise, authoritative analysis of the six points Arjuna requested, providing the philosophical foundation for spiritual realization.',
    });

    // Verse 5: Sources of Knowledge
    await db.insert('chapter_13', {
      'verse_number': 5,
      'sanskrit':
          'ऋषिभिर्बहुधा गीतं छन्दोभिर्विविधैः पृथक् | ब्रह्मसूत्रपदैश्चैव हेतुमद्भिर्विनिश्चितैः || 5 ||',
      'translation':
          'This truth has been sung in many ways by sages in various Vedic hymns (*chhandobhiḥ*), and especially in the definitive and reasoned aphorisms of the **Brahma Sūtra**.',
      'word_meaning':
          'ऋषिभिः—by the sages; बहुधा—in many ways; गीतम्—sung; छन्दोभिः—in the Vedas (metres); विविधैः—various; पृथक्—separately; ब्रह्म-सूत्र-पदैः—in the aphorisms of the Brahma Sūtra; च एव—and also; हेतुमद्भिः—with reason/logic; विनिश्चितैः—conclusive.',
      'commentary':
          'Krishna confirms that the knowledge He is imparting is not novel but is firmly established in scripture, including the Vedas and the logical structure of the *Brahma Sūtra*.',
    });

    // Verse 6: Components of the Field (Kṣhetra) - Part 1
    await db.insert('chapter_13', {
      'verse_number': 6,
      'sanskrit':
          'महाभूतान्यहङ्कारो बुद्धिरव्यक्तमेव च | इन्द्रियाणि दशैकं च पञ्च चेन्द्रियगोचराः || 6 ||',
      'translation':
          'The Field (*Kṣhetra*) consists of: the five **Great Elements** (*Mahā-bhūtāni*), **Ego** (*ahaṅkāra*), **Intellect** (*buddhi*), the **Unmanifest** (*avyaktam* - Mūla Prakriti), the eleven **Senses** (*indriyāṇi*) and the five **objects of the senses** (*indriya-gocharāḥ*).',
      'word_meaning':
          'महा-भूतानि—the five great elements (earth, water, fire, air, ether); अहङ्कारः—the ego; बुद्धिः—the intellect; अव्यक्तम्—the unmanifest (primordial matter); एव च—and also; इन्द्रियाणि—the senses; दश एकम् च—ten and one (the mind); पञ्च च—and five; इन्द्रिय-गोचराः—the objects of the senses.',
      'commentary':
          'This and the next verse enumerate the **24 elements of material nature** (*Prakriti*) that constitute the Field. They include the gross body (elements), the subtle body (mind, intellect, ego, senses), and the causal body (unmanifest Prakriti).',
    });

    // Verse 7: Components of the Field (Kṣhetra) - Part 2 (Modifications)
    await db.insert('chapter_13', {
      'verse_number': 7,
      'sanskrit':
          'इच्छा द्वेषः सुखं दुःखं सङ्घातश्चेतना धृतिः | एतत्क्षेत्रं समासेन सविकारमुदाहृतम् || 7 ||',
      'translation':
          'Desire (*ichchhā*), hatred (*dveṣha*), pleasure (*sukha*), pain (*duḥkha*), the aggregate (body/mind), consciousness (*chetanā*), and steadfastness (*dhṛitiḥ*). This is the Field, briefly described with its modifications (*sa-vikāram*).',
      'word_meaning':
          'इच्छा—desire; द्वेषः—hatred; सुखम्—happiness; दुःखम्—distress; सङ्घातः—the aggregate (body); चेतना—consciousness/sensation; धृतिः—steadfastness; एतत्—this; क्षेत्रम्—the Field; समासेन—briefly; स-विकारम्—with its modifications; उदाहृतम्—declared.',
      'commentary':
          'This lists the internal qualities and experiences, which are the **modifications** (*vikāras*) of the Field. They are effects of the Field’s operation and are not inherent to the spirit (Kṣhetrajña).',
    });

    // Verse 8: Qualities of True Knowledge (Jñāna) - Part 1
    await db.insert('chapter_13', {
      'verse_number': 8,
      'sanskrit':
          'अमानित्वमदम्भित्वमहिंसा क्षान्तिरार्जवम् | आचार्योपासनं शौचं स्थैर्यमात्मविनिग्रहः || 8 ||',
      'translation':
          'True Knowledge (*Jñāna*) is: **Humility** (*amānitvam*), unpretentiousness (*adambhitvam*), **non-violence** (*ahiṁsā*), forbearance (*kṣhāntiḥ*), honesty (*ārjavam*), service to the Guru (*āchāryopāsanam*), purity (*śhaucham*), steadfastness (*sthairyam*), and self-control (*ātma-vinigrahaḥ*).',
      'word_meaning':
          'अमानित्वम्—humility; अदम्भित्वम्—unpretentiousness; अहिंसा—non-violence; क्षान्तिः—forbearance/patience; आर्जवम्—honesty/simplicity; आचार्य-उपासनम्—service to the Guru; शौचम्—purity (external and internal); स्थैर्यम्—steadfastness; आत्म-विनिग्रहः—self-control.',
      'commentary':
          'From this verse, Krishna describes **20 qualities** that constitute true spiritual knowledge. These are not intellectual facts, but ethical and moral virtues that prepare the mind for Self-realization. True knowledge is a way of being.',
    });

    // Verse 9: Qualities of True Knowledge (Jñāna) - Part 2
    await db.insert('chapter_13', {
      'verse_number': 9,
      'sanskrit':
          'इन्द्रियार्थेषु वैराग्यमनहङ्कार एव च | जन्ममृत्युजराव्याधिदुःखदोषानुदर्शनम् || 9 ||',
      'translation':
          'Detachment from the objects of the senses (*indriyārtheṣhu vairāgyam*), absence of ego (*anahaṅkāra*), and constantly reflecting on the suffering and defects of birth, death, old age, and sickness (*janma-mṛityu-jarā-vyādhi-duḥkha-doṣhānudarśhanam*);',
      'word_meaning':
          'इन्द्रिय-अर्थेषु—in the objects of the senses; वैराग्यम्—detachment; अनहङ्कारः—absence of ego; एव च—and also; जन्म-मृत्यु-जरा-व्याधि-दुःख-दोष-अनुदर्शनम्—constantly reflecting on the suffering and defects of birth, death, old age, and sickness.',
      'commentary':
          'This highlights the importance of **detachment** from worldly pleasures and **Vairagya** (dispassion), which is cultivated by meditating on the temporary, sorrowful, and defective nature of material life.',
    });

    // Verse 10: Qualities of True Knowledge (Jñāna) - Part 3
    await db.insert('chapter_13', {
      'verse_number': 10,
      'sanskrit':
          'असक्तिरनभिष्वङ्गः पुत्रदारगृहादिषु | नित्यं च समचित्तत्वमिष्टानिष्टोपपत्तिषु || 10 ||',
      'translation':
          'Non-attachment (*asaktiḥ*), non-identification with son, wife, home, and so forth (*anabhiṣhvaṅgaḥ*), and constant equanimity of mind (*sama-chittatvam*) upon the attainment of desirable and undesirable events (*iṣhṭāniṣhṭopapattiṣhu*);',
      'word_meaning':
          'असक्तिः—non-attachment; अनभिष्वङ्गः—non-identification/non-clinging; पुत्र-दार-गृह-आदिषु—to son, wife, home, etc.; नित्यम्—constantly; च—and; सम-चित्तत्वम्—equanimity; इष्ट-अनिष्ट-उपपत्तिषु—upon the attainment of desirable and undesirable events.',
      'commentary':
          'The devotee must rise above the clinging that binds one to family and possessions. **Equanimity** (*sama-chittatvam*) is the inner stability that remains unshaken by favorable (iṣhṭa) or unfavorable (aniṣhṭa) outcomes.',
    });

    // Verse 11: Qualities of True Knowledge (Jñāna) - Part 4
    await db.insert('chapter_13', {
      'verse_number': 11,
      'sanskrit':
          'मयि चानन्ययोगेन भक्तिरव्यभिचारिणी | विविक्तदेशसेवित्वमरतिर्जनसंसदि || 11 ||',
      'translation':
          'Unwavering devotion (*bhaktir avyabhichāriṇī*) to Me by the Yoga of non-separation (*ananya-yogena*), inclination to live in solitary places (*vivikta-deśha-sevitvam*), and distaste for the company of mundane people (*aratir jana-saṁsadi*);',
      'word_meaning':
          'मयि च—and in Me; अनन्य-योगेन—by the Yoga of non-separation (undivided); भक्तिः—devotion; अव्यभिचारिणी—unwavering; विविक्त-देश-सेवित्वम्—inclination to live in solitary places; अरतिः—distaste; जन-संसदि—for the company of mundane people.',
      'commentary':
          'This is a crucial virtue for the Bhakti Yogī: **pure, unmixed devotion** (*ananya-bhakti*) to the Lord. It also suggests a preference for a calm, introspective environment over excessive social contact, which can distract the mind.',
    });

    // Verse 12: Qualities of True Knowledge (Jñāna) - Part 5
    await db.insert('chapter_13', {
      'verse_number': 12,
      'sanskrit':
          'अध्यात्मज्ञाननित्यत्वं तत्त्वज्ञानार्थदर्शनम् | एतज्ज्ञानमिति प्रोक्तमज्ञानं यदतोऽन्यथा || 12 ||',
      'translation':
          'Constancy in the pursuit of spiritual knowledge (*adhyātma-jñāna-nityatvam*), and seeing the goal of the knowledge of truth (*tattva-jñānārtha-darśhanam*). All this is declared to be **Knowledge**; what is contrary to this is **Ignorance** (*ajñānam*).',
      'word_meaning':
          'अध्यात्म-ज्ञान-नित्यत्वम्—constancy in self-knowledge; तत्त्व-ज्ञान-अर्थ-दर्शनम्—seeing the goal of the knowledge of the Truth (the Supreme Reality); एतत्—this; ज्ञानम्—Knowledge; इति—thus; प्रोक्तम्—declared; अज्ञानम्—Ignorance; यत्—which; अतः—from this; अन्यथा—otherwise (different).',
      'commentary':
          'This concludes the list of 20 virtues defining *Jñāna*. **True Knowledge is not just what you know, but how you live**. Everything opposed to these virtues is considered *ajñāna* (ignorance).',
    });

    // Verse 13: Introducing the Object of Knowledge (Jñeya)
    await db.insert('chapter_13', {
      'verse_number': 13,
      'sanskrit':
          'ज्ञेयं यत्तत्प्रवक्ष्यामि यज्ज्ञात्वामृतमश्नुते | अनादिमत्परं ब्रह्म न सत्तन्नासदुच्यते || 13 ||',
      'translation':
          'I shall now describe the **Object of Knowledge** (*Jñeya*), by knowing which one attains immortality (*amṛitam aśhnute*). It is the beginningless Supreme **Brahman**, which is said to be neither being (*sat*) nor non-being (*asat*).',
      'word_meaning':
          'ज्ञेयम्—the object of knowledge; यत्—which; तत्—that; प्रवक्ष्यामि—I shall now describe; यत्—which; ज्ञात्वा—having known; अमृतम्—immortality; अश्नुते—one attains; अनादि-मत्—without any beginning; परम्—supreme; ब्रह्म—Brahman (the Absolute Truth); न सत्—neither being; तत्—that; न असत्—nor non-being; उच्यते—is called.',
      'commentary':
          'The *Jñeya* is the Supreme Absolute Reality (Brahman). It is beyond the duality of **Sat** (existent, manifest) and **Asat** (non-existent, unmanifest), as both terms are limited by the material intellect. It is the transcendental source of all existence.',
    });

    // Verse 14: The Pervasiveness of Brahman (The Jñeya) - Part 1
    await db.insert('chapter_13', {
      'verse_number': 14,
      'sanskrit':
          'सर्वतः पाणिपादं तत्सर्वतोऽक्षिशिरोमुखम् | सर्वतः श्रुतिमल्लोके सर्वमावृत्य तिष्ठति || 14 ||',
      'translation':
          'That Supreme Reality has hands and feet everywhere (*sarvataḥ pāṇi-pādaṁ*), eyes, heads, and faces everywhere (*sarvato-’kṣhi-śhiro-mukham*), hearing everywhere (*sarvataḥ śhruti-mal*) in the world, pervading everything, it remains (*sarvam āvṛitya tiṣhṭhati*).',
      'word_meaning':
          'सर्वतः—everywhere; पाणि-पादम्—hands and feet; तत्—that (Brahman); सर्वतः—everywhere; अक्षि-शिरः-मुखम्—eyes, heads, and faces; सर्वतः—everywhere; श्रुति-मत्—having ears (hearing); लोके—in the world; सर्वम्—everything; आवृत्य—encompassing; तिष्ठति—remains.',
      'commentary':
          'This describes the **Cosmic Form** of the Absolute (Brahman) as the **All-Pervading** spirit. It performs all actions and perceives all objects through the sensory and motor organs of every living being, yet it remains transcendent.',
    });

    // Verse 15: The Paradoxical Nature of Brahman - Part 2
    await db.insert('chapter_13', {
      'verse_number': 15,
      'sanskrit':
          'सर्वेन्द्रियगुणाभासं सर्वेन्द्रियविवर्जितम् | असक्तं सर्वभृच्चैव निर्गुणं गुणभोक्तृ च || 15 ||',
      'translation':
          'It appears to possess the functions of all the senses (*sarvendriya-guṇābhāsaṁ*), yet it is devoid of all senses (*sarvendriya-vivarjitam*); unattached (*asaktam*), yet the maintainer of all (*sarva-bhṛit*); free from the modes of nature (*nirguṇaṁ*), yet the enjoyer of them (*guṇa-bhoktṛi*).',
      'word_meaning':
          'सर्व-इन्द्रिय-गुण-आभासम्—shining with the qualities of all the senses; सर्व-इन्द्रिय-विवर्जितम्—devoid of all senses; असक्तम्—unattached; सर्व-भृत्—the supporter of all; च एव—and also; निर्गुणम्—without the three modes of nature (guṇas); गुण-भोक्तृ—the enjoyer of the modes; च—and.',
      'commentary':
          'This highlights the **paradoxical, transcendental nature** of Brahman. It is a subtle principle: It is beyond the material senses (sense-less) but is the source of all sensory perception; it is unattached to matter, yet it sustains the entire universe; it is not bound by the *guṇas* (modes of nature) but directs and enjoys their actions.',
    });

    // Ensure this code block extends your existing insertChapter13Verses function.

    // Verse 16: The Paradoxical Reality of Brahman (The Jñeya) - Part 3
    await db.insert('chapter_13', {
      'verse_number': 16,

      'sanskrit':
          'बहिरन्तश्च भूतानामचरं चरमेव च | सूक्ष्मत्वात्तदविज्ञेयं दूरस्थं चान्तिके च तत् || 16 ||',
      'translation':
          'It exists **outside** and **inside** all beings; it is the **moving** and the **non-moving**. Because of its subtlety (*sūkṣhmatvāt*), it is incomprehensible; it is far away, yet it is also very near.',
      'word_meaning':
          'बहिः—outside; अन्तः च—and inside; भूतानाम्—of all beings; अचरम्—non-moving; चरम् एव च—and moving as well; सूक्ष्मत्वात्—because of its subtlety; तत्—that (Brahman); अविज्ञेयम्—incomprehensible; दूरस्थम् च—and situated far away; अन्तिके च—and near; तत्—that.',
      'commentary':
          'The essence of Brahman is its **subtlety** (*sūkṣhmatvāt*), which makes it logically difficult to grasp. It is simultaneously pervasive (inside everything) and transcendent (far away), revealing that physical distance is irrelevant to spiritual realization.',
    });

    // Verse 17: The Light of Lights
    await db.insert('chapter_13', {
      'verse_number': 17,

      'sanskrit':
          'अविभक्तं च भूतेषु विभक्तमिव च स्थितम् | भूतभर्तृ च तज्ज्ञेयं ग्रसिष्णु प्रभविष्णु च || 17 ||',
      'translation':
          'Though undivided, it appears to be divided (*vibhakta-miva*) among beings. It is the **supporter of all beings** (*bhūta-bhartṛi*), yet it is also the **consumer** (*grasiṣhṇu*), and the **creator** (*prabhaviṣhṇu*).',
      'word_meaning':
          'अविभक्तम् च—and undivided; भूतेषु—among beings; विभक्तम् इव च—and as if divided; स्थितम्—situated; भूत-भर्तृ—the supporter of beings; च तत् ज्ञेयम्—and that should be known; ग्रसिष्णु—the devourer; प्रभविष्णु—the creator; च—and.',
      'commentary':
          'Brahman, though non-dual (*avibhaktaṁ*), appears divided due to the multitude of individual bodies and minds. Krishna uses the cycles of life (*bhartṛi*), dissolution (*grasiṣhṇu*), and creation (*prabhaviṣhṇu*) to show the constant, single reality behind all cosmic phenomena.',
    });

    // Verse 18: The ultimate purpose of knowledge
    await db.insert('chapter_13', {
      'verse_number': 18,

      'sanskrit':
          'ज्योतिषामपि तज्ज्योतिस्तमसः परमुच्यते | ज्ञानं ज्ञेयं ज्ञानगम्यं हृदि सर्वस्य विष्ठितम् || 18 ||',
      'translation':
          'That Supreme Reality is the **Light of all lights**, said to be beyond darkness. It is **Knowledge** (*Jñānaṁ*), the **Object of Knowledge** (*Jñeyaṁ*), and the **Goal of Knowledge** (*Jñāna-gamyam*). It resides specially within the hearts of all.',
      'word_meaning':
          'ज्योतिषाम् अपि—even of lights; तत् ज्योतिः—that light; तमसः—of darkness; परम्—beyond; उच्यते—is called; ज्ञानम्—knowledge; ज्ञेयम्—the knowable; ज्ञान-गम्यम्—the goal of knowledge; हृदि—in the heart; सर्वस्य—of all; विष्ठितम्—resides.',
      'commentary':
          'This summarizes the *Jñeya* section. Brahman is the *self-luminous light* that removes the darkness of ignorance. Crucially, this ultimate reality is not distant but resides in the heart (*hṛidi sarvasya viṣhṭhitam*) of every being.',
    });

    // Verse 19: Conclusion of the Field, Knowledge, and Object
    await db.insert('chapter_13', {
      'verse_number': 19,

      'sanskrit':
          'इति क्षेत्रं तथा ज्ञानं ज्ञेयं चोक्तं समासतः | मद्भक्त एतद्विज्ञाय मद्भावायोपपद्यते || 19 ||',
      'translation':
          'Thus, the Field (*Kṣhetra*), Knowledge (*Jñānaṁ*), and the Object of Knowledge (*Jñeyaṁ*) have been briefly declared. My devotee (*mad-bhaktaḥ*), knowing this, becomes qualified to attain My nature (*mad-bhāvāyopapadyate*).',
      'word_meaning':
          'इति—thus; क्षेत्रम्—the Field; तथा—and; ज्ञानम्—Knowledge; ज्ञेयम् च—and the Knowable; उक्तम्—declared; समासतः—briefly; मत्-भक्तः—My devotee; एतत्—this; विज्ञाय—having realized; मद्-भावाय—to My nature; उपपद्यते—becomes qualified.',
      'commentary':
          'This serves as a pivotal transition. Krishna confirms the complete theoretical framework has been provided, and emphasizes that **Bhakti** is the practical means to apply this knowledge and realize the Self.',
    });

    // Verse 20: Introducing Prakṛiti and Puruṣha
    await db.insert('chapter_13', {
      'verse_number': 20,

      'sanskrit':
          'प्रकृतिं पुरुषं चैव विद्ध्यनादी उभावपि | विकारान्गुणांश्चैव विद्धि प्रकृतिसम्भवान् || 20 ||',
      'translation':
          'Know that **Prakṛiti** (Material Nature) and **Puruṣha** (the enjoyer/soul) are both **beginningless** (*anādī*). Know also that all transformations (*vikārān*) and the *guṇas* (modes of nature) are born of **Prakṛiti**.',
      'word_meaning':
          'प्रकृतिम्—Prakṛiti (Matter/Nature); पुरुषम्—Puruṣha (Spirit/Soul); च एव—and also; विद्धि—know; अनादी—beginningless; उभौ अपि—both; विकारान्—transformations; गुणान् च एव—and also the *guṇas*; विद्धि—know; प्रकृति-सम्भवान्—born of Prakṛiti.',
      'commentary':
          'Krishna now addresses Arjuna’s original Verse 1 question. He establishes that the two cosmic components—matter and soul—are both **eternal, without beginning** (*anādī*). This sets up the analysis of how they interact.',
    });

    // Verse 21: The cause of the soul’s suffering
    await db.insert('chapter_13', {
      'verse_number': 21,

      'sanskrit':
          'कार्यकारणकर्तृत्वे हेतुः प्रकृतिरुच्यते | पुरुषः सुखदुःखानां भोक्तृत्वे हेतुरुच्यते || 21 ||',
      'translation':
          'Prakṛiti is said to be the cause of the agency, effects, and instruments (the body/senses). **Puruṣha** (the soul) is said to be the cause of **experiencing** (*bhoktṛtve*) pleasure and pain.',
      'word_meaning':
          'कार्य-कारण-कर्तृत्वे—in the agency of the body, effect, and instruments; हेतुः—cause; प्रकृतिः—Prakṛiti; उच्यते—is called; पुरुषः—Puruṣha (the soul); सुख-दुःखानाम्—of pleasure and pain; भोक्तृत्वे—in the experience; हेतुः—cause; उच्यते—is called.',
      'commentary':
          'This defines the function of each eternal principle: **Prakṛiti** generates the physical and mental mechanisms (*body, action, effects*), while **Puruṣha** (the soul) is the conscious entity that falsely identifies with these mechanisms, thereby becoming the **experiencer** (*bhoktā*) of their resultant pleasure and pain.',
    });

    // Verse 22: The cause of rebirth
    await db.insert('chapter_13', {
      'verse_number': 22,

      'sanskrit':
          'पुरुषः प्रकृतिस्थो हि भुङ्क्ते प्रकृतिजान्गुणान् | कारणं गुणसङ्गोऽस्य सदसद्योनिजन्मसु || 22 ||',
      'translation':
          'The Puruṣha, situated in Prakṛiti (the body), experiences the *guṇas* born of Prakṛiti. Attachment to these *guṇas* is the cause of its birth in good and evil wombs.',
      'word_meaning':
          'पुरुषः—Puruṣha (the soul); प्रकृति-स्थः—situated in Prakṛiti; हि—certainly; भुङ्क्ते—experiences/enjoys; प्रकृति-जान्—born of Prakṛiti; गुणान्—the *guṇas*; कारणम्—the cause; गुण-सङ्गः—attachment to the *guṇas*; अस्य—his; सत्-असत्-योनि-जन्मसु—in taking birth in good and evil wombs.',
      'commentary':
          'The soul’s bondage is not inherent but caused by **attachment** (*guṇa-saṅgaḥ*). The false clinging to the experiences generated by the *guṇas* is what forces the soul into the cycle of rebirth (*saṁsāra*), dictating its future embodiment.',
    });

    // Verse 23: The Supreme Soul (Paramātmā)
    await db.insert('chapter_13', {
      'verse_number': 23,

      'sanskrit':
          'उपद्रष्टानुमन्ता च भर्ता भोक्ता महेश्वरः | परमात्मेति चाप्युक्तो देहेऽस्मिन्पुरुषः परः || 23 ||',
      'translation':
          'The Supreme Spirit (*Puruṣhaḥ Paraḥ*) in this body is the witness (*Upadraṣhṭā*), the sanctioner (*Anumantā*), the supporter (*Bhartā*), the experiencer (*Bhoktā*), and the **Supreme Lord** (*Maheśhvaraḥ*), also called the **Supreme Soul** (*Paramātmā*).',
      'word_meaning':
          'उपद्रष्टा—the witness; अनुमन्ता—the sanctioner; च—and; भर्ता—the supporter; भोक्ता—the experiencer; महा-ईश्वरः—the Supreme Lord; परम-आत्मा—the Supreme Soul; इति च अपि उक्तः—and is also called; देहे अस्मिन्—in this body; पुरुषः परः—the Supreme Spirit.',
      'commentary':
          'Krishna introduces the **Paramātmā** (Supreme Soul) as the third, highest principle present in the body. Unlike the individual soul, the Paramātmā is transcendent, acting primarily as the **Witness** (*Upadraṣhṭā*) and the **Sanctioner** (*Anumantā*) of the individual soul\'s choices.',
    });

    // Verse 24: The fruit of knowing Puruṣha and Prakṛiti
    await db.insert('chapter_13', {
      'verse_number': 24,

      'sanskrit':
          'य एवं वेत्ति पुरुषं प्रकृतिं च गुणैः सह | सर्वथा वर्तमानोऽपि न स भूयोऽभिजायते || 24 ||',
      'translation':
          'One who thus knows the **Puruṣha** (the soul), and **Prakṛiti** (nature) along with its *guṇas*, is not born again, regardless of their present mode of living.',
      'word_meaning':
          'यः—who; एवम्—thus; वेत्ति—knows; पुरुषम्—the spirit; प्रकृतिम् च—and Prakṛiti; गुणैः सह—along with the *guṇas*; सर्वथा—in all circumstances; वर्तमानः अपि—even being situated; न सः—he is not; भूयः—again; अभिजायते—born.',
      'commentary':
          'The ultimate knowledge is the ability to clearly distinguish the pure spiritual self from the material principle and its modes. This discriminative knowledge guarantees liberation (*na sa bhūyo’bhijāyate*) and is the essence of this chapter.',
    });

    // Verse 25: Three primary paths to realization
    await db.insert('chapter_13', {
      'verse_number': 25,

      'sanskrit':
          'ध्यानेनात्मनि पश्यन्ति केचिदात्मानमात्मना | अन्ये सांख्येन योगेन कर्मयोगेन चापरे || 25 ||',
      'translation':
          'Some perceive the Self within themselves through **meditation** (*Dhyānena*); others, through the **Yoga of Knowledge** (*Sānkhyena*); and yet others, through the **Yoga of Action** (*Karma-yogena*).',
      'word_meaning':
          'ध्यानेन—by meditation; आत्मनि—in the Self; पश्यन्ति—see; केचित्—some; आत्मानम्—the Self; आत्मना—by the mind/intellect; अन्ये—others; साङ्ख्येन योगेन—by the Yoga of knowledge (Sānkhya); कर्म-योगेन च अपरे—and others by the Yoga of action.',
      'commentary':
          'Krishna categorizes the three main practical approaches to attaining self-realization, confirming that all paths—contemplation, intellectual discrimination, and detached work—are valid means to achieve the same goal.',
    });

    // Verse 26: Salvation through faith (The fourth path)
    await db.insert('chapter_13', {
      'verse_number': 26,

      'sanskrit':
          'अन्ये त्वेवमजानन्तः श्रुत्वान्येभ्य उपासते | तेऽपि चातितरन्त्येव मृत्युं श्रुतिपरायणाः || 26 ||',
      'translation':
          'Others, however, not knowing these methods, begin to worship by hearing from others. They too transcend the path of death, being sincerely devoted to what they have heard (*śhruti-parāyaṇāḥ*).',
      'word_meaning':
          'अन्ये तु—but others; एवम्—thus; अजानन्तः—not knowing; श्रुत्वा—having heard; अन्येभ्यः—from others; उपासते—worship; ते अपि च—they also; अतितरन्ति एव—certainly cross over; मृत्युम्—death; श्रुति-परायणाः—devoted to hearing (from authorities).',
      'commentary':
          'This introduces the path of **faith** (*Śhruti-parāyaṇāḥ*). Even those lacking the capacity for deep Yoga or intense intellect can achieve liberation merely by faithfully following the instructions heard from a realized teacher.',
    });

    // Verse 27: The vision of the universal Self
    await db.insert('chapter_13', {
      'verse_number': 27,

      'sanskrit':
          'यावत्सञ्जायते किञ्चित्सत्त्वं स्थावरजङ्गमम् | क्षेत्रक्षेत्रज्ञसंयोगात्तद्विद्धि भरतर्षभ || 27 ||',
      'translation':
          'Whatever moving or non-moving thing comes into existence, O best of the Bhāratas, know that it arises from the **union of the Field and the Knower of the Field** (*Kṣhetra-Kṣhetrajña-saṁyogāt*).',
      'word_meaning':
          'यावत्—whatever; सञ्जायते—comes into being; किञ्चित्—anything; सत्त्वम्—being; स्थावर-जङ्गमम्—moving and non-moving; क्षेत्र-क्षेत्रज्ञ-संयोगात्—from the union of the Field and the Knower of the Field; तत् विद्धि—know that; भरतर्षभ—O best of the Bhāratas.',
      'commentary':
          'The universe is a composite reality. All creation—from stones to people—is the result of the eternal collaboration between **Matter** (the passive *Kṣhetra*) and **Spirit** (the active *Kṣhetrajña*).',
    });

    // Verse 28: The vision of the Supreme in all
    await db.insert('chapter_13', {
      'verse_number': 28,

      'sanskrit':
          'समं सर्वेषु भूतेषु तिष्ठन्तं परमेश्वरम् | विनश्यत्स्वविनश्यन्तं यः पश्यति स पश्यति || 28 ||',
      'translation':
          'One who sees the **Supreme Lord** (*Parameśhvaraṁ*) dwelling **equally** (*samaṁ*) in all beings—the Imperishable amidst the perishable—truly sees the reality.',
      'word_meaning':
          'समम्—equally; सर्वेषु भूतेषु—in all beings; तिष्ठन्तम्—dwelling; परम-ईश्वरम्—the Supreme Lord; विनश्यत्सु—in the perishing; अ-विनश्यन्तम्—the non-perishing; यः—who; पश्यति—sees; सः—he; पश्यति—truly sees.',
      'commentary':
          'This is the hallmark of the realized vision. The wise person perceives the **non-perishing Supreme Lord** residing within every temporary, perishing body. This equal vision prevents self-degradation and harmful action.',
    });

    // Verse 29: The consequence of the equal vision
    await db.insert('chapter_13', {
      'verse_number': 29,

      'sanskrit':
          'समं पश्यन्हि सर्वत्र समवस्थितमीश्वरम् | न हिनस्त्यात्मनात्मानं ततो याति परां गतिम् || 29 ||',
      'translation':
          'Because one sees the equal Lord situated everywhere, one does not degrade the self by the self, and thereby attains the supreme destination.',
      'word_meaning':
          'समम्—equal; पश्यन्—seeing; हि—certainly; सर्वत्र—everywhere; समवस्थितम्—equally situated; ईश्वरम्—the Lord; न हिनस्ति—does not injure/degrade; आत्मना आत्मानम्—the self by the self; ततः—therefore; याति—attains; पराम् गतिम्—the supreme goal.',
      'commentary':
          'Injury to the self (*ātmanātmānaṁ hinasti*) means acting out of ignorance, which generates *karma*. By maintaining the equal vision, the wise person acts in alignment with the Divine, ensuring spiritual progress (*parāṁ gatim*).',
    });

    // Verse 30: The true doer is Prakṛiti
    await db.insert('chapter_13', {
      'verse_number': 30,

      'sanskrit':
          'प्रकृत्यैव च कर्माणि क्रियमाणानि सर्वशः | यः पश्यति तथात्मानमकर्तारं स पश्यति || 30 ||',
      'translation':
          'One who sees that **all actions are performed entirely by Prakṛiti** (material nature) and that the Self is the non-doer (*akartāṁ*)—he truly sees.',
      'word_meaning':
          'प्रकृत्या एव—by Prakṛiti alone; च कर्माणि—and actions; क्रियमाणानि—being performed; सर्वशः—entirely; यः पश्यति—who sees; तथा आत्मानम्—and similarly the Self; अकर्तारम्—the non-doer; सः पश्यति—he truly sees.',
      'commentary':
          'This resolves the problem of agency. The liberated soul understands that all physical and mental activities are mechanisms of nature, and the true **Self** is merely the eternal **witness** (*akartāraṁ*), thus freeing itself from all actions.',
    });

    // Ensure this code block extends your existing insertChapter13Verses function.

    // Verse 31: The vision of unity leading to Brahman
    await db.insert('chapter_13', {
      'verse_number': 31,

      'sanskrit':
          'यदा भूतपृथग्भावमेकस्थमनुपश्यति | तत एव च विस्तारं ब्रह्म सम्पद्यते तदा || 31 ||',
      'translation':
          'When one realizes that the manifold variety of beings is **established in the one** (*eka-stham*) and sees the evolution of all that variety originating from the same source, then he attains to Brahman.',
      'word_meaning':
          'यदा—when; भूत-पृथक्-भावम्—the separate existence of beings; एक-स्थम्—established in the one; अनुपश्यति—realizes; ततः एव च—and from that alone; विस्तारम्—the evolution/expansion; ब्रह्म—Brahman (the Absolute Truth); सम्पद्यते—attains; तदा—then.',
      'commentary':
          'This describes the ultimate realization (*Samyag Darśana*). The seeker must see past the apparent diversity (*pṛithagbhāvam*) and recognize the single, underlying reality (Brahman) as the cause and substratum of all phenomenal expansion. This realization *is* the attainment of Brahman.',
    });

    // Verse 32: The eternal, non-binding nature of the Self
    await db.insert('chapter_13', {
      'verse_number': 32,

      'sanskrit':
          'अनादित्वान्निर्गुणत्वात्परमात्मायमव्ययः | शरीरस्थोऽपि कौन्तेय न करोति न लिप्यते || 32 ||',
      'translation':
          'Because the Supreme Soul (*Paramātmā*) is beginningless (*anāditvāt*) and without the *guṇas* (modes), O son of Kuntī, though dwelling in the body, it **neither acts nor is bound** (*na karo ti na lipyate*).',
      'word_meaning':
          'अनादित्वात्—because of beginninglessness; निर्गुणत्वात्—because of being without *guṇas*; परम-आत्मा—the Supreme Soul; अयम्—this; अव्ययः—imperishable; शरीर-स्थः अपि—though dwelling in the body; न करोति—does not act; न लिप्यते—is not bound.',
      'commentary':
          'This reaffirms the nature of the *Kṣhetrajña*. The soul is eternal (*anāditvāt*) and spiritual (*nirguṇatvāt*); therefore, the actions and binding nature of the body are not its own. The soul is merely the detached witness within the body.',
    });

    // Verse 33: The illumination of the entire field
    await db.insert('chapter_13', {
      'verse_number': 33,

      'sanskrit':
          'यथा सर्वगतं सौक्ष्म्यादाकाशं नोपलिप्यते | सर्वत्रावस्थितो देहे तथात्मा नोपलिप्यते || 33 ||',
      'translation':
          'Just as the all-pervading space (*ākāśham*), due to its subtlety, is not tainted (*na upalipyate*), similarly, the Self, though situated in every body, is never tainted.',
      'word_meaning':
          'यथा—just as; सर्व-गतम्—all-pervading; सौक्ष्म्यात्—due to its subtlety; आकाशम्—space/ether; न उपलिप्यते—is not tainted; सर्वत्र—everywhere; अवस्थितः—situated; देहे—in the body; तथा—similarly; आत्मा—the Self; न उपलिप्यते—is not tainted.',
      'commentary':
          'This famous analogy of **Space (*Ākāśham*)** demonstrates the soul\'s non-attachment. Just as air pollution does not stick to space, the spiritual soul remains pure, unaffected by the activities, merits, and demerits of the material body it inhabits.',
    });

    // Verse 34: The light of consciousness
    await db.insert('chapter_13', {
      'verse_number': 34,

      'sanskrit':
          'यथा प्रकाशयत्येकः कृत्स्नं लोकमिमं रविः | क्षेत्रं क्षेत्री तथा कृत्स्नं प्रकाशयति भारत || 34 ||',
      'translation':
          'Just as the sun single-handedly illuminates this entire world, O Bhārata, so does the Knower of the Field (*Kṣhetrī*) illuminate the entire Field.',
      'word_meaning':
          'यथा—just as; प्रकाशयति—illuminates; एकः—single; कृत्स्नम्—entire; लोकम् इमम्—this world; रविः—the sun; क्षेत्रम्—the Field; क्षेत्री—the Knower of the Field; तथा—similarly; कृत्स्नम्—the entire; प्रकाशयति—illuminates; भारत—O Bhārata.',
      'commentary':
          'The analogy of the **Sun** (*Ravi*) shows the function of the soul. The soul\'s consciousness illuminates the entire body-mind complex, just as the sun illuminates the world. The consciousness is one, but the field it illuminates (the body) varies.',
    });

    // Verse 35: The Conclusion of Knowledge (The path to the Supreme Goal)
    await db.insert('chapter_13', {
      'verse_number': 35,

      'sanskrit':
          'क्षेत्रक्षेत्रज्ञयोरेवमन्तरं ज्ञानचक्षुषा | भूतप्रकृतिमोक्षं च ये विदुर्यान्ति ते परम् || 35 ||',
      'translation':
          'Those who perceive the **distinction** (*antaraṁ*) between the Field and the Knower of the Field with the **eye of knowledge** (*jñāna-chakṣhuṣhā*), and understand the process of **release from material nature** (*bhūta-prakṛiti-mokṣhaṁ*), attain the Supreme.',
      'word_meaning':
          'क्षेत्र-क्षेत्रज्ञयोः—of the Field and the Knower of the Field; एवम्—thus; अन्तरम्—the distinction; ज्ञान-चक्षुषा—with the eye of knowledge; भूत-प्रकृति-मोक्षम्—release from material nature; च—and; ये विदुः—those who know; यान्ति ते—they attain; परम्—the Supreme.',
      'commentary':
          'This final verse summarizes the whole chapter. The essential knowledge for liberation is **Viveka** (discrimination)—distinguishing the soul (Spirit) from the body (Matter). Possessing this discriminative wisdom grants the ultimate goal (*paramaṁ*).',
    });
  }

  Future<void> insertChapter14Verses(Database db) async {
    await db.insert('chapter_14', {
      'verse_number': 1,

      'sanskrit':
          'परं भूयः प्रवक्ष्यामि ज्ञानानां ज्ञानमुत्तमम् | यज्ज्ञात्वा मुनयः सर्वे परां सिद्धिमितो गताः || 1 ||',
      'translation':
          'The Blessed Lord said: I shall once again explain to you the supreme wisdom, the best of all knowledge; knowing which, all the sages have attained supreme perfection.',
      'word_meaning':
          'परम्—supreme; भूयः—again; प्रवक्ष्यामि—I shall explain; ज्ञानानाम्—of knowledge; ज्ञानम्—wisdom; उत्तमम्—supreme; यत्—by which; ज्ञात्वा—knowing; मुनयः—sages; सर्वे—all; पराम्—supreme; सिद्धिम्—perfection; इतः—from here; गताः—attained.',
      'commentary':
          'Shree Krishna begins this chapter by introducing knowledge that transcends even what was explained before — the understanding of the three guṇas (sattva, rajas, tamas) that bind the soul.',
    });

    await db.insert('chapter_14', {
      'verse_number': 2,

      'sanskrit':
          'इदं ज्ञानमुपाश्रित्य मम साधर्म्यमागताः | सर्गेऽपि नोपजायन्ते प्रलये न व्यथन्ति च || 2 ||',
      'translation':
          'Having taken refuge in this knowledge, they attain oneness with Me. They are neither born at creation nor disturbed at dissolution.',
      'word_meaning':
          'इदम्—this; ज्ञानम्—knowledge; उपाश्रित्य—taking refuge in; मम—My; साधर्म्यम्—oneness in nature; आगताः—attained; सर्गे—at creation; अपि—even; न—not; उपजायन्ते—are born; प्रलये—at dissolution; न—not; व्यथन्ति—are disturbed; च—and.',
      'commentary':
          'Those who realize this supreme knowledge transcend material nature. They are not subject to birth and death because they merge into the divine consciousness of God.',
    });

    await db.insert('chapter_14', {
      'verse_number': 3,

      'sanskrit':
          'मम योनिर्महद् ब्रह्म तस्मिन्गर्भं दधाम्यहम् | सम्भवः सर्वभूतानां ततो भवति भारत || 3 ||',
      'translation':
          'The great Brahman is My womb, and in that I place the seed; from that, O Bhārata, the birth of all beings takes place.',
      'word_meaning':
          'मम—My; योनि:—womb; महत् ब्रह्म—great primordial nature; तस्मिन्—in that; गर्भम्—seed; दधामि—I place; अहम्—I; सम्भवः—birth; सर्व भूतानाम्—of all beings; ततः—from that; भवति—is; भारत—O Bhārata.',
      'commentary':
          'Here Krishna describes the process of creation. Material nature (Mahad Brahma) is like a womb, and He impregnates it with the seeds of all living beings — thus creation begins.',
    });

    await db.insert('chapter_14', {
      'verse_number': 4,

      'sanskrit':
          'सर्वयोनिषु कौन्तेय मूर्तयः सम्भवन्ति याः | तासां ब्रह्म महद्योनिरहं बीजप्रदः पिता || 4 ||',
      'translation':
          'O son of Kunti, whatever forms are produced in any wombs, the great Brahman is their womb, and I am the seed-giving father.',
      'word_meaning':
          'सर्व योनिषु—in all species; कौन्तेय—O son of Kunti; मूर्तयः—forms; सम्भवन्ति—are born; याः—whatever; तासाम्—of them; ब्रह्म—material nature; महत् योनि:—great womb; अहम्—I; बीज प्रदः—seed-giving; पिता—father.',
      'commentary':
          'The Lord is both the efficient and material cause of creation. Prakṛiti (nature) is His womb, and He Himself provides the living souls — making Him the ultimate Father of all beings.',
    });

    await db.insert('chapter_14', {
      'verse_number': 5,

      'sanskrit':
          'सत्त्वं रजस्तम इति गुणाः प्रकृतिसम्भवाः | निबध्नन्ति महाबाहो देहे देहिनमव्ययम् || 5 ||',
      'translation':
          'Sattva, rajas, and tamas — these three guṇas, born of material nature, bind the eternal soul to the body, O mighty-armed one.',
      'word_meaning':
          'सत्त्वम्—mode of goodness; रजस्—mode of passion; तमः—mode of ignorance; इति—thus; गुणाः—qualities; प्रकृति सम्भवाः—born of material nature; निबध्नन्ति—bind; महा बाहो—O mighty-armed one; देहे—in the body; देहिनम्—embodied soul; अव्ययम्—imperishable.',
      'commentary':
          'These three guṇas (qualities) form the fundamental forces of Prakṛiti. Though the soul is eternal and beyond them, it becomes bound by their influence when in contact with matter.',
    });

    await db.insert('chapter_14', {
      'verse_number': 6,

      'sanskrit':
          'तत्र सत्त्वं निर्मलत्वात्प्रकाशकमनामयम् | सुखसङ्गेन बध्नाति ज्ञानसङ्गेन चानघ || 6 ||',
      'translation':
          'Of these, sattva, being pure, illuminates and is free from disease. It binds the soul through attachment to happiness and knowledge, O sinless one.',
      'word_meaning':
          'तत्र—among them; सत्त्वम्—mode of goodness; निर्मलत्वात्—being pure; प्रकाशकम्—illuminating; अनामयम्—free from disease; सुख सङ्गेन—by attachment to happiness; बध्नाति—binds; ज्ञान सङ्गेन—by attachment to knowledge; च—and; अनघ—O sinless one.',
      'commentary':
          'The mode of goodness promotes clarity, wisdom, and peace. However, it still binds the soul by attachment to virtue and comfort, preventing liberation.',
    });

    await db.insert('chapter_14', {
      'verse_number': 7,

      'sanskrit':
          'रजो रागात्मकं विद्धि तृष्णासङ्गसमुद्भवम् | तन्निबध्नाति कौन्तेय कर्मसङ्गेन देहिनम् || 7 ||',
      'translation':
          'Know rajas to be of the nature of passion, the source of thirst and attachment; it binds the soul through attachment to action, O son of Kunti.',
      'word_meaning':
          'रजः—mode of passion; रागात्मकम्—of the nature of desire; विद्धि—know; तृष्णा—thirst; सङ्ग—attachment; समुद्भवम्—born of; तत्—that; निबध्नाति—binds; कौन्तेय—O son of Kunti; कर्म सङ्गेन—by attachment to actions; देहिनम्—the embodied soul.',
      'commentary':
          'Rajas leads to activity and restlessness. It causes the soul to remain engaged in worldly pursuits due to desire and attachment to the results of work.',
    });

    await db.insert('chapter_14', {
      'verse_number': 8,

      'sanskrit':
          'तमस्त्वज्ञानजं विद्धि मोहनं सर्वदेहिनाम् | प्रमादालस्यनिद्राभिस्तन्निबध्नाति भारत || 8 ||',
      'translation':
          'Know tamas to be born of ignorance; it deludes all embodied beings. It binds the soul through negligence, laziness, and sleep, O Bhārata.',
      'word_meaning':
          'तमः—mode of ignorance; तु—but; अज्ञानजम्—born of ignorance; विद्धि—know; मोहनम्—deluding; सर्व देहिनाम्—of all embodied beings; प्रमाद—negligence; आलस्य—laziness; निद्राभिः—by sleep; तत्—that; निबध्नाति—binds; भारत—O Bhārata.',
      'commentary':
          'The mode of ignorance clouds wisdom and leads to delusion, lethargy, and inertia. It drags the soul down toward darkness and bondage.',
    });

    await db.insert('chapter_14', {
      'verse_number': 9,

      'sanskrit':
          'सत्त्वं सुखे सञ्जयति रजः कर्मणि भारत | ज्ञानमावृत्य तु तमः प्रमादे सञ्जयत्युत || 9 ||',
      'translation':
          'Sattva binds one to happiness, rajas to action, and tamas, covering knowledge, binds one to negligence, O Bhārata.',
      'word_meaning':
          'सत्त्वम्—mode of goodness; सुखे—to happiness; सञ्जयति—binds; रजः—mode of passion; कर्मणि—to action; भारत—O Bhārata; ज्ञानम्—knowledge; आवृत्य—covering; तु—but; तमः—mode of ignorance; प्रमादे—to negligence; सञ्जयति—binds; उत—indeed.',
      'commentary':
          'Each guṇa binds the soul differently — goodness to joy and peace, passion to constant effort, and ignorance to sloth and carelessness.',
    });

    await db.insert('chapter_14', {
      'verse_number': 10,

      'sanskrit':
          'रजस्तमश्चाभिभूय सत्त्वं भवति भारत | रजः सत्त्वं तमश्चैव तमः सत्त्वं रजस्तथा || 10 ||',
      'translation':
          'Sometimes sattva prevails over rajas and tamas, O Bhārata; sometimes rajas dominates sattva and tamas, and sometimes tamas dominates sattva and rajas.',
      'word_meaning':
          'रजः—passion; तमः—ignorance; च—and; अभिभूय—overpowering; सत्त्वम्—goodness; भवति—prevails; भारत—O Bhārata; रजः—passion; सत्त्वम्—goodness; तमः—ignorance; च—also; एव—indeed; तमः—ignorance; सत्त्वम्—goodness; रजः—passion; तथा—likewise.',
      'commentary':
          'The three guṇas are in constant struggle for dominance. Depending on circumstances and one’s inner tendencies, one guṇa may overpower the others at different times.',
    });

    await db.insert('chapter_14', {
      'verse_number': 11,

      'sanskrit':
          'सर्वद्वारेषु देहेऽस्मिन्प्रकाश उपजायते | ज्ञानं यदा तदा विद्याद्विवृद्धं सत्त्वमित्युत || 11 ||',
      'translation':
          'When the light of knowledge shines through all the gates of the body, then one should know that sattva has increased.',
      'word_meaning':
          'सर्व द्वारेषु—through all the gates (the senses); देहे अस्मिन्—in this body; प्रकाशः—illumination; उपजायते—arises; ज्ञानम्—knowledge; यदा—when; तदा—then; विद्यात्—know; विवृद्धम्—increased; सत्त्वम्—mode of goodness; इति—thus; उत—indeed.',
      'commentary':
          'When one’s senses, mind, and intellect are clear and illumined by wisdom, it indicates the predominance of the sattva guṇa.',
    });

    await db.insert('chapter_14', {
      'verse_number': 12,

      'sanskrit':
          'लोभः प्रवृत्तिरारम्भः कर्मणामशमः स्पृहा | रजस्येतानि जायन्ते विवृद्धे भरतर्षभ || 12 ||',
      'translation':
          'When greed, activity, worldly pursuits, restlessness, and desire arise, know that rajas has increased, O best of the Bharatas.',
      'word_meaning':
          'लोभः—greed; प्रवृत्तिः—activity; आरम्भः—undertaking; कर्मणाम्—of actions; अशमः—restlessness; स्पृहा—desire; रजसि—in the mode of passion; एतानि—these; जायन्ते—arise; विवृद्धे—when increased; भरतर्षभ—O best of the Bharatas.',
      'commentary':
          'An increase in rajas manifests as ambition, competition, and endless desire for results — making one restless and outwardly active.',
    });

    await db.insert('chapter_14', {
      'verse_number': 13,

      'sanskrit':
          'अप्रकाशोऽप्रवृत्तिश्च प्रमादो मोह एव च | तमस्येतानि जायन्ते विवृद्धे कुरुनन्दन || 13 ||',
      'translation':
          'Darkness, inactivity, negligence, and delusion arise when tamas predominates, O joy of the Kurus.',
      'word_meaning':
          'अप्रकाशः—darkness; अप्रवृत्तिः—inactivity; च—and; प्रमादः—negligence; मोहः—delusion; एव—indeed; च—and; तमसि—in the mode of ignorance; एतानि—these; जायन्ते—arise; विवृद्धे—when increased; कुरु नन्दन—O joy of the Kurus.',
      'commentary':
          'When tamas increases, it clouds the intellect. A person becomes dull, careless, and inert, losing enthusiasm for right action.',
    });

    await db.insert('chapter_14', {
      'verse_number': 14,

      'sanskrit':
          'यदा सत्त्वे प्रवृद्धे तु प्रलयं याति देहभृत् | तदोत्तमविदां लोकानमलान्प्रतिपद्यते || 14 ||',
      'translation':
          'When one dies in the state of sattva, one attains the pure worlds of the wise and the virtuous.',
      'word_meaning':
          'यदा—when; सत्त्वे—in the mode of goodness; प्रवृद्धे—increased; तु—indeed; प्रलयम्—dissolution; याति—attains (death); देह भृत्—the embodied being; तदा—then; उत्तम विदाम्—of the wise; लोकान्—worlds; अमलान्—pure; प्रतिपद्यते—attains.',
      'commentary':
          'A person who dies while under the influence of sattva goes to higher celestial realms, experiencing peace and purity as a reward for virtuous living.',
    });

    await db.insert('chapter_14', {
      'verse_number': 15,

      'sanskrit':
          'रजसि प्रलयं गत्वा कर्मसङ्गिषु जायते | तथा प्रलीनस्तमसि मूढयोनिषु जायते || 15 ||',
      'translation':
          'Dying in rajas, one is born among those attached to action; dying in tamas, one takes birth in the wombs of the deluded.',
      'word_meaning':
          'रजसि—in the mode of passion; प्रलयम्—death; गत्वा—having attained; कर्म सङ्गिषु—among the active; जायते—is born; तथा—similarly; प्रलीनः—having died; तमसि—in ignorance; मूढ—deluded; योनिषु—in wombs; जायते—is born.',
      'commentary':
          'Death under the influence of rajas leads to rebirth among those constantly striving and desiring results. Death under tamas leads to ignorant or even subhuman births.',
    });

    await db.insert('chapter_14', {
      'verse_number': 16,

      'sanskrit':
          'कर्मणः सुकृतस्याहुः सात्त्विकं निर्मलं फलम् | रजसस्तु फलंदुःखमज्ञानं तमसः फलम् || 16 ||',
      'translation':
          'The result of righteous action, they say, is pure and sattvic; the result of rajas is pain, and the result of tamas is ignorance.',
      'word_meaning':
          'कर्मणः—of work; सुकृतस्य—of good deeds; आहुः—they say; सात्त्विकम्—of the mode of goodness; निर्मलम्—pure; फलम्—result; रजसः—of passion; तु—but; फलम्—result; दुःखम्—pain; अज्ञानम्—ignorance; तमसः—of the mode of ignorance; फलम्—result.',
      'commentary':
          'Good deeds performed in sattva yield clarity and peace. Actions in rajas bring restlessness and dissatisfaction, while those in tamas result in confusion and ignorance.',
    });

    await db.insert('chapter_14', {
      'verse_number': 17,

      'sanskrit':
          'सत्त्वात्सञ्जायते ज्ञानं रजसो लोभ एव च | प्रमादमोहौ तमसो भवतोऽज्ञानमेव च || 17 ||',
      'translation':
          'From sattva arises knowledge, from rajas arises greed, and from tamas arise negligence and delusion, as well as ignorance.',
      'word_meaning':
          'सत्त्वात्—from goodness; सञ्जायते—arises; ज्ञानम्—knowledge; रजसः—from passion; लोभः—greed; एव—indeed; च—and; प्रमाद—negligence; मोहौ—delusion; तमसः—from ignorance; भवतः—arise; अज्ञानम्—ignorance; एव—indeed; च—and.',
      'commentary':
          'Each guṇa gives rise to a certain mental state — sattva produces clarity and wisdom, rajas gives rise to desire, and tamas leads to dullness and forgetfulness.',
    });

    await db.insert('chapter_14', {
      'verse_number': 18,

      'sanskrit':
          'ऊर्ध्वं गच्छन्ति सत्त्वस्था मध्ये तिष्ठन्ति राजसाः | जघन्यगुणवृत्तिस्था अधो गच्छन्ति तामसाः || 18 ||',
      'translation':
          'Those situated in sattva go upward; the rajasic remain in the middle; and those in tamas, engaged in the lowest qualities, go downward.',
      'word_meaning':
          'ऊर्ध्वम्—upward; गच्छन्ति—go; सत्त्व स्थाः—situated in goodness; मध्ये—in the middle; तिष्ठन्ति—remain; राजसाः—those in passion; जघन्य—base; गुण वृत्ति स्थाः—engaged in the lowest qualities; अधः—downward; गच्छन्ति—go; तामसाः—those in ignorance.',
      'commentary':
          'The mode of goodness elevates the soul toward higher realms or spiritual progress, passion keeps it bound to material striving, and ignorance drags it toward degradation.',
    });

    await db.insert('chapter_14', {
      'verse_number': 19,

      'sanskrit':
          'नान्यं गुणेभ्यः कर्तारं यदा द्रष्टानुपश्यति | गुणेभ्यश्च परं वेत्ति मद्भावं सोऽधिगच्छति || 19 ||',
      'translation':
          'When the seer perceives no doer other than the guṇas and knows that which is beyond the guṇas, he attains My divine nature.',
      'word_meaning':
          'न—no; अन्यम्—other; गुणेभ्यः—than the guṇas; कर्तारम्—doer; यदा—when; द्रष्टा—the seer; अनुपश्यति—perceives; गुणेभ्यः च—and beyond the guṇas; परम्—transcendent; वेत्ति—knows; मत् भावम्—My divine nature; सः—he; अधिगच्छति—attains.',
      'commentary':
          'When a wise person realizes that all actions are done by nature’s modes and the soul is merely a witness, they transcend the guṇas and reach divine consciousness.',
    });

    await db.insert('chapter_14', {
      'verse_number': 20,

      'sanskrit':
          'गुणानेतानतीत्य त्रीन्देही देहसमुद्भवान् | जन्ममृत्युजरादुःखैर्विमुक्तोऽमृतमश्नुते || 20 ||',
      'translation':
          'When the embodied soul transcends these three guṇas, which arise from the body, it is freed from birth, death, old age, and sorrow, and attains immortality.',
      'word_meaning':
          'गुणान्—qualities; एतान्—these; अतीत्य—transcending; त्रीन्—three; देही—the embodied soul; देह—body; समुद्भवान्—arising from; जन्म—birth; मृत्यु—death; जरा—old age; दुःखैः—sorrows; विमुक्तः—freed; अमृतम्—immortality; अश्नुते—attains.',
      'commentary':
          'Liberation is achieved when one rises above the three modes of material nature. Such a soul becomes free from the cycle of birth and death and experiences eternal bliss.',
    });

    await db.insert('chapter_14', {
      'verse_number': 21,

      'sanskrit':
          'अर्जुन उवाच | कैर्लिङ्गैस्त्रीन्गुणानेतानतीतो भवति प्रभो | किमाचारः कथं चैतांस्त्रीन्गुणानतिवर्तते || 21 ||',
      'translation':
          'Arjuna said: O Lord, by what marks is one known who has gone beyond these three guṇas? What is his conduct, and how does he transcend them?',
      'word_meaning':
          'अर्जुनः उवाच—Arjuna said; कैः लिङ्गैः—by what characteristics; त्रीन् गुणान्—three modes; एतान्—these; अतीतः—transcended; भवति—becomes; प्रभो—O Lord; किम् आचारः—what conduct; कथम्—and how; च—and; एतान्—these; त्रीन् गुणान्—three modes; अतिवर्तते—transcends.',
      'commentary':
          'Arjuna seeks clarification on how to recognize a person who has transcended the guṇas — their external signs, behavior, and the means by which they overcome material influence.',
    });

    await db.insert('chapter_14', {
      'verse_number': 22,

      'sanskrit':
          'श्रीभगवानुवाच | प्रकाशं च प्रवृत्तिं च मोहमेव च पाण्डव | न द्वेष्टि सम्प्रवृत्तानि न निवृत्तानि काङ्क्षति || 22 ||',
      'translation':
          'The Blessed Lord said: O son of Pandu, one who neither hates illumination, activity, and delusion when they appear, nor longs for them when they disappear, is said to have transcended the guṇas.',
      'word_meaning':
          'श्री भगवान् उवाच—the Blessed Lord said; प्रकाशम्—illumination (sattva); च—and; प्रवृत्तिम्—activity (rajas); च—and; मोहम्—delusion (tamas); एव—indeed; च—and; पाण्डव—O son of Pandu; न—not; द्वेष्टि—hates; सम्प्रवृत्तानि—when they arise; न—not; निवृत्तानि—when they cease; काङ्क्षति—desires.',
      'commentary':
          'The transcendent person remains unaffected by the rise and fall of the guṇas. They neither crave sattva, nor shun rajas or tamas — they stay detached and balanced.',
    });

    await db.insert('chapter_14', {
      'verse_number': 23,

      'sanskrit':
          'उदासीनवदासीनो गुणैर्यो न विचाल्यते | गुणा वर्तन्त इत्येवं योऽवतिष्ठति नेङ्गते || 23 ||',
      'translation':
          'One who sits like a neutral observer, unmoved by the guṇas, knowing that it is the guṇas that act, and remains steady and unshaken — such a person transcends them.',
      'word_meaning':
          'उदासीनवत्—like one indifferent; आसीनः—sitting; गुणैः—by the modes; यः—who; न—not; विचाल्यते—is disturbed; गुणाः—the modes; वर्तन्ते—act; इति—thus; एवम्—so; यः—who; अवतिष्ठति—remains firm; न—not; इङ्गते—moves.',
      'commentary':
          'The wise remain as witnesses, realizing that the modes of nature operate independently of the soul. This detachment grants stability and peace.',
    });

    await db.insert('chapter_14', {
      'verse_number': 24,

      'sanskrit':
          'समदुःखसुखः स्वस्थः समलोष्टाश्मकाञ्चनः | तुल्यप्रियाप्रियो धीरस्तुल्यनिन्दात्मसंस्तुतिः || 24 ||',
      'translation':
          'One who is the same in pleasure and pain, who dwells in the Self, who regards a clod, a stone, and gold alike; who is even-minded toward loved and unloved, firm, and the same in praise and blame — such a person is transcendent.',
      'word_meaning':
          'सम दुःख सुखः—balanced in joy and sorrow; स्वस्थः—steady in the self; सम—equal; लोष्ट—clod; अश्म—stone; काञ्चनः—gold; तुल्य प्रिय अप्रियः—equal to the agreeable and disagreeable; धीरः—steady; तुल्य—equal; निन्दा—blame; आत्म संस्तुतिः—and praise of oneself.',
      'commentary':
          'The person who has transcended the guṇas sees all things and experiences with equanimity — unaffected by material distinctions or others’ opinions.',
    });

    await db.insert('chapter_14', {
      'verse_number': 25,

      'sanskrit':
          'मानापमानयोस्तुल्यस्तुल्यो मित्रारिपक्षयोः | सर्वारम्भपरित्यागी गुणातीतः स उच्यते || 25 ||',
      'translation':
          'One who is the same in honor and dishonor, the same toward friend and foe, and who has abandoned all undertakings — such a person is said to have transcended the guṇas.',
      'word_meaning':
          'मान—honor; अपमानयोः—dishonor; तुल्यः—equal; तुल्यः—equal; मित्र—friend; अरि—enemy; पक्षयोः—among parties; सर्व आरम्भ—of all undertakings; परित्यागी—renouncer; गुण अतीतः—beyond the guṇas; सः—he; उच्यते—is said.',
      'commentary':
          'Freedom from egoistic involvement makes one beyond dualities. Such a soul sees no difference between friend or foe and gives up self-centered action.',
    });

    await db.insert('chapter_14', {
      'verse_number': 26,

      'sanskrit':
          'मां च योऽव्यभिचारेण भक्तियोगेन सेवते | स गुणान्समतीत्यैतान्ब्रह्मभूयाय कल्पते || 26 ||',
      'translation':
          'But those who serve Me with unwavering devotion, transcending these guṇas, become eligible to attain Brahman (the divine state).',
      'word_meaning':
          'माम्—Me; च—and; यः—who; अव्यभिचारेण—unflinching; भक्ति योगेन—through devotion; सेवते—serves; सः—he; गुणान्—modes; समतीत्य—transcending; एतान्—these; ब्रह्म भूयाय—becoming Brahman; कल्पते—becomes fit.',
      'commentary':
          'Unwavering devotion to the Lord leads one beyond the influence of material nature. Such a devotee attains oneness with the divine essence.',
    });

    await db.insert('chapter_14', {
      'verse_number': 27,

      'sanskrit':
          'ब्रह्मणो हि प्रतिष्ठाहममृतस्याव्ययस्य च | शाश्वतस्य च धर्मस्य सुखस्यैकान्तिकस्य च || 27 ||',
      'translation':
          'For I am the foundation of the imperishable Brahman, of immortal and eternal dharma, and of everlasting bliss.',
      'word_meaning':
          'ब्रह्मणः—of Brahman; हि—indeed; प्रतिष्ठा—foundation; अहम्—I am; अमृतस्य—of the immortal; अव्ययस्य—of the imperishable; च—and; शाश्वतस्य—of the eternal; च—and; धर्मस्य—of dharma; सुखस्य—of happiness; एकान्तिकस्य—supreme; च—and.',
      'commentary':
          'Krishna concludes by revealing that He is the ultimate basis of Brahman itself. Devotion to Him transcends even spiritual liberation — leading to eternal bliss and divine union.',
    });
  }

  Future<void> insertChapter15Verses(Database db) async {
    await db.insert('chapter_15', {
      'verse_number': 1,

      'sanskrit':
          'ऊर्ध्वमूलमधःशाखमश्वत्थं प्राहुरव्ययम् | छन्दांसि यस्य पर्णानि यस्तं वेद स वेदवित् || 1 ||',
      'translation':
          'The Supreme Divine Personality said: They speak of an eternal Ashvattha tree with roots above and branches below. Its leaves are the Vedic hymns, and one who knows this tree is a knower of the Vedas.',
      'word_meaning':
          'ऊर्ध्व—upward; मूलम्—roots; अधः—downward; शाखम्—branches; अश्वत्थम्—the banyan tree; प्राहुः—they say; अव्ययम्—eternal; छन्दांसि—the Vedic hymns; यस्य—whose; पर्णानि—leaves; यः—who; तम्—that; वेद—knows; सः—he; वेद-वित्—is the knower of the Vedas.',
      'commentary':
          'The upside-down banyan tree represents material existence, with its roots (God) above and branches (worldly manifestations) below. Its leaves—the Vedas—sustain life by providing spiritual knowledge.',
    });

    await db.insert('chapter_15', {
      'verse_number': 2,

      'sanskrit':
          'अधश्चोर्ध्वं प्रसृतास्तस्य शाखा गुणप्रवृद्धा विषयप्रवालाः | अधश्च मूलान्यनुसन्ततानि कर्मानुबन्धीनि मनुष्यलोके || 2 ||',
      'translation':
          'Its branches extend upward and downward, nourished by the modes of material nature, with sense objects as its buds. Its roots spread downward, binding living beings to actions in the human world.',
      'word_meaning':
          'अधः—downward; च—and; ऊर्ध्वम्—upward; प्रसृताः—extended; तस्य—its; शाखाः—branches; गुण-प्रवृद्धाः—nourished by the modes; विषय-प्रवालाः—buds as sense objects; अधः—downward; च—and; मूलानि—roots; अनुसन्ततानि—extended; कर्म-अनुबन्धीनि—bound by actions; मनुष्य-लोके—in the world of humans.',
      'commentary':
          'The branches of material life are nourished by the three gunas (sattva, rajas, tamas). The sense objects act as buds, and karma acts as roots, keeping the soul bound to material existence.',
    });

    await db.insert('chapter_15', {
      'verse_number': 3,

      'sanskrit':
          'न रूपमस्येह तथोपलभ्यते नान्तो न चादिर्न च संप्रतिष्ठा | अश्वत्थमेनं सुविरूढमूलं असङ्गशस्त्रेण दृढेन छित्त्वा || 3 ||',
      'translation':
          'Its form cannot be perceived here in this world—neither its beginning, nor its end, nor its foundation. But after cutting down this deeply rooted Ashvattha tree with the strong axe of detachment—',
      'word_meaning':
          'न—not; रूपम्—form; अस्य—its; इह—here; तथा—so; उपलभ्यते—is perceived; न—not; अन्तः—end; न—not; च—and; आदिः—beginning; न—not; च—and; संप्रतिष्ठा—foundation; अश्वत्थम्—banyan tree; एनम्—this; सुविरूढ-मूलम्—firmly rooted; असङ्ग-शस्त्रेण—with the weapon of detachment; दृढेन—strong; छित्त्वा—having cut.',
      'commentary':
          'The illusory nature of the material world cannot be fully known. Only by the weapon of detachment can one sever ties with this entangled existence.',
    });

    await db.insert('chapter_15', {
      'verse_number': 4,

      'sanskrit':
          'ततः पदं तत्परिमार्गितव्यं यस्मिन्गता न निवर्तन्ति भूयः | तमेव चाद्यं पुरुषं प्रपद्ये यतः प्रवृत्तिः प्रसृता पुराणी || 4 ||',
      'translation':
          'Then one must seek that supreme abode, having reached which, there is no return. I take refuge in that primeval Supreme Person, from whom the eternal activity has emanated.',
      'word_meaning':
          'ततः—then; पदम्—abode; तत्—that; परिमार्गितव्यम्—should be sought; यस्मिन्—in which; गता—having gone; न—not; निवर्तन्ति—return; भूयः—again; तम्—Him; एव—indeed; च—and; आद्यं—primeval; पुरुषम्—Supreme Person; प्रपद्ये—I surrender; यतः—from whom; प्रवृत्तिः—activity; प्रसृता—has emanated; पुराणी—ancient.',
      'commentary':
          'Liberation comes by surrendering to the eternal source of all activity—the Supreme Lord—whose abode once attained, one never returns to the cycle of birth and death.',
    });

    await db.insert('chapter_15', {
      'verse_number': 5,

      'sanskrit':
          'निर्मानमोहा जितसङ्गदोषा अध्यात्मनित्या विनिवृत्तकामाः | द्वन्द्वैर्विमुक्ताः सुखदुःखसंज्ञैर् गच्छन्त्यमूढाः पदमव्ययं तत् || 5 ||',
      'translation':
          'Free from pride and delusion, victorious over the evil of attachment, dwelling constantly in the Self, their desires completely gone, freed from the dualities of pleasure and pain—such wise ones reach that eternal abode.',
      'word_meaning':
          'नि—without; मान—pride; मोहा—delusion; जित—conquered; सङ्ग—attachment; दोषाः—evil; अध्यात्म—self-realized; नित्या—ever fixed; विनिवृत्त—withdrawn; कामाः—desires; द्वन्द्वैः—duality; विमुक्ताः—freed; सुख—pleasure; दुःख—pain; संज्ञैः—named; गच्छन्ति—reach; अमूढाः—the wise; पदम्—abode; अव्ययम्—eternal.',
      'commentary':
          'Only those who are free from ego, desires, and attachment, and are unaffected by the dualities of life, can attain the imperishable Supreme state.',
    });

    await db.insert('chapter_15', {
      'verse_number': 6,

      'sanskrit':
          'न तद्भासयते सूर्यो न शशाङ्को न पावकः | यद्गत्वा न निवर्तन्ते तद्धाम परमं मम || 6 ||',
      'translation':
          'Neither the sun, nor the moon, nor fire can illuminate that Supreme Abode. Having gone there, one never returns. That is My supreme abode.',
      'word_meaning':
          'न—not; तत्—that; भासयते—illuminates; सूर्यः—the sun; न—not; शशाङ्कः—the moon; न—not; पावकः—fire; यत्—where; गत्वा—having gone; न—not; निवर्तन्ते—they return; तत्—that; धाम—abode; परमम्—supreme; मम—My.',
      'commentary':
          'The divine realm of God is beyond material illumination. Once the soul reaches it, it never returns to mortal existence.',
    });

    await db.insert('chapter_15', {
      'verse_number': 7,

      'sanskrit':
          'ममैवांशो जीवलोके जीवभूतः सनातनः | मनःषष्ठानीन्द्रियाणि प्रकृतिस्थानि कर्षति || 7 ||',
      'translation':
          'The living entities in this conditioned world are My eternal fragmental parts. But bound by material nature, they struggle with the six senses, including the mind.',
      'word_meaning':
          'मम—My; एव—indeed; अंशः—fragment; जीव-लोके—in the world of living beings; जीव-भूतः—the living entity; सनातनः—eternal; मनः—mind; षष्ठानि—sixth; इन्द्रियाणि—senses; प्रकृति-स्थानि—situated in material nature; कर्षति—struggles.',
      'commentary':
          'Every living being is an eternal spark of the Divine, but illusion and attachment to the senses keep it entangled in material struggles.',
    });

    await db.insert('chapter_15', {
      'verse_number': 8,

      'sanskrit':
          'शरीरं यदवाप्नोति यच्चाप्युत्क्रामतीश्वरः | गृहित्वैतानि संयाति वायुर्गन्धानिवाशयात् || 8 ||',
      'translation':
          'Just as the wind carries scents from their source, the embodied soul carries the mind and senses from one body to another when it leaves an old body and enters a new one.',
      'word_meaning':
          'शरीरम्—body; यत्—when; अवाप्नोति—attains; यत् च—and; अपि—also; उत्क्रामति—leaves; ईश्वरः—the soul; गृहित्वा—taking; एतानि—these; संयाति—goes; वायुः—the wind; गन्धान्—scents; इव—as; आशयात्—from their source.',
      'commentary':
          'This verse beautifully explains reincarnation—the soul carries impressions (mind and senses) like wind carrying fragrance, continuing its journey from one life to another.',
    });

    await db.insert('chapter_15', {
      'verse_number': 9,

      'sanskrit':
          'श्रोत्रं चक्षुः स्पर्शनं च रसनं घ्राणमेव च | अधिष्ठाय मनश्चायं विषयानुपसेवते || 9 ||',
      'translation':
          'Presiding over the ear, eye, touch, tongue, and nose, as well as the mind, the embodied soul experiences the sense objects.',
      'word_meaning':
          'श्रोत्रम्—ear; च—and; चक्षुः—eye; स्पर्शनम्—touch; च—and; रसनम्—tongue; घ्राणम्—nose; एव—indeed; च—and; अधिष्ठाय—presiding; मनः—mind; च—and; अयम्—this (soul); विषयान्—sense objects; उपसेवते—enjoys.',
      'commentary':
          'The soul operates through the body’s senses to interact with the world. However, the senses serve as instruments, not the true enjoyers—the soul is the conscious experiencer.',
    });

    await db.insert('chapter_15', {
      'verse_number': 10,

      'sanskrit':
          'उत्क्रामन्तं स्थितं वापि भुञ्जानं वा गुणान्वितम् | विमूढा नानुपश्यन्ति पश्यन्ति ज्ञानचक्षुषः || 10 ||',
      'translation':
          'The ignorant do not perceive the soul when it departs from the body, dwells within it, or enjoys the sense objects. But those with the eyes of knowledge can see it.',
      'word_meaning':
          'उत्क्रामन्तम्—departing; स्थितम्—residing; वा—or; अपि—even; भुञ्जानम्—enjoying; वा—or; गुण—modes of nature; अन्वितम्—associated; विमूढाः—the deluded; न—not; अनुपश्यन्ति—see; पश्यन्ति—see; ज्ञान—of knowledge; चक्षुषः—with eyes.',
      'commentary':
          'Those blinded by ignorance cannot perceive the journey of the soul. Only the wise, through spiritual knowledge, can see beyond the physical form.',
    });

    await db.insert('chapter_15', {
      'verse_number': 11,

      'sanskrit':
          'यतन्तो योगिनश्चैनं पश्यन्त्यात्मन्यवस्थितम् | यतन्तोऽप्यकृतात्मानो नैनं पश्यन्त्यचेतसः || 11 ||',
      'translation':
          'The yogis, striving diligently, perceive the soul situated within themselves. But those whose minds are not purified and who lack self-control cannot perceive it, even though they strive.',
      'word_meaning':
          'यतन्तः—striving; योगिनः—yogis; च—and; एनम्—this (soul); पश्यन्ति—see; आत्मनि—within themselves; अवस्थितम्—situated; यतन्तः—striving; अपि—even; अ-кृत-आत्मानः—those not disciplined; न—not; एनम्—this (soul); पश्यन्ति—see; अ-चेतसः—undeveloped minds.',
      'commentary':
          'The disciplined yogis realize the soul within through meditation and purity of mind. Those lacking mental control and self-discipline cannot perceive the soul even with effort.',
    });

    await db.insert('chapter_15', {
      'verse_number': 12,

      'sanskrit':
          'यदादित्यगतं तेजो जगद्भासयतेऽखिलम् | यच्चन्द्रमसि यच्चाग्नौ तत्तेजो विद्धि मामकम् || 12 ||',
      'translation':
          'Know that the splendor that shines from the sun, which illumines the whole world, and that which is in the moon and in fire—know that to be My radiance.',
      'word_meaning':
          'यत्—that which; आदित्य-गतम्—residing in the sun; तेजः—radiance; जगत्—the world; भासयते—illumines; अखिलम्—entire; यत् च—and that which; चन्द्रमसि—in the moon; यत् च—and that which; अग्नौ—in fire; तत्—that; तेजः—splendor; विद्धि—know; मामकम्—Mine.',
      'commentary':
          'The divine energy of God pervades all luminous sources—the sun, moon, and fire—all shine by His brilliance.',
    });

    await db.insert('chapter_15', {
      'verse_number': 13,

      'sanskrit':
          'गामाविश्य च भूतानि धारयाम्यहमोजसा | पुष्णामि चौषधीः सर्वाः सोमो भूत्वा रसात्मकः || 13 ||',
      'translation':
          'Entering the earth, I sustain all beings with My energy. Becoming the moon, I nourish all plants with the essence of life.',
      'word_meaning':
          'गाम्—earth; आविश्य—entering; च—and; भूतानि—all beings; धारयामि—I sustain; अहम्—I; ओजसा—by My energy; पुष्णामि—I nourish; च—and; औषधीः—plants; सर्वाः—all; सोमः—the moon; भूत्वा—becoming; रस-आत्मकः—full of nectar.',
      'commentary':
          'God’s presence supports all life—He sustains the earth, nourishes plants through the moon’s essence, and pervades creation with divine vitality.',
    });

    await db.insert('chapter_15', {
      'verse_number': 14,

      'sanskrit':
          'अहं वैश्वानरो भूत्वा प्राणिनां देहमाश्रितः | प्राणापानसमायुक्तः पचाम्यन्नं चतुर्विधम् || 14 ||',
      'translation':
          'Becoming the fire of digestion in the bodies of all living beings, I unite with the vital air and digest the four kinds of food.',
      'word_meaning':
          'अहम्—I; वैश्वानरः—digestive fire; भूत्वा—becoming; प्राणिनाम्—of living beings; देहम्—body; आश्रितः—situated; प्राण—life airs; अपान—downward air; समायुक्तः—united; पचामि—I digest; अन्नम्—food; चतुर्विधम्—of four kinds (chewed, swallowed, licked, sucked).',
      'commentary':
          'The Lord manifests as the metabolic fire (Vaishvānara) in all living bodies, enabling digestion and sustaining physical life.',
    });

    await db.insert('chapter_15', {
      'verse_number': 15,

      'sanskrit':
          'सर्वस्य चाहं हृदि सन्निविष्टो मत्तः स्मृतिर्ज्ञानमपोहनं च | वेदैश्च सर्वैरहमेव वेद्यो वेदान्तकृद्वेदविदेव चाहम् || 15 ||',
      'translation':
          'I am seated in the hearts of all beings; from Me come memory, knowledge, and forgetfulness. I am verily the object to be known by all the Vedas. Indeed, I am the compiler of Vedanta and the knower of the Vedas.',
      'word_meaning':
          'सर्वस्य—of all; च—and; अहम्—I; हृदि—in the heart; सन्निविष्टः—situated; मत्तः—from Me; स्मृतिः—memory; ज्ञानम्—knowledge; अपोहनम्—forgetfulness; च—and; वेदैः—by the Vedas; च—and; सर्वैः—all; अहम्—I; एव—indeed; वेद्यः—to be known; वेदान्त—Vedanta; कृत्—compiler; वेद-वित्—knower of Vedas; एव—indeed; च—and; अहम्—I.',
      'commentary':
          'The Lord dwells in the hearts of all beings as the inner guide, giving rise to memory, knowledge, and even forgetfulness. He is both the author and subject of all Vedic wisdom.',
    });

    await db.insert('chapter_15', {
      'verse_number': 16,

      'sanskrit':
          'द्वाविमौ पुरुषौ लोके क्षरश्चाक्षर एव च | क्षरः सर्वाणि भूतानि कूटस्थोऽक्षर उच्यते || 16 ||',
      'translation':
          'There are two kinds of beings in this world—the perishable and the imperishable. The perishable are all created beings, and the imperishable is the unchanging soul.',
      'word_meaning':
          'द्वौ—two; इमौ—these; पुरुषौ—beings; लोके—in the world; क्षरः—perishable; च—and; अक्षरः—imperishable; एव—indeed; च—and; क्षरः—the perishable; सर्वाणि—all; भूतानि—creatures; कूटस्थः—the immutable; अक्षरः—the imperishable; उच्यते—is said.',
      'commentary':
          'All living beings with material bodies are perishable. The soul, being spiritual and immutable, is imperishable.',
    });

    await db.insert('chapter_15', {
      'verse_number': 17,

      'sanskrit':
          'उत्तमः पुरुषस्त्वन्यः परमात्मेत्युधाहृतः | यो लोकत्रयमाविश्य बिभर्त्यव्यय ईश्वरः || 17 ||',
      'translation':
          'But distinct from these two is the Supreme Person, called the Paramātmā, who, entering the three worlds, sustains them as the imperishable Lord.',
      'word_meaning':
          'उत्तमः—the Supreme; पुरुषः—Person; तु—but; अन्यः—another; परमात्मा—the Supreme Soul; इति—thus; उधाहृतः—is said; यः—who; लोक-त्रयम्—the three worlds; आविश्य—entering; बिभर्ति—sustains; अव्ययः—imperishable; ईश्वरः—the Lord.',
      'commentary':
          'Beyond both the perishable (bodies) and imperishable (souls) exists the Supreme Divine Being—God Himself—who pervades and supports all realms.',
    });

    await db.insert('chapter_15', {
      'verse_number': 18,

      'sanskrit':
          'यस्मात्क्षरमतीतोऽहमक्षरादपि चोत्तमः | अतोऽस्मि लोके वेदे च प्रथितः पुरुषोत्तमः || 18 ||',
      'translation':
          'Because I am transcendental to both the perishable and the imperishable, and am even higher than the imperishable, I am celebrated in the world and in the Vedas as the Supreme Person (Puruṣhottama).',
      'word_meaning':
          'यस्मात्—because; क्षरम्—the perishable; अतीतः—transcended; अहम्—I; अक्षरात्—imperishable; अपि—even; च—and; उत्तमः—higher; अतः—therefore; अस्मि—I am; लोके—in the world; वेदे—in the Vedas; च—and; प्रथितः—celebrated; पुरुष-उत्तमः—the Supreme Person.',
      'commentary':
          'God is beyond both material and spiritual categories—He is Supreme. Hence, He is known as Purushottama, the highest of all beings.',
    });

    await db.insert('chapter_15', {
      'verse_number': 19,

      'sanskrit':
          'यो मामेवमसम्मूढो जानाति पुरुषोत्तमम् | स सर्वविद्भजति मां सर्वभावेन भारत || 19 ||',
      'translation':
          'One who, without delusion, knows Me as the Supreme Person, knows everything. Such a person worships Me wholeheartedly, O Bhārata.',
      'word_meaning':
          'यः—who; माम्—Me; एवम्—thus; असम्मूढः—undeluded; जानाति—knows; पुरुषोत्तमम्—the Supreme Person; सः—he; सर्व-वित्—knower of all; भजति—worships; माम्—Me; सर्व-भावेन—with full devotion; भारत—O Bhārata.',
      'commentary':
          'Those who truly recognize Krishna as the Supreme Person understand the essence of all knowledge and naturally engage in wholehearted devotion.',
    });

    await db.insert('chapter_15', {
      'verse_number': 20,

      'sanskrit':
          'इति गुह्यतमं शास्त्रमिदमुक्तं मयानघ | एतद्बुद्ध्वा बुद्धिमान्स्यात्कृतकृत्यश्च भारत || 20 ||',
      'translation':
          'Thus, I have explained to you this most confidential teaching, O sinless one. Understanding this, a person becomes wise and fulfills all that is to be accomplished.',
      'word_meaning':
          'इति—thus; गुह्य-तमम्—most secret; शास्त्रम्—teaching; इदम्—this; उक्तम्—has been spoken; मया—by Me; अनघ—O sinless one; एतत्—this; बुद्ध्वा—knowing; बुद्धिमान्—wise; स्यात्—becomes; कृत-कृत्यः—fulfilled; च—and; भारत—O Bhārata.',
      'commentary':
          'By understanding this supreme knowledge about the eternal soul and Supreme Person, one attains true wisdom and achieves the ultimate purpose of human life—union with God.',
    });
  }

  Future<void> insertChapter16Verses(Database db) async {
    await db.insert('chapter_16', {
      'verse_number': 1,

      'sanskrit':
          'अभयं सत्त्वसंशुद्धिर्ज्ञानयोगव्यवस्थितिः | दानं दमश्च यज्ञश्च स्वाध्यायस्तप आर्जवम् || 1 ||',
      'translation':
          'Fearlessness, purity of mind, steadfastness in the yoga of knowledge, charity, control of the senses, performance of sacrifice, study of the scriptures, austerity, and straightforwardness—these are divine qualities, O Arjuna.',
      'word_meaning':
          'अभयम्—fearlessness; सत्त्व—of mind; संशुद्धिः—purity; ज्ञानयोग—of the yoga of knowledge; व्यवस्थितिः—steadfastness; दानम्—charity; दमः—control of the senses; च—and; यज्ञः—sacrifice; स्वाध्यायः—study of the scriptures; तपः—austerity; आर्जवम्—straightforwardness.',
      'commentary':
          'Shree Krishna begins listing divine qualities (Daivi Sampatti) necessary for liberation. The first among them is fearlessness, born from faith and knowledge of the Self.',
    });

    await db.insert('chapter_16', {
      'verse_number': 2,

      'sanskrit':
          'अहिंसा सत्यमक्रोधस्त्यागः शान्तिरपैशुनम् | दया भूतेष्वलोलुप्त्वं मार्दवं ह्रीरचापलम् || 2 ||',
      'translation':
          'Non-violence, truthfulness, absence of anger, renunciation, tranquility, aversion to fault-finding, compassion to living beings, absence of greed, gentleness, modesty, and lack of fickleness—these are divine virtues.',
      'word_meaning':
          'अहिंसा—non-violence; सत्यम्—truthfulness; अक्रोधः—absence of anger; त्यागः—renunciation; शान्तिः—tranquility; अपैशुनम्—aversion to fault-finding; दया—compassion; भूतेषु—to all living beings; अलोलुप्त्वम्—absence of greed; मार्दवम्—gentleness; ह्रीः—modesty; अचापलम्—lack of fickleness.',
      'commentary':
          'These qualities are manifestations of a purified mind. They lead to inner peace and alignment with divine nature.',
    });

    await db.insert('chapter_16', {
      'verse_number': 3,

      'sanskrit':
          'तेजः क्षमा धृतिः शौचमद्रोहो नातिमानिता | भवन्ति संपदं दैवीमभिजातस्य भारत || 3 ||',
      'translation':
          'Vigor, forgiveness, fortitude, cleanliness, absence of malice, and lack of excessive pride—these, O Bhārata, are the qualities of those born with divine nature.',
      'word_meaning':
          'तेजः—vigor; क्षमा—forgiveness; धृतिः—fortitude; शौचम्—cleanliness; अद्रोहः—absence of malice; न—not; अतिमानिता—excessive pride; भवन्ति—are; संपदम्—qualities; दैवीम्—divine; अभिजातस्य—of one born with; भारत—O Bhārata.',
      'commentary':
          'These divine traits elevate a person spiritually. A divine-natured person lives harmoniously and progresses toward liberation.',
    });

    await db.insert('chapter_16', {
      'verse_number': 4,

      'sanskrit':
          'दम्भो दर्पोऽभिमानश्च क्रोधः पारुष्यमेव च | अज्ञानं चाभिजातस्य पार्थ संपदमासुरीम् || 4 ||',
      'translation':
          'Hypocrisy, arrogance, pride, anger, harshness, and ignorance—these, O Parth, are the qualities of those born with demoniac nature.',
      'word_meaning':
          'दम्भः—hypocrisy; दर्पः—arrogance; अभिमानः—pride; च—and; क्रोधः—anger; पारुष्यम्—harshness; एव—indeed; च—and; अज्ञानम्—ignorance; च—and; अभिजातस्य—of one born with; पार्थ—O Parth; संपदम्—qualities; आसुरीम्—demoniac.',
      'commentary':
          'Asuric (demoniac) qualities lead to bondage and suffering. They are rooted in ego and ignorance of the true self.',
    });

    await db.insert('chapter_16', {
      'verse_number': 5,

      'sanskrit':
          'दैवी संपद्विमोक्षाय निबन्धायासुरी मता | मा शुचः संपदं दैवीमभिजातोऽसि पाण्डव || 5 ||',
      'translation':
          'The divine qualities lead to liberation, while the demoniac qualities lead to bondage. But do not grieve, O son of Pandu, for you are born with divine virtues.',
      'word_meaning':
          'दैवी—divine; संपत्—qualities; विमोक्षाय—to liberation; निबन्धाय—to bondage; आसुरी—demoniac; मता—are considered; मा शुचः—do not grieve; संपदम्—qualities; दैवीम्—divine; अभिजातः—born with; असि—you are; पाण्डव—O son of Pandu.',
      'commentary':
          'Shree Krishna reassures Arjuna that he possesses divine qualities and is destined for liberation.',
    });

    await db.insert('chapter_16', {
      'verse_number': 6,

      'sanskrit':
          'द्वौ भूतसर्गौ लोकेऽस्मिन्दैव आसुर एव च | दैवो विस्तरशः प्रोक्त आसुरं पार्थ मे शृणु || 6 ||',
      'translation':
          'There are two kinds of beings in this world—the divine and the demoniac. The divine nature has been described in detail; now hear from Me about the demoniac, O Parth.',
      'word_meaning':
          'द्वौ—two; भूतसर्गौ—kinds of beings; लोके—in the world; अस्मिन्—in this; दैवः—divine; आसुरः—demoniac; एव—indeed; च—and; दैवः—divine; विस्तरशः—in detail; प्रोक्तः—described; आसुरम्—demoniac; पार्थ—O Parth; मे—My; शृणु—hear.',
      'commentary':
          'Shree Krishna introduces the contrast between divine and demoniac natures as two paths shaping human behavior and destiny.',
    });

    await db.insert('chapter_16', {
      'verse_number': 7,

      'sanskrit':
          'प्रवृत्तिं च निवृत्तिं च जना न विदुरासुराः | न शौचं नापि चाचारो न सत्यं तेषु विद्यते || 7 ||',
      'translation':
          'Those of demoniac nature do not understand what is proper action and what is improper. They have neither purity, nor proper conduct, nor truth.',
      'word_meaning':
          'प्रवृत्तिम्—right action; च—and; निवृत्तिम्—prohibition; च—and; जनाः—people; न—not; विदुः—understand; आसुराः—of demoniac nature; न—not; शौचम्—purity; न—not; अपि—also; च—and; आचारः—proper conduct; न—not; सत्यम्—truth; तेषु—in them; विद्यते—exists.',
      'commentary':
          'People of demoniac nature act impulsively without moral clarity, disregarding purity, discipline, and truth.',
    });

    await db.insert('chapter_16', {
      'verse_number': 8,

      'sanskrit':
          'असत्यमप्रतिष्ठं ते जगदाहुरनीश्वरम् | अपरस्परसंभूतं किमन्यत्कामहैतुकम् || 8 ||',
      'translation':
          'They say that the world is unreal, without moral foundation, and without God. They claim it is produced by mutual union of male and female, and that lust alone is its cause.',
      'word_meaning':
          'असत्यम्—unreal; अप्रतिष्ठम्—without moral basis; ते—they; जगत्—world; आहुः—say; अनईश्वरम्—without God; अपरस्परसंभूतम्—born of sexual union; किम्—what else; अन्यत्—other; कामहेतुकम्—caused by lust.',
      'commentary':
          'This verse describes the materialistic worldview of demoniac people, who deny divinity and moral order, attributing creation to mere desire and matter.',
    });

    await db.insert('chapter_16', {
      'verse_number': 9,

      'sanskrit':
          'एतां दृष्टिमवष्टभ्य नष्टात्मानोऽल्पबुद्धयः | प्रभवन्त्युग्रकर्माणः क्षयाय जगतोऽहिताः || 9 ||',
      'translation':
          'Holding such views, the demoniac, who are of small intellect and ruined souls, engage in unholy acts meant to destroy the world.',
      'word_meaning':
          'एताम्—this; दृष्टिम्—view; अवष्टभ्य—holding; नष्टात्मानः—ruined souls; अल्पबुद्धयः—of small intellect; प्रभवन्ति—arise; उग्रकर्माणः—cruel acts; क्षयाय—for destruction; जगतः—of the world; अहिताः—enemies.',
      'commentary':
          'Such thinking leads to destructive behavior. Denying divine order, they become enemies of harmony and society.',
    });

    await db.insert('chapter_16', {
      'verse_number': 10,

      'sanskrit':
          'काममाश्रित्य दुष्पूरं दम्भमानमदान्विताः | मोहाद्‍गृहीत्वासद्ग्राहान्प्रवर्तन्तेऽशुचिव्रताः || 10 ||',
      'translation':
          'Filled with insatiable desires, hypocrisy, pride, and arrogance, the demoniac, deluded by ignorance, engage in impure acts, following false doctrines.',
      'word_meaning':
          'कामम्—desire; आश्रित्य—taking refuge in; दुष्पूरम्—insatiable; दम्भ—hypocrisy; मान—pride; मद—arrogance; अन्विताः—endowed with; मोहात्—through delusion; गृहीत्वा—grasping; असत्—false; ग्राहान्—doctrines; प्रवर्तन्ते—engage; अशुचि—impure; व्रताः—vows.',
      'commentary':
          'Driven by greed and pride, they adopt unholy practices and distorted philosophies to justify indulgence.',
    });

    await db.insert('chapter_16', {
      'verse_number': 11,
      'sanskrit':
          'चिन्तामपरिमेयां च प्रलयान्तामुपाश्रिताः | कामोपभोगपरमा एतावदिति निश्चिताः || 11 ||',
      'translation':
          'Gripped by innumerable anxieties that end only with death, they are devoted to the gratification of desires and convinced that this is the highest goal of life.',
      'word_meaning':
          'चिन्ताम्—anxieties; अपरिमेयाम्—immeasurable; च—and; प्रलयान्ताम्—ending only with death; उपाश्रिताः—taking refuge in; काम—desire; उपभोग—enjoyment; परमाḥ—supremely engrossed; एतावत्—thus; इति—so thinking; निश्चिताः—convinced.',
      'commentary':
          'Their desires and worries never end; they live and die in the endless pursuit of pleasure, thinking material enjoyment is life’s only purpose.',
    });

    await db.insert('chapter_16', {
      'verse_number': 12,
      'sanskrit':
          'आशापाशशतैर्बद्धाः कामक्रोधपरायणाः | ईहन्ते कामभोगार्थमन्यायेनार्थसञ्चयान् || 12 ||',
      'translation':
          'Bound by hundreds of desires, filled with lust and anger, they strive to accumulate wealth by unjust means for sensual pleasure.',
      'word_meaning':
          'आशा—desires; पाश—fetters; शतैः—by hundreds; बद्धाः—bound; काम—lust; क्रोध—anger; परायणाः—devoted to; ईहन्ते—they strive; कामभोगार्थम्—for sensual enjoyment; अन्यायेन—unlawfully; अर्थ—wealth; सञ्चयान्—to accumulate.',
      'commentary':
          'People enslaved by greed and anger resort to unethical practices to fulfill their material cravings, deepening their bondage.',
    });

    await db.insert('chapter_16', {
      'verse_number': 13,
      'sanskrit':
          'इदमद्य मया लब्धमिमं प्राप्स्ये मनोरथम् | इदमस्तीदमपि मे भविष्यति पुनर्धनम् || 13 ||',
      'translation':
          '“This has today been gained by me; this desire I shall obtain. This is mine already, and this wealth too shall be mine again in the future.”',
      'word_meaning':
          'इदम्—this; अद्य—today; मया—by me; लब्धम्—gained; इमम्—this; प्राप्स्ये—I shall obtain; मनोरथम्—desire; इदम्—this; अस्ति—is; इदम्—this; अपि—also; मे—mine; भविष्यति—will become; पुनः—again; धनम्—wealth.',
      'commentary':
          'They live in egoistic delusion, thinking themselves the sole doers and owners, never realizing the transient nature of wealth and desires.',
    });

    await db.insert('chapter_16', {
      'verse_number': 14,
      'sanskrit':
          'असौ मया हतः शत्रुर्हनिष्ये चापरानपि | ईश्वरोऽहमहं भोगी सिद्धोऽहं बलवान्सुखी || 14 ||',
      'translation':
          '“I have slain this enemy, and others too I shall slay! I am the lord; I am the enjoyer; I am perfect, powerful, and happy.”',
      'word_meaning':
          'असौ—that one; मया—by me; हतः—slain; शत्रुः—enemy; हनिष्ये—I shall slay; च—and; अपरान्—others; अपि—also; ईश्वरः—lord; अहम्—I am; अहम्—I; भोगी—enjoyer; सिद्धः—perfect; अहम्—I am; बलवान्—powerful; सुखी—happy.',
      'commentary':
          'Puffed up with pride, they imagine themselves the doers of all actions, blinded by power and arrogance.',
    });

    await db.insert('chapter_16', {
      'verse_number': 15,
      'sanskrit':
          'आढ्योऽभिजनवानस्मि कोऽन्योऽस्ति सदृशो मया | यक्ष्ये दास्यामि मोदिष्य इत्यज्ञानविमोहिताः || 15 ||',
      'translation':
          '“I am wealthy and high-born; who else is equal to me? I shall perform sacrifices, give charity, and enjoy!”—thus they are deluded by ignorance.',
      'word_meaning':
          'आढ्यः—wealthy; अभिजनवान्—noble; अस्मि—I am; कः—who; अन्यः—else; अस्ति—is; सदृशः—equal; मया—to me; यक्ष्ये—I will sacrifice; दास्यामि—I will give (charity); मोदिष्ये—I will enjoy; इति—thus; अज्ञान—ignorance; विमोहिताः—deluded.',
      'commentary':
          'Their ego blinds them into thinking they are superior to others. Even their acts of charity or religion are driven by pride and self-glorification.',
    });

    await db.insert('chapter_16', {
      'verse_number': 16,
      'sanskrit':
          'अनेकचित्तविभ्रान्ता मोहजालसमावृताः | प्रसक्ताः कामभोगेषु पतन्ति नरकेऽशुचौ || 16 ||',
      'translation':
          'Bewildered by numerous thoughts, caught in the web of delusion, and addicted to sensual enjoyments, they fall into a foul hell.',
      'word_meaning':
          'अनेक—many; चित्त—minds; विभ्रान्ताः—confused; मोहजाल—net of delusion; समावृताः—enveloped; प्रसक्ताः—attached; कामभोगेषु—to sensual enjoyments; पतन्ति—they fall; नरके—into hell; अशुचौ—impure.',
      'commentary':
          'Their endless desires lead to confusion and downfall. Excessive indulgence traps them in lower states of existence.',
    });

    await db.insert('chapter_16', {
      'verse_number': 17,
      'sanskrit':
          'आत्मसंभाविताः स्तब्धा धनमानमदान्विताः | यजन्ते नामयज्ञैस्ते दम्भेनाविधिपूर्वकम् || 17 ||',
      'translation':
          'Self-conceited, stubborn, filled with pride and arrogance of wealth, they perform ostentatious sacrifices not in accordance with scriptural injunctions.',
      'word_meaning':
          'आत्मसंभाविताः—self-conceited; स्तब्धाः—stubborn; धन—wealth; मान—pride; मद—arrogance; अन्विताः—endowed with; यजन्ते—they perform sacrifices; नाम—by name only; यज्ञैः—with rituals; ते—they; दम्भेन—out of hypocrisy; अविधिपूर्वकम्—without following scriptural rules.',
      'commentary':
          'Their religious acts are motivated by ego, not devotion. Such superficial rituals bring no spiritual merit.',
    });

    await db.insert('chapter_16', {
      'verse_number': 18,
      'sanskrit':
          'अहंकारं बलं दर्पं कामं क्रोधं च संश्रिताः | मामात्मपरदेहेषु प्रद्विषन्तोऽभ्यसूयकाः || 18 ||',
      'translation':
          'Possessed by ego, strength, arrogance, desire, and anger, these cruel people hate Me, who dwells in their own bodies and in others.',
      'word_meaning':
          'अहंकारम्—ego; बलम्—strength; दर्पम्—arrogance; कामम्—desire; क्रोधम्—anger; च—and; संश्रिताः—endowed with; माम्—Me; आत्म—self; पर—others; देहेषु—in bodies; प्रद्विषन्तः—hating; अभ्यसूयकाः—envious.',
      'commentary':
          'When ego dominates, they lose sight of the Divine within themselves and others, turning hateful and destructive.',
    });

    await db.insert('chapter_16', {
      'verse_number': 19,
      'sanskrit':
          'तानहं द्विषतः क्रुरान्संसारेषु नराधमान् | क्षिपाम्यजस्रमशुभानासुरीष्वेव योनिषु || 19 ||',
      'translation':
          'Those hateful, cruel, and vilest among men, I repeatedly hurl into demoniac wombs in the cycle of rebirths.',
      'word_meaning':
          'तान्—them; अहम्—I; द्विषतः—hateful; क्रुरान्—cruel; संसारेषु—in worldly existence; नराधमान्—the vilest of men; क्षिपामि—I cast; अजस्रम्—constantly; अशुभान्—inauspicious; आसुरीषु—demoniac; एव—indeed; योनिषु—in wombs.',
      'commentary':
          'As a consequence of their actions and mindset, they are born in environments that perpetuate ignorance and suffering.',
    });

    await db.insert('chapter_16', {
      'verse_number': 20,
      'sanskrit':
          'आसुरीं योनिमापन्ना मूढा जन्मनि जन्मनि | मामप्राप्यैव कौन्तेय ततो यान्त्यधमां गतिम् || 20 ||',
      'translation':
          'Entering demoniac wombs birth after birth, these deluded souls never reach Me, O son of Kunti, but sink to the lowest state of existence.',
      'word_meaning':
          'आसुरीम्—demoniac; योनिम्—womb; आपन्नाः—attaining; मूढाः—deluded; जन्मनि जन्मनि—birth after birth; माम्—Me; अप्राप्य—not attaining; एव—indeed; कौन्तेय—O son of Kunti; ततः—thereafter; यान्ति—they go; अधमाम्—lowest; गतिम्—state.',
      'commentary':
          'Their continued indulgence in demoniac tendencies keeps them bound to lower realms, far from divine realization.',
    });

    await db.insert('chapter_16', {
      'verse_number': 21,
      'sanskrit':
          'त्रिविधं नरकस्येदं द्वारं नाशनमात्मनः | कामः क्रोधस्तथा लोभस्तस्मादेतत्त्रयं त्यजेत् || 21 ||',
      'translation':
          'There are three gates leading to hell—lust, anger, and greed. They destroy the soul; therefore, one should abandon all three.',
      'word_meaning':
          'त्रिविधम्—threefold; नरकस्य—of hell; इदम्—this; द्वारम्—gate; नाशनम्—destructive; आत्मनः—of the soul; कामः—lust; क्रोधः—anger; तथा—and; लोभः—greed; तस्मात्—therefore; एतत्—these; त्रयम्—three; त्यजेत्—should abandon.',
      'commentary':
          'Shree Krishna summarizes the root of evil: desire, anger, and greed. Renouncing them leads to peace and spiritual progress.',
    });

    await db.insert('chapter_16', {
      'verse_number': 22,
      'sanskrit':
          'एतैर्विमुक्तः कौन्तेय तमोद्वारैस्त्रिभिर्नरः | आचरत्यात्मनः श्रेयस्ततो याति परां गतिम् || 22 ||',
      'translation':
          'Freed from these three gates of darkness, O son of Kunti, a person acts for self-upliftment and then attains the supreme goal.',
      'word_meaning':
          'एतैः—from these; विमुक्तः—freed; कौन्तेय—O son of Kunti; तमोद्वारैः—gates of darkness; त्रिभिः—three; नरः—person; आचरति—acts; आत्मनः—self; श्रेयः—welfare; ततः—then; याति—attains; पराम्—supreme; गतिम्—destination.',
      'commentary':
          'When lust, anger, and greed are conquered, the mind becomes pure and ready for liberation.',
    });

    await db.insert('chapter_16', {
      'verse_number': 23,
      'sanskrit':
          'यः शास्त्रविधिमुत्सृज्य वर्तते कामकारतः | न स सिद्धिमवाप्नोति न सुखं न परां गतिम् || 23 ||',
      'translation':
          'He who disregards the injunctions of the scriptures and acts according to his desires attains neither perfection, nor happiness, nor the supreme goal.',
      'word_meaning':
          'यः—who; शास्त्र—scripture; विधिम्—injunction; उत्सृज्य—disregarding; वर्तते—acts; कामकारतः—according to desire; न—not; सः—he; सिद्धिम्—perfection; अवाप्नोति—attains; न—not; सुखम्—happiness; न—not; पराम्—supreme; गतिम्—goal.',
      'commentary':
          'Disregarding divine law leads to moral and spiritual ruin. Discipline and scriptural guidance are essential for self-purification.',
    });

    await db.insert('chapter_16', {
      'verse_number': 24,
      'sanskrit':
          'तस्माच्छास्त्रं प्रमाणं ते कार्याकार्यव्यवस्थितौ | ज्ञात्वा शास्त्रविधानोक्तं कर्म कर्तुमिहार्हसि || 24 ||',
      'translation':
          'Therefore, the scriptures are your authority in determining what should and should not be done. Knowing their prescriptions, you should act accordingly in this world.',
      'word_meaning':
          'तस्मात्—therefore; शास्त्रम्—scripture; प्रमाणम्—authority; ते—for you; कार्य—duty; अकार्य—non-duty; व्यवस्थितौ—in determining; ज्ञात्वा—knowing; शास्त्र—scriptural; विधान—injunction; उक्तम्—prescribed; कर्म—action; कर्तुम्—to perform; इह—in this world; अर्हसि—you should.',
      'commentary':
          'Shree Krishna concludes by emphasizing that scriptures are the guiding light for right action, ensuring moral clarity and spiritual progress.',
    });
  }

  Future<void> insertChapter17Verses(Database db) async {
    await db.insert('chapter_17', {
  'verse_number': 1,
  'sanskrit':
      'अर्जुन उवाच | ये शास्त्रविधिमुत्सृज्य यजन्ते श्रद्धयान्विताः | तेषां निष्ठा तु का कृष्ण सत्त्वमाहो रजस्तमः || 1 ||',
  'translation':
      'Arjun said: O Krishna, what is the position of those who disregard the scriptures, yet worship with faith? Is their faith in goodness, passion, or ignorance?',
  'word_meaning':
      'अर्जुन उवाच—Arjun said; ये—those who; शास्त्रविधिम्—scriptural injunctions; उत्सृज्य—disregard; यजन्ते—worship; श्रद्धया—faith; अन्विताः—possessed of; तेषाम्—their; निष्ठा—faith; तु—but; का—what; कृष्ण—O Krishna; सत्त्वम्—goodness; आहो—or; रजः—passion; तमः—ignorance.',
  'commentary':
      'Arjun inquires whether those who worship faithfully but without scriptural guidance act in goodness, passion, or ignorance. This begins the classification of faith.'
    });

await db.insert('chapter_17', {
  'verse_number': 2,
  'sanskrit':
      'श्रीभगवानुवाच | त्रिविधा भवति श्रद्धा देहिनां सा स्वभावजा | सात्त्विकी राजसी चैव तामसी चेति तां श्रृणु || 2 ||',
  'translation':
      'The Blessed Lord said: Faith is of three kinds, born of the nature of the embodied beings — sattvic, rajasic, and tamasic. Hear about them from Me.',
  'word_meaning':
      'श्रीभगवानुवाच—The Blessed Lord said; त्रिविधा—threefold; भवति—is; श्रद्धा—faith; देहिनाम्—of the embodied beings; सा—it; स्वभावजा—born of nature; सात्त्विकी—of goodness; राजसी—of passion; तामसी—of ignorance; इति—thus; ताम्—of that; श्रृणु—hear.',
  'commentary':
      'Krishna explains that faith arises from one’s inherent nature (*svabhava*) and is classified into three types—sattvic, rajasic, and tamasic.'
});

await db.insert('chapter_17', {
  'verse_number': 3,
  'sanskrit':
      'सत्त्वानुरूपा सर्वस्य श्रद्धा भवति भारत | श्रद्धामयोऽयं पुरुषो यो यच्छ्रद्धः स एव सः || 3 ||',
  'translation':
      'The faith of every person is according to their nature, O Bhārata. One is made of faith; as one’s faith, so is one’s nature.',
  'word_meaning':
      'सत्त्व—nature; अनुरूपा—according to; सर्वस्य—of every person; श्रद्धा—faith; भवति—is; भारत—O Bhārata; श्रद्धामयः—full of faith; अयम्—this; पुरुषः—person; यः—who; यत्—what; श्रद्धः—faith; सः—he; एव—indeed; सः—so.',
  'commentary':
      'Faith reflects one’s inner nature. A person essentially becomes what they place their faith in — faith shapes identity and behavior.'
});

await db.insert('chapter_17', {
  'verse_number': 4,
  'sanskrit':
      'यजन्ते सात्त्विका देवान्यक्षरक्षांसि राजसाः | प्रेतान्भूतगणांश्चान्ये यजन्ते तामसा जनाः || 4 ||',
  'translation':
      'Those in the mode of goodness worship the gods; those in passion worship demigods and demons; and those in ignorance worship ghosts and spirits.',
  'word_meaning':
      'यजन्ते—worship; सात्त्विकाः—those in goodness; देवान्—gods; यक्षा—celestial beings; रक्षांसि—demons; राजसाः—those in passion; प्रेतान्—spirits; भूतगणान्—ghosts; च—and; अन्ये—others; यजन्ते—worship; तामसाः—those in ignorance; जनाः—people.',
  'commentary':
      'The type of deity one worships reflects one’s nature: divine beings for sattvic, powerful beings for rajasic, and dark entities for tamasic tendencies.'
});

await db.insert('chapter_17', {
  'verse_number': 5,
  'sanskrit':
      'अशास्त्रविहितं घोरं तप्यन्ते ये तपो जनाः | दम्भाहंकारसंयुक्ताः कामरागबलान्विताः || 5 ||',
  'translation':
      'Those who perform severe austerities not enjoined by the scriptures, impelled by hypocrisy and ego, and driven by desire and attachment, are of ignorance.',
  'word_meaning':
      'अशास्त्रविहितम्—not prescribed by scripture; घोरम्—terrible; तप्यन्ते—perform austerities; ये—those; तपः—austerity; जनाः—people; दम्भ—hypocrisy; अहंकार—ego; संयुक्ताः—united with; काम—desire; राग—attachment; बल—force; अन्विताः—driven by.',
  'commentary':
      'Such false asceticism, born of pride and desire, leads not to enlightenment but to harm, reflecting tamasic delusion.'
});

await db.insert('chapter_17', {
  'verse_number': 6,
  'sanskrit':
      'कर्शयन्तः शरीरस्थं भूतग्राममचेतसः | मां चैवान्तःशरीरस्थं तान्विद्ध्यासुरनिश्चयान् || 6 ||',
  'translation':
      'Those senseless persons who torture the elements in their body, and Me dwelling within, know them to be demoniacal in disposition.',
  'word_meaning':
      'कर्शयन्तः—torturing; शरीरस्थम्—situated in the body; भूतग्रामम्—the group of elements; अचेतसः—senseless; माम्—Me; च—also; एव—indeed; अन्तःशरीरस्थम्—situated within the body; तान्—them; विद्धि—know; असुरनिश्चयान्—of demoniacal resolve.',
  'commentary':
      'Those who harm their own body or life force in the name of austerity offend the Divine within; such behavior is demonic, not spiritual.'
});

await db.insert('chapter_17', {
  'verse_number': 7,
  'sanskrit':
      'आहारस्त्वपि सर्वस्य त्रिविधो भवति प्रियः | यज्ञस्तपस्तथा दानं तेषां भेदमिमं श्रृणु || 7 ||',
  'translation':
      'Even food, sacrifice, austerity, and charity are of three kinds according to the modes of nature. Hear their distinctions from Me.',
  'word_meaning':
      'आहारः—food; तु—indeed; अपि—even; सर्वस्य—of everyone; त्रिविधः—three kinds; भवति—is; प्रियः—dear; यज्ञः—sacrifice; तपः—austerity; तथा—also; दानम्—charity; तेषाम्—their; भेदम्—differences; इमम्—this; श्रृणु—hear.',
  'commentary':
      'Krishna begins classifying human actions like eating, worship, and charity according to the three gunas — goodness, passion, and ignorance.'
});

await db.insert('chapter_17', {
  'verse_number': 8,
  'sanskrit':
      'आयुःसत्त्वबलारोग्यसुखप्रीतिविवर्धनाः | रस्याः स्निग्धाः स्थिरा हृद्या आहाराः सात्त्विकप्रियाः || 8 ||',
  'translation':
      'Foods that increase life, purity, strength, health, happiness, and satisfaction — that are juicy, nourishing, and pleasant — are dear to the sattvic.',
  'word_meaning':
      'आयुः—life; सत्त्व—purity; बल—strength; आरोग्य—health; सुख—happiness; प्रीति—contentment; विवर्धनाः—increasing; रस्याः—juicy; स्निग्धाः—unctuous; स्थिराः—steady; हृद्या—pleasing to the heart; आहाराः—foods; सात्त्विकप्रियाः—dear to those in goodness.',
  'commentary':
      'Sattvic foods nurture clarity and longevity. They include fresh, wholesome, and mild-tasting foods that bring inner peace.'
});

await db.insert('chapter_17', {
  'verse_number': 9,
  'sanskrit':
      'कट्वम्ललवणात्युष्णतीक्ष्णरूक्षविदाहिनः | आहारा राजसस्येष्टा दुःखशोकामयप्रदाः || 9 ||',
  'translation':
      'Foods that are bitter, sour, salty, excessively hot, pungent, dry, and burning are dear to the passionate, but cause pain, sorrow, and disease.',
  'word_meaning':
      'कटु—bitter; अम्ल—sour; लवण—salty; अत्युष्ण—very hot; तीक्ष्ण—pungent; रूक्ष—dry; विदाहिनः—burning; आहाराः—foods; राजसस्य—of those in passion; इष्टाः—dear; दुःख—pain; शोक—sorrow; आमय—disease; प्रदाः—producing.',
  'commentary':
      'Rajasic foods excite the senses but disturb mental balance, often leading to restlessness and ailments.'
});

await db.insert('chapter_17', {
  'verse_number': 10,
  'sanskrit':
      'यातयामं गतरसं पूति पर्युषितं च यत् | उच्छिष्टमपि चामेध्यं भोजनं तामसप्रियम् || 10 ||',
  'translation':
      'Food that is stale, tasteless, putrid, decomposed, impure, or leftovers is dear to those in ignorance.',
  'word_meaning':
      'यातयामम्—stale; गतरसम्—tasteless; पूति—foul-smelling; पर्युषितम्—decomposed; च—and; यत्—which; उच्छिष्टम्—remnants; अपि—even; च—and; अमेध्यम्—impure; भोजनम्—food; तामसप्रियम्—dear to the tamasic.',
  'commentary':
      'Tamasic foods diminish vitality and clarity, symbolizing laziness, ignorance, and spiritual darkness.'
});

await db.insert('chapter_17', {
  'verse_number': 11,
  'sanskrit':
      'अफलाकाङ्क्षिभिर्यज्ञो विधिदृष्टो य इज्यते | यष्टव्यमेवेति मनः समाधाय स सात्त्विकः || 11 ||',
  'translation':
      'Sacrifice that is performed according to scriptural injunctions, without desire for reward, and with a firm mind — that is sattvic.',
  'word_meaning':
      'अफलाकाङ्क्षिभिः—without desire for fruit; यज्ञः—sacrifice; विधिदृष्टः—according to ordinance; यः—which; इज्यते—is performed; यष्टव्यम्—ought to be performed; एव—indeed; इति—thus; मनः—mind; समाधाय—with concentration; सः—that; सात्त्विकः—is of goodness.',
  'commentary':
      'A sattvic sacrifice is selfless and scripturally guided, performed with devotion rather than personal gain.'
});

await db.insert('chapter_17', {
  'verse_number': 12,
  'sanskrit':
      'अभिसंधाय तु फलं दम्भार्थमपि चैव यत् | इज्यते भरतश्रेष्ठ तं यज्ञं विद्धि राजसम् || 12 ||',
  'translation':
      'But sacrifice performed for the sake of reward or ostentation — know that sacrifice, O best of the Bharatas, to be rajasic.',
  'word_meaning':
      'अभिसंधाय—with desire for; तु—but; फलं—fruit; दम्भार्थम्—for show; अपि—also; च—and; एव—indeed; यत्—which; इज्यते—is performed; भरतश्रेष्ठ—O best of the Bharatas; तम्—that; यज्ञम्—sacrifice; विद्धि—know; राजसम्—of passion.',
  'commentary':
      'Rajasic sacrifices are motivated by ego or personal reward, not by devotion or purity of heart.'
});

await db.insert('chapter_17', {
  'verse_number': 13,
  'sanskrit':
      'विधिहीनमसृष्टान्नं मन्त्रहीनमदक्षिणम् | श्रद्धाविरहितं यज्ञं तामसं परिचक्षते || 13 ||',
  'translation':
      'Sacrifice that is not in accordance with scriptural rules, where no food is distributed, no mantras are chanted, no gifts given, and no faith exists — that is said to be tamasic.',
  'word_meaning':
      'विधिहीनम्—without rule; असृष्टान्नम्—without food distribution; मन्त्रहीनम्—without mantras; अदक्षिणम्—without gift; श्रद्धाविरहितम्—without faith; यज्ञम्—sacrifice; तामसम्—of ignorance; परिचक्षते—is said to be.',
  'commentary':
      'Tamasic sacrifice lacks understanding, reverence, and compassion — performed mechanically or superstitiously.'
});

await db.insert('chapter_17', {
  'verse_number': 14,
  'sanskrit':
      'देवद्विजगुरुप्राज्ञपूजनं शौचमार्जवम् | ब्रह्मचर्यमहिंसा च शारीरं तप उच्यते || 14 ||',
  'translation':
      'Worship of the gods, the twice-born, teachers, and the wise; purity, straightforwardness, celibacy, and non-violence — these are said to be austerities of the body.',
  'word_meaning':
      'देव—of the gods; द्विज—of the twice-born; गुरु—of teachers; प्राज्ञ—of the wise; पूजनम्—worship; शौचम्—purity; आर्जवम्—straightforwardness; ब्रह्मचर्यम्—celibacy; अहिंसा—non-violence; च—and; शारीरम्—of the body; तपः—austerity; उच्यते—is said to be.',
  'commentary':
      'Austerity of the body includes respect for elders and discipline in personal conduct — it strengthens moral and spiritual integrity.'
});

await db.insert('chapter_17', {
  'verse_number': 15,
  'sanskrit':
      'अनुद्वेगकरं वाक्यं सत्यं प्रियहितं च यत् | स्वाध्यायाभ्यसनं चैव वाङ्मयं तप उच्यते || 15 ||',
  'translation':
      'Speech that does not cause distress, that is truthful, pleasing, and beneficial, along with regular study of the scriptures — this is called austerity of speech.',
  'word_meaning':
      'अनुद्वेगकरम्—not causing distress; वाक्यम्—speech; सत्यम्—truthful; प्रियहितम्—pleasing and beneficial; च—and; यत्—which; स्वाध्यायाभ्यसनम्—study and recitation of scriptures; च—and; एव—indeed; वाङ्मयम्—of speech; तपः—austerity; उच्यते—is called.',
  'commentary':
      'Austerity of speech involves truth, kindness, and scriptural study — words must heal and uplift, not harm or mislead.'
});

await db.insert('chapter_17', {
  'verse_number': 16,
  'sanskrit':
      'मनःप्रसादः सौम्यत्वं मौनमात्मविनिग्रहः | भावसंशुद्धिरित्येतत्तपो मानसमुच्यते || 16 ||',
  'translation':
      'Serenity of mind, gentleness, silence, self-control, and purity of heart — these are called austerities of the mind.',
  'word_meaning':
      'मनःप्रसादः—serenity of mind; सौम्यत्वम्—gentleness; मौनम्—silence; आत्मविनिग्रहः—self-control; भावसंशुद्धिः—purity of heart; इति—thus; एतत्—this; तपः—austerity; मानसम्—of the mind; उच्यते—is said to be.',
  'commentary':
      'Mental austerity involves maintaining inner calm, clarity, and compassion. True discipline begins with mastery over thoughts and emotions.'
});

await db.insert('chapter_17', {
  'verse_number': 17,
  'sanskrit':
      'श्रद्धया परया तप्तं तपस्तत्त्रिविधं नरैः | अफलाकाङ्क्षिभिर्युक्तैः सात्त्विकं परिचक्षते || 17 ||',
  'translation':
      'When these threefold austerities are practiced with supreme faith by those who expect no reward, they are said to be sattvic.',
  'word_meaning':
      'श्रद्धया—with faith; परया—supreme; तप्तम्—performed; तपः—austerity; तत्—that; त्रिविधम्—threefold; नरैः—by men; अफलाकाङ्क्षिभिः—expecting no reward; युक्तैः—with discipline; सात्त्विकम्—of goodness; परिचक्षते—is said to be.',
  'commentary':
      'Austerity done with devotion and no selfish motive is pure (sattvic) and leads to inner harmony and wisdom.'
});

await db.insert('chapter_17', {
  'verse_number': 18,
  'sanskrit':
      'सत्कारमानपूजार्थं तपो दम्भेन चैव यत् | क्रियते तदिह प्रोक्तं राजसं चलमध्रुवम् || 18 ||',
  'translation':
      'Austerity performed for respect, honor, or worship, and motivated by hypocrisy, is said to be rajasic, unstable, and impermanent.',
  'word_meaning':
      'सत्कार—respect; मान—honor; पूजा—worship; अर्थम्—for the sake of; तपः—austerity; दम्भेन—by hypocrisy; च—and; एव—indeed; यत्—which; क्रियते—is practiced; तत्—that; इह—here; प्रोक्तम्—is said to be; राजसम्—of passion; चलम्—unstable; अध्रुवम्—impermanent.',
  'commentary':
      'Rajasic austerity is ego-driven — done for recognition or show, it lacks sincerity and fades quickly.'
});

await db.insert('chapter_17', {
  'verse_number': 19,
  'sanskrit':
      'मूढग्रहेणात्मनो यत्पीडया क्रियते तपः | परस्योत्सादनार्थं वा तत् तामसमुदाहृतम् || 19 ||',
  'translation':
      'Austerity performed out of foolish obstinacy, with self-torture or to harm others, is said to be tamasic.',
  'word_meaning':
      'मूढग्रहेण—out of deluded resolve; आत्मनः—of oneself; यत्—which; पीडया—with torture; क्रियते—is performed; तपः—austerity; परस्य—of another; उत्सादनार्थम्—for harming; वा—or; तत्—that; तामसम्—of ignorance; उदाहृतम्—is declared.',
  'commentary':
      'Tamasic austerity arises from ignorance or cruelty — harming oneself or others under the guise of discipline.'
});

await db.insert('chapter_17', {
  'verse_number': 20,
  'sanskrit':
      'दातव्यमिति यद्दानं दीयतेऽनुपकारिणे | देशे काले च पात्रे च तद्दानं सात्त्विकं स्मृतम् || 20 ||',
  'translation':
      'Charity given with a sense of duty, at the proper place and time, and to a worthy person, without expectation of return, is considered sattvic.',
  'word_meaning':
      'दातव्यम्—it ought to be given; इति—thus; यत्—which; दानम्—charity; दीयते—is given; अनुपकारिणे—to one who cannot return the favor; देशे—place; काले—time; च—and; पात्रे—to a deserving person; च—and; तत्—that; दानम्—charity; सात्त्विकम्—of goodness; स्मृतम्—is remembered.',
  'commentary':
      'Sattvic charity is selfless, pure, and mindful — given out of compassion, not for recognition or gain.'
});

await db.insert('chapter_17', {
  'verse_number': 21,
  'sanskrit':
      'यत्तु प्रत्युपकारार्थं फलमुद्दिश्य वा पुनः | दीयते च परिक्लिष्टं तद्दानं राजसं स्मृतम् || 21 ||',
  'translation':
      'But charity given expecting something in return, or for some fruit or result, and given reluctantly, is considered rajasic.',
  'word_meaning':
      'यत्—which; तु—but; प्रत्युपकारार्थम्—for return of favor; फलम्—reward; उद्दिश्य—seeking; वा—or; पुनः—again; दीयते—is given; च—and; परिक्लिष्टम्—with reluctance; तत्—that; दानम्—charity; राजसम्—of passion; स्मृतम्—is considered.',
  'commentary':
      'Rajasic charity is transactional — it is done with expectation or hesitation, lacking true generosity of spirit.'
});

await db.insert('chapter_17', {
  'verse_number': 22,
  'sanskrit':
      'अदेशकाले यद्दानमपात्रेभ्यश्च दीयते | असत्कृतमवज्ञातं तत्तामसमुदाहृतम् || 22 ||',
  'translation':
      'Charity given at the wrong place or time, to unworthy persons, or without respect or sincerity, is said to be tamasic.',
  'word_meaning':
      'अदेशकाले—at an improper place or time; यत्—which; दानम्—charity; अपात्रेभ्यः—to unworthy persons; च—and; दीयते—is given; असत्कृतम्—without respect; अवज्ञातम्—with disdain; तत्—that; तामसम्—of ignorance; उदाहृतम्—is declared.',
  'commentary':
      'Tamasic charity is thoughtless and disrespectful — given carelessly or to unworthy recipients, it brings no spiritual merit.'
});

await db.insert('chapter_17', {
  'verse_number': 23,
  'sanskrit':
      'ॐ तत् सत् इति निर्देशो ब्रह्मणस्त्रिविधः स्मृतः | ब्राह्मणास्तेन वेदाश्च यज्ञाश्च विहिताः पुरा || 23 ||',
  'translation':
      '“Om Tat Sat” — this has been declared as the triple designation of Brahman. The Brahmins, the Vedas, and sacrifices were created of that in ancient times.',
  'word_meaning':
      'ॐ तत् सत्—Om, Tat, Sat; इति—thus; निर्देशः—designation; ब्रह्मणः—of Brahman; त्रिविधः—threefold; स्मृतः—is remembered; ब्राह्मणाः—the Brahmins; तेन—by that; वेदाः—the Vedas; च—and; यज्ञाः—sacrifices; च—and; विहिताः—ordained; पुरा—in the beginning.',
  'commentary':
      'These sacred words — Om, Tat, and Sat — symbolize the Absolute Truth and are used to sanctify all spiritual acts like sacrifice, study, and charity.'
});

await db.insert('chapter_17', {
  'verse_number': 24,
  'sanskrit':
      'तस्मादोमित्युदाहृत्य यज्ञदानतपःक्रियाः | प्रवर्तन्ते विधानोक्ताः सततं ब्रह्मवादिनाम् || 24 ||',
  'translation':
      'Therefore, acts of sacrifice, charity, and austerity as enjoined by the scriptures are always begun by the devotees of Brahman with the utterance of “Om.”',
  'word_meaning':
      'तस्मात्—therefore; ओम् इति—uttering Om; उदाहृत्य—after uttering; यज्ञ—sacrifice; दान—charity; तपः—penance; क्रियाः—acts; प्रवर्तन्ते—begin; विधानोक्ताः—as prescribed by the scriptures; सततम्—always; ब्रह्मवादिनाम्—by the knowers of Brahman.',
  'commentary':
      'The utterance of “Om” sanctifies all spiritual practices, aligning them with divine consciousness.'
});

await db.insert('chapter_17', {
  'verse_number': 25,
  'sanskrit':
      'तदित्यनभिसंधाय फलं यज्ञतपःक्रियाः | दानक्रियाश्च विविधाः क्रियन्ते मोक्षकाङ्क्षिभिः || 25 ||',
  'translation':
      'Uttering “Tat,” the seekers of liberation perform various acts of sacrifice, austerity, and charity without desire for results.',
  'word_meaning':
      'तत् इति—uttering Tat; अनभिसंधाय—without attachment; फलं—fruit; यज्ञ—sacrifice; तपः—austerity; क्रियाः—acts; दानक्रियाः—acts of charity; च—and; विविधाः—various; क्रियन्ते—are performed; मोक्षकाङ्क्षिभिः—by those seeking liberation.',
  'commentary':
      '“Tat” signifies dedication to the Supreme — acts done with this spirit are free from ego and desire.'
});

await db.insert('chapter_17', {
  'verse_number': 26,
  'sanskrit':
      'सद्भावे साधुभावे च सदित्येतत्प्रयुज्यते | प्रशस्ते कर्मणि तथा सच्छब्दः पार्थ युज्यते || 26 ||',
  'translation':
      'The word “Sat” is used to denote existence and goodness; O Parth, it is also used to describe praiseworthy actions.',
  'word_meaning':
      'सद्भावे—in the sense of reality; साधुभावे—in the sense of goodness; च—and; सत् इति—Sat thus; एतत्—this; प्रयुज्यते—is used; प्रशस्ते—in auspicious; कर्मणि—action; तथा—also; सत् शब्दः—the word Sat; पार्थ—O Parth; युज्यते—is applied.',
  'commentary':
      '“Sat” means truth, goodness, and auspiciousness — it sanctifies righteous actions and existence itself.'
});

await db.insert('chapter_17', {
  'verse_number': 27,
  'sanskrit':
      'यज्ञे तपसि दाने च स्थितिः सत् इति चोच्यते | कर्म चैव तदर्थीयं सदित्येवाभिधीयते || 27 ||',
  'translation':
      'Steadfastness in sacrifice, austerity, and charity is also called “Sat”; and action performed for the sake of the Supreme is likewise designated as “Sat.”',
  'word_meaning':
      'यज्ञे—in sacrifice; तपसि—in austerity; दाने—in charity; च—and; स्थितिः—steadfastness; सत् इति—is called Sat; च—and; उच्यते—is said; कर्म—action; च—and; एव—also; तत् अर्थीयम्—done for that purpose (of God); सत् इति एव—is verily called Sat; अभिधीयते—is designated.',
  'commentary':
      'When actions like charity or penance are performed with devotion and dedication to truth, they are imbued with the essence of “Sat.”'
});

await db.insert('chapter_17', {
  'verse_number': 28,
  'sanskrit':
      'अश्रद्धया हुतं दत्तं तपस्तप्तं कृतं च यत् | असदित्युच्यते पार्थ न च तत्प्रेत्य नो इह || 28 ||',
  'translation':
      'Whatever is offered, given, or performed without faith is called “Asat,” O Parth — it is fruitless both now and hereafter.',
  'word_meaning':
      'अश्रद्धया—without faith; हुतम्—offered; दत्तम्—given; तपः—penance; तप्तम्—performed; कृतम्—done; च—and; यत्—which; असत् इति—is called Asat; उच्यते—is said; पार्थ—O Parth; न च—not; तत्—that; प्रेत्य—after death; न—not; इह—here (in this world).',
  'commentary':
      'Faith is the foundation of all spiritual action. Deeds done without faith are hollow — they yield no result, either here or beyond.'
});

  }
  
  Future<void> insertChapter18Verses(Database db) async {
await db.insert('chapter_18', {
  'verse_number': 1,
  'sanskrit':
      'अर्जुन उवाच | संन्यासस्य महाबाहो तत्त्वमिच्छामि वेदितुम् | त्यागस्य च हृषीकेश पृथक्केशिनिषूदन || 1 ||',
  'translation':
      'Arjun said: O mighty-armed Krishna, I wish to understand the true nature of renunciation (sannyās) and also of relinquishment (tyāg), and the distinction between them, O Hrishikesha, O Keshinisudana.',
  'word_meaning':
      'अर्जुन उवाच—Arjun said; संन्यासस्य—of renunciation; महा-बाहो—mighty-armed one; तत्त्वम्—the truth; इच्छामि—I wish; वेदितुम्—to know; त्यागस्य—of relinquishment; च—and; हृषीकेश—Krishna, master of the senses; पृथक्—difference; केशि-निषूदन—slayer of the demon Keshi.',
  'commentary':
      'Arjun begins the final chapter seeking clarification about the terms *sannyās* and *tyāg*. He wants to know if they are the same or different, as they seem to both involve giving up worldly actions.'
});

await db.insert('chapter_18', {
  'verse_number': 2,
  'sanskrit':
      'श्रीभगवानुवाच | काम्यानां कर्मणां न्यासं संन्यासं कवयो विदुः | सर्वकर्मफलत्यागं प्राहुस्त्यागं विचक्षणाः || 2 ||',
  'translation':
      'The Supreme Lord said: The wise understand *sannyās* as the renunciation of actions motivated by desire, while the learned declare *tyāg* as the renunciation of the fruits of all actions.',
  'word_meaning':
      'श्रीभगवान् उवाच—The Blessed Lord said; काम्यानाम्—motivated by desire; कर्मणाम्—of actions; न्यासम्—renunciation; संन्यासम्—renunciation; कवयः—the wise; विदुः—understand; सर्व—of all; कर्म—actions; फल—fruits; त्यागम्—relinquishment; प्राहुः—declare; त्यागम्—renunciation; विचक्षणाः—the learned.',
  'commentary':
      'Krishna distinguishes between *sannyās* (giving up desire-driven actions) and *tyāg* (giving up the fruits of all actions). Both are spiritual paths, but *tyāg* is considered more balanced for those in action.'
});

await db.insert('chapter_18', {
  'verse_number': 3,
  'sanskrit':
      'त्याज्यं दोषवदित्येके कर्म प्राहुर्मनीषिणः | यज्ञदानतपःकर्म न त्याज्यमिति चापरे || 3 ||',
  'translation':
      'Some philosophers declare that all kinds of actions should be given up as they are full of fault, while others declare that acts of sacrifice, charity, and penance should never be abandoned.',
  'word_meaning':
      'त्याज्यम्—should be given up; दोषवत्—full of fault; इति—thus; एके—some; कर्म—action; प्राहुः—say; मनीषिणः—the wise; यज्ञ—sacrifice; दान—charity; तपः—penance; कर्म—actions; न—not; त्याज्यम्—should be given up; इति—thus; च—and; अपरे—others.',
  'commentary':
      'There is a difference of opinion among spiritual thinkers—some advocate complete renunciation of all actions, while others recommend continuing noble acts like sacrifice, charity, and penance.'
});

await db.insert('chapter_18', {
  'verse_number': 4,
  'sanskrit':
      'निश्चयं श्रृणु मे तत्र त्यागे भरतसत्तम | त्यागो हि पुरुषव्याघ्र त्रिविधः संप्रकीर्तितः || 4 ||',
  'translation':
      'Hear from Me, O best of the Bharatas, My conclusion about renunciation. Renunciation has been declared to be of three kinds, O tiger among men.',
  'word_meaning':
      'निश्चयम्—definite conclusion; श्रृणु—hear; मे—from Me; तत्र—therein; त्यागे—about renunciation; भरत-सत्तम—best of the Bharatas (Arjun); त्यागः—renunciation; हि—indeed; पुरुष-व्याघ्र—tiger among men; त्रि-विदः—of three kinds; संप्रकीर्तितः—is declared.',
  'commentary':
      'Krishna promises to remove the confusion by clearly classifying renunciation into three types based on the modes (*gunas*).'
});

await db.insert('chapter_18', {
  'verse_number': 5,
  'sanskrit':
      'यज्ञदानतपःकर्म न त्याज्यं कार्यमेव तत् | यज्ञो दानं तपश्चैव पावनानि मनीषिणाम् || 5 ||',
  'translation':
      'Acts of sacrifice, charity, and penance should never be abandoned; they must be performed, for they purify even the wise.',
  'word_meaning':
      'यज्ञ—sacrifice; दान—charity; तपः—penance; कर्म—actions; न—not; त्याज्यम्—should be abandoned; कार्यम्—must be done; एव—indeed; तत्—that; यज्ञः—sacrifice; दानम्—charity; तपः—penance; च—and; एव—certainly; पावनानि—purifying; मनीषिणाम्—of the wise.',
  'commentary':
      'Spiritual duties like sacrifice, charity, and penance elevate the soul by purifying the heart from selfishness and attachment.'
});

await db.insert('chapter_18', {
  'verse_number': 6,
  'sanskrit':
      'एतान्यपि तु कर्माणि सङ्गं त्यक्त्वा फलानि च | कर्तव्यानीति मे पार्थ निश्चितं मतमुत्तमम् || 6 ||',
  'translation':
      'Even these actions should be performed without attachment and expectation of reward, O Parth; this is My firm and best opinion.',
  'word_meaning':
      'एतानि—these; अपि—even; तु—but; कर्माणि—actions; सङ्गम्—attachment; त्यक्त्वा—renouncing; फलानि—fruits; च—and; कर्तव्यानि—should be done; इति—thus; मे—My; पार्थ—Arjun; निश्चितम्—certain; मतम्—opinion; उत्तमम्—supreme.',
  'commentary':
      'Krishna clarifies that true renunciation is not giving up action, but detaching from results and ego while performing one’s duty.'
});

await db.insert('chapter_18', {
  'verse_number': 7,
  'sanskrit':
      'नियतस्य तु संन्यासः कर्मणो नोपपद्यते | मोहात्तस्य परित्यागस्तामसः परिकीर्तितः || 7 ||',
  'translation':
      'Renunciation of obligatory duties is not proper. Abandonment of such duties out of delusion is declared to be in the mode of ignorance.',
  'word_meaning':
      'नियतस्य—of prescribed; तु—but; संन्यासः—renunciation; कर्मणः—of duty; न—not; उपपद्यते—is proper; मोहात्—out of delusion; तस्य—his; परित्यागः—abandonment; तामसः—in the mode of ignorance; परिकीर्तितः—is declared.',
  'commentary':
      'If a person gives up their duties out of ignorance or confusion, it leads to spiritual degradation rather than liberation.'
});

await db.insert('chapter_18', {
  'verse_number': 8,
  'sanskrit':
      'दुःखमित्येव यत्कर्म कायक्लेशभयात्त्यजेत् | स कृत्वा राजसं त्यागं नैव त्यागफलं लभेत् || 8 ||',
  'translation':
      'When one renounces duty merely because it is troublesome or causes bodily discomfort, such renunciation is said to be in the mode of passion. Such a renouncer does not gain the fruits of true renunciation.',
  'word_meaning':
      'दुःखम्—painful; इति—thus; एव—indeed; यत्—which; कर्म—action; कायक्लेश—bodily suffering; भयात्—out of fear; त्यजेत्—gives up; सः—that person; कृत्वा—having done; राजसम्—mode of passion; त्यागम्—renunciation; न—not; एव—indeed; त्याग-फलं—fruit of renunciation; लभेत्—obtains.',
  'commentary':
      'Renouncing action due to laziness or discomfort is *rājasic tyāg*—it arises from attachment to comfort rather than from wisdom.'
});

await db.insert('chapter_18', {
  'verse_number': 9,
  'sanskrit':
      'कार्यमित्येव यत्कर्म नियतं क्रियते अर्जुन | सङ्गं त्यक्त्वा फलं चैव स त्यागः सात्त्विको मतः || 9 ||',
  'translation':
      'When prescribed duty is performed only because it ought to be done, without attachment or desire for results, such renunciation is considered to be in the mode of goodness.',
  'word_meaning':
      'कार्यं—ought to be done; इति—thus; एव—certainly; यत्—which; कर्म—action; नियतम्—prescribed; क्रियते—is performed; अर्जुन—O Arjun; सङ्गम्—attachment; त्यक्त्वा—renouncing; फलम्—fruits; च—and; एव—indeed; सः—that; त्यागः—renunciation; सात्त्विकः—in goodness; मतः—is considered.',
  'commentary':
      '*Sāttvik tyāg* is ideal renunciation—acting dutifully without attachment, ego, or expectation of results.'
});

await db.insert('chapter_18', {
  'verse_number': 10,
  'sanskrit':
      'न द्वेष्ट्यकुशलं कर्म कुशले नानुषज्जते | त्यागी सत्त्वसमाविष्टो मेधावी छिन्नसंशयः || 10 ||',
  'translation':
      'The one who neither hates unpleasant work nor is attached to pleasant work is a true renunciate, full of goodness and wisdom, and free from all doubts.',
  'word_meaning':
      'न—does not; द्वेष्टि—hate; अकुशलम्—unpleasant; कर्म—work; कुशले—pleasant; न—not; अनुषज्जते—is attached; त्यागी—renunciate; सत्त्व—goodness; समाविष्टः—endowed with; मेधावी—wise; छिन्न—cut off; संशयः—doubts.',
  'commentary':
      'A wise renouncer performs every duty with equanimity. He neither clings to pleasurable tasks nor avoids difficult ones, showing purity of mind and detachment.'
});

await db.insert('chapter_18', {
  'verse_number': 11,
  'sanskrit':
      'न हि देहभृता शक्यं त्यक्तुं कर्माण्यशेषतः | यस्तु कर्मफलत्यागी स त्यागीत्यभिधीयते || 11 ||',
  'translation':
      'It is indeed not possible for one who possesses a body to completely renounce all actions. But the one who renounces the fruits of actions is said to have truly renounced.',
  'word_meaning':
      'न—not; हि—indeed; देह-भृता—embodied being; शक्यम्—is possible; त्यक्तुम्—to renounce; कर्माणि—actions; अशेषतः—entirely; यः—who; तु—but; कर्म-फल-त्यागी—renounces fruits of actions; सः—he; त्यागी—renunciate; इति—thus; अभिधीयते—is called.',
  'commentary':
      'As long as one lives in the body, action is inevitable. True renunciation is therefore giving up attachment to results, not abstaining from action.'
});

await db.insert('chapter_18', {
  'verse_number': 12,
  'sanskrit':
      'अनिष्टमिष्टं मिश्रं च त्रिविधं कर्मणः फलम् | भवत्यत्यागिनां प्रेत्य न तु संन्यासिनां क्वचित् || 12 ||',
  'translation':
      'The threefold results of actions—desirable, undesirable, and mixed—accrue after death to those who have not renounced, but never to those who are renounced.',
  'word_meaning':
      'अनिष्टम्—undesirable; इष्टम्—desirable; मिश्रम्—mixed; च—and; त्रि-विदम्—threefold; कर्मणः—of actions; फलम्—result; भवति—accrues; अ-त्यागिनाम्—to those who do not renounce; प्रेत्य—after death; न—not; तु—but; संन्यासिनाम्—to the renounced; क्वचित्—at any time.',
  'commentary':
      'Those attached to results are bound by karma, while true renunciates escape karmic bondage by surrendering outcomes to God.'
});

await db.insert('chapter_18', {
  'verse_number': 13,
  'sanskrit':
      'पञ्चैतानि महाबाहो कारणानि निबोध मे | सांख्ये कृतान्ते प्रोक्तानि सिद्धये सर्वकर्मणाम् || 13 ||',
  'translation':
      'Learn from Me, O mighty-armed Arjun, the five factors that have been declared in the Sāṅkhya philosophy as essential for the accomplishment of all actions.',
  'word_meaning':
      'पञ्च—five; एतानि—these; महा-बाहो—O mighty-armed one; कारणानि—causes; निबोध—learn; मे—from Me; सांख्ये—in the Sāṅkhya philosophy; कृतान्ते—ultimate conclusion; प्रोक्तानि—declared; सिद्धये—for accomplishment; सर्व-कर्मणाम्—of all actions.',
  'commentary':
      'Krishna introduces the five causes of any action’s completion, according to philosophy: the doer, instruments, efforts, circumstances, and the divine will.'
});

await db.insert('chapter_18', {
  'verse_number': 14,
  'sanskrit':
      'अधिष्ठानं तथा कर्ता करणं च पृथग्विधम् | विविधाश्च पृथक्चेष्टा दैवं चैवात्र पञ्चमम् || 14 ||',
  'translation':
      'The body, the doer, the various instruments, the distinct efforts, and the divine will—these are the five factors of action.',
  'word_meaning':
      'अधिष्ठानम्—the body; तथा—also; कर्ता—the doer; करणम्—instruments; च—and; पृथक्-विदम्—of various kinds; विविधाः—various; च—and; पृथक्—distinct; चेष्टाः—efforts; दैवम्—divine will; च—and; एव—indeed; अत्र—here; पञ्चमम्—the fifth.',
  'commentary':
      'No action is performed independently. The body and mind are tools, the soul is the doer, effort is the process, and divine grace ensures completion.'
});

await db.insert('chapter_18', {
  'verse_number': 15,
  'sanskrit':
      'शरीरवाङ्मनोभिर्यत्कर्म प्रारभते नरः | न्याय्यं वा विपरीतं वा पञ्चैते तस्य हेतवः || 15 ||',
  'translation':
      'Whatever action a person performs with body, speech, and mind—whether right or wrong—these five are its causes.',
  'word_meaning':
      'शरीर—body; वाक्—speech; मनोभिः—mind; यत्—which; कर्म—action; प्रारभते—performs; नरः—a person; न्याय्यम्—right; वा—or; विपरीतम्—wrong; वा—or; पञ्च—five; एते—these; तस्य—its; हेतवः—causes.',
  'commentary':
      'Human action arises from multiple sources—body, mind, and speech—guided by the five factors. Thus, no one can claim absolute doership.'
});

await db.insert('chapter_18', {
  'verse_number': 16,
  'sanskrit':
      'तत्रैवं सति कर्तारमात्मानं केवलं तु यः | पश्यत्यकृतबुद्धित्वान्न स पश्यति दुर्मतिः || 16 ||',
  'translation':
      'Therefore, the person whose mind is impure and who sees the self alone as the doer does not see truly; his understanding is deluded.',
  'word_meaning':
      'तत्र—there; एवम्—thus; सति—being so; कर्तारम्—the doer; आत्मानम्—the self; केवलम्—alone; तु—but; यः—who; पश्यति—sees; अ-कृत-बुद्धित्वात्—due to impure intellect; न—not; सः—he; पश्यति—sees; दुर्मतिः—of poor understanding.',
  'commentary':
      'Egoistic identification with being the sole doer is ignorance. The wise see actions as performed by the interplay of body, mind, and divine forces.'
});

await db.insert('chapter_18', {
  'verse_number': 17,
  'sanskrit':
      'यस्य नाहंकृतो भावो बुद्धिर्यस्य न लिप्यते | हत्वाऽपि स इमाँल्लोकान्न हन्ति न निबध्यते || 17 ||',
  'translation':
      'The one who is free from ego and whose intellect is untainted, even if he kills these people, does not kill and is not bound by the act.',
  'word_meaning':
      'यस्य—whose; न—not; अहं-कृतः—egoistic; भावः—disposition; बुद्धिः—intellect; यस्य—whose; न—not; लिप्यते—is tainted; हत्वा अपि—even having killed; सः—he; इमान्—these; लोकान्—people; न—not; हन्ति—kills; न—not; निबध्यते—is bound.',
  'commentary':
      'Krishna reiterates that a selfless person, acting without ego or attachment, remains untouched by karma even in seemingly violent actions.'
});

await db.insert('chapter_18', {
  'verse_number': 18,
  'sanskrit':
      'ज्ञानं ज्ञेयं परिज्ञाता त्रिविधा कर्मचोदना | करणं कर्म कर्तेति त्रिविधः कर्मसंग्रहः || 18 ||',
  'translation':
      'Knowledge, the object of knowledge, and the knower—these are the three motivating factors of action. The instrument, the action, and the doer—these make up the threefold basis of action.',
  'word_meaning':
      'ज्ञानम्—knowledge; ज्ञेयम्—object of knowledge; परिज्ञाता—knower; त्रि-विदा—threefold; कर्म-चोदना—incitement to action; करणम्—instrument; कर्म—action; कर्ता—doer; इति—thus; त्रि-विदः—threefold; कर्म-संग्रहः—basis of action.',
  'commentary':
      'Action is driven by three internal motivators—knowledge, the knower, and the object—and manifests through three external components—instrument, deed, and doer.'
});

await db.insert('chapter_18', {
  'verse_number': 19,
  'sanskrit':
      'ज्ञानं कर्म च कर्ता च त्रिधैव गुणभेदतः | प्रोच्यते गुणसङ्ख्याने यथावच्छृणु तान्यपि || 19 ||',
  'translation':
      'Knowledge, action, and the doer are of three kinds according to the distinction of the modes of material nature. Hear about them as I describe them in detail.',
  'word_meaning':
      'ज्ञानम्—knowledge; कर्म—action; च—and; कर्ता—doer; च—and; त्रिधा—threefold; एव—indeed; गुण-भेदतः—based on the modes; प्रोच्यते—are described; गुण-सङ्ख्याने—in the science of the Gunas; यथा-अवच्छृणु—hear properly; तानि—those; अपि—also.',
  'commentary':
      'Just as matter operates under three modes—sattva, rajas, and tamas—so too do knowledge, action, and the doer fall under these categories.'
});

await db.insert('chapter_18', {
  'verse_number': 20,
  'sanskrit':
      'सर्वभूतेषु येनैकं भावमव्ययमीक्षते | अविभक्तं विभक्तेषु तज्ज्ञानं विद्धि सात्त्विकम् || 20 ||',
  'translation':
      'That knowledge by which one sees the one indestructible reality in all beings, undivided among the divided—know that knowledge to be in the mode of goodness.',
  'word_meaning':
      'सर्व-भूतेषु—in all beings; येन—by which; एकम्—one; भावम्—essence; अव्ययम्—indestructible; ईक्षते—sees; अविभक्तम्—undivided; विभक्तेषु—among the divided; तत्—that; ज्ञानम्—knowledge; विद्धि—know; सात्त्विकम्—in goodness.',
  'commentary':
      'Sāttvik knowledge perceives the same divine essence in all beings. It sees unity in diversity—the oneness of the soul within all forms.'
});

await db.insert('chapter_18', {
  'verse_number': 21,
  'sanskrit':
      'पृथक्त्वेन तु यज्ज्ञानं नानाभावान्पृथग्विधान् | वेत्ति सर्वेषु भूतेषु तज्ज्ञानं विद्धि राजसम् || 21 ||',
  'translation':
      'But that knowledge which sees various entities of distinct kinds as separate among all beings—know that to be in the mode of passion.',
  'word_meaning':
      'पृथक्त्वेन—as separate; तु—but; यत्—which; ज्ञानम्—knowledge; नाना—many; भावान्—natures; पृथक्—different; विधान्—kinds; वेत्ति—sees; सर्वेषु—in all; भूतेषु—beings; तत्—that; ज्ञानम्—knowledge; विद्धि—know; राजसम्—in passion.',
  'commentary':
      'Rājasic knowledge sees diversity as division. It perceives separateness and individuality but ignores the underlying spiritual unity.'
});

await db.insert('chapter_18', {
  'verse_number': 22,
  'sanskrit':
      'यत्तु कृत्स्नवदेकस्मिन्कार्ये सक्तमहैतुकम् | अतत्त्वार्थवदल्पं च तत्तामसमुदाहृतम् || 22 ||',
  'translation':
      'That knowledge which clings to one single effect as if it were the whole, without reason or understanding of the truth, and which is trivial—know that to be in the mode of ignorance.',
  'word_meaning':
      'यत्—which; तु—but; कृत्स्नवत्—as if whole; एकस्मिन्—in one thing; कार्ये—effect; सक्तम्—attached; अ-हेतुकम्—without reason; अ-तत्त्व-अर्थवत्—without true understanding; अल्पम्—trivial; च—and; तत्—that; तामसम्—in ignorance; उदाहृतम्—is called.',
  'commentary':
      'Tāmasic knowledge is narrow, irrational, and misdirected—it mistakes a part for the whole and remains bound by superstition and delusion.'
});

await db.insert('chapter_18', {
  'verse_number': 23,
  'sanskrit':
      'नियतं सङ्गरहितमरागद्वेषतः कृतम् | अफलप्रेप्सुना कर्म यत्तत्सात्त्विकमुच्यते || 23 ||',
  'translation':
      'An action performed as a duty, without attachment, without love or hatred, and without desire for results, is declared to be in the mode of goodness.',
  'word_meaning':
      'नियतम्—prescribed; सङ्ग-रहितम्—free from attachment; अ-राग-द्वेषतः—without attraction or aversion; कृतम्—performed; अ-फल-प्रेप्सुना—without longing for fruits; कर्म—action; यत्—that; तत्—that; सात्त्विकम्—in goodness; उच्यते—is said.',
  'commentary':
      'Sāttvik action arises from duty, not desire. It is performed selflessly, balanced between joy and discomfort, with the welfare of all in mind.'
});

await db.insert('chapter_18', {
  'verse_number': 24,
  'sanskrit':
      'यत्तु कामेप्सुना कर्म साहंकारेण वा पुनः | क्रियते बहुलायासं तद्राजसमुदाहृतम् || 24 ||',
  'translation':
      'But that action which is performed with great effort, seeking pleasure or driven by ego, is declared to be in the mode of passion.',
  'word_meaning':
      'यत्—which; तु—but; काम-इप्सुना—desiring reward; कर्म—action; स-अहंकारेण—with ego; वा—or; पुनः—again; क्रियते—is performed; बहु-ल-आयासम्—with much strain; तत्—that; राजसम्—in passion; उदाहृतम्—is called.',
  'commentary':
      'Rājasic action is done with expectation of reward and personal gain, born of desire and ego, often resulting in stress and disappointment.'
});

await db.insert('chapter_18', {
  'verse_number': 25,
  'sanskrit':
      'अनुबन्धं क्षयं हिंसामनपेक्ष्य च पौरुषम् | मोहादारभ्यते कर्म यत्तत्तामसमुच्यते || 25 ||',
  'translation':
      'That action which is undertaken out of delusion, without regard for consequences, loss, harm, or one’s capacity, is said to be in the mode of ignorance.',
  'word_meaning':
      'अनुबन्धम्—consequences; क्षयम्—loss; हिंसाम्—injury; अनपेक्ष्य—without consideration; च—and; पौरुषम्—one’s ability; मोहात्—out of delusion; आरभ्यते—is undertaken; कर्म—action; यत्—that; तत्—that; तामसम्—in ignorance; उच्यते—is said.',
  'commentary':
      'Tāmasic action is impulsive and reckless, performed in ignorance of its outcomes, leading to harm for oneself and others.'
});

await db.insert('chapter_18', {
  'verse_number': 26,
  'sanskrit':
      'मुक्तसङ्गोऽनहंवादी धृत्युत्साहसमन्वितः | सिद्ध्यसिद्ध्योर्निर्विकारः कर्ता सात्त्विक उच्यते || 26 ||',
  'translation':
      'Free from attachment, without egotism, endowed with steadfastness and enthusiasm, and unchanged in success or failure—such a doer is said to be of *sattvic* nature.',
  'word_meaning':
      'मुक्तसङ्गः—free from attachment; अनहंवादी—without ego; धृत्युत्साहसमन्वितः—endowed with resolve and enthusiasm; सिद्ध्यसिद्ध्योः—in success and failure; निर्विकारः—unchanged; कर्ता—doer; सात्त्विकः—sattvic; उच्यते—is said to be.',
  'commentary':
      'A *sattvic* doer performs actions selflessly, with calmness and inner strength, remaining unaffected by results.'
});

await db.insert('chapter_18', {
  'verse_number': 27,
  'sanskrit':
      'रागी कर्मफलप्रेप्सुर्लुब्धो हिंसात्मकः अशुचिः | हर्षशोकान्वितः कर्ता राजसः परिकीर्तितः || 27 ||',
  'translation':
      'The doer who is passionate, desirous of the fruits of actions, greedy, harmful, impure, and subject to joy and sorrow—is declared to be *rajasic*.',
  'word_meaning':
      'रागी—passionate; कर्मफलप्रेप्सुः—desiring fruit of action; लुब्धः—greedy; हिंसात्मकः—malicious; अशुचिः—impure; हर्षशोकान्वितः—subject to joy and sorrow; कर्ता—doer; राजसः—rajasic; परिकीर्तितः—is said to be.',
  'commentary':
      'A *rajasic* person acts with desire and attachment, seeking results and experiencing emotional highs and lows.'
});

await db.insert('chapter_18', {
  'verse_number': 28,
  'sanskrit':
      'अयुक्तः प्राकृतः स्तब्धः शठो नैष्कृतिकोऽलसः | विषादी दीर्घसूत्री च कर्ता तामस उच्यते || 28 ||',
  'translation':
      'Unsteady, vulgar, stubborn, deceitful, malicious, lazy, despondent, and procrastinating—the doer is said to be *tamasic*.',
  'word_meaning':
      'अयुक्तः—unsteady; प्राकृतः—vulgar; स्तब्धः—stubborn; शठः—deceitful; नैष्कृतिकः—malicious; अलसः—lazy; विषादी—depressed; दीर्घसूत्री—procrastinating; कर्ता—doer; तामसः—tamasic; उच्यते—is said to be.',
  'commentary':
      'A *tamasic* person lacks focus and purity, often acting out of ignorance, laziness, or deceit.'
});

await db.insert('chapter_18', {
  'verse_number': 29,
  'sanskrit':
      'बुद्धेर्भेदं धृतेश्चैव गुणतस्त्रिविधं शृणु | प्रोच्यमानमशेषेण पृथक्त्वेन धनंजय || 29 ||',
  'translation':
      'Now hear from Me, O Dhananjaya, the threefold distinction of intellect and firmness, according to the modes of material nature, explained completely and separately.',
  'word_meaning':
      'बुद्धेः—of intellect; भेदम्—distinction; धृतेः—of firmness; च—and; एव—also; गुणतः—according to modes; त्रिविधम्—threefold; शृणु—hear; प्रोच्यमानम्—being explained; अशेषेण—completely; पृथक्त्वेन—separately; धनंजय—O Dhananjaya.',
  'commentary':
      'Krishna begins explaining how *intellect (buddhi)* and *steadfastness (dhriti)* differ according to the three gunas.'
});

await db.insert('chapter_18', {
  'verse_number': 30,
  'sanskrit':
      'प्रवृत्तिं च निवृत्तिं च कार्याकार्ये भयाभये | बन्धं मोक्षं च या वेत्ति बुद्धिः सा पार्थ सात्त्विकी || 30 ||',
  'translation':
      'That intellect which knows action and renunciation, what ought to be done and what ought not, fear and fearlessness, bondage and liberation—is said to be *sattvic*, O Partha.',
  'word_meaning':
      'प्रवृत्तिम्—action; च—and; निवृत्तिम्—renunciation; च—and; कार्य-अकार्ये—what ought or ought not be done; भय-अभये—fear and fearlessness; बन्धम्—bondage; मोक्षम्—liberation; च—and; या—who; वेत्ति—knows; बुद्धिः—intellect; सा—that; पार्थ—O Partha; सात्त्विकी—sattvic.',
  'commentary':
      'A *sattvic* intellect discerns right from wrong and acts according to dharma, guided by wisdom and self-control.'
});

await db.insert('chapter_18', {
  'verse_number': 31,
  'sanskrit':
      'यया धर्ममधर्मं च कार्यं चाकार्यमेव च | अयथावत्प्रजानाति बुद्धिः सा पार्थ राजसी || 31 ||',
  'translation':
      'That intellect, O Partha, which wrongly understands dharma and adharma, and what should be done and what should not, is *rajasic*.',
  'word_meaning':
      'यया—by which; धर्मम्—righteousness; अधर्मम्—unrighteousness; कार्यम्—what should be done; च—and; अकार्यं—what should not be done; एव—indeed; च—and; अयथावत्—wrongly; प्रजानाति—understands; बुद्धिः—intellect; सा—that; पार्थ—O Partha; राजसी—rajasic.',
  'commentary':
      'The *rajasic* intellect is clouded by desire and personal interest, often misjudging right and wrong.'
});

await db.insert('chapter_18', {
  'verse_number': 32,
  'sanskrit':
      'अधर्मं धर्ममिति या मन्यते तमसावृता | सर्वार्थान्विपरीतांश्च बुद्धिः सा पार्थ तामसी || 32 ||',
  'translation':
      'That intellect which, enveloped in darkness, regards unrighteousness as righteousness and sees all things in a perverted way, O Partha, is said to be *tamasic*.',
  'word_meaning':
      'अधर्मम्—unrighteousness; धर्मम्—righteousness; इति—thus; या—who; मन्यते—considers; तमसावृता—covered by darkness; सर्व-अर्थान्—all things; विपरीतान्—perverted; च—and; बुद्धिः—intellect; सा—that; पार्थ—O Partha; तामसी—tamasic.',
  'commentary':
      'A *tamasic* intellect sees everything in reverse due to ignorance, mistaking wrong for right.'
});

await db.insert('chapter_18', {
  'verse_number': 33,
  'sanskrit':
      'धृत्या यया धारयते मनःप्राणेन्द्रियक्रियाः | योगेनाव्यभिचारिण्या धृतिः सा पार्थ सात्त्विकी || 33 ||',
  'translation':
      'That firmness by which one steadfastly controls the functions of the mind, life-breath, and senses through unwavering yoga is *sattvic*, O Partha.',
  'word_meaning':
      'धृत्या—by firmness; यया—by which; धारयते—one controls; मनः—mind; प्राण—life-breath; इन्द्रिय—senses; क्रियाः—functions; योगेन—through yoga; अव्यभिचारिण्या—unswerving; धृतिः—firmness; सा—that; पार्थ—O Partha; सात्त्विकी—sattvic.',
  'commentary':
      'A *sattvic dhriti* reflects spiritual stability—control over body and mind through consistent practice of yoga and discipline.'
});

await db.insert('chapter_18', {
  'verse_number': 34,
  'sanskrit':
      'यया तु धर्मकामार्थान्धृत्या धारयतेऽर्जुन | प्रसङ्गेन फलाकाङ्क्षी धृतिः सा पार्थ राजसी || 34 ||',
  'translation':
      'But the firmness by which one holds fast to duty, desires, and wealth, with attachment and longing for results—that firmness, O Partha, is *rajasic*.',
  'word_meaning':
      'यया—by which; तु—but; धर्म-काम-अर्थान्—duty, desire, and wealth; धृत्या—by firmness; धारयते—holds fast; अर्जुन—O Arjuna; प्रसङ्गेन—with attachment; फल-आकाङ्क्षी—desiring fruit; धृतिः—firmness; सा—that; पार्थ—O Partha; राजसी—rajasic.',
  'commentary':
      'The *rajasic* type of firmness is fueled by desire and attachment to worldly outcomes rather than spiritual goals.'
});

await db.insert('chapter_18', {
  'verse_number': 35,
  'sanskrit':
      'यया स्वप्नं भयं शोकं विषादं मदमेव च | न विमुञ्चति दुर्मेधा धृतिः सा पार्थ तामसी || 35 ||',
  'translation':
      'That firmness by which a foolish person clings to sleep, fear, grief, despair, and conceit, O Partha, is *tamasic*.',
  'word_meaning':
      'यया—by which; स्वप्नम्—sleep; भयं—fear; शोकम्—grief; विषादम्—despair; मदम्—conceit; एव—also; च—and; न विमुञ्चति—does not give up; दुर्मेधा—foolish; धृतिः—firmness; सा—that; पार्थ—O Partha; तामसी—tamasic.',
  'commentary':
      'A *tamasic dhriti* binds a person to inertia, fear, and delusion—blocking progress and clarity.'
});

await db.insert('chapter_18', {
  'verse_number': 36,
  'sanskrit':
      'सुखं त्विदानीं त्रिविधं शृणु मे भरतर्षभ | अभ्यासाद्रमते यत्र दुःखान्तं च निगच्छति || 36 ||',
  'translation':
      'Now hear from Me, O best of the Bharatas, of the three kinds of happiness—by practice one delights in it and attains the end of sorrow.',
  'word_meaning':
      'सुखम्—happiness; तु—but; इदानीम्—now; त्रिविधम्—threefold; शृणु—hear; मे—from Me; भरतर्षभ—O best of Bharatas; अभ्यासात्—by practice; रमते—delights; यत्र—in which; दुःख-अन्तम्—end of sorrow; च—and; निगच्छति—attains.',
  'commentary':
      'Happiness, too, is classified according to the three gunas. Through right practice, one attains lasting peace.'
});

await db.insert('chapter_18', {
  'verse_number': 37,
  'sanskrit':
      'यत्तदग्रे विषमिव परिणामेऽमृतोपमम् | तत्सुखं सात्त्विकं प्रोक्तमात्मबुद्धिप्रसादजम् || 37 ||',
  'translation':
      'That which seems like poison at first but is nectar at the end—that happiness, born of the serenity of one’s intellect, is said to be *sattvic*.',
  'word_meaning':
      'यत्—which; तत्—that; अग्रे—at first; विषम्—poison; इव—as; परिणामे—at the end; अमृत-उपमम्—like nectar; तत्—that; सुखम्—happiness; सात्त्विकम्—sattvic; प्रोक्तम्—is said; आत्म-बुद्धि-प्रसादजम्—born of the purity of the mind and intellect.',
  'commentary':
      'True joy comes after discipline and self-control. Though initially difficult, it leads to peace and bliss.'
});

await db.insert('chapter_18', {
  'verse_number': 38,
  'sanskrit':
      'विषयेन्द्रियसंयोगाद्यत्तदग्रेऽमृतोपमम् | परिणामे विषमिव तत्सुखं राजसं स्मृतम् || 38 ||',
  'translation':
      'Happiness that arises from the contact of the senses with their objects, which seems like nectar at first but is poison in the end, is *rajasic*.',
  'word_meaning':
      'विषय—objects; इन्द्रिय—senses; संयोगात्—from contact; यत्—which; तत्—that; अग्रे—at first; अमृत-उपमम्—like nectar; परिणामे—at the end; विषम्—poison; इव—as; तत्—that; सुखम्—happiness; राजसम्—rajasic; स्मृतम्—is declared.',
  'commentary':
      '*Rajasic* happiness comes from sensory pleasures. Though enjoyable initially, it leads to suffering and attachment.'
});

await db.insert('chapter_18', {
  'verse_number': 39,
  'sanskrit':
      'यदग्रे चानुबन्धे च सुखं मोहनमात्मनः | निद्रालस्यप्रमादोत्थं तत्तामसमुदाहृतम् || 39 ||',
  'translation':
      'That happiness which deludes the self both at the beginning and in its results, arising from sleep, laziness, and negligence—is called *tamasic*.',
  'word_meaning':
      'यत्—which; अग्रे—at first; च—and; अनुबन्धे—afterwards; च—and; सुखम्—happiness; मोहनम्—delusive; आत्मनः—of the self; निद्रा—sleep; आलस्य—laziness; प्रमाद—negligence; उत्पन्नम्—arising from; तत्—that; तामसम्—tamasic; उदाहृतम्—is said to be.',
  'commentary':
      '*Tamasic* happiness gives false comfort, keeping one trapped in ignorance and indolence.'
});

await db.insert('chapter_18', {
  'verse_number': 40,
  'sanskrit':
      'न तदस्ति पृथिव्यां वा दिवि देवेषु वा पुनः | सत्त्वं प्रकृतिजैर्मुक्तं यदेभिः स्यात्त्रिभिर्गुणैः || 40 ||',
  'translation':
      'There is no being on earth, or even among the gods in heaven, that is free from these three modes born of material nature.',
  'word_meaning':
      'न—not; तत्—that; अस्ति—is; पृथिव्याम्—on earth; वा—or; दिवि—in heaven; देवेषु—among the gods; वा—or; पुनः—again; सत्त्वम्—being; प्रकृति-जैः—born of nature; मुक्तम्—free; यत्—which; एभिः—by these; स्यात्—may be; त्रिभिः गुणैः—three modes.',
  'commentary':
      'Every being, from the lowest to the highest, is influenced by the three gunas—sattva, rajas, and tamas. Liberation requires transcending them.'
});

await db.insert('chapter_18', {
  'verse_number': 41,
  'sanskrit':
      'ब्राह्मणक्षत्रियविशां शूद्राणां च परन्तप | कर्माणि प्रविभक्तानि स्वभावप्रभवैर्गुणैः || 41 ||',
  'translation':
      'The duties of the Brāhmaṇas, Kṣhatriyas, Vaiśyas, and Śūdras, O Parantapa, are divided according to the qualities born of their own nature.',
  'word_meaning':
      'ब्राह्मण—of the Brāhmaṇas; क्षत्रिय—of the Kṣhatriyas; विशाम्—of the Vaiśyas; शूद्राणाम्—of the Śūdras; च—and; परन्तप—O scorcher of enemies (Arjuna); कर्माणि—duties; प्रविभक्तानि—are divided; स्वभाव—one’s own nature; प्रभवैः—born of; गुणैः—qualities.',
  'commentary':
      'Krishna explains that social duties arise from one’s natural qualities (*guna*) and tendencies (*svabhava*), not from birth alone.'
});

await db.insert('chapter_18', {
  'verse_number': 42,
  'sanskrit':
      'शमो दमस्तपः शौचं क्षान्तिरार्जवमेव च | ज्ञानं विज्ञानमास्तिक्यं ब्रह्मकर्म स्वभावजम् || 42 ||',
  'translation':
      'Serenity, self-control, austerity, purity, forgiveness, uprightness, knowledge, wisdom, and faith in God are the duties of the Brāhmaṇas, born of their nature.',
  'word_meaning':
      'शमः—serenity; दमः—self-control; तपः—austerity; शौचम्—purity; क्षान्तिः—forgiveness; आर्जवम्—uprightness; एव—indeed; च—and; ज्ञानम्—knowledge; विज्ञानम्—wisdom; आस्तिक्यम्—faith in God; ब्रह्म-कर्म—duty of the Brāhmaṇa; स्वभाव-जम्—born of one’s nature.',
  'commentary':
      'Brāhmaṇas are naturally inclined toward learning, teaching, and spirituality, focusing on peace and wisdom.'
});

await db.insert('chapter_18', {
  'verse_number': 43,
  'sanskrit':
      'शौर्यं तेजो धृतिर्दाक्ष्यं युद्धे चाप्यपलायनम् | दानमीश्वरभावश्च क्षात्रं कर्म स्वभावजम् || 43 ||',
  'translation':
      'Valor, vigor, determination, skill, not fleeing from battle, generosity, and leadership are the duties of the Kṣhatriyas, born of their nature.',
  'word_meaning':
      'शौर्यम्—valor; तेजः—vigor; धृतिः—determination; दाक्ष्यम्—skill; युद्धे—in battle; च—and; अपि—also; अपलायनम्—not fleeing; दानम्—generosity; ईश्वर-भावः—leadership; च—and; क्षात्रम्—of the Kṣhatriya; कर्म—duty; स्वभाव-जम्—born of nature.',
  'commentary':
      'Kṣhatriyas are born leaders and protectors who combine courage and compassion in serving society.'
});

await db.insert('chapter_18', {
  'verse_number': 44,
  'sanskrit':
      'कृषिगौरक्ष्यवाणिज्यं वैश्यकर्म स्वभावजम् | परिचर्यात्मकं कर्म शूद्रस्यापि स्वभावजम् || 44 ||',
  'translation':
      'Agriculture, cattle rearing, and trade are the natural duties of the Vaiśyas; and service to others is the natural duty of the Śūdras.',
  'word_meaning':
      'कृषि—agriculture; गो-रक्ष्य—cow protection; वाणिज्यम्—trade; वैश्य-कर्म—duty of the Vaiśya; स्वभाव-जम्—born of nature; परिचर्या—service; आत्मकम्—by nature; कर्म—duty; शूद्रस्य—of the Śūdra; अपि—also; स्वभाव-जम्—born of nature.',
  'commentary':
      'The Vaiśya sustains economic life, while the Śūdra contributes through faithful service and labor.'
});

await db.insert('chapter_18', {
  'verse_number': 45,
  'sanskrit':
      'स्वे स्वे कर्मण्यभिरतः संसिद्धिं लभते नरः | स्वकर्मनिरतः सिद्धिं यथा विन्दति तच्छृणु || 45 ||',
  'translation':
      'By being devoted to one’s own natural duty, a person attains perfection. Hear now how one attains perfection by performing one’s own work.',
  'word_meaning':
      'स्वे स्वे—in one’s own; कर्मणि—duty; अभिरतः—engaged; संसिद्धिम्—perfection; लभते—attains; नरः—a person; स्वकर्म—one’s own duty; निरतः—devoted; सिद्धिम्—perfection; यथा—how; विन्दति—attains; तत्—that; शृणु—hear.',
  'commentary':
      'Krishna emphasizes that spiritual perfection comes through dedication to one’s *svadharma*—one’s own natural duty.'
});

await db.insert('chapter_18', {
  'verse_number': 46,
  'sanskrit':
      'यतः प्रवृत्तिर्भूतानां येन सर्वमिदं ततम् | स्वकर्मणा तमभ्यर्च्य सिद्धिं विन्दति मानवः || 46 ||',
  'translation':
      'By worshiping through one’s own duty Him from whom all beings have come and by whom all this is pervaded, a person attains perfection.',
  'word_meaning':
      'यतः—from whom; प्रवृत्तिः—origination; भूतानाम्—of beings; येन—by whom; सर्वम्—everything; इदम्—this; ततम्—is pervaded; स्व-कर्मणा—by one’s own duty; तम्—Him; अभ्यर्च्य—by worshiping; सिद्धिम्—perfection; विन्दति—attains; मानवः—a person.',
  'commentary':
      'All duties, when performed with devotion to God, become acts of worship leading to perfection.'
});

await db.insert('chapter_18', {
  'verse_number': 47,
  'sanskrit':
      'श्रेयान्स्वधर्मो विगुणः परधर्मात्स्वनुष्ठितात् | स्वभावनियतं कर्म कुर्वन्नाप्नोति किल्बिषम् || 47 ||',
  'translation':
      'Better is one’s own duty, though imperfect, than the duty of another well-performed. Performing duty according to one’s nature, one does not incur sin.',
  'word_meaning':
      'श्रेयान्—better; स्व-धर्मः—one’s own duty; विगुणः—imperfectly performed; पर-धर्मात्—than another’s duty; सुवनुष्ठितात्—well performed; स्वभाव—one’s nature; नियतम्—prescribed; कर्म—duty; कुर्वन्—doing; न—not; आप्नोति—incurs; किल्बिषम्—sin.',
  'commentary':
      'Even an imperfectly done *svadharma* purifies the soul, while adopting another’s duty can cause confusion and bondage.'
});

await db.insert('chapter_18', {
  'verse_number': 48,
  'sanskrit':
      'सहजं कर्म कौन्तेय सदोषमपि न त्यजेत् | सर्वारम्भा हि दोषेण धूमेनाग्निरिवावृताः || 48 ||',
  'translation':
      'One should not abandon the duty born of one’s nature, even if it appears faulty, O Kaunteya. For all undertakings are covered by defects, just as fire is enveloped by smoke.',
  'word_meaning':
      'सहजम्—born of one’s nature; कर्म—duty; कौन्तेय—O son of Kunti; स-दोषम्—with fault; अपि—even; न—not; त्यजेत्—should abandon; सर्व-आरम्भाः—all undertakings; हि—for; दोषेण—by defect; धूमेन—by smoke; अग्निः—fire; इव—as; आवृताः—enveloped.',
  'commentary':
      'No action is flawless; therefore, one must perform their natural duty despite imperfections.'
});

await db.insert('chapter_18', {
  'verse_number': 49,
  'sanskrit':
      'असक्तबुद्धिः सर्वत्र जितात्मा विगतस्पृहः | नैष्कर्म्यसिद्धिं परमां संन्यासेनाधिगच्छति || 49 ||',
  'translation':
      'He whose intellect is unattached everywhere, who has conquered the self and is free from desires, attains the supreme perfection of freedom from action through renunciation.',
  'word_meaning':
      'असक्त-बुद्धिः—with unattached intellect; सर्वत्र—everywhere; जित-आत्मा—self-controlled; विगत-स्पृहः—free from desire; नैष्कर्म्य-सिद्धिम्—perfection of actionlessness; परमाम्—supreme; संन्यासेन—through renunciation; अधिगच्छति—attains.',
  'commentary':
      'True renunciation is inner detachment, not abandonment of action. Through this, one attains liberation.'
});

await db.insert('chapter_18', {
  'verse_number': 50,
  'sanskrit':
      'सिद्धिं प्राप्तो यथा ब्रह्म तथाप्नोति निबोध मे | समासेनैव कौन्तेय निष्ठा ज्ञानस्य या परा || 50 ||',
  'translation':
      'Learn from Me briefly, O Kaunteya, how one who has attained perfection reaches Brahman, the supreme state of knowledge.',
  'word_meaning':
      'सिद्धिम्—perfection; प्राप्तः—having attained; यथा—how; ब्रह्म—Brahman; तथ—thus; आप्नोति—attains; निबोध—understand; मे—from Me; समासेन—briefly; एव—indeed; कौन्तेय—O Kaunteya; निष्ठा—culmination; ज्ञानस्य—of knowledge; या—which; परा—supreme.',
  'commentary':
      'Krishna now explains the ultimate stage beyond action—how perfection leads to realization of Brahman.'
});

await db.insert('chapter_18', {
  'verse_number': 51,
  'sanskrit':
      'बुद्ध्या विशुद्धया युक्तो धृत्यात्मानं नियम्य च | शब्दादीन्विषयांस्त्यक्त्वा रागद्वेषौ व्युदस्य च || 51 ||',
  'translation':
      'Endowed with a purified intellect, controlling the mind with firmness, renouncing the objects of the senses, and giving up attraction and aversion...',
  'word_meaning':
      'बुद्ध्या—by intellect; विशुद्धया—purified; युक्तः—endowed; धृत्या—with firmness; आत्मानम्—the mind; नियम्य—controlling; च—and; शब्द-आदीन्—sound and others; विषयान्—objects; त्यक्त्वा—renouncing; राग-द्वेषौ—attraction and aversion; व्युदस्य—giving up; च—and.',
  'commentary':
      'The seeker must discipline intellect, senses, and desires, turning inward toward spiritual realization.'
});

await db.insert('chapter_18', {
  'verse_number': 52,
  'sanskrit':
      'विविक्तसेवी लघ्वाशी यतवाक्कायमानसः | ध्यानयोगपरो नित्यं वैराग्यं समुपाश्रितः || 52 ||',
  'translation':
      'Living in seclusion, eating lightly, controlling speech, body, and mind, devoted to meditation and yoga, and taking refuge in dispassion...',
  'word_meaning':
      'विविक्त-सेवी—living in seclusion; लघु-आशी—eating lightly; यत-वाक्-काय-मानसः—controlling speech, body, and mind; ध्यान-योग-परः—devoted to meditation and yoga; नित्यम्—always; वैराग्यम्—dispassion; समुपाश्रितः—taking refuge in.',
  'commentary':
      'The path to Brahman requires solitude, simplicity, self-control, and consistent meditation.'
});

await db.insert('chapter_18', {
  'verse_number': 53,
  'sanskrit':
      'अहङ्कारं बलं दर्पं कामं क्रोधं परिग्रहम् | विमुच्य निर्ममः शान्तो ब्रह्मभूयाय कल्पते || 53 ||',
  'translation':
      'Having abandoned ego, power, pride, desire, anger, and possession, being free from selfishness and calm—such a person becomes fit for union with Brahman.',
  'word_meaning':
      'अहङ्कारम्—ego; बलम्—power; दर्पम्—pride; कामम्—desire; क्रोधम्—anger; परिग्रहम्—possessiveness; विमुच्य—having given up; निर्ममः—without self-interest; शान्तः—peaceful; ब्रह्म-भूयाय—for becoming Brahman; कल्पते—is fit.',
  'commentary':
      'Liberation comes when the ego dissolves, and peace arises from the absence of selfish attachments.'
});

await db.insert('chapter_18', {
  'verse_number': 54,
  'sanskrit':
      'ब्रह्मभूतः प्रसन्नात्मा न शोचति न काङ्क्षति | समः सर्वेषु भूतेषु मद्भक्तिṁ लभते पराम् || 54 ||',
  'translation':
      'One who has become Brahman, serene in mind, neither grieves nor desires. Such a person, seeing all beings alike, attains supreme devotion to Me.',
  'word_meaning':
      'ब्रह्म-भूतः—one who has realized Brahman; प्रसन्न-आत्मा—serene in mind; न—not; शोचति—grieves; न—not; काङ्क्षति—desires; समः—equanimous; सर्वेषु—in all; भूतेषु—beings; मत्-भक्तिम्—devotion to Me; लभते—attains; पराम्—supreme.',
  'commentary':
      'When knowledge matures into equanimity, devotion naturally arises—devotion that transcends all distinctions.'
});

await db.insert('chapter_18', {
  'verse_number': 55,
  'sanskrit':
      'भक्त्या मामभिजानाति यावान्यश्चास्मि तत्त्वतः | ततो मां तत्त्वतो ज्ञात्वा विशते तदनन्तरम् || 55 ||',
  'translation':
      'Through devotion, one truly knows Me in essence—who I am and what I am. Having thus known Me in truth, one enters into Me thereafter.',
  'word_meaning':
      'भक्त्या—through devotion; माम्—Me; अभिजानाति—knows truly; यावान्—what I am; यः च—and who I am; अस्मि—I am; तत्त्वतः—in truth; ततः—then; मां—Me; तत्त्वतः—truly; ज्ञात्वा—knowing; विशते—enters; तत्-अनन्तरम्—thereafter.',
  'commentary':
      'Bhakti is the highest path—through pure devotion, one knows Krishna in truth and merges into His divine being.'
});

await db.insert('chapter_18', {
  'verse_number': 56,
  'sanskrit':
      'सर्वकर्माण्यपि सदा कुर्वाणो मद्व्यपाश्रयः | मत्प्रसादादवाप्नोति शाश्वतं पदमव्ययम् || 56 ||',
  'translation':
      'Though engaged in all kinds of actions, those who take refuge in Me, by My grace, attain the eternal and imperishable abode.',
  'word_meaning':
      'सर्व कर्माणि अपि सदा—though always performing all actions; कुर्वाणः—engaged; मत् व्यपाश्रयः—taking refuge in Me; मत् प्रसादात्—by My grace; अवाप्नोति—attains; शाश्वतं—eternal; पदम्—abode; अव्ययम्—imperishable.',
  'commentary':
      'Even while acting in the world, those who surrender to Krishna remain untouched by its bondage and reach His supreme abode through His grace.'
});

await db.insert('chapter_18', {
  'verse_number': 57,
  'sanskrit':
      'चेतसा सर्वकर्माणि मयि संन्यस्य मत्परः | बुद्धियोगमुपाश्रित्य मच्चित्तः सततं भव || 57 ||',
  'translation':
      'Mentally renounce all actions to Me, considering Me as the Supreme. Take refuge in the yoga of intelligence and always keep your mind fixed on Me.',
  'word_meaning':
      'चेतसा—by the mind; सर्व कर्माणि—all actions; मयि—unto Me; संन्यस्य—renouncing; मत् परः—regarding Me as Supreme; बुद्धि योगम्—yoga of intelligence; उपाश्रित्य—taking refuge in; मत् चित्तः—mind fixed on Me; सततम्—always; भव—be.',
  'commentary':
      'Krishna instructs Arjuna to dedicate all actions to Him and remain absorbed in divine consciousness through the yoga of wisdom.'
});

await db.insert('chapter_18', {
  'verse_number': 58,
  'sanskrit':
      'मच्चित्तः सर्वदुर्गाणि मत्प्रसादात्तरिष्यसि | अथ चेत्त्वमहंकारान्न श्रोष्यसि विनङ्क्ष्यसि || 58 ||',
  'translation':
      'If your mind is fixed on Me, you shall overcome all obstacles by My grace. But if, due to ego, you do not listen, you will perish.',
  'word_meaning':
      'मत् चित्तः—mind fixed on Me; सर्व दुर्गाणि—all obstacles; मत् प्रसादात्—by My grace; तरिष्यसि—you shall cross over; अथ—but; चेत्—if; त्वम्—you; अहंकारात्—from ego; न—not; श्रोष्यसि—heed; विनङ्क्ष्यसि—you will perish.',
  'commentary':
      'Surrender removes all hindrances through divine grace. Ego and disobedience, however, lead to downfall and suffering.'
});

await db.insert('chapter_18', {
  'verse_number': 59,
  'sanskrit':
      'यदहंकारमाश्रित्य न योत्स्य इति मन्यसे | मिथ्यैष व्यवसायस्ते प्रकृतिस्त्वां नियोक्ष्यति || 59 ||',
  'translation':
      'If, out of ego, you think, “I will not fight,” this resolve of yours is false; your own nature will compel you to act.',
  'word_meaning':
      'यत्—if; अहंकारम्—ego; आश्रित्य—taking shelter of; न—not; योत्स्ये—I will fight; इति—thus; मन्यसे—you think; मिथ्या—false; एष—this; व्यवसायः—resolve; ते—your; प्रकृतिः—your nature; त्वाम्—you; नियोक्ष्यति—will drive to act.',
  'commentary':
      'Actions are driven by one’s nature. Denying duty out of ego is futile; the guṇas of nature will still compel one to act.'
});

await db.insert('chapter_18', {
  'verse_number': 60,
  'sanskrit':
      'स्वभावजेन कौन्तेय निबद्धः स्वेन कर्मणा | कर्तुं नेच्छसि यन्मोहात्करिष्यस्यवशोऽपि तत् || 60 ||',
  'translation':
      'Bound by your own nature-born karma, O Kaunteya, though you do not wish to act out of delusion, you will be driven to perform it even against your will.',
  'word_meaning':
      'स्वभावजेन—born of your nature; कौन्तेय—O son of Kunti; निबद्धः—bound; स्वेन—by your own; कर्मणा—duty; कर्तुम्—to perform; न—not; इच्छसि—you wish; यत्—what; मोहात्—out of delusion; करिष्यसि—you shall perform; अवशः—helplessly; अपि—even; तत्—that.',
  'commentary':
      'Arjuna’s warrior nature, born of rajas, compels him to fight. One’s innate nature cannot be denied indefinitely.'
});

await db.insert('chapter_18', {
  'verse_number': 61,
  'sanskrit':
      'ईश्वरः सर्वभूतानां हृद्देशेऽर्जुन तिष्ठति | भ्रामयन्सर्वभूतानि यन्त्रारूढानि मायया || 61 ||',
  'translation':
      'The Supreme Lord dwells in the hearts of all beings, O Arjuna, and causes them to revolve by His māyā as if mounted on a machine.',
  'word_meaning':
      'ईश्वरः—the Supreme Lord; सर्व भूतानाम्—of all beings; हृद् देशे—in the hearts; अर्जुन—O Arjuna; तिष्ठति—resides; भ्रामयन्—causing to revolve; सर्व भूतानि—all beings; यन्त्र आरूढानि—mounted on a machine; मायया—by His illusion.',
  'commentary':
      'God, seated within all, directs the movements of all beings through the power of His divine illusion. He is the inner controller of all actions.'
});

await db.insert('chapter_18', {
  'verse_number': 62,
  'sanskrit':
      'तमेव शरणं गच्छ सर्वभावेन भारत | तत्प्रसादात्परां शान्तिं स्थानं प्राप्स्यसि शाश्वतम् || 62 ||',
  'translation':
      'Surrender fully unto Him, O Bhārata; by His grace you shall attain supreme peace and the eternal abode.',
  'word_meaning':
      'तम् एव—unto Him alone; शरणम्—refuge; गच्छ—go; सर्व भावेन—with all your being; भारत—O son of Bharata; तत् प्रसादात्—by His grace; पराम्—supreme; शान्तिम्—peace; स्थानम्—abode; प्राप्स्यसि—you shall attain; शाश्वतम्—eternal.',
  'commentary':
      'The culmination of all teachings: surrender completely to the Lord with heart and mind, and attain eternal peace in His abode.'
});

await db.insert('chapter_18', {
  'verse_number': 63,
  'sanskrit':
      'इति ते ज्ञानमाख्यातं गुह्याद्गुह्यतरं मया | विमृश्यैतदशेषेण यथेच्छसि तथा कुरु || 63 ||',
  'translation':
      'Thus, I have declared to you this knowledge which is more secret than all secrets. Reflect fully on it, and then act as you wish.',
  'word_meaning':
      'इति—thus; ते—to you; ज्ञानम्—knowledge; आख्यातम्—has been explained; गुह्यात्—than secret; गुह्यतरम्—more profound; मया—by Me; विमृश्य—reflecting; एतत्—on this; अशेषेण—completely; यथा इच्छसि—as you wish; तथा—so; कुरु—act.',
  'commentary':
      'Krishna grants Arjuna free will after giving divine wisdom — urging him to reflect and then choose his course.'
});

await db.insert('chapter_18', {
  'verse_number': 64,
  'sanskrit':
      'सर्वगुह्यतमं भूयः शृणु मे परमं वचः | इष्टोऽसि मे दृढमिति ततो वक्ष्यामि ते हितम् || 64 ||',
  'translation':
      'Hear again My most confidential words, the supreme instruction; you are very dear to Me, and therefore I will tell you what is best for you.',
  'word_meaning':
      'सर्व गुह्यतमम्—the most confidential; भूयः—again; शृणु—hear; मे—My; परमम्—supreme; वचः—word; इष्टः—dear; असि—you are; मे—to Me; दृढम्—truly; इति—thus; ततः—therefore; वक्ष्यामि—I shall speak; ते—your; हितम्—welfare.',
  'commentary':
      'Out of divine affection, Krishna prepares to reveal the essence of all teachings — the supreme secret leading to liberation.'
});

await db.insert('chapter_18', {
  'verse_number': 65,
  'sanskrit':
      'मन्मना भव मद्भक्तो मद्याजी मां नमस्कुरु | मामेवैष्यसि युक्तैवमात्मानं मत्परायणः || 65 ||',
  'translation':
      'Always think of Me, be devoted to Me, worship Me, and offer obeisance to Me. Thus you shall surely come to Me, having dedicated yourself to Me.',
  'word_meaning':
      'मत् मनाः—think of Me; भव—be; मत् भक्तः—My devotee; मत् याजी—worship Me; माम्—unto Me; नमस्कुरु—offer obeisance; माम् एव—unto Me alone; एष्यसि—you shall come; युक्तः—united; एवम्—thus; आत्मानम्—yourself; मत् परायणः—fully devoted to Me.',
  'commentary':
      'The simplest and highest path: devotion through love and remembrance of God leads one to union with Him.'
});

await db.insert('chapter_18', {
  'verse_number': 66,
  'sanskrit':
      'सर्वधर्मान्परित्यज्य मामेकं शरणं व्रज | अहं त्वां सर्वपापेभ्यो मोक्षयिष्यामि मा शुचः || 66 ||',
  'translation':
      'Abandon all varieties of dharma and simply surrender unto Me. I shall deliver you from all sinful reactions; do not fear.',
  'word_meaning':
      'सर्व धर्मान्—all duties; परित्यज्य—abandoning; माम्—unto Me; एकम्—alone; शरणम्—refuge; व्रज—go; अहम्—I; त्वाम्—you; सर्व पापेभ्यः—from all sins; मोक्षयिष्यामि—shall liberate; मा—not; शुचः—grieve.',
  'commentary':
      'This is the Gita’s ultimate verse — complete surrender to God transcends all duties and leads to liberation. It is both a promise and a command of divine love.'
});

await db.insert('chapter_18', {
  'verse_number': 67,
  'sanskrit':
      'इदं ते नातपस्काय नाभक्ताय कदाचन | न चाशुश्रूषवे वाच्यं न च मां योऽभ्यसूयति || 67 ||',
  'translation':
      'This should never be spoken to one who is not austere, not devoted, unwilling to listen, or who is envious of Me.',
  'word_meaning':
      'इदम्—this; ते—by you; न—not; अतपस्काय—to one who is not austere; न—not; अभक्ताय—to one who is not devoted; कदाचन—ever; न—not; च—and; अशुश्रूषवे—to one who is unwilling to hear; वाच्यम्—should be spoken; न—not; च—and; माम्—of Me; यः—who; अभ्यसूयति—is envious.',
  'commentary':
      'The sacred knowledge of surrender is to be shared only with sincere, pure-hearted seekers — not with the irreverent or envious.'
});

await db.insert('chapter_18', {
  'verse_number': 68,
  'sanskrit':
      'यं मां परमं गुह्यं मद्भक्तेष्वभिधास्यति | भक्तिं मयि परां कृत्वा मामेवैष्यत्यसंशयम् || 68 ||',
  'translation':
      'Whoever teaches this supreme secret to My devotees, performing the highest act of devotion, shall surely come to Me.',
  'word_meaning':
      'यः—whoever; माम्—Me; परमम्—supreme; गुह्यम्—secret; मत् भक्तेषु—to My devotees; अभिधास्यति—will explain; भक्तिम्—devotion; मयि—towards Me; पराम्—supreme; कृत्वा—having performed; माम् एव—unto Me alone; एष्यति—will come; असंशयम्—without doubt.',
  'commentary':
      'Teaching the Gita to others with devotion is itself the highest service to Krishna and leads one to union with Him.'
});

await db.insert('chapter_18', {
  'verse_number': 69,
  'sanskrit':
      'न च तस्मान्मनुष्येषु कश्चिन्मे प्रियकृत्तमः | भविता न च मे तस्मादन्यः प्रियतरो भुवि || 69 ||',
  'translation':
      'There is no one among humans who does dearer service to Me than he, nor shall there ever be one more beloved to Me on earth.',
  'word_meaning':
      'न च—and none; तस्मात्—than him; मनुष्येषु—among humans; कश्चित्—anyone; मे—to Me; प्रिय कृत्—one who does what is dear; तमः—greater; भविता—will be; न—not; च—and; मे—to Me; तस्मात्—than him; अन्यः—another; प्रियतरः—dearer; भुवि—on earth.',
  'commentary':
      'One who spreads this divine message becomes most dear to the Lord — as he participates in uplifting souls toward liberation.'
});

await db.insert('chapter_18', {
  'verse_number': 70,
  'sanskrit':
      'अध्येष्यते च य इमं धर्म्यं संवादमावयोः | ज्ञानयज्ञेन तेनाहमिष्टः स्यामिति मे मतिः || 70 ||',
  'translation':
      'And one who studies this sacred dialogue of ours worships Me through the sacrifice of knowledge — this is My conviction.',
  'word_meaning':
      'अध्येष्यते—will study; च—and; यः—who; इमम्—this; धर्म्यम्—sacred; संवादम्—conversation; आवयोः—between us two; ज्ञान यज्ञेन—by the sacrifice of knowledge; तेन—by him; अहम्—I; इष्टः—am worshiped; स्याम्—I become; इति—thus; मे—My; मतिः—opinion.',
  'commentary':
      'Reading or studying the Gita with reverence is an act of worship in itself. Through understanding, one performs the yajña of wisdom that pleases the Lord.'
});

await db.insert('chapter_18', {
  'verse_number': 71,
  'sanskrit':
      'श्रद्धावाननसूयश्च शृणुयादपि यो नरः | सोऽपि मुक्तः शुभाँल्लोकान्प्राप्नुयात्पुण्यकर्मणाम् || 71 ||',
  'translation':
      'Even the man who listens with faith and without envy, even he, being free from sin, shall attain to the auspicious worlds of the pious.',
  'word_meaning':
      'श्रद्धावान्—full of faith; अनसूयः—without envy; च—and; शृणुयात्—may hear; अपि—even; यः—who; नरः—man; सः—he; अपि—even; मुक्तः—liberated; शुभान्—auspicious; लोकान्—worlds; प्राप्नुयात्—shall attain; पुण्यकर्मणाम्—of the pious.',
  'commentary':
      'Even listening to the Gita with devotion and without criticism grants merit and liberation, leading one toward higher realms of righteousness.',
});

await db.insert('chapter_18', {
  'verse_number': 72,
  'sanskrit':
      'कच्चिदेतच्छ्रुतं पार्थ त्वयैकाग्रेण चेतसा | कच्चिदज्ञानसंमोहः प्रनष्टस्ते धनञ्जय || 72 ||',
  'translation':
      'O Partha, has this been heard by you with a one-pointed mind? Has your delusion born of ignorance been destroyed, O Dhananjaya?',
  'word_meaning':
      'कच्चित्—whether; एतत्—this; श्रुतम्—heard; पार्थ—O son of Pritha; त्वया—by you; एकाग्रेण—with a concentrated; चेतसा—mind; कच्चित्—whether; अज्ञान—ignorance; संमोहः—delusion; प्रनष्टः—destroyed; ते—your; धनञ्जय—O Arjuna.',
  'commentary':
      'After delivering His teachings, Krishna gently asks Arjuna if his confusion and delusion have been removed, symbolizing the teacher’s compassion and concern.',
});

await db.insert('chapter_18', {
  'verse_number': 73,
  'sanskrit':
      'अर्जुन उवाच | नष्टो मोहः स्मृतिर्लब्धा त्वत्प्रसादान्मयाच्युत | स्थितोऽस्मि गतसन्देहः करिष्ये वचनं तव || 73 ||',
  'translation':
      'Arjuna said: My delusion is destroyed, and I have regained memory through Your grace, O Achyuta. I am firm and free from doubt; I will act according to Your word.',
  'word_meaning':
      'अर्जुन उवाच—Arjuna said; नष्टः—destroyed; मोहः—delusion; स्मृतिः—memory; लब्धा—regained; त्वत्—Your; प्रसादात्—by grace; मया—by me; अच्युत—O Krishna; स्थितः अस्मि—I stand firm; गतसन्देहः—free from doubt; करिष्ये—I shall act; वचनम्—word; तव—Your.',
  'commentary':
      'Arjuna’s realization marks the transformation from confusion to clarity. Enlightened by Krishna’s wisdom, he resolves to fulfill his duty as a warrior.',
});

await db.insert('chapter_18', {
  'verse_number': 74,
  'sanskrit':
      'सञ्जय उवाच | इत्यहं वासुदेवस्य पार्थस्य च महात्मनः | संवादमिममश्रौषमद्भुतं रोमहर्षणम् || 74 ||',
  'translation':
      'Sanjaya said: Thus have I heard this wonderful and thrilling dialogue between the great-souled Krishna and Arjuna, the son of Pritha.',
  'word_meaning':
      'सञ्जय उवाच—Sanjaya said; इति—thus; अहम्—I; वासुदेवस्य—of Krishna; पार्थस्य—of Arjuna; च—and; महात्मनः—great-souled; संवादम्—dialogue; इमम्—this; अश्रौषम्—heard; अद्भुतम्—wonderful; रोमहर्षणम्—hair-raising.',
  'commentary':
      'Sanjaya, the divine seer, expresses awe and reverence for the divine conversation that inspires devotion and spiritual wonder.',
});

await db.insert('chapter_18', {
  'verse_number': 75,
  'sanskrit':
      'व्यासप्रसादाच्छ्रुतवानेतद्गुह्यमहं परम् | योगं योगेश्वरात्कृष्णात्साक्षात्कथयतः स्वयम् || 75 ||',
  'translation':
      'Through the grace of Vyasa, I have heard this supreme and most secret Yoga, directly from Krishna, the Lord of Yoga, Himself declaring it.',
  'word_meaning':
      'व्यास—Vyasa; प्रसादात्—by grace; श्रुतवान्—have heard; एतत्—this; गुह्यम्—secret; अहम्—I; परम्—supreme; योगम्—Yoga; योगेश्वरात्—from the Lord of Yoga; कृष्णात्—from Krishna; साक्षात्—directly; कथयतः—speaking; स्वयम्—Himself.',
  'commentary':
      'Sanjaya acknowledges that his ability to hear this divine discourse was due to Sage Vyasa’s blessing, showing humility and gratitude.',
});

await db.insert('chapter_18', {
  'verse_number': 76,
  'sanskrit':
      'राजन्संस्मृत्य संस्मृत्य संवादमिममद्भुतम् | केशवार्जुनयोः पुण्यं हृष्यामि च मुहुर्मुहुः || 76 ||',
  'translation':
      'O King, as I repeatedly recall this marvelous and holy dialogue between Keshava and Arjuna, I rejoice again and again.',
  'word_meaning':
      'राजन्—O King; संस्मृत्य—remembering; संवादम्—dialogue; इमम्—this; अद्भुतम्—wonderful; केशव—Krishna; अर्जुनयोः—of Arjuna; पुण्यम्—holy; हृष्यामि—I rejoice; मुहुः मुहुः—again and again.',
  'commentary':
      'Sanjaya describes the joy and upliftment he experiences each time he recalls the sacred conversation, emphasizing its divine purity and power.',
});

await db.insert('chapter_18', {
  'verse_number': 77,
  'sanskrit':
      'तच्च संस्मृत्य संस्मृत्य रूपमत्यद्भुतं हरेः | विस्मयो मे महान् राजन्हृष्यामि च पुनः पुनः || 77 ||',
  'translation':
      'And remembering again and again that most wondrous form of Hari, great is my astonishment, and I rejoice again and again, O King.',
  'word_meaning':
      'तत्—that; संस्मृत्य—remembering; रूपम्—form; अत्यद्भुतम्—most wonderful; हरेः—of Krishna; विस्मयः—astonishment; मे—my; महान्—great; राजन्—O King; हृष्यामि—I rejoice; पुनः पुनः—again and again.',
  'commentary':
      'The vision of Krishna’s divine form remains vividly imprinted in Sanjaya’s mind, filling him with both wonder and devotion.',
});

await db.insert('chapter_18', {
  'verse_number': 78,
  'sanskrit':
      'यत्र योगेश्वरः कृष्णो यत्र पार्थो धनुर्धरः | तत्र श्रीर्विजयो भूतिर्ध्रुवा नीतिर्मतिर्मम || 78 ||',
  'translation':
      'Wherever there is Krishna, the Lord of Yoga, and wherever there is Arjuna, the wielder of the bow, there will surely be prosperity, victory, happiness, and firm morality — this is my conviction.',
  'word_meaning':
      'यत्र—wherever; योगेश्वरः—Lord of Yoga; कृष्णः—Krishna; यत्र—wherever; पार्थः—Arjuna; धनुर्धरः—wielder of the bow; तत्र—there; श्रीः—prosperity; विजयः—victory; भूतिः—happiness; ध्रुवा—certain; नीतिः—morality; मतिः मम—this is my opinion.',
  'commentary':
      'The Gita concludes with this powerful affirmation: wherever divine wisdom (Krishna) and righteous action (Arjuna) unite, success and virtue are assured.',
});

  }
  // --- INSERT CHAPTER METADATA ---
  Future<void> _insertInitialChapters(Database db) async {
    final chaptersData = [
      {
        'chapter_number': 1,
        'chapter_name': 'Arjun Viṣhād Yog',
        'chapter_name_sanskrit': 'अर्जुनविषादयोग',
        'summary':
            'Arjuna’s despondency and moral confusion on the battlefield of Kurukshetra.',
        'total_verses': 47,
        'completed_percentage': 8,
      },
      {
        'chapter_number': 2,
        'chapter_name': 'Sānkhya Yog',
        'chapter_name_sanskrit': 'सांख्ययोग',
        'summary':
            'Krishna explains the eternal nature of the soul and introduces the concept of selfless action.',
        'total_verses': 72,
      },
      {
        'chapter_number': 3,
        'chapter_name': 'Karm Yog',
        'chapter_name_sanskrit': 'कर्मयोग',
        'summary':
            'The path of action — Krishna advises Arjuna to act selflessly without attachment to results.',
        'total_verses': 43,
      },
      {
        'chapter_number': 4,
        'chapter_name': 'Jñāna Karma Sanyās Yog',
        'chapter_name_sanskrit': 'ज्ञानकर्मसंन्यासयोग',
        'summary':
            'Krishna explains divine knowledge and the purpose of karma.',
        'total_verses': 42,
      },
      {
        'chapter_number': 5,
        'chapter_name': 'Karma Sanyās Yog',
        'chapter_name_sanskrit': 'कर्मसंन्यासयोग',
        'summary':
            'The Yoga of Renunciation — Krishna explains detachment from fruits of action.',
        'total_verses': 29,
        'completed_percentage': 55,
      },
      {
        'chapter_number': 6,
        'chapter_name': 'Dhyān Yog',
        'chapter_name_sanskrit': 'ध्यानयोग',
        'summary':
            'Krishna describes discipline of the mind and meditation practices.',
        'total_verses': 47,
      },
      {
        'chapter_number': 7,
        'chapter_name': 'Jñān Vijñān Yog',
        'chapter_name_sanskrit': 'ज्ञानविज्ञानयोग',
        'summary':
            'Krishna reveals his divine nature and the knowledge of both material and spiritual aspects.',
        'total_verses': 30,
      },
      {
        'chapter_number': 8,
        'chapter_name': 'Akṣhar Brahma Yog',
        'chapter_name_sanskrit': 'अक्षरब्रह्मयोग',
        'summary':
            'The path to the imperishable Brahman and the process of remembering God at death.',
        'total_verses': 28,
      },
      {
        'chapter_number': 9,
        'chapter_name': 'Rājavidyā Rājaguhya Yog',
        'chapter_name_sanskrit': 'राजविद्याराजगुह्ययोग',
        'summary':
            'The Yoga of Royal Knowledge and Royal Secret — the greatness of devotion to Krishna.',
        'total_verses': 34,
      },
      {
        'chapter_number': 10,
        'chapter_name': 'Vibhūti Yog',
        'chapter_name_sanskrit': 'विभूतियोग',
        'summary':
            'Krishna describes his divine manifestations and opulences throughout creation.',
        'total_verses': 42,
      },
      {
        'chapter_number': 11,
        'chapter_name': 'Vishwaroop Darshan Yog',
        'chapter_name_sanskrit': 'विश्वरूपदर्शनयोग',
        'summary':
            'Arjuna is granted divine vision and witnesses Krishna’s universal cosmic form.',
        'total_verses': 55,
      },
      {
        'chapter_number': 12,
        'chapter_name': 'Bhakti Yog',
        'chapter_name_sanskrit': 'भक्तियोग',
        'summary':
            'The path of devotion — Krishna explains the qualities of true devotees.',
        'total_verses': 20,
      },
      {
        'chapter_number': 13,
        'chapter_name': 'Kṣhetra Kṣhetrajña Vibhaag Yog',
        'chapter_name_sanskrit': 'क्षेत्रक्षेत्रज्ञविभागयोग',
        'summary':
            'Explains the field (body) and the knower of the field (soul).',
        'total_verses': 35,
      },
      {
        'chapter_number': 14,
        'chapter_name': 'Guṇatraya Vibhaag Yog',
        'chapter_name_sanskrit': 'गुणत्रयविभागयोग',
        'summary':
            'Krishna describes the three modes of material nature: sattva, rajas, and tamas.',
        'total_verses': 27,
      },
      {
        'chapter_number': 15,
        'chapter_name': 'Puruṣhottam Yog',
        'chapter_name_sanskrit': 'पुरुषोत्तमयोग',
        'summary':
            'The Supreme Divine Personality — Krishna describes the eternal tree of life and ultimate reality.',
        'total_verses': 20,
      },
      {
        'chapter_number': 16,
        'chapter_name': 'Daivāsur Sampad Vibhaag Yog',
        'chapter_name_sanskrit': 'दैवासुरसम्पद्विभागयोग',
        'summary':
            'The difference between divine and demoniac natures in humans.',
        'total_verses': 24,
      },
      {
        'chapter_number': 17,
        'chapter_name': 'Śhraddhātray Vibhaag Yog',
        'chapter_name_sanskrit': 'श्रद्धात्रयविभागयोग',
        'summary':
            'Classification of faith and how it affects food, sacrifice, and austerity.',
        'total_verses': 28,
      },
      {
        'chapter_number': 18,
        'chapter_name': 'Mokṣha Sanyās Yog',
        'chapter_name_sanskrit': 'मोक्षसंन्यासयोग',
        'summary':
            'Final teachings summarizing renunciation, knowledge, and liberation.',
        'total_verses': 78,
      },
    ];

    for (final chapter in chaptersData) {
      await db.insert('chapters', chapter);
    }
  }

  // --- FETCH ALL CHAPTERS ---
  Future<List<Chapter>> fetchAllChapters() async {
    final db = await instance.database;
    final maps = await db.query('chapters', orderBy: 'chapter_number ASC');
    return List.generate(maps.length, (i) => Chapter.fromMap(maps[i]));
  }

  // --- FETCH VERSES OF A GIVEN CHAPTER ---
  Future<List<Verse>> fetchChapterVerses(int chapterNumber) async {
    final db = await instance.database;
    final tableName = 'chapter_$chapterNumber';
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'verse_number ASC',
    );

    // Convert List<Map> to List<Verse>
    return List.generate(maps.length, (i) => Verse.fromMap(maps[i]));
  }

  // --- CLOSE DATABASE ---
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
