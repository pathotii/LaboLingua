import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/login/login_view.dart';
import 'package:library_app/teacher_side/teacher_proponents.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SQFLite/database_helper.dart';
import '../bookmark_provider.dart';
import 'approved_notes.dart';
import 'pending_view.dart';
import 'teacher_home.dart';
import 'teacher_view_words.dart';

class TeacherSideBalbal extends StatefulWidget {
  final String category;

  const TeacherSideBalbal({super.key, required this.category});

  @override
  State<TeacherSideBalbal> createState() => _TeacherSideBalbalState();
}

class _TeacherSideBalbalState extends State<TeacherSideBalbal> {
  final List<Map<String, String>> _preSavedItems = [
    {
      'word': 'Abnoy',
      'definitionLabo': '',
      'definitionFilipino': 'hindi normal',
      'definitionEnglish': 'abnormal',
      'audio': 'assets/audio/Abnoy B_20241124_202928.mp3'
    },
    {
      'word': 'Tarak',
      'definitionLabo': '',
      'definitionFilipino': 'tirik ang mata',
      'definitionEnglish': 'white out',
      'audio': 'assets/audio/Tarak B_20241124_202851.mp3'
    },
    {
      'word': 'Kuspad',
      'definitionLabo': '',
      'definitionFilipino': 'kuto, lisa',
      'definitionEnglish': 'lice',
      'audio': 'assets/audio/Kuspad B_20241124_235015.mp3'
    },
    {
      'word': 'Sagmaw',
      'definitionLabo': '',
      'definitionFilipino': 'kaning baboy',
      'definitionEnglish': 'pigs food',
      'audio': 'assets/audio/Sagmaw B_20241124_202825.mp3'
    },
    {
      'word': 'Ruso',
      'definitionLabo': '',
      'definitionFilipino': 'lugi, hindi kumita',
      'definitionEnglish': 'loss',
      'audio': 'assets/audio/Ruso B_20241124_202759.mp3'
    },
    {
      'word': 'Puaw',
      'definitionLabo': '',
      'definitionFilipino': 'isang mangmang o tanga',
      'definitionEnglish': 'a stupid fool',
      'audio': 'assets/audio/Puaw B_20241124_125855.mp3'
    },
    {
      'word': 'Guslok',
      'definitionLabo': '',
      'definitionFilipino': 'gabing-gabi na kung umuwi',
      'definitionEnglish': 'very late at night',
      'audio': 'assets/audio/Guslok B_20241124_234932.mp3'
    },
    {
      'word': 'lablab/Lag-ok',
      'definitionLabo': '',
      'definitionFilipino': 'pag-inom ng tubig',
      'definitionEnglish': 'drinking water',
      'audio': 'assets/audio/Lablab o Lag-ok B_20241124_235020.mp3'
    },
    {
      'word': 'anakin',
      'definitionLabo': '',
      'definitionFilipino': 'sabi ko',
      'definitionEnglish': '"i said"',
      'audio': 'assets/audio/Anakin B_20241123_202417.mp3'
    },
    {
      'word': 'gurabhal',
      'definitionLabo': '',
      'definitionFilipino': 'rough',
      'definitionEnglish': 'magaspang',
      'audio': 'assets/audio/Gurabhal B_20241124_234929.mp3'
    },
    {
      'word': 'kuramos',
      'definitionLabo': '',
      'definitionFilipino': 'lamukot',
      'definitionEnglish': 'to crumple',
      'audio': 'assets/audio/Kuramos B_20241124_235008.mp3'
    },
    {
      'word': 'kuripas',
      'definitionLabo': '',
      'definitionFilipino': 'mabilis na pagtakbo',
      'definitionEnglish': 'quick running',
      'audio': 'assets/audio/Kuripas B_20241124_235010.mp3'
    },
    {
      'word': 'wiri-wiri',
      'definitionLabo': '',
      'definitionFilipino': 'nalilito',
      'definitionEnglish': 'confused',
      'audio': 'assets/audio/Wiri-wiri B_20241123_202430.mp3'
    },
    {
      'word': 'punete',
      'definitionLabo': '',
      'definitionFilipino': 'pagsuntok',
      'definitionEnglish': 'a punch',
      'audio': 'assets/audio/Punete B_20241123_202427.mp3'
    },
    {
      'word': 'Abhaw',
      'definitionLabo': '',
      'definitionFilipino': 'mayabang',
      'definitionEnglish': 'boastful',
      'audio': 'assets/audio/Abhaw B_20241124_130210.mp3'
    },
    {
      'word': 'Agok',
      'definitionLabo': '',
      'definitionFilipino': 'bilasang isda',
      'definitionEnglish': 'rotten fish',
      'audio': 'assets/audio/Agok B_20241124_204117.mp3'
    },
    {
      'word': 'Dalihin',
      'definitionLabo': '',
      'definitionFilipino': 'tirahin',
      'definitionEnglish': 'to strike/shoot',
      'audio': 'assets/audio/Dalihin B_20241124_203235.mp3'
    },
    {
      'word': 'karot',
      'definitionLabo': '',
      'definitionFilipino': 'kalbo',
      'definitionEnglish': 'bald',
      'audio': 'assets/audio/Karot B_20241124_235002.mp3'
    },
    {
      'word': 'lasngag',
      'definitionLabo': '',
      'definitionFilipino': 'lasing',
      'definitionEnglish': 'intoxicated',
      'audio': 'assets/audio/Lasngag B_20241124_235029.mp3'
    },
    {
      'word': 'libak',
      'definitionLabo': '',
      'definitionFilipino': 'tsismis',
      'definitionEnglish': 'gossip',
      'audio': 'assets/audio/Libak B_20241124_235038.mp3'
    },
    {
      'word': 'luki',
      'definitionLabo': '',
      'definitionFilipino': 'sira-ulo, lukarit',
      'definitionEnglish': 'crazy',
      'audio': 'assets/audio/Luki B_20241124_235049.mp3'
    },
    {
      'word': 'bagrat',
      'definitionLabo': '',
      'definitionFilipino': 'malakas na hangin at ulan',
      'definitionEnglish': 'strong wind and rain',
      'audio': 'assets/audio/Bagrat B_20241124_130225.mp3'
    },
    {
      'word': 'ulbot',
      'definitionLabo': '',
      'definitionFilipino': 'mayabang',
      'definitionEnglish': 'braggart',
      'audio': 'assets/audio/Ulbot B_20241123_202250.mp3'
    },
    {
      'word': 'Bagunitan',
      'definitionLabo': '',
      'definitionFilipino': 'tumutukoy sa isang lalaki na kayang tiisin ang pinakamatitinding suntok',
      'definitionEnglish': 'refers to a male whose body can take the hardest punches',
      "audio": "assets/audio/Bagunitan B_20241123_202005.mp3"
    },    
    {
      'word': 'ugsak',
      'definitionLabo': '',
      'definitionFilipino': 'pukpukin o patamaan ng isang bagay',
      'definitionEnglish': 'hit with',
      "audio": "assets/audio/Ugsak L_20241124_202857.mp3"
    },
    {
      'word': 'Garutay',
      'definitionLabo': '',
      'definitionFilipino': 'babaeng makiri, talipandas',
      'definitionEnglish': 'flirtatious woman, hussy',
      'audio': 'assets/audio/Garutay B_20241124_234839.mp3'
    },
    {
      'word': 'wakwak',
      'definitionLabo': '',
      'definitionFilipino': 'punit na malaki',
      'definitionEnglish': 'torn widely',
      'audio': 'assets/audio/Wakwak B_20241123_202254.mp3'
    },
    {
      'word': 'wating-wating',
      'definitionLabo': '',
      'definitionFilipino': 'nahihilo',
      'definitionEnglish': 'groggy',
      'audio': 'assets/audio/Wating-wating B_20241123_202257.mp3'
    },
    {
      'word': 'git-il',
      'definitionLabo': '',
      'definitionFilipino': 'paglalandi',
      'definitionEnglish': 'to urge to flirt',
      'audio': 'assets/audio/Git-il B_20241124_130119.mp3'
    },
    {
      'word': 'kaybot',
      'definitionLabo': '',
      'definitionFilipino': 'kalkalin',
      'definitionEnglish': 'to rummage',
      'audio': 'assets/audio/Kaybot B_20241124_130343.mp3'
    },
    {
      'word': 'duridot',
      'definitionLabo': '',
      'definitionFilipino':
          'paikutin ang isang daliri o bagay sa loob ng butas',
      'definitionEnglish': 'rotate a finger or an object inside the hole.',
      'audio': 'assets/audio/Duridot B_20241124_130426.mp3'
    },
    {
      'word': 'muraskas',
      'definitionLabo': '',
      'definitionFilipino': 'salitang malakas',
      'definitionEnglish': 'talking loud',
      'audio': 'assets/audio/Muraskas B_20241124_202611.mp3'
    },
    {
      'word': 'mug-ak',
      'definitionLabo': '',
      'definitionFilipino': 'puno ang bibig',
      'definitionEnglish': 'mouth full',
      'audio': 'assets/audio/Mug-ak B_20241124_202613.mp3'
    },
    {
      'word': 'nak-nak',
      'definitionLabo': '',
      'definitionFilipino': 'nagtutubig na sugat',
      'definitionEnglish': 'weeping wound',
      'audio': 'assets/audio/Naknak B_20241124_202632.mp3'
    },
    {
      'word': 'nami',
      'definitionLabo': '',
      'definitionFilipino': 'nakaw',
      'definitionEnglish': 'steal',
      'audio': 'assets/audio/Nami B_20241124_202639.mp3'
    },
    {
      'word': 'ngar-ot',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': 'bite',
      'audio': 'assets/audio/Ngar-ot B_20241123_202140.mp3'
    },
    {
      'word': 'taya pato',
      'definitionLabo': '',
      'definitionFilipino': 'todo, ubos kung ubos',
      'definitionEnglish': 'everything all in',
      'audio': 'assets/audio/Taya Pato B_20241124_202841.mp3'
    },
    {
      'word': 'tusik',
      'definitionLabo': '',
      'definitionFilipino': 'lasing',
      'definitionEnglish': 'drunk',
      'audio': 'assets/audio/Tusik B_20241124_202843.mp3'
    },
    {
      'word': 'uldot',
      'definitionLabo': '',
      'definitionFilipino': 'nakausli',
      'definitionEnglish': 'protruding',
      'audio': 'assets/audio/Uldot B_20241123_202246.mp3'
    },
    {
      'word': 'ukrong',
      'definitionLabo': '',
      'definitionFilipino': 'atras, umurong',
      'definitionEnglish': 'reverse',
      'audio': 'assets/audio/Ukrong B_20241124_202904.mp3'
    },
    {
      'word': 'wagak',
      'definitionLabo': '',
      'definitionFilipino': 'lasing',
      'definitionEnglish': 'drunk',
      'audio': 'assets/audio/Wagak B_20241124_202917.mp3'
    },
    {
      'word': 'wat-wat',
      'definitionLabo': '',
      'definitionFilipino': 'linisin',
      'definitionEnglish': 'clean up',
      'audio': 'assets/audio/Wat-wat B_20241124_202921.mp3'
    },
    {
      'word': 'watik-watik',
      'definitionLabo': '',
      'definitionFilipino': 'biglaang pagtapon',
      'definitionEnglish': 'discard abruptly',
      'audio': 'assets/audio/Watik-watik B_20241124_202923.mp3'
    },
    {
      'word': 'ya, di baya',
      'definitionLabo': '',
      'definitionFilipino': 'hindi naman',
      'definitionEnglish': 'not really',
      'audio': 'assets/audio/Ya, di baya B_20241124_202924.mp3'
    },
    {
      'word': 'buta',
      'definitionLabo': '',
      'definitionFilipino': 'naalis sa larong baraha',
      'definitionEnglish': 'ousted (in game of cards)',
      'audio': 'assets/audio/Buta B_20241124_130148.mp3'
    },
    {
      'word': 'gabsuk',
      'definitionLabo': '',
      'definitionFilipino': 'madilim, takipsilim',
      'definitionEnglish': 'dark; night fall',
      'audio': 'assets/audio/Gabsuk B_20241124_130146.mp3'
    },
    {
      'word': 'hapagin',
      'definitionLabo': '',
      'definitionFilipino': 'humabol',
      'definitionEnglish': 'to run after',
      'audio': 'assets/audio/Hapagin B_20241124_125913.mp3'
    },
    {
      'word': 'hagpok',
      'definitionLabo': '',
      'definitionFilipino': 'tanga, walang alam',
      'definitionEnglish': 'fool',
      'audio': 'assets/audio/Hagpok B_20241124_234936.mp3'
    },
    {
      'word': 'uraol',
      'definitionLabo': '',
      'definitionFilipino': 'isang nakakatakot na iyak',
      'definitionEnglish': 'a haunting cry',
      'audio': 'assets/audio/Uraol B_20241123_202244.mp3'
    },
    {
      'word': 'tir-is',
      'definitionLabo': '',
      'definitionFilipino': 'pag-ihi',
      'definitionEnglish': 'urination',
      'audio': 'assets/audio/Tir-is B_20241123_202231.mp3'
    },
    {
      'word': 'sugot',
      'definitionLabo': '',
      'definitionFilipino': 'isang tao na mabilis na nang-aasar ng iba',
      'definitionEnglish': 'a person who instantly needles another',
      'audio': 'assets/audio/Sugot B_20241123_202216.mp3'
    },
    {
      'word': 'pangag',
      'definitionLabo': '',
      'definitionFilipino': 'isang mangmang',
      'definitionEnglish': 'a fool',
      'audio': 'assets/audio/Pangag B_20241123_202201.mp3'
    },
    {
      'word': 'puklay',
      'definitionLabo': '',
      'definitionFilipino': 'isang kalagayan ng panghihina at lungkot',
      'definitionEnglish': 'a forlorn and weak condition',
      'audio': 'assets/audio/Puklay B_20241123_202156.mp3'
    },
    {
      'word': 'ngak-ngak',
      'definitionLabo': '',
      'definitionFilipino': 'ang kilos ng pagsasalita habang bukas ang bibig',
      'definitionEnglish': 'the act of talking with the mouth open',
      'audio': 'assets/audio/Ngak-ngak B_20241123_202142.mp3'
    },
    {
      'word': 'nguraol',
      'definitionLabo': '',
      'definitionFilipino': 'matagal at mahabang pag-iyak',
      'definitionEnglish': 'a long, prolonged crying',
      'audio': 'assets/audio/Nguraol B_20241123_202109.mp3'
    },
    {
      'word': 'maragamo',
      'definitionLabo': '',
      'definitionFilipino':
          'tunog ng pagputok o pagtunog ng pagkain sa loob ng bibig',
      'definitionEnglish': 'cracking sound of food inside the mouth',
      'audio': 'assets/audio/Maragamo B_20241123_202109.mp3'
    },
    {
      'word': 'la-pak',
      'definitionLabo': '',
      'definitionFilipino': 'bahagyang sampal',
      'definitionEnglish': 'a light slap',
      'audio': 'assets/audio/Lapak B_20241123_202107.mp3'
    },
    {
      'word': 'lagmak',
      'definitionLabo': '',
      'definitionFilipino': 'pag-upo nang may kabigatan sa puwitan',
      'definitionEnglish': "down on one's behind",
      'audio': 'assets/audio/Lagmak B_20241123_202105.mp3'
    },
    {
      'word': 'haro',
      'definitionLabo': '',
      'definitionFilipino': 'madamot',
      'definitionEnglish':
          'a person clinging to some possession rather childishly',
      'audio': 'assets/audio/Haro B_20241123_202047.mp3'
    },
    {
      'word': 'hablo',
      'definitionLabo': '',
      'definitionFilipino': 'ang kilos ng paglamon ng pagkain',
      'definitionEnglish': 'the act of gobbling up food',
      'audio': 'assets/audio/Hablo B_20241123_202051.mp3'
    },
    {
      'word': 'gaot',
      'definitionLabo': '',
      'definitionFilipino': 'sira-sira o punit-punit',
      'definitionEnglish': 'hard penetration',
      'audio': 'assets/audio/Gaot B_20241123_202045.mp3'
    },
    {
      'word': 'guray-guray',
      'definitionLabo': '',
      'definitionFilipino': 'sira-sira o punit-punit',
      'definitionEnglish': 'tattered',
      'audio': 'assets/audio/Guray-guray B_20241123_202043.mp3'
    },
    {
      'word': 'gumsa',
      'definitionLabo': '',
      'definitionFilipino': 'gumos, piga',
      'definitionEnglish': 'mashing',
      'audio': 'assets/audio/Gumsa B_20241123_202041.mp3'
    },
    {
      'word': 'gunit',
      'definitionLabo': '',
      'definitionFilipino': 'paghila sa buhok',
      'definitionEnglish': 'hair-pulling',
      'audio': 'assets/audio/Gunit B_20241123_202037.mp3'
    },
    {
      'word': 'gul-ok',
      'definitionLabo': '',
      'definitionFilipino':
          'akto ng pisikal na pag-pwersa sa kalaban sa pamamagitan ng pagsakal sa leeg o kamay',
      'definitionEnglish':
          'the act of physically overpowering a foe by wringing the neck or the hand mashing',
      'audio': 'assets/audio/Gul-ok B_20241123_202039.mp3'
    },
    {
      'word': 'bagaok',
      'definitionLabo': '',
      'definitionFilipino': 'pagbagsak nang may tunog',
      'definitionEnglish': 'falls with a thud',
      'audio': 'assets/audio/Bagaok B_20241123_202009.mp3'
    },
    {
      'word': 'busngal',
      'definitionLabo': '',
      'definitionFilipino': 'suntok sa bibig',
      'definitionEnglish': 'punch in the mouth',
      'audio': 'assets/audio/Busngal B_20241123_202013.mp3'
    },
  ];

  List<Map<String, dynamic>> _savedWords = [];
  List<String> _bookmarkedWords = [];
  String _searchQuery = '';
  List<Map<String, dynamic>> _approvedWords = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedWords();
    _fetchApprovedWords();
    _printAllWords();
  }

  Future<void> _printAllWords() async {
    try {
      final words = await DatabaseHelper().fetchAllWords();
      print('All words in the notes table:');
      for (var word in words) {
        print(word['word']); // Adjust the key if necessary
      }
    } catch (e) {
      print('Failed to fetch words: $e');
    }
  }

  Future<void> _fetchApprovedWords() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('approved_words')
          .where('status', isEqualTo: 'approved') // Only approved words
          .where('category', isEqualTo: 'Balbal') // Only Kolokyal category
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No approved Kolokyal words found.");
      }

      // Log the fetched documents to confirm the word is coming through
      for (var doc in querySnapshot.docs) {
        print("Fetched word from Firestore: ${doc.data()}");
      }

      setState(() {
        _approvedWords = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'word': data['word'],
            'definitionLabo': data['definitionLabo'],
            'definitionFilipino': data['definitionFilipino'],
            'definitionEnglish': data['definitionEnglish'],
            'studentName': data['studentName'],
            'audioFilePath': data['audioFilePath'],
            'status': data['status'],
            'category': data['category'],
          };
        }).toList();

        _approvedWords
            .sort((a, b) => (a['word'] ?? '').compareTo(b['word'] ?? ''));
      });
    } catch (e) {
      print('Error fetching approved Kolokyal words: $e');
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _loadBookmarkedWords() async {
    try {
      final bookmarks = await DatabaseHelper().getBookmarkedWords();
      setState(() {
        _bookmarkedWords =
            bookmarks.map((bookmark) => bookmark['word'] as String).toList();
      });
    } catch (e) {
      print('Failed to load bookmarked words: $e');
    }
  }

  Future<void> _loadWordsFromDatabase([String? newWord]) async {
    final words = await DatabaseHelper().fetchWords();
    print('Fetched words from database: $words');

    setState(() {
      _savedWords = words.map((word) {
        return {
          'id': word['id'],
          'word': word['word'],
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
          'audioFilePath': word['audioFilePath'],
        };
      }).toList();

      // If there is a new word, append it to the end
      if (newWord != null && newWord.isNotEmpty) {
        _savedWords.add({
          'word': newWord,
          'definitionLabo': '',
          'definitionFilipino': '',
          'definitionEnglish': '',
          'audioFilePath': '',
        });
      }
    });
  }

  Future<void> _bookmarkWord(Map<String, dynamic> word) async {
    final provider = context.read<BookmarkProvider>();

    // Ensure the word key is present
    if (word['word'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word is missing. Cannot bookmark.')),
      );
      return;
    }

    String wordText = word['word']; // Get the word text
    int wordId =
        word['id'] ?? DateTime.now().millisecondsSinceEpoch; // Generate an ID

    // Check if the word is already bookmarked using the provider
    bool isBookmarked = provider.isBookmarked(wordId);

    try {
      if (!isBookmarked) {
        // If not bookmarked, proceed to bookmark
        await DatabaseHelper().insertBookmark({
          'id': wordId,
          'word': wordText,
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
        });

        provider.addBookmark({
          'id': wordId,
          'word': wordText,
          'definitionLabo': word['definitionLabo'],
          'definitionFilipino': word['definitionFilipino'],
          'definitionEnglish': word['definitionEnglish'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word bookmarked successfully!')),
        );
      } else {
        // If already bookmarked, proceed to unbookmark
        await DatabaseHelper().removeBookmark(wordId);
        provider.removeBookmark(wordId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word unbookmarked successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [
      ..._preSavedItems,
      ..._approvedWords,
    ];

    allItems.sort((a, b) {
      final wordA = (a['word'] ?? '').toLowerCase();
      final wordB = (b['word'] ?? '').toLowerCase();
      return wordA.compareTo(wordB);
    });

    final filteredItems = allItems.where((item) {
      final word = item['word']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return word.startsWith(query);
    }).toList();

    String capitalize(String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    final capitalizedItems = filteredItems.map((item) {
      return {
        ...item,
        'word': capitalize(item['word'] ?? ''),
      };
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/POST.png', // Path to your GIF asset
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          Column(
            children: [
              // Top Container for the images, replacing the AppBar
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/LOGO.png',
                        height: 75,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 50),
                      Image.asset(
                        'assets/images/TITLE.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: _updateSearchQuery,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2.0,
                height: 25,
              ),
              Expanded(
                child: capitalizedItems.isEmpty
                    ? const Center(child: Text('No saved words'))
                    : ListView.builder(
                        itemCount: capitalizedItems.length,
                        itemBuilder: (context, index) {
                          final item = capitalizedItems[index];
                          final isBookmarked =
                              _bookmarkedWords.contains(item['word']);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                leading: const Icon(Icons.wb_sunny_outlined),
                                title: Text(
                                  item['word'] ?? 'No word',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                  onPressed: () => _bookmarkWord(item),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherViewNoteView(
                                        word: item['word'] ?? '',
                                        definitionLabo:
                                            item['definitionLabo'] ?? '',
                                        definitionFilipino:
                                            item['definitionFilipino'] ?? '',
                                        definitionEnglish:
                                            item['definitionEnglish'] ?? '',
                                        studentName: item[''] ?? '',
                                        category: widget.category,
                                        audioFilePath: item['audio'] ?? '',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black12),
                  ),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black54,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherHomeView(
                              category: '',
                            ),
                          ),
                        ).then((newWord) => _loadWordsFromDatabase(newWord));
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PendingWordsView(),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApprovedWordsView(),
                          ),
                        );
                        break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherProponents(),
                          ),
                        );
                        break;
                      case 4:
                        _handleLogout(context);
                        break;
                    }
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_max_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PendingWordsView(),
                            ),
                          );
                          _loadWordsFromDatabase();
                        },
                        child: const Icon(Icons.pending_outlined),
                      ),
                      label: 'Pending',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.approval_outlined),
                      label: 'Approved',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined),
                      label: 'Mananaliksik',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.logout_outlined),
                      label: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userType');

    // Clear navigation stack and push LoginView
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
      (route) => false,
    );
  }
}
