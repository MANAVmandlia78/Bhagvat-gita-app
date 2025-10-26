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
    // await deleteDatabase(path);

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
