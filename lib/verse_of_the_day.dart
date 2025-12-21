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
    {
  'ref': 'BG 2.48',
  'text':
      'Be steadfast in yoga, perform your duty and abandon attachment to success or failure.',
},
{
  'ref': 'BG 2.50',
  'text':
      'A person engaged in devotional service rids himself of both good and bad actions.',
},
{
  'ref': 'BG 3.19',
  'text':
      'Therefore, without attachment, perform your duty, for by working without attachment one attains the Supreme.',
},
{
  'ref': 'BG 4.7',
  'text':
      'Whenever there is a decline in righteousness and an increase in unrighteousness, I manifest Myself.',
},
{
  'ref': 'BG 4.38',
  'text':
      'In this world, there is nothing so purifying as knowledge.',
},
{
  'ref': 'BG 5.22',
  'text':
      'Pleasures born of sense contact are sources of suffering and have a beginning and an end.',
},
{
  'ref': 'BG 6.5',
  'text':
      'Let a man lift himself by his own self alone, and let him not lower himself.',
},
{
  'ref': 'BG 6.6',
  'text':
      'For one who has conquered the mind, the mind is the best of friends.',
},
{
  'ref': 'BG 6.19',
  'text':
      'Just as a lamp in a windless place does not flicker, so the disciplined mind remains steady in meditation.',
},
{
  'ref': 'BG 7.14',
  'text':
      'This divine energy of Mine is difficult to overcome, but those who surrender unto Me cross beyond it.',
},
{
  'ref': 'BG 9.22',
  'text':
      'To those who are constantly devoted and worship Me with love, I give the understanding by which they can come to Me.',
},
{
  'ref': 'BG 9.34',
  'text':
      'Engage your mind always in thinking of Me, become My devotee, worship Me, and offer obeisance to Me.',
},
{
  'ref': 'BG 10.8',
  'text':
      'I am the source of all spiritual and material worlds. Everything emanates from Me.',
},
{
  'ref': 'BG 12.15',
  'text':
      'One who is not disturbed by others and does not disturb others is very dear to Me.',
},
{
  'ref': 'BG 12.16',
  'text':
      'One who is free from dependence, pure, expert, impartial, and free from anxiety is dear to Me.',
},
{
  'ref': 'BG 13.8',
  'text':
      'Humility, tolerance, simplicity, purity, and self-control are the qualities of true knowledge.',
},
{
  'ref': 'BG 16.3',
  'text':
      'Nonviolence, truthfulness, freedom from anger, and compassion are divine qualities.',
},
{
  'ref': 'BG 18.58',
  'text':
      'If you become conscious of Me, you will pass over all obstacles by My grace.',
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
