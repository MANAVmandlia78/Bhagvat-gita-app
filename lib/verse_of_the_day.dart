class VerseOfTheDay {
  static final List<Map<String, String>> verses = [
    {
      'ref': 'BG 2.47',
      'text':
          'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.',
    },
    {
      'ref': 'BG 6.19',
      'text':
          'Just as a lamp in a windless place does not flicker, so the disciplined mind remains steady in meditation.',
    },
    {
      'ref': 'BG 12.15',
      'text':
          'One who is not disturbed by others and does not disturb others is very dear to Me.',
    },
    {
      'ref': 'BG 18.66',
      'text':
          'Abandon all varieties of dharma and simply surrender unto Me. I shall deliver you from all fear.',
    },
  ];

  // Returns the SAME verse for the entire day
  static Map<String, String> getTodayVerse() {
    final int day = DateTime.now().day;
    final int index = day % verses.length;
    return verses[index];
  }
}
