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
