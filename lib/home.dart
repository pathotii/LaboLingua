import 'package:flutter/material.dart';
import 'SQFLite/database_helper.dart';
import 'bookmarked_view.dart';
import 'view_words.dart';
import 'add_note.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> _preSavedItems = [
    {
      'word': 'Awas',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'step down',
    },
    {
      'word': 'Apritado',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'madaliin',
    },
    {
      'word': 'agot-utin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'marungis',
    },
    {
      'word': 'abhaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'boastful',
    },
    {
      'word': 'aratuot',
      'definitionLabo': 'tulad ng sunod-sunod na paninigarilyo',
      'definitionFilipino': 'tulad ng sunod-sunod na paninigarilyo',
      'definitionEnglish': '',
    },
    {
      'word': 'aramusa',
      'definitionLabo':
          'iyong pagtanggap, pagbibigay ng isang bagay, karaniwan ay pera na walang pumipigil',
      'definitionFilipino':
          'iyong pagtanggap, pagbibigay ng isang bagay, karaniwan ay pera na walang pumipigil',
      'definitionEnglish': '',
    },
    {
      'word': 'agil-ilin',
      'definitionLabo': 'marumi ang pananamit/libagin',
      'definitionFilipino': 'marumi ang pananamit/libagin',
      'definitionEnglish': '',
    },
    {
      'word': 'antak',
      'definitionLabo': 'tulad ng isang sugat na napakasakit',
      'definitionFilipino': 'tulad ng isang sugat na napakasakit',
      'definitionEnglish': '',
    },
    {
      'word': 'bunhak',
      'definitionLabo': 'mataba at mayamang pagkakaayos tulad ng lupa',
      'definitionFilipino': 'mataba at mayamang pagkakaayos tulad ng lupa',
      'definitionEnglish': '',
    },
    {
      'word': 'butiktik',
      'definitionLabo': 'sobrang busog',
      'definitionFilipino': 'sobrang busog',
      'definitionEnglish': '',
    },
    {
      'word': 'bagrat',
      'definitionLabo': 'malakas na hangin at ulan',
      'definitionFilipino': 'malakas na hangin at ulan',
      'definitionEnglish': '',
    },
    {
      'word': 'bana-bana',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to think',
    },
    {
      'word': 'batikalin',
      'definitionLabo': 'pukulin',
      'definitionFilipino': 'pukulin',
      'definitionEnglish': 'to hit',
    },
    {
      'word': 'balni',
      'definitionLabo': 'napaso ng mainit na tubig',
      'definitionFilipino': 'napaso ng mainit na tubig',
      'definitionEnglish': '',
    },
    {
      'word': 'bulsot',
      'definitionLabo': '',
      'definitionFilipino': 'nahulog sa isang maliit na butas o balon',
      'definitionEnglish': '',
    },
    {
      'word': 'balubagi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'not sincere (alibi)',
    },
    {
      'word': 'bar-ao',
      'definitionLabo': '',
      'definitionFilipino': 'mahinang gumalaw',
      'definitionEnglish': '',
    },
    {
      'word': 'bulwat',
      'definitionLabo': '',
      'definitionFilipino': 'nabutas',
      'definitionEnglish': '',
    },
    {
      'word': 'bugwak',
      'definitionLabo': '',
      'definitionFilipino': 'natapon',
      'definitionEnglish': '',
    },
    {
      'word': 'balentong',
      'definitionLabo': '',
      'definitionFilipino': 'nabaliktad',
      'definitionEnglish': '',
    },
    {
      'word': 'kisot',
      'definitionLabo': '',
      'definitionFilipino': 'kagat ng bubuyog',
      'definitionEnglish': '',
    },
    {
      'word': 'kurumbot',
      'definitionLabo': '',
      'definitionFilipino': 'isang uri ng prutas na natatagpuan sa gubat',
      'definitionEnglish': '',
    },
    {
      'word': 'kawas',
      'definitionLabo': '',
      'definitionFilipino': 'maiksi o maliit',
      'definitionEnglish': '',
    },
    {
      'word': 'karaw',
      'definitionLabo': '',
      'definitionFilipino': 'kinakabahan',
      'definitionEnglish': '',
    },
    {
      'word': 'karutkot',
      'definitionLabo': '',
      'definitionFilipino': 'sayurin ang tira',
      'definitionEnglish': '',
    },
    {
      'word': 'karangkang',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'carelessly',
    },
    {
      'word': 'kurapog',
      'definitionLabo': '',
      'definitionFilipino': 'yakapin',
      'definitionEnglish': 'to hug',
    },
    {
      'word': 'ulbot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'braggart',
    },
    {
      'word': 'ukyabit',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'cling to, like a leech',
    },
    {
      'word': 'wakwak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'torn widely',
    },
    {
      'word': 'kulbo',
      'definitionLabo': '',
      'definitionFilipino': 'takbo',
      'definitionEnglish': 'darting away in a fright',
    },
    {
      'word': 'kadugin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': '',
    },
    {
      'word': 'wating-wating',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'groggy',
    },
    {
      'word': 'walang panapsi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'undiminished appetite',
    },
    {
      'word': 'iraid',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to shared off',
    },
    {
      'word': 'tagiti',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a slight drizzle',
    },
    {
      'word': 'kurimpit',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': '',
    },
    {
      'word': 'siapuan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to ignore',
    },
    {
      'word': 'riparohin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'attend to',
    },
    {
      'word': 'magnanami',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'small-time thief',
    },
    {
      'word': 'tugpa',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to land down as in river or farm',
    },
    {
      'word': 'anakin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'i said',
    },
    {
      'word': 'dasig-dasig',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'move over a little',
    },
    {
      'word': 'kulipaw',
      'definitionLabo': '',
      'definitionFilipino': 'nang-sisimot',
      'definitionEnglish': 'gold panning term',
    },
    {
      'word': 'kulibsaw',
      'definitionLabo': '',
      'definitionFilipino': 'galaw ng tubig na may isda',
      'definitionEnglish': '',
    },
    {
      'word': 'kalibkib',
      'definitionLabo': '',
      'definitionFilipino': 'kudkurin',
      'definitionEnglish': 'shred 1/4 of coconut',
    },
    {
      'word': 'kaybot',
      'definitionLabo': '',
      'definitionFilipino': 'kalkalin',
      'definitionEnglish': '',
    },
    {
      'word': 'kurumbistre',
      'definitionLabo': '',
      'definitionFilipino': 'takot',
      'definitionEnglish': 'coward',
    },
    {
      'word': 'kas-kas',
      'definitionLabo': '',
      'definitionFilipino': 'mabilis',
      'definitionEnglish': '',
    },
    {
      'word': 'kilikisi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'sparkling',
    },
    {
      'word': 'dilwat',
      'definitionLabo': '',
      'definitionFilipino': 'nakalabas ang dila',
      'definitionEnglish': '',
    },
    {
      'word': 'dasmag',
      'definitionLabo': '',
      'definitionFilipino': 'habulin, daluhungin',
      'definitionEnglish': '',
    },
    {
      'word': 'duldog',
      'definitionLabo': '',
      'definitionFilipino': 'sundot',
      'definitionEnglish': '',
    },
    {
      'word': 'dukhaw',
      'definitionLabo': '',
      'definitionFilipino': 'abutin/kuhanin',
      'definitionEnglish': '',
    },
    {
      'word': 'daphag',
      'definitionLabo': '',
      'definitionFilipino': 'daganan',
      'definitionEnglish': '',
    },
    {
      'word': 'duklat',
      'definitionLabo': '',
      'definitionFilipino': 'nasundot sa mata',
      'definitionEnglish': 'to poke the eye',
    },
    {
      'word': 'dutdot',
      'definitionLabo': '',
      'definitionFilipino': 'sawsaw',
      'definitionEnglish': '',
    },
    {
      'word': 'duridot',
      'definitionLabo': '',
      'definitionFilipino':
          'paikutin ang isang daliri o bagay sa loob ng isang butas',
      'definitionEnglish': 'to finger in, usually in hard, circling manner',
    },
    {
      'word': 'dalasang',
      'definitionLabo': '',
      'definitionFilipino': 'sagasaan',
      'definitionEnglish': '',
    },
    {
      'word': 'garaygay',
      'definitionLabo': '',
      'definitionFilipino': 'parang maton kung lumakad',
      'definitionEnglish': '',
    },
    {
      'word': 'guop',
      'definitionLabo': '',
      'definitionFilipino': 'yakap (nakakulong sa mga bisig)',
      'definitionEnglish': '',
    },
    {
      'word': 'guna-gunahin',
      'definitionLabo': '',
      'definitionFilipino': 'samantalahin',
      'definitionEnglish': '',
    },
    {
      'word': 'gut-lo',
      'definitionLabo': '',
      'definitionFilipino': 'pantal',
      'definitionEnglish': '',
    },
    {
      'word': 'galho',
      'definitionLabo': '',
      'definitionFilipino': 'dumi sa ngipin',
      'definitionEnglish': 'grease-like dirt in the teeth',
    },
    {
      'word': 'hampok',
      'definitionLabo': '',
      'definitionFilipino': 'bilasa',
      'definitionEnglish': '',
    },
    {
      'word': 'hagok',
      'definitionLabo': '',
      'definitionFilipino': 'hilik',
      'definitionEnglish': '',
    },
    {
      'word': 'halung-hagong',
      'definitionLabo': '',
      'definitionFilipino': 'badoy',
      'definitionEnglish': '',
    },
    {
      'word': 'haranghado',
      'definitionLabo': '',
      'definitionFilipino': 'siga',
      'definitionEnglish': '',
    },
    {
      'word': 'haklab',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': '',
    },
    {
      'word': 'himil',
      'definitionLabo': '',
      'definitionFilipino': 'hawaka',
      'definitionEnglish': '',
    },
    {
      'word': 'hiwit',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'deformed',
    },
    {
      'word': 'halup',
      'definitionLabo': '',
      'definitionFilipino': 'gutom',
      'definitionEnglish': '',
    },
    {
      'word': 'hat-hat',
      'definitionLabo': '',
      'definitionFilipino': 'ipamigay',
      'definitionEnglish': 'spread-out',
    },
    {
      'word': 'itok',
      'definitionLabo': '',
      'definitionFilipino': 'ikot',
      'definitionEnglish': 'turn',
    },
    {
      'word': 'intig',
      'definitionLabo': '',
      'definitionFilipino': 'kanti',
      'definitionEnglish': '',
    },
    {
      'word': 'il-igin',
      'definitionLabo': '',
      'definitionFilipino': 'sugatin',
      'definitionEnglish': '',
    },
    {
      'word': 'lat-lat',
      'definitionLabo': '',
      'definitionFilipino': 'sagi',
      'definitionEnglish': '',
    },
    {
      'word': 'lantuag',
      'definitionLabo': '',
      'definitionFilipino': 'paggala ng walang katuturan',
      'definitionEnglish': '',
    },
    {
      'word': 'lumpat',
      'definitionLabo': '',
      'definitionFilipino': 'lukso',
      'definitionEnglish': '',
    },
    {
      'word': "lab'it",
      'definitionLabo': '',
      'definitionFilipino': 'konti',
      'definitionEnglish': '',
    },
    {
      'word': 'labsay',
      'definitionLabo': '',
      'definitionFilipino': 'hindi masarap',
      'definitionEnglish': 'not appetite pleasing',
    },
    {
      'word': 'lusdak',
      'definitionLabo': '',
      'definitionFilipino': 'malata ang pagkakaluto',
      'definitionEnglish': '',
    },
    {
      'word': 'lumhok',
      'definitionLabo': '',
      'definitionFilipino': 'lambot',
      'definitionEnglish': '',
    },
    {
      'word': 'muraskas',
      'definitionLabo': '',
      'definitionFilipino': 'salitang malakas',
      'definitionEnglish': '',
    },
    {
      'word': 'mug-ak',
      'definitionLabo': '',
      'definitionFilipino': 'puno ang bibig',
      'definitionEnglish': '',
    },
    {
      'word': 'mapung-aw',
      'definitionLabo': '',
      'definitionFilipino': 'malungkot',
      'definitionEnglish': '',
    },
    {
      'word': 'muk-muk',
      'definitionLabo': '',
      'definitionFilipino': 'nag-iisip',
      'definitionEnglish': '',
    },
    {
      'word': 'murusdot',
      'definitionLabo': '',
      'definitionFilipino': 'nakasimangot',
      'definitionEnglish': '',
    },
    {
      'word': 'nag-uumong',
      'definitionLabo': '',
      'definitionFilipino': 'kumakain ng solo',
      'definitionEnglish': '',
    },
    {
      'word': 'natig-akan',
      'definitionLabo': '',
      'definitionFilipino': 'nabulunan',
      'definitionEnglish': '',
    },
    {
      'word': 'napuposan',
      'definitionLabo': '',
      'definitionFilipino': 'kinapos ng hininga',
      'definitionEnglish': '',
    },
    {
      'word': 'nak-nak',
      'definitionLabo': '',
      'definitionFilipino': 'nagtutubig na sugat',
      'definitionEnglish': '',
    },
    {
      'word': 'nagmamalatuat',
      'definitionLabo': '',
      'definitionFilipino': 'nangingibabaw ang boses',
      'definitionEnglish': '',
    },
    {
      'word': 'nakabangbang',
      'definitionLabo': '',
      'definitionFilipino': 'nakaharap palagi',
      'definitionEnglish': '',
    },
    {
      'word': 'nami',
      'definitionLabo': '',
      'definitionFilipino': 'nakaw',
      'definitionEnglish': '',
    },
    {
      'word': 'ngar-ot',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': '',
    },
    {
      'word': 'ngasab',
      'definitionLabo': '',
      'definitionFilipino': 'nguya',
      'definitionEnglish': '',
    },
    {
      'word': 'ngarangaw',
      'definitionLabo': '',
      'definitionFilipino': 'malakas na iyak',
      'definitionEnglish': '',
    },
    {
      'word': 'pugyapot',
      'definitionLabo': '',
      'definitionFilipino': 'nagsusumikap, nagkukumahog, naghihirap',
      'definitionEnglish': '',
    },
    {
      'word': 'purongpusong',
      'definitionLabo': '',
      'definitionFilipino': 'magagalitin, madaling mainis',
      'definitionEnglish': '',
    },
    {
      'word': 'pal-am',
      'definitionLabo': '',
      'definitionFilipino': 'taga, marka ng sugat',
      'definitionEnglish': '',
    },
    {
      'word': 'par-at',
      'definitionLabo': '',
      'definitionFilipino': 'mapalot, mabaho',
      'definitionEnglish': '',
    },
    {
      'word': 'pirigpidig',
      'definitionLabo': '',
      'definitionFilipino': 'lupasay, dabog',
      'definitionEnglish': '',
    },
    {
      'word': 'raba-raba',
      'definitionLabo': '',
      'definitionFilipino': 'lumahok sa usapan ng bigla',
      'definitionEnglish': '',
    },
    {
      'word': 'rapado',
      'definitionLabo': '',
      'definitionFilipino': 'hambalos',
      'definitionEnglish': '',
    },
    {
      'word': 'ruso',
      'definitionLabo': '',
      'definitionFilipino': 'lugi, hindi kumita',
      'definitionEnglish': '',
    },
    {
      'word': 'rugado',
      'definitionLabo': '',
      'definitionFilipino': 'pagod ang katawan at isip',
      'definitionEnglish': '',
    },
    {
      'word': 'sagmaw',
      'definitionLabo': '',
      'definitionFilipino': 'kaning baboy',
      'definitionEnglish': '',
    },
    {
      'word': 'salampak',
      'definitionLabo': '',
      'definitionFilipino': 'lupagi',
      'definitionEnglish': '',
    },
    {
      'word': 'sagimsim',
      'definitionLabo': '',
      'definitionFilipino': 'takaw',
      'definitionEnglish': '',
    },
    {
      'word': 'sawisaw',
      'definitionLabo': '',
      'definitionFilipino': 'tsamba',
      'definitionEnglish': '',
    },
    {
      'word': 'siya baya',
      'definitionLabo': '',
      'definitionFilipino': 'oo naman!',
      'definitionEnglish': '',
    },
    {
      'word': 'talang',
      'definitionLabo': '',
      'definitionFilipino': 'nagkamali',
      'definitionEnglish': 'out',
    },
    {
      'word': 'taya pato',
      'definitionLabo': '',
      'definitionFilipino': 'todo, ubos kung ubos',
      'definitionEnglish': 'all in',
    },
    {
      'word': 'tusik',
      'definitionLabo': '',
      'definitionFilipino': 'lasing',
      'definitionEnglish': '',
    },
    {
      'word': 'tultog',
      'definitionLabo': '',
      'definitionFilipino': 'pukpok',
      'definitionEnglish': '',
    },
    {
      'word': 'tangwa',
      'definitionLabo': '',
      'definitionFilipino': 'gilid',
      'definitionEnglish': '',
    },
    {
      'word': 'tarak',
      'definitionLabo': '',
      'definitionFilipino': 'tirik ang mata',
      'definitionEnglish': '',
    },
    {
      'word': 'tik-ib',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': '',
    },
    {
      'word': 'talsik',
      'definitionLabo': '',
      'definitionFilipino': 'tilapon',
      'definitionEnglish': '',
    },
    {
      'word': 'ugsak',
      'definitionLabo': '',
      'definitionFilipino': 'upak, banat',
      'definitionEnglish': '',
    },
    {
      'word': 'ulnok',
      'definitionLabo': '',
      'definitionFilipino': 'umigsi, umurong',
      'definitionEnglish': '',
    },
    {
      'word': 'uldot',
      'definitionLabo': '',
      'definitionFilipino': 'litaw',
      'definitionEnglish': '',
    },
    {
      'word': 'ukrong',
      'definitionLabo': '',
      'definitionFilipino': 'atras, umurong',
      'definitionEnglish': '',
    },
    {
      'word': 'utay-utay',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'slowly',
    },
    {
      'word': 'wagak',
      'definitionLabo': '',
      'definitionFilipino': 'lasing',
      'definitionEnglish': '',
    },
    {
      'word': 'wat-wat',
      'definitionLabo': '',
      'definitionFilipino': 'linisin',
      'definitionEnglish': '',
    },
    {
      'word': 'watik-watik',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'discard abruptly',
    },
    {
      'word': 'ya, di baya',
      'definitionLabo': '',
      'definitionFilipino': 'hindi naman',
      'definitionEnglish': '',
    },
    {
      'word': 'talay-talay',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'lined-up in succession; in a row',
    },
    {
      'word': 'lagsang',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          "to come out, as a new born baby from the mother's womb",
    },
    {
      'word': 'naglulupagi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'sat on the floor or ground and moving to and fro,\nwhining and complaining',
    },
    {
      'word': 'hinupog',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'rape; sexually molested',
    },
    {
      'word': 'pinanggirahawan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          "that which occured in a state of sudden fear or dislike to cause one's hair to stand up",
    },
    {
      'word': 'buta',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'ousted (in game of cards)',
    },
    {
      'word': 'gabsuk',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'dark; night fall',
    },
    {
      'word': 'sukiti',
      'definitionLabo': '',
      'definitionFilipino': 'suntok na nagmula sa baba',
      'definitionEnglish': 'a punch thrown from below',
    },
    {
      'word': 'natil-an',
      'definitionLabo': '',
      'definitionFilipino': 'natigilan',
      'definitionEnglish': "almost lost one's breath due to pain",
    },
    {
      'word': 'naburangka',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'fell, with arms and feet wide open',
    },
    {
      'word': 'balbagan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to pretense',
    },
    {
      'word': 'uplasan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'synonymous with `balbagan`',
    },
    {
      'word': 'sigmak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to dispose of human waste',
    },
    {
      'word': 'harab-harab',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'overly excited, ready to pounce anytime',
    },
    {
      'word': 'ginagama-gamahan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'in a state of feverish anticipation',
    },
    {
      'word': 'naglalantuag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'lazing around',
    },
    {
      'word': 'padag-padag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': "stomping in one's feet",
    },
    {
      'word': 'hahara-hara',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'standing in the way; interrupting',
    },
    {
      'word': 'sasabat-sabat',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to interrupt as in conversation; to needle at',
    },
    {
      'word': 'huring-huding',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'aimless talk',
    },
    {
      'word': 'bagla',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'unclean',
    },
    {
      'word': 'damak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to overfill as in food',
    },
    {
      'word': 'pasal',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'voracious eater',
    },
    {
      'word': 'walang rato',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'without let up',
    },
    {
      'word': 'walang kapormalan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'without proper conduct and behavior',
    },
    {
      'word': 'takma',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to pick-up',
    },
    {
      'word': 'harumal',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'the act of hitting and striking with a big instrument',
    },
    {
      'word': 'puaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a stupid fool',
    },
    {
      'word': 'rapas',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to hit somebody, generally with a light material',
    },
    {
      'word': 'nagmumual',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'eating with full mouth',
    },
    {
      'word': 'nagmumuong',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'eating selfishly, usually, out of reach of anybody',
    },
    {
      'word': 'linterok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a mild word used for cursing',
    },
    {
      'word': 'hapagin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to run after',
    },
    {
      'word': 'tarakbuhan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'a word used to describe a crowd running, mostly out of fear or panic',
    },
    {
      'word': 'tumalbo',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'got thrown away',
    },
    {
      'word': 'nagumiawan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'became aware of',
    },
    {
      'word': 'sikig',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'time-pressed',
    },
    {
      'word': 'ukraban',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to bite strongly',
    },
    {
      'word': 'butukan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'makeshift nipa hut',
    },
    {
      'word': 'halibis',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to throw at',
    },
    {
      'word': 'yan ta ay!',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'You See!',
    },
    {
      'word': 'lugita',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'in state where there is complete absence of hygiene;\nusually, when perspiration and dirt stuck to the body',
    },
    {
      'word': 'napasurabag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'fell or got thrown against a surface or wall',
    },
    {
      'word': 'dagil',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'brush aside',
    },
    {
      'word': 'punete',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a punch',
    },
    {
      'word': 'wiri-wiri',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'confused',
    },
    {
      'word': 'taghuya',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'alias',
    },
    {
      'word': 'pabirik',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'the process of extracting gold from amalgam as in gold panning',
    },
    {
      'word': 'kuyamit',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'act of mating, specially among animals and chicken',
    },
    {
      'word': 'kutib',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'small bite',
    },
    {
      'word': 'halhal',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'gasping for breath',
    },
    {
      'word': 'tiik',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'strangle with bare hands',
    },
    {
      'word': 'bugti',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'synonymous with `punete`',
    },
    {
      'word': 'itumog',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'to submerge, as in body of water',
    },
    {
      'word': 'lampadog',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'falling with a thud',
    },
    {
      'word': 'pulasi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a pool of dirty water',
    },
    {
      'word': 'sibot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'busy',
    },
    {
      'word': 'kumuda',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'cabinet for clothing',
    },
    {
      'word': 'hari-i',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a game of hide-and-seek',
    },
    {
      'word': 'sinaludsod',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a native cake, not unlike the pancake',
    },
    {
      'word': 'upot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a roundly-defeated fellow, at the tail-end',
    },
    {
      'word': 'mahaldat',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'painful, as a painful stomach',
    },
    {
      'word': 'baghuk',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'lazy',
    },
    {
      'word': 'bangkukang',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'cockcroach',
    },
    {
      'word': 'lulam',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'out of wits',
    },
    {
      'word': 'hagpuk',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': "ignoramus; doesn't know anything",
    },
    {
      'word': 'naulkan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'got almost choked due to clogged throat',
    },
    {
      'word': 'tuprag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'blown away in several directions',
    },
    {
      'word': 'tabuldo',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'sweet potato; camote',
    },
    {
      'word': 'tam-ak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'step-on',
    },
    {
      'word': 'uraol',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a haunting cry',
    },
    {
      'word': 'ulsik',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'usually an adjective that describes an eye that bulges out',
    },
    {
      'word': 'tamilmil',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'one who barely touches his food;\nalso, one who barely speaks',
    },
    {
      'word': 'turay-og',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'the act of shooting-up high and going down slowly',
    },
    {
      'word': 'tir-is',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'urination',
    },
    {
      'word': 'sig-ok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'sobbing half-chokingly',
    },
    {
      'word': 'sungingi',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'pressing the mouth to the teeth',
    },
    {
      'word': 'sugot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a person who instantly needles another',
    },
    {
      'word': 'ragiik',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a creaky sound',
    },
    {
      'word': 'ragot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'gnashing of teeth',
    },
    {
      'word': 'pangag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a fool',
    },
    {
      'word': 'puk-it',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': "screw out with one's finger/s",
    },
    {
      'word': 'puklay',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a forlorn and weak condition',
    },
    {
      'word': 'yukayok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'in semi-crouching position, usually out-of-despair',
    },
    {
      'word': 'pastidyo',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a problem person',
    },
    {
      'word': 'patitian',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'drain out',
    },
    {
      'word': 'nguk-ngok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'the smallest member of the shell family',
    },
    {
      'word': 'natalik-ad',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'fell backward',
    },
    {
      'word': 'ngak-ngak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'the act of talking with the mouth open',
    },
    {
      'word': 'ngurangol',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a long, prolonged crying',
    },
    {
      'word': 'manatok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'delicious; also, tasty',
    },
    {
      'word': 'madata',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'not so good',
    },
    {
      'word': 'maantak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'painful',
    },
    {
      'word': 'maragamo',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'cracking sound of food inside the mouth',
    },
    {
      'word': 'la-pak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a light slap',
    },
    {
      'word': 'lagmak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': "down on one's behind",
    },
    {
      'word': 'labsak',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'a condition of too much water spoiling the mixture of food',
    },
    {
      'word': 'hilamon',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'the clearing of weeds that grow amont plants',
    },
    {
      'word': 'haro',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'a person clinging to some possession rather childishly',
    },
    {
      'word': 'gaot',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'hard penetration',
    },
    {
      'word': 'guray-guray',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'tattered',
    },
    {
      'word': 'gumsa',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'mashing',
    },
    {
      'word': 'gunit',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'hair-pulling',
    },
    {
      'word': 'gul-ok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'the act of physically overpowering a foe by wringing the neck or the hand mashing',
    },
    {
      'word': 'dik-il',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'an uninterrupted touch, usually in the arm',
    },
    {
      'word': 'alibadbad',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'craving; a powerful urge',
    },
    {
      'word': 'butilaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'prematurely-cooked food',
    },
    {
      'word': 'butwa',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'sudden appearance',
    },
    {
      'word': 'batikalin',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'throwing',
    },
    {
      'word': 'bagunitan',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish':
          'refers to a male whose body can take the hardest punches',
    },
    {
      'word': 'bu-alaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'coward',
    },
    {
      'word': 'bagaok',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'falls with a thud',
    },
    {
      'word': 'busngal',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'punch in the mouth',
    },
    {
      'word': 'kurahaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a loud shout or a loud cry',
    },
    {
      'word': 'kuribaw',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a running retreat',
    },
    {
      'word': 'kulambitay',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'hang on, usually to a rope or a vine',
    },
    {
      'word': 'kaslag',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'one who does not stay put inside the house',
    },
    {
      'word': 'kurapog',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'a crouching, give-no-quarters embrace',
    },
    {
      'word': 'kuras-il',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'coarse',
    },
    {
      'word': 'kutap-al',
      'definitionLabo': '',
      'definitionFilipino': '',
      'definitionEnglish': 'heavily covered, usually with make up',
    },
  ];

  List<Map<String, dynamic>> _savedWords = [];
  List<String> _bookmarkedWords = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadWordsFromDatabase();
    _loadBookmarkedWords();
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
    String wordText = word['word'];
    bool isBookmarked = _bookmarkedWords.contains(wordText);

    if (!isBookmarked) {
      try {
        await DatabaseHelper().insertBookmark({
          'word': word['word'] as String,
          'definitionLabo': word['definitionLabo'] as String,
          'definitionFilipino': word['definitionFilipino'] as String,
          'definitionEnglish': word['definitionEnglish'] as String,
        });
        setState(() {
          _bookmarkedWords.add(wordText);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Word bookmarked successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to bookmark the word.')),
        );
      }
    } else {
      setState(() {
        _bookmarkedWords.remove(wordText);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word unbookmarked successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [
      ..._preSavedItems,
      ..._savedWords,
    ];

    final filteredItems = allItems.where((item) {
      final word = item['word']?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return word.startsWith(
          query); // Change this to check if word starts with the query
    }).toList();

    filteredItems.sort((a, b) => (a['word'] ?? '').compareTo(b['word'] ?? ''));

    // Function to capitalize the first letter of a word
    String capitalize(String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }

    // Map the filtered items to capitalize the first letter of each word
    final capitalizedItems = filteredItems.map((item) {
      return {
        ...item,
        'word': capitalize(item['word'] ?? ''), // Capitalize the first letter
      };
    }).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFBAC08), Color(0xFFFFFAA7), Color(0xFFFFFAA7),  Color(0xFFFBAC08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Top Container for the images, replacing the AppBar
            Padding(
              padding: const EdgeInsets.only(top: 15),
              
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/LOGO.png',
                      height: 75,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 80),
                    Image.asset(
                      'assets/images/TITLE.png',
                      height: 65,
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
              color: Colors.black, // Set the color of the divider to black
              thickness: 2.0, // Optional: Set the thickness of the divider
              height:
                  25, // Optional: Set the height space before and after the divider
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              leading: const Icon(Icons.wb_sunny_outlined),
                              title: Text(
                                item['word'] ?? 'No word',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
                                    builder: (context) => ViewNoteView(
                                      word: item['word'] ?? '',
                                      definitionLabo:
                                          item['definitionLabo'] ?? '',
                                      definitionFilipino:
                                          item['definitionFilipino'] ?? '',
                                      definitionEnglish:
                                          item['definitionEnglish'] ?? '',
                                          
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
                    // case 0:
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const HomeView(),
                    //     ),
                    //   ).then((newWord) => _loadWordsFromDatabase(newWord));
                    //   break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNoteView(),
                        ),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookmarkedView(),
                        ),
                      );
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
                            builder: (context) => const AddNoteView(),
                          ),
                        );
                        _loadWordsFromDatabase();
                      },
                      child: const Icon(Icons.add_box_outlined),
                    ),
                    label: 'Add Note',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_add_outlined),
                    label: 'Saved',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_outlined),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
