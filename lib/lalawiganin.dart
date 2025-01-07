import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/login/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SQFLite/database_helper.dart';
import 'bookmark_provider.dart';
import 'bookmarked_view.dart';
import 'home.dart';
import 'proponents.dart';
import 'view_words.dart';
import 'add_note.dart';

class Lalawiganin extends StatefulWidget {
  final String category;

  const Lalawiganin({super.key, required this.category});

  @override
  State<Lalawiganin> createState() => _LalawiganinState();
}

class _LalawiganinState extends State<Lalawiganin> {
  final List<Map<String, String>> _preSavedItems = [
    {
      "word": "Awas",
      "definitionLabo": "",
      "definitionFilipino": "bumaba",
      "definitionEnglish": "step down",
      "audio": "assets/audio/Awas L_20241124_130207.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "apritado",
      "definitionLabo": "",
      "definitionFilipino": "madaliin",
      "definitionEnglish": "hurried",
      "audio": "assets/audio/Apritado L_20241124_130218.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "agot-utin",
      "definitionLabo": "",
      "definitionFilipino": "marungis",
      "definitionEnglish": "dirty",
      "audio": "assets/audio/Agot-utin L_20241124_130208.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "aratuot",
      "definitionLabo": "",
      "definitionFilipino": "tulad ng sunod-sunod na paninigarilyo",
      "definitionEnglish": "like a series of smoking",
      "audio": "assets/audio/Aratuot L_20241124_130213.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'Halibis',
      'definitionLabo': '',
      'definitionFilipino': 'paghagis',
      'definitionEnglish': 'to throw at',
      "audio": "assets/audio/Halibis L_20241123_202450.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kilkil',
      'definitionLabo': '',
      'definitionFilipino': 'hanapin',
      'definitionEnglish': 'finding',
      "audio": "assets/audio/Kilkil L_20241124_130336.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'Walang panapsi',
      'definitionLabo': '',
      'definitionFilipino': 'hindi nababawasan ang gana sa pagkain',
      'definitionEnglish': 'undiminished appetite',
      "audio": "assets/audio/Walang panapsi L_20241123_202300.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "aramusa",
      "definitionLabo": "",
      "definitionFilipino":
          "iyong pagtanggap, pagbibigay ng isang bagay, karaniwan ay pera na walang pumipigil",
      "definitionEnglish":
          "the act of receiving or giving something, usually money, without any restrictions",
      "audio": "assets/audio/Aramusa L_20241124_130214.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "agil-ilin",
      "definitionLabo": "",
      "definitionFilipino": "marumi ang pananamit/libagin",
      "definitionEnglish": "dirty clothing",
      "audio": "assets/audio/Agil-ilin L_20241124_130216.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "antak",
      "definitionLabo": "",
      "definitionFilipino": "isang sugat na napakasakit",
      "definitionEnglish": "a wound that is very painful",
      "audio": "assets/audio/Antak L_20241124_130221.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      "word": "bunhak",
      "definitionLabo": "",
      "definitionFilipino": "mataba at mayamang pagkakaayos tulad ng lupa",
      "definitionEnglish": "fat and rich arrangement, like soil",
      "audio": "assets/audio/Bunhak L_20241124_130222.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "butiktik",
      "definitionLabo": "",
      "definitionFilipino": "sobrang busog",
      "definitionEnglish": "extremely full",
      "audio": "assets/audio/Butiktik L_20241124_130224.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "bana-bana",
      "definitionLabo": "",
      "definitionFilipino": "mag-isip",
      "definitionEnglish": "to think",
      "audio": "assets/audio/Bana-bana L_20241124_130227.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "balni",
      "definitionLabo": "",
      "definitionFilipino": "napaso ng mainit na tubig",
      "definitionEnglish": "scalded with hot water",
      "audio": "assets/audio/Balni L_20241124_130232.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "bulsot",
      "definitionLabo": "",
      "definitionFilipino": "nahulog sa isang maliit na butas o balon",
      "definitionEnglish": "fell into a small hole or pit",
      "audio": "assets/audio/Bulsot L_20241124_130234.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "balubagi",
      "definitionLabo": "",
      "definitionFilipino": "hindi matinong kausap",
      "definitionEnglish": "not sincere",
      "audio": "assets/audio/Balubagi L_20241124_130236.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "bar-ao",
      "definitionLabo": "",
      "definitionFilipino": "mahinang gumalaw",
      "definitionEnglish": "moved weakly",
      "audio": "assets/audio/Bar-ao L_20241124_130239.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "bulwat",
      "definitionLabo": "",
      "definitionFilipino": "nabutas",
      "definitionEnglish": "pierced",
      "audio": "assets/audio/Bulwat L_20241124_130241.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "bugwak",
      "definitionLabo": "",
      "definitionFilipino": "natapon",
      "definitionEnglish": "spilled",
      "audio": "assets/audio/Bugwak L_20241124_130242.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "balentong",
      "definitionLabo": "",
      "definitionFilipino": "nabaliktad",
      "definitionEnglish": "overturned",
      "audio": "assets/audio/Balentong Lalawiganin.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "kurumbot",
      "definitionLabo": "",
      "definitionFilipino": "isang uri ng prutas na natatagpuan sa gubat",
      "definitionEnglish": "a type of fruit found in the forest",
      "audio": "assets/audio/Kurumbot L_20241124_130247.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      "word": "kawas",
      "definitionLabo": "",
      "definitionFilipino": "maiksi o maliit",
      "definitionEnglish": "short or small",
      "audio": "assets/audio/Kawas L_20241124_130248.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "karaw",
      "definitionLabo": "",
      "definitionFilipino": "kinakabahan",
      "definitionEnglish": "nervous",
      "audio": "assets/audio/Karaw L_20241124_130249.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "karutkot",
      "definitionLabo": "",
      "definitionFilipino": "sayurin ang tira",
      "definitionEnglish": "to scrape leftovers",
      "audio": "assets/audio/Karutkot L_20241124_130251.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "karangkang",
      "definitionLabo": "",
      "definitionFilipino": "carelessly",
      "definitionEnglish": "carelessly",
      "audio": "assets/audio/Karangkang L_20241124_130310.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      "word": "kulbo",
      "definitionLabo": "",
      "definitionFilipino": "takbo",
      "definitionEnglish": "to run",
      "audio": "assets/audio/Kulbo L_20241123_202030.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "kadugin",
      "definitionLabo": "",
      "definitionFilipino": "bugbugin",
      "definitionEnglish": "to beat",
      "audio": "assets/audio/Kadugin L_20241124_130331.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      "word": "iraid",
      "definitionLabo": "",
      "definitionFilipino": "pag-aalis o pagtapyas",
      "definitionEnglish": "to share off",
      "audio": "assets/audio/Iraid L_20241123_202301.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tagiti',
      'definitionLabo': '',
      'definitionFilipino': 'mahinang ambon',
      'definitionEnglish': 'a slight drizzle',
      "audio": "assets/audio/Tagiti L_20241123_202405.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kurimpit',
      'definitionLabo': '',
      'definitionFilipino': 'maliit na kuto',
      'definitionEnglish': 'small louse',
      "audio": "assets/audio/Kurimpit L_20241124_130332.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'siapuan',
      'definitionLabo': '',
      'definitionFilipino': 'balewalain',
      'definitionEnglish': 'to ignore',
      "audio": "assets/audio/Siapuan L_20241123_202408.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'riparohin',
      'definitionLabo': '',
      'definitionFilipino': 'asikasuhin',
      'definitionEnglish': 'attend to',
      "audio": "assets/audio/Riparuhin L_20241123_202409.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'magnanami',
      'definitionLabo': '',
      'definitionFilipino': 'maliliit na magnanakaw',
      'definitionEnglish': 'small-time thief',
      "audio": "assets/audio/Magnanami L_20241123_202412.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'tugpa',
      'definitionLabo': '',
      'definitionFilipino': 'dumaong o lumapag, tulad sa ilog o bukid',
      'definitionEnglish': 'to land down as in river or farm',
      "audio": "assets/audio/Tugpa L_20241123_202415.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'dasig-dasig',
      'definitionLabo': '',
      'definitionFilipino': 'umusog nang kaunti',
      'definitionEnglish': 'move over a little',
      "audio": "assets/audio/Dasig-dasig L_20241123_202419.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kulipaw',
      'definitionLabo': '',
      'definitionFilipino': 'maghalughog o mangalakal',
      'definitionEnglish': 'to scavenge',
      "audio": "assets/audio/Kulipaw L_20241123_202433.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kulibsaw',
      'definitionLabo': '',
      'definitionFilipino': 'galaw ng tubig na may isda',
      'definitionEnglish': 'movement of water with fish in it',
      "audio": "assets/audio/Kulibsaw L_20241124_130339.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kalibkib',
      'definitionLabo': '',
      'definitionFilipino': 'kudkurin',
      'definitionEnglish': 'shred 1/4 of coconut',
      "audio": "assets/audio/Kalibkib L_20241124_130341.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kurumbistre',
      'definitionLabo': '',
      'definitionFilipino': 'takot',
      'definitionEnglish': 'coward',
      "audio": "assets/audio/Kurumbistre L_20241124_130346.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kas-kas',
      'definitionLabo': '',
      'definitionFilipino': 'mabilis',
      'definitionEnglish': 'fast',
      "audio": "assets/audio/Kaskas L_20241124_130348.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kilikisi',
      'definitionLabo': '',
      'definitionFilipino': 'kumikinang',
      'definitionEnglish': 'sparkling',
      "audio": "assets/audio/Kilikisi L_20241124_130349.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'dilwat',
      'definitionLabo': '',
      'definitionFilipino': 'nakalabas ang dila',
      'definitionEnglish': 'the tongue is sticking out',
      "audio": "assets/audio/Dilwat L_20241124_130351.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'dasmag',
      'definitionLabo': '',
      'definitionFilipino': 'habulin, daluhungin',
      'definitionEnglish': 'to chase',
      "audio": "assets/audio/Dasmag L_20241124_130354.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'duldog',
      'definitionLabo': '',
      'definitionFilipino': 'sundot',
      'definitionEnglish': 'poke',
      "audio": "assets/audio/Duldog L_20241124_130356.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'dukhaw',
      'definitionLabo': '',
      'definitionFilipino': 'abutin/kuhanin',
      'definitionEnglish': 'to take',
      "audio": "assets/audio/Dukhaw L_20241124_130358.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'daphag',
      'definitionLabo': '',
      'definitionFilipino': 'daganan',
      'definitionEnglish': 'to put on top of',
      "audio": "assets/audio/Daphag L_20241124_130400.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'duklat',
      'definitionLabo': '',
      'definitionFilipino': 'nasundot sa mata',
      'definitionEnglish': 'to poke the eye',
      "audio": "assets/audio/Duklat L_20241124_130401.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'duridotin',
      'definitionLabo': '',
      'definitionFilipino':
          'pagpasok gamit ang daliri, karaniwang sa paikot at madiing paraan',
      'definitionEnglish': 'to finger in, usually in hard, circling manner',
      "audio": "assets/audio/Duridotin L_20241123_202034.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'dalasang',
      'definitionLabo': '',
      'definitionFilipino': 'sagasaan',
      'definitionEnglish': 'run over',
      "audio": "assets/audio/Dalasang Lalawiganin.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'garaygay',
      'definitionLabo': '',
      'definitionFilipino': 'parang maton kung lumakad',
      'definitionEnglish': 'walks like a thug',
      "audio": "assets/audio/Garaygay L_20241124_130406.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'guop',
      'definitionLabo': '',
      'definitionFilipino': 'yakap (nakakulong sa mga bisig)',
      'definitionEnglish': 'embrace or hug (enclosed in the arms).',
      "audio": "assets/audio/Guop L_20241124_130409.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'gut-lo',
      'definitionLabo': '',
      'definitionFilipino': 'pantal',
      'definitionEnglish': 'rash',
      "audio": "assets/audio/Gutlo L_20241124_130412.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'galho',
      'definitionLabo': '',
      'definitionFilipino': 'dumi sa ngipin',
      'definitionEnglish': 'grease-like dirt in the teeth',
      "audio": "assets/audio/Galho L_20241124_130415.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'hampok',
      'definitionLabo': '',
      'definitionFilipino': 'bilasa',
      'definitionEnglish': 'rotten',
      "audio": "assets/audio/Hampok L_20241124_130416.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hagok',
      'definitionLabo': '',
      'definitionFilipino': 'hilik',
      'definitionEnglish': 'snore',
      "audio": "assets/audio/Hagok L_20241124_130419.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'halung-hagong',
      'definitionLabo': '',
      'definitionFilipino': 'badoy',
      'definitionEnglish': 'corny',
      "audio": "assets/audio/Halung hagong L_20241124_130420.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'haranghado',
      'definitionLabo': '',
      'definitionFilipino': 'siga',
      'definitionEnglish': 'gangster',
      "audio": "assets/audio/Haranghado L_20241124_130422.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'haklab',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': 'kagat',
      "audio": "assets/audio/Haklab L_20241124_130424.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'himil',
      'definitionLabo': '',
      'definitionFilipino': 'hawakan',
      'definitionEnglish': 'grasp',
      "audio": "assets/audio/Himil L_20241124_202537.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'hiwit',
      'definitionLabo': '',
      'definitionFilipino': 'laylay',
      'definitionEnglish': 'deformed',
      "audio": "assets/audio/Hiwit L_20241124_202540.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'halup',
      'definitionLabo': '',
      'definitionFilipino': 'gutom',
      'definitionEnglish': 'starving',
      "audio": "assets/audio/Halup L_20241124_202541.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hat-hat',
      'definitionLabo': '',
      'definitionFilipino': 'ipamigay',
      'definitionEnglish': 'spread-out',
      "audio": "assets/audio/Hat-hat L_20241124_202543.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'itok',
      'definitionLabo': '',
      'definitionFilipino': 'ikot',
      'definitionEnglish': 'turn',
      "audio": "assets/audio/Itok L_20241124_202545.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'intig',
      'definitionLabo': '',
      'definitionFilipino': 'kanti',
      'definitionEnglish': 'to nudge',
      "audio": "assets/audio/Intig L_20241124_202548.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'il-igin',
      'definitionLabo': '',
      'definitionFilipino': 'sugatin',
      'definitionEnglish': "a person who's prone or always have wound",
      "audio": "assets/audio/Il-igin L_20241124_202552.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'lat-lat',
      'definitionLabo': '',
      'definitionFilipino': 'sagi',
      'definitionEnglish': 'bump',
      "audio": "assets/audio/Latlat L_20241124_202554.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'lantuag',
      'definitionLabo': '',
      'definitionFilipino': 'paggala ng walang katuturan',
      'definitionEnglish': 'roaming without purpose',
      "audio": "assets/audio/Lantuag L_20241124_202557.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'lumpat',
      'definitionLabo': '',
      'definitionFilipino': 'lukso',
      'definitionEnglish': 'jump',
      "audio": "assets/audio/Lumpat L_20241124_202559.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': "lab'it",
      'definitionLabo': '',
      'definitionFilipino': 'konti',
      'definitionEnglish': 'a little',
      "audio": "assets/audio/Lab_it L_20241124_202601.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'labsay',
      'definitionLabo': '',
      'definitionFilipino': 'hindi masarap',
      'definitionEnglish': 'not appetite pleasing or not tasty',
      "audio": "assets/audio/Labsay L_20241124_202603.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'lusdak',
      'definitionLabo': '',
      'definitionFilipino': 'malata ang pagkakaluto',
      'definitionEnglish': 'overcooked',
      "audio": "assets/audio/Lusdak L_20241124_202607.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'lumhok',
      'definitionLabo': '',
      'definitionFilipino': 'lambot',
      'definitionEnglish': 'soft',
      "audio": "assets/audio/Lumhok L_20241124_202609.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'malumhok',
      'definitionLabo': '',
      'definitionFilipino': 'malambot',
      'definitionEnglish': 'too soft',
      "audio": "assets/audio/Malumhok Lalawiganin.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'mapung-aw',
      'definitionLabo': '',
      'definitionFilipino': 'malungkot',
      'definitionEnglish': 'feeling down',
      "audio": "assets/audio/Mapung-aw L_20241124_202615.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'mukmok',
      'definitionLabo': '',
      'definitionFilipino': 'nag-iisip',
      'definitionEnglish': 'thinking',
      "audio": "assets/audio/Mukmok L_20241124_202619.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'murusdot',
      'definitionLabo': '',
      'definitionFilipino': 'nakasimangot',
      'definitionEnglish': 'frowning',
      "audio": "assets/audio/Murusdot L_20241124_202621.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nag-uumong',
      'definitionLabo': '',
      'definitionFilipino': 'kumakain ng solo',
      'definitionEnglish': 'eating lonely',
      "audio": "assets/audio/Nag-uumong L_20241124_202624.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'natig-akan',
      'definitionLabo': '',
      'definitionFilipino': 'nabulunan',
      'definitionEnglish': 'choked',
      "audio": "assets/audio/Natig-akan L_20241124_202626.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nagmamalatuat',
      'definitionLabo': '',
      'definitionFilipino': 'nangingibabaw ang boses',
      'definitionEnglish': 'the voice stands out',
      "audio": "assets/audio/Nagmamalatuat L_20241124_202634.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ngasab',
      'definitionLabo': '',
      'definitionFilipino': 'nguya',
      'definitionEnglish': 'chew',
      "audio": "assets/audio/Ngasab L_20241124_202645.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ngarangaw',
      'definitionLabo': '',
      'definitionFilipino': 'malakas na iyak',
      'definitionEnglish': 'loud cry',
      "audio": "assets/audio/Ngarangaw L_20241124_202648.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'pal-am',
      'definitionLabo': '',
      'definitionFilipino': 'taga, marka ng sugat',
      'definitionEnglish': 'wound scar',
      "audio": "assets/audio/Pal-am L_20241124_202654.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'par-at',
      'definitionLabo': '',
      'definitionFilipino': 'mapalot, mabaho',
      'definitionEnglish': 'smelly',
      "audio": "assets/audio/Par-at L_20241124_202752.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'pirigpidig',
      'definitionLabo': '',
      'definitionFilipino': 'lupasay, dabog',
      'definitionEnglish': 'seizing',
      "audio": "assets/audio/Pirigpidig L_20241124_202754.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'raba-raba',
      'definitionLabo': '',
      'definitionFilipino': 'lumahok sa usapan ng bigla',
      'definitionEnglish': 'to butt in, to interject suddenly',
      "audio": "assets/audio/Raba-raba L_20241124_202755.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'rapado',
      'definitionLabo': '',
      'definitionFilipino': 'hambalos',
      'definitionEnglish': 'strike',
      "audio": "assets/audio/Rapado L_20241124_202757.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'rugado',
      'definitionLabo': '',
      'definitionFilipino': 'pagod ang katawan at isip',
      'definitionEnglish': 'exhausted body or mind',
      "audio": "assets/audio/Rugado L_20241124_202823.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'sawisaw',
      'definitionLabo': '',
      'definitionFilipino': 'tsamba',
      'definitionEnglish': 'chance/luck',
      "audio": "assets/audio/Sawisaw L_20241124_202832.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'siya baya',
      'definitionLabo': '',
      'definitionFilipino': '"oo naman!"',
      'definitionEnglish': '"of course!"',
      "audio": "assets/audio/Siya baya B_20241124_202837.mp3",
      'subcategory': 'Expression'
    },
    {
      'word': 'talang',
      'definitionLabo': '',
      'definitionFilipino': 'nagkamali',
      'definitionEnglish': 'erred',
      "audio": "assets/audio/Talang L_20241124_202840.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tultog',
      'definitionLabo': '',
      'definitionFilipino': 'pukpok',
      'definitionEnglish': 'to pound',
      "audio": "assets/audio/Tultog L_20241124_202846.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tangwa',
      'definitionLabo': '',
      'definitionFilipino': 'gilid',
      'definitionEnglish': 'side',
      "audio": "assets/audio/Tangwa L_20241124_202849.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'tik-ib',
      'definitionLabo': '',
      'definitionFilipino': 'kagat',
      'definitionEnglish': 'bite',
      "audio": "assets/audio/Tik-ib L_20241124_202853.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'ulnok',
      'definitionLabo': '',
      'definitionFilipino': 'umigsi, umurong',
      'definitionEnglish': 'recede',
      "audio": "assets/audio/Ulnok L_20241124_202901.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'utay-utay',
      'definitionLabo': '',
      'definitionFilipino': 'dahan-dahan',
      'definitionEnglish': 'little by little',
      "audio": "assets/audio/Utay-utay L_20241124_130101.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'talay-talay',
      'definitionLabo': '',
      'definitionFilipino': 'nakapila o isang hanay',
      'definitionEnglish': 'lined-up in succession; in a row',
      "audio": "assets/audio/Talay-talay L_20241124_130205.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'lagsang',
      'definitionLabo': '',
      'definitionFilipino':
          'lumabas, tulad ng bagong silang na sanggol mula sa sinapupunan ng ina',
      'definitionEnglish':
          "to come out, as a new born baby from the mother's womb",
      "audio": "assets/audio/Lagsang L_20241124_130157.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'hinupog',
      'definitionLabo': '',
      'definitionFilipino': 'panggagahasa, sekswal na pang-aabuso',
      'definitionEnglish': 'rape; sexually molested',
      "audio": "assets/audio/Hinupog L_20241124_130152.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'natil-an',
      'definitionLabo': '',
      'definitionFilipino': 'halos nawalan ng hininga dahil sa sakit',
      'definitionEnglish': "almost lost one's breath due to pain",
      "audio": "assets/audio/Natil-an L_20241124_130145.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'naburangka',
      'definitionLabo': '',
      'definitionFilipino': 'nahulog na nakabuka ang mga kamay at paa',
      'definitionEnglish': 'fell, with arms and feet wide open',
      "audio": "assets/audio/Naburangka L_20241124_130143.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'balbagan',
      'definitionLabo': '',
      'definitionFilipino': 'tirahin, saktan',
      'definitionEnglish': 'to hurt',
      "audio": "assets/audio/Balbagan L_20241123_202457.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'uplasan',
      'definitionLabo': '',
      'definitionFilipino': 'katulad ng balbagan (pagpapanggap)',
      'definitionEnglish': 'synonymous with `balbagan`',
      "audio": "assets/audio/Uplasan L_20241123_202458.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'sigmak',
      'definitionLabo': '',
      'definitionFilipino': 'pagtatapon ng dumi ng tao',
      'definitionEnglish': 'to dispose of human waste',
      "audio": "assets/audio/Sigmak L_20241123_202502.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'harab-harab',
      'definitionLabo': '',
      'definitionFilipino': 'sobrang sabik, handang umatake anumang oras',
      'definitionEnglish': 'overly excited, ready to pounce anytime',
      "audio": "assets/audio/Harab-harab L_20241123_202504.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'ginagama-gamahan',
      'definitionLabo': '',
      'definitionFilipino': 'nasa estado ng matinding pananabik',
      'definitionEnglish': 'in a state of feverish anticipation',
      "audio": "assets/audio/Ginagamagamahan L_20241123_202506.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'naglalantuag',
      'definitionLabo': '',
      'definitionFilipino': 'nagpapalipas-oras o walang ginagawa',
      'definitionEnglish': 'lazing around',
      "audio": "assets/audio/Naglalantuag L_20241123_202508.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'padag-padag',
      'definitionLabo': '',
      'definitionFilipino': 'malakas na pagtapak ng mga paa',
      'definitionEnglish': "stomping in one's feet",
      "audio": "assets/audio/Padag-padag L_20241123_202510.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'hahara-hara',
      'definitionLabo': '',
      'definitionFilipino': 'nakaharang o humahadlang',
      'definitionEnglish': 'standing in the way; interrupting',
      "audio": "assets/audio/hahara hara L_20241123_202511.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'huring-huding',
      'definitionLabo': '',
      'definitionFilipino': 'usapang walang direksyon',
      'definitionEnglish': 'aimless talk',
      "audio": "assets/audio/Huring huding L_20241123_202515.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bagla',
      'definitionLabo': '',
      'definitionFilipino': 'marumi',
      'definitionEnglish': 'unclean',
      "audio": "assets/audio/Bagla L_20241123_202518.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'damak',
      'definitionLabo': '',
      'definitionFilipino': 'paglagay nang sobra, lalo na sa pagkain',
      'definitionEnglish': 'to overfill as in food',
      "audio": "assets/audio/Damak L_20241123_202519.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'pasal',
      'definitionLabo': '',
      'definitionFilipino': 'masibang kumain',
      'definitionEnglish': 'voracious eater',
      "audio": "assets/audio/Pasal L_20241124_125845.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'walang rato',
      'definitionLabo': '',
      'definitionFilipino': 'walang tigil',
      'definitionEnglish': 'without let up',
      "audio": "assets/audio/Walang rato L_20241124_125848.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'takma',
      'definitionLabo': '',
      'definitionFilipino': 'pagpulot, pumulot',
      'definitionEnglish': 'to pick-up',
      "audio": "assets/audio/Takma L_20241124_125852.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'harumal',
      'definitionLabo': '',
      'definitionFilipino': 'ang kilos ng pagtama gamit ang malaking bagay',
      'definitionEnglish':
          'the act of hitting and striking with a big instrument',
      "audio": "assets/audio/Harumal L_20241124_125854.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'rapas',
      'definitionLabo': '',
      'definitionFilipino': 'pagpalo gamit ang magaan na bagay',
      'definitionEnglish': 'to hit somebody, generally with a light material',
      "audio": "assets/audio/Rapas L_20241124_125859.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nagmumual',
      'definitionLabo': '',
      'definitionFilipino': 'kumakain na puno ang bibig',
      'definitionEnglish': 'eating with full mouth',
      "audio": "assets/audio/Nagmumual L_20241124_125900.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nagmumuong',
      'definitionLabo': '',
      'definitionFilipino': 'kumakain na puno ang bibig',
      'definitionEnglish': 'eating selfishly, usually, out of reach of anybody',
      "audio": "assets/audio/Nagmumuong L_20241124_130103.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tarakbuhan',
      'definitionLabo': '',
      'definitionFilipino':
          'salitang ginagamit upang ilarawan ang nagkukumpulan o tumatakbuhang tao, karaniwang dulot ng takot o gulat',
      'definitionEnglish':
          'a word used to describe a crowd running, mostly out of fear or panic',
      "audio": "assets/audio/Tarakbuhan L_20241124_125914.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nagumiawan',
      'definitionLabo': '',
      'definitionFilipino': 'nagkaroon ng kamalayan',
      'definitionEnglish': 'became aware of',
      "audio": "assets/audio/Nagumiawan L_20241123_202442.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ukraban',
      'definitionLabo': '',
      'definitionFilipino': 'pagkagat nang malakas',
      'definitionEnglish': 'to bite strongly',
      "audio": "assets/audio/Ukraban L_20241123_202445.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'butukan',
      'definitionLabo': '',
      'definitionFilipino': 'pansamantalang tuluyan, kubo',
      'definitionEnglish': 'makeshift nipa hut',
      "audio": "assets/audio/Butukan L_20241123_202447.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'lugita',
      'definitionLabo': '',
      'definitionFilipino': 'kalagayan ng kawalan ng kalinisan',
      'definitionEnglish':
          'in state where there is complete absence of hygiene;\nusually, when perspiration and dirt stuck to the body',
      "audio": "assets/audio/Lugita L_20241123_202454.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'napasurabag',
      'definitionLabo': '',
      'definitionFilipino': 'natumba o naihampas sa isang ibabaw o pader',
      'definitionEnglish': 'fell or got thrown against a surface or wall',
      "audio": "assets/audio/Napasurabag L_20241123_202424.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'taghuya',
      'definitionLabo': '',
      'definitionFilipino': 'alyas o palayaw',
      'definitionEnglish': 'alias',
      "audio": "assets/audio/Taghuya L_20241123_202435.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'pabirik',
      'definitionLabo': '',
      'definitionFilipino': 'proseso ng pagkuha ng ginto mula sa amalgam',
      'definitionEnglish':
          'the process of extracting gold from amalgam as in gold panning',
      "audio": "assets/audio/Pabirik L_20241123_202437.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kuyamit',
      'definitionLabo': '',
      'definitionFilipino':
          'kilos ng pagtatalik, lalo na sa mga hayop at manok',
      'definitionEnglish': 'act of mating, specially among animals and chicken',
      "audio": "assets/audio/Kuyamit L_20241124_125917.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kutib',
      'definitionLabo': '',
      'definitionFilipino': 'maliit na kagat',
      'definitionEnglish': 'small bite',
      "audio": "assets/audio/Kutib L_20241124_130044.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'tiik',
      'definitionLabo': '',
      'definitionFilipino': 'pananakal gamit ang kamay',
      'definitionEnglish': 'strangle with bare hands',
      "audio": "assets/audio/Tiik L_20241124_130106.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'bugti',
      'definitionLabo': '',
      'definitionFilipino': 'katulad ng punete (suntok)',
      'definitionEnglish': 'synonymous with `punete`',
      "audio": "assets/audio/Bugti L_20241124_130108.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'itumog',
      'definitionLabo': '',
      'definitionFilipino': 'lumubog sa tubig',
      'definitionEnglish': 'to submerge, as in body of water',
      "audio": "assets/audio/Itumog L_20241124_130111.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'lampadog',
      'definitionLabo': '',
      'definitionFilipino': 'bumagsak nang malakas',
      'definitionEnglish': 'falling with a thud',
      "audio": "assets/audio/Lampadog L_20241124_130113.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'sibot',
      'definitionLabo': '',
      'definitionFilipino': 'abala, nagmamadali',
      'definitionEnglish': 'busy',
      "audio": "assets/audio/Sibot L_20241124_130116.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kumuda',
      'definitionLabo': '',
      'definitionFilipino': 'aparador para sa damit',
      'definitionEnglish': 'cabinet for clothing',
      "audio": "assets/audio/Kumuda L_20241124_130121.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'hari-l',
      'definitionLabo': '',
      'definitionFilipino': 'laro ng taguan',
      'definitionEnglish': 'a game of hide-and-seek',
      "audio": "assets/audio/Hari-l L_20241124_130122.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'sinaludsod',
      'definitionLabo': '',
      'definitionFilipino': 'isang katutubong kakanin',
      'definitionEnglish': 'a native cake, not unlike the pancake',
      "audio": "assets/audio/Sinaludsod L_20241124_130125.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'upot',
      'definitionLabo': '',
      'definitionFilipino': 'isang tao na talo nang todo',
      'definitionEnglish': 'a roundly-defeated fellow, at the tail-end',
      "audio": "assets/audio/Upot L_20241124_130126.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'mahaldat',
      'definitionLabo': '',
      'definitionFilipino': 'masakit, tulad ng masakit na tiyan',
      'definitionEnglish': 'painful, as a painful stomach',
      "audio": "assets/audio/Mahaldat L_20241124_130128.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'baghuk',
      'definitionLabo': '',
      'definitionFilipino': 'tamad',
      'definitionEnglish': 'lazy',
      "audio": "assets/audio/Baghuk L_20241124_130129.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'bangkukang',
      'definitionLabo': '',
      'definitionFilipino': 'ipis',
      'definitionEnglish': 'cockcroach',
      "audio": "assets/audio/Bangkukang L_20241124_130132.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'lulam',
      'definitionLabo': '',
      'definitionFilipino': 'wala sa sarili',
      'definitionEnglish': 'out of wits',
      "audio": "assets/audio/Lulam L_20241124_130134.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hagpuk',
      'definitionLabo': '',
      'definitionFilipino': 'ignorante, walang alam',
      'definitionEnglish': "ignoramus; doesn't know anything",
      "audio": "assets/audio/Hagpuk L_20241124_130137.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'naulkan',
      'definitionLabo': '',
      'definitionFilipino': 'halos nabulunan dahil sa bara sa lalamunan',
      'definitionEnglish': 'got almost choked due to clogged throat',
      "audio": "assets/audio/Naulkan L_20241124_130138.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tabuldo',
      'definitionLabo': '',
      'definitionFilipino': 'kamote',
      'definitionEnglish': 'sweet potato; camote',
      "audio": "assets/audio/Tabuldo L_20241123_202240.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'tam-ak',
      'definitionLabo': '',
      'definitionFilipino': 'tapakan',
      'definitionEnglish': 'step-on',
      "audio": "assets/audio/Tam-ak L_20241123_202242.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'tamilmil',
      'definitionLabo': '',
      'definitionFilipino':
          'isang taong halos hindi kumakain o halos hindi nagsasalita',
      'definitionEnglish':
          'one who barely touches his food;\nalso, one who barely speaks',
      "audio": "assets/audio/Tamilmil L_20241123_202235.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'turay-og',
      'definitionLabo': '',
      'definitionFilipino':
          'ang kilos ng mabilis na pag-akyat at dahan-dahang pagbaba',
      'definitionEnglish': 'the act of shooting-up high and going down slowly',
      "audio": "assets/audio/Turay-og L_20241123_202233.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'sig-ok',
      'definitionLabo': '',
      'definitionFilipino': 'pag-iyak nang parang nasasakal',
      'definitionEnglish': 'sobbing half-chokingly',
      "audio": "assets/audio/Sig-ok L_20241123_202227.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'sungingi',
      'definitionLabo': '',
      'definitionFilipino': 'pagsiksik ng bibig sa ngipin',
      'definitionEnglish': 'pressing the mouth to the teeth',
      "audio": "assets/audio/Sungingi L_20241123_202218.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ragiik',
      'definitionLabo': '',
      'definitionFilipino': 'isang maingay na tunog na parang lumalangitngit',
      'definitionEnglish': 'a creaky sound',
      "audio": "assets/audio/Ragiik L_20241123_202213.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ragot',
      'definitionLabo': '',
      'definitionFilipino': 'pagkiskis ng ngipin',
      'definitionEnglish': 'gnashing of teeth',
      "audio": "assets/audio/Ragot L_20241123_202203.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'puk-it',
      'definitionLabo': '',
      'definitionFilipino':
          'pag-ikot o pagtanggal ng bagay gamit ang mga daliri',
      'definitionEnglish': "screw out with one's finger/s",
      "audio": "assets/audio/Puk-it L_20241123_202158.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'yukayok',
      'definitionLabo': '',
      'definitionFilipino': 'bahagyang nakayuko',
      'definitionEnglish': 'in semi-crouching position, usually out-of-despair',
      "audio": "assets/audio/Yukoyak L_20241123_202153.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'pastidyo',
      'definitionLabo': '',
      'definitionFilipino': 'makulit, pasaway',
      'definitionEnglish': 'a problem person',
      "audio": "assets/audio/Pastidyo L_20241123_202151.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'patitian',
      'definitionLabo': '',
      'definitionFilipino': 'pag-alis ng tubig',
      'definitionEnglish': 'drain out',
      "audio": "assets/audio/Patitian L_20241123_202148.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nguk-ngok',
      'definitionLabo': '',
      'definitionFilipino': 'ang pinakamaliit na pamilya ng kabibe',
      'definitionEnglish': 'the smallest member of the shell family',
      "audio": "assets/audio/Nguk ngok L_20241123_202146.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'natalik-ad',
      'definitionLabo': '',
      'definitionFilipino': 'natumba patalikod',
      'definitionEnglish': 'fell backward',
      "audio": "assets/audio/Natalik-ad L_20241123_202144.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'manatok',
      'definitionLabo': '',
      'definitionFilipino': 'masarap; malasa',
      'definitionEnglish': 'delicious; also, tasty',
      "audio": "assets/audio/Manatok L_20241123_202134.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'madata',
      'definitionLabo': '',
      'definitionFilipino': 'hindi ganoon kasarap',
      'definitionEnglish': 'not so good',
      "audio": "assets/audio/Madata L_20241123_202114.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'maantak',
      'definitionLabo': '',
      'definitionFilipino': 'masakit',
      'definitionEnglish': 'painful',
      "audio": "assets/audio/Maantak L_20241123_202112.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'labsak',
      'definitionLabo': '',
      'definitionFilipino':
          'isang kondisyon kung saan sumobra ang tubig at nasira ang timpla ng pagkain',
      'definitionEnglish':
          'a condition of too much water spoiling the mixture of food',
      "audio": "assets/audio/Labsak L_20241123_202053.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hilamon',
      'definitionLabo': '',
      'definitionFilipino':
          'ang paglilinis o pag-aalis ng mga damo na tumutubo sa paligid ng mga halaman',
      'definitionEnglish': 'the clearing of weeds that grow amont plants',
      "audio": "assets/audio/Hilamon L_20241123_202049.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'dik-il',
      'definitionLabo': '',
      'definitionFilipino': 'tuloy-tuloy na pagdikit, karaniwang sa braso',
      'definitionEnglish': 'an uninterrupted touch, usually in the arm',
      "audio": "assets/audio/Dik-il _20241123_202032.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'butilaw',
      'definitionLabo': '',
      'definitionFilipino': 'pagkain na niluto nang hindi sapat',
      'definitionEnglish': 'prematurely-cooked food',
      "audio": "assets/audio/Butilaw L_20241123_201954.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'butwa',
      'definitionLabo': '',
      'definitionFilipino': 'biglaang paglitaw',
      'definitionEnglish': 'sudden appearance',
      "audio": "assets/audio/Butwa L_20241123_201957.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'batikal',
      'definitionLabo': '',
      'definitionFilipino': 'paghagis',
      'definitionEnglish': 'throwing',
      "audio": "assets/audio/Batikal L_20241123_202000.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'batikalin',
      'definitionLabo': '',
      'definitionFilipino': 'ihagis',
      'definitionEnglish': 'to throw;',
      "audio": "assets/audio/Batikalin L_20241124_130231.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'bu-alaw',
      'definitionLabo': '',
      'definitionFilipino': 'duwag',
      'definitionEnglish': 'coward',
      "audio": "assets/audio/Bualaw L_20241123_202007.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kurahaw',
      'definitionLabo': '',
      'definitionFilipino': 'malakas na sigaw o iyak',
      'definitionEnglish': 'a loud shout or a loud cry',
      "audio": "assets/audio/Kurahaw L_20241123_202015.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kuribaw',
      'definitionLabo': '',
      'definitionFilipino': 'mabilis na pag-urong o pagtakbo palayo',
      'definitionEnglish': 'a running retreat',
      "audio": "assets/audio/Kuribaw L_20241123_202017.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kulambitay',
      'definitionLabo': '',
      'definitionFilipino': 'pagkapit, kadalasang sa lubid o baging',
      'definitionEnglish': 'hang on, usually to a rope or a vine',
      "audio": "assets/audio/Kulambitay L_20241123_202020.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kaslag',
      'definitionLabo': '',
      'definitionFilipino': 'isang taong hindi nananatili sa loob ng bahay',
      'definitionEnglish': 'one who does not stay put inside the house',
      "audio": "assets/audio/Kaslag L_20241123_202022.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kurapog',
      'definitionLabo': '',
      'definitionFilipino': 'isang mahigpit na pagkapit',
      'definitionEnglish': 'a crouching, give-no-quarters embrace',
      "audio": "assets/audio/Kurapog L_20241123_202024.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kuras-il',
      'definitionLabo': '',
      'definitionFilipino': 'magaspang',
      'definitionEnglish': 'coarse',
      "audio": "assets/audio/Kuras-il L_20241123_202026.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kutap-al',
      'definitionLabo': '',
      'definitionFilipino': 'makapal ang pagkalagay, karaniwang sa pampaganda',
      'definitionEnglish': 'heavily covered, usually with make up',
      "audio": "assets/audio/Kutap-al L_20241123_202028.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'ulsik',
      'definitionLabo': '',
      'definitionFilipino':
          'karaniwang ginagamit upang ilarawan ang mata na nakaumbok',
      'definitionEnglish':
          'usually an adjective that describes an eye that bulges out',
      "audio": "assets/audio/Ulsik L_20241123_202248.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'sukiti',
      'definitionLabo': '',
      'definitionFilipino': 'suntok mula sa ibaba',
      'definitionEnglish': 'a punch thrown from below',
      "audio": "assets/audio/Sukiti L_20241123_202421.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'nagraragiik',
      'definitionLabo': '',
      'definitionFilipino': 'bagay na gumagawa ng ingay',
      'definitionEnglish': 'an object that makes noise',
      "audio": "assets/audio/Nagraragiik L_20241124_235102.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'muringot',
      'definitionLabo': '',
      'definitionFilipino': 'laging nakasimangot',
      'definitionEnglish': 'always frowning',
      "audio": "assets/audio/Muringot L_20241124_235100.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'makuras-il',
      'definitionLabo': '',
      'definitionFilipino': 'magaspang sa dila',
      'definitionEnglish': 'rough on the tounge',
      "audio": "assets/audio/Makuras-il L_20241124_235057.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'Maantod',
      'definitionLabo': '',
      'definitionFilipino': 'amoy-araw',
      'definitionEnglish': 'smell of sunlight',
      "audio": "assets/audio/Maantod L_20241124_235053.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'mabaskog',
      'definitionLabo': '',
      'definitionFilipino': 'matatag ang binti hindi basta maitutumba',
      'definitionEnglish':
          "The legs are sturdy and won't easily be knocked down",
      "audio": "assets/audio/Mabaskog L_20241124_235052.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'lung-ad',
      'definitionLabo': '',
      'definitionFilipino': 'Paglabas ng sobrang gatas sa bibig ng sanggol',
      'definitionEnglish': "spitting up excess milk from the baby's mouth",
      "audio": "assets/audio/Lung-ad L_20241124_235050.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'ludag',
      'definitionLabo': '',
      'definitionFilipino': 'nagpuputik dahil laging dinadaanan',
      'definitionEnglish': 'becoming muddy due to frequent passing',
      "audio": "assets/audio/Ludag L_20241124_235043.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'likot',
      'definitionLabo': '',
      'definitionFilipino': 'laro',
      'definitionEnglish': 'fidget',
      "audio": "assets/audio/Likot L_20241124_235040.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'lapusak',
      'definitionLabo': '',
      'definitionFilipino': 'laganap kahit saan',
      'definitionEnglish': 'widespread everywhere',
      "audio": "assets/audio/Lapusak L_20241124_235036.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'lagutok',
      'definitionLabo': '',
      'definitionFilipino': 'pagtunog ng kamay na pinapuputok',
      'definitionEnglish': 'the sound of clapping hands',
      "audio": "assets/audio/Lagutok L_20241124_235033.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'lagitik',
      'definitionLabo': '',
      'definitionFilipino': 'pagtunog ng mga bagay gawa sa kahoy o kawayan',
      'definitionEnglish': 'the sound of objects made of wood or bamboo',
      "audio": "assets/audio/Lagitik L_20241124_235031.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'lamak',
      'definitionLabo': '',
      'definitionFilipino': 'apaw na apaw sa lalagyan',
      'definitionEnglish': 'overflowing from the container',
      "audio": "assets/audio/Lamak L_20241124_235024.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kuyapot',
      'definitionLabo': '',
      'definitionFilipino': 'bigas na mahirap isaing',
      'definitionEnglish': 'rice that is hard to cook',
      "audio": "assets/audio/Kuyapot L_20241124_235017.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kurubot',
      'definitionLabo': '',
      'definitionFilipino': 'kulubot ang balat',
      'definitionEnglish': 'wrinkled skin',
      "audio": "assets/audio/Kurubot L_20241124_235013.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'kimpi',
      'definitionLabo': '',
      'definitionFilipino': 'kasag, maliit na alimango',
      'definitionEnglish': 'small crab',
      "audio": "assets/audio/Kimpi L_20241124_235006.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kamrag',
      'definitionLabo': '',
      'definitionFilipino': 'kalmot',
      'definitionEnglish': 'scratch',
      "audio": "assets/audio/Kamrag L_20241124_234959.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'kalugkog',
      'definitionLabo': '',
      'definitionFilipino': 'paggawa ng ingay',
      'definitionEnglish': 'making noise',
      "audio": "assets/audio/Kalugkog L_20241124_234957.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'kablit',
      'definitionLabo': '',
      'definitionFilipino': 'kalabit',
      'definitionEnglish': 'tap',
      "audio": "assets/audio/Kablit L_20241124_234952.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'huplos',
      'definitionLabo': '',
      'definitionFilipino': 'makabitaw o makawala sa pagkakahawak',
      'definitionEnglish': 'to break free',
      "audio": "assets/audio/Huplos L_20241124_234947.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'hiplak/Kupos',
      'definitionLabo': '',
      'definitionFilipino': 'walang laman ang tiyan',
      'definitionEnglish': 'empty stomach',
      "audio": "assets/audio/Hiplak o Kupos L_20241124_234945.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hindaw',
      'definitionLabo': '',
      'definitionFilipino': 'pag-amot ng isang bagay',
      'definitionEnglish': 'not attempting to get something',
      "audio": "assets/audio/Hindaw L_20241124_234943.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'hibtog',
      'definitionLabo': '',
      'definitionFilipino': 'pagtaba ng katawan',
      'definitionEnglish': 'bloated',
      "audio": "assets/audio/Hibtog L_20241124_234941.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'hamag',
      'definitionLabo': '',
      'definitionFilipino': 'pakikipagkulitan',
      'definitionEnglish': 'teasing',
      "audio": "assets/audio/Hamag L_20241124_234940.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'gabsok',
      'definitionLabo': '',
      'definitionFilipino': 'gabi',
      'definitionEnglish': 'night',
      "audio": "assets/audio/Gabsok L_20241124_234934.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'gumrok',
      'definitionLabo': '',
      'definitionFilipino': 'mahigpit na hawak',
      'definitionEnglish': 'tight holding',
      "audio": "assets/audio/Gumrok L_20241124_234924.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'giprad',
      'definitionLabo': '',
      'definitionFilipino':
          'gustong laging naglalayas, di kuntento sa pamamahay, babaeng kalye',
      'definitionEnglish':
          'always wants to run away, not content with her home, street woman',
      "audio": "assets/audio/Giprad L_20241124_234859.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'git-ilin',
      'definitionLabo': '',
      'definitionFilipino': 'babaeng malandi, mataray, makiri',
      'definitionEnglish': 'stern women',
      "audio": "assets/audio/Git-ilin L_20241124_234856.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'gabok',
      'definitionLabo': '',
      'definitionFilipino': 'wala ng tibay',
      'definitionEnglish': 'lack of sturdiness',
      "audio": "assets/audio/Gabok L_20241124_234833.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'dul-ong',
      'definitionLabo': '',
      'definitionFilipino': 'masyadong malapit',
      'definitionEnglish': 'too close',
      "audio": "assets/audio/Dul-ong L_20241124_203238.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'butingting',
      'definitionLabo': '',
      'definitionFilipino': 'pagkalikot ng mga sirang kagamitan',
      'definitionEnglish': 'repairing broken things',
      "audio": "assets/audio/Butingting L_20241124_203145.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'buringot',
      'definitionLabo': '',
      'definitionFilipino': 'laging naka ismid',
      'definitionEnglish': 'the face always looks fierce',
      "audio": "assets/audio/Buringot L_20241124_203143.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'burakat',
      'definitionLabo': '',
      'definitionFilipino': 'malaking mata',
      'definitionEnglish': 'bulging eyes',
      "audio": "assets/audio/Burakat L_20241124_203140.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'bunggo',
      'definitionLabo': '',
      'definitionFilipino': 'mahiyain',
      'definitionEnglish': 'shy',
      "audio": "assets/audio/Bunggo L_20241124_203017.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'Bungal',
      'definitionLabo': '',
      'definitionFilipino': 'bungi',
      'definitionEnglish': 'gap-toothed',
      "audio": "assets/audio/Bungal L_20241124_203015.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bung-aw',
      'definitionLabo': '',
      'definitionFilipino': 'maliit na kuwebang may tubig',
      'definitionEnglish': 'small cave with water',
      "audio": "assets/audio/Bung-aw L_20241124_203013.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bulinaw',
      'definitionLabo': '',
      'definitionFilipino': 'dilis na puti',
      'definitionEnglish': 'white anchovy',
      "audio": "assets/audio/Bulinaw L_20241124_203012.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bugkos',
      'definitionLabo': '',
      'definitionFilipino': 'bungos',
      'definitionEnglish': 'bunch',
      "audio": "assets/audio/Bugkos L_20241124_203006.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'botog',
      'definitionLabo': '',
      'definitionFilipino': 'hindi nagsasabi ng totoo/sinungaling',
      'definitionEnglish': 'liar',
      "audio": "assets/audio/Botog L_20241124_203003.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'bistay',
      'definitionLabo': '',
      'definitionFilipino': 'bilao',
      'definitionEnglish': 'flat basket',
      "audio": "assets/audio/Bistay L_20241124_203001.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bingot',
      'definitionLabo': '',
      'definitionFilipino': 'ngongo',
      'definitionEnglish': 'nasally',
      "audio": "assets/audio/Bingot L_20241124_202959.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bigik',
      'definitionLabo': '',
      'definitionFilipino': 'pinakamaliit ng biik',
      'definitionEnglish': 'smallest piglet',
      "audio": "assets/audio/Bigik L_20241124_202953.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'bayambang',
      'definitionLabo': '',
      'definitionFilipino': 'sako',
      'definitionEnglish': 'sack',
      "audio": "assets/audio/Bayambang L_20241124_202951.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'bangot',
      'definitionLabo': '',
      'definitionFilipino': 'sahog sa ulam',
      'definitionEnglish': 'ingredient in the dish',
      "audio": "assets/audio/Bangot L_20241124_202949.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'balinghoy',
      'definitionLabo': '',
      'definitionFilipino': 'kamoteng kahoy o kanggos',
      'definitionEnglish': 'cassava',
      "audio": "assets/audio/Balinghoy L_20241124_202948.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'baligwat',
      'definitionLabo': '',
      'definitionFilipino': 'pasanin para gumaan ang dala-dala',
      'definitionEnglish': 'carrier',
      "audio": "assets/audio/Baligwat L_20241124_202944.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'baak',
      'definitionLabo': '',
      'definitionFilipino': 'basag, hiwa, biyak',
      'definitionEnglish': 'broken',
      "audio": "assets/audio/Baak L_20241124_202940.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'aritiit',
      'definitionLabo': '',
      'definitionFilipino': 'makating makati',
      'definitionEnglish': 'extremely itchy',
      "audio": "assets/audio/Aratiit L_20241124_202936.mp3",
      'subcategory': 'Pang-uri'
    },
    {
      'word': 'alulunti',
      'definitionLabo': '',
      'definitionFilipino': 'bulating lupa',
      'definitionEnglish': 'earthworm',
      "audio": "assets/audio/Alulunti L_20241124_202934.mp3",
      'subcategory': 'Pangngalan'
    },
    {
      'word': 'pugyapot',
      'definitionLabo': '',
      'definitionFilipino': 'nagsusumikap, nagkukumahog, naghihirap',
      'definitionEnglish': 'striving',
      "audio": "assets/audio/Pugyapot L_20241124_202650.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'naglulupagi',
      'definitionLabo': '',
      'definitionFilipino': 'naupo sa sahig o lupa',
      'definitionEnglish': 'sat on the floor or ground',
      "audio": "assets/audio/Naglulupagi L _20241124_130154.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'ukyabit',
      'definitionLabo': '',
      'definitionFilipino': 'kumapit tulad ng linta',
      'definitionEnglish': 'to cling to, to hold on to like a leech',
      "audio": "assets/audio/Ukyabit L _20241124_130023.mp3",
      'subcategory': 'Pandiwa'
    },
    {
      'word': 'linterok',
      'definitionLabo': '',
      'definitionFilipino':
          'banayad na salita na ginagamit sa pagsasabi ng masamang salita',
      'definitionEnglish': 'a mild world used for cursing',
      "audio": "assets/audio/Linterok L_20241124_125911.mp3",
      'subcategory': 'Pang-uri'
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
          .where('category', isEqualTo: 'Lalawiganin') // Only Kolokyal category
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
                                      builder: (context) => ViewNoteView(
                                        word: item['word'] ?? '',
                                        definitionLabo:
                                            item['definitionLabo'] ?? '',
                                        definitionFilipino:
                                            item['definitionFilipino'] ?? '',
                                        definitionEnglish:
                                            item['definitionEnglish'] ?? '',
                                        category: widget.category,
                                        audioFilePath: item['audio'] ?? '',
                                        meaning: item['subcategory'] ?? '',
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
                            builder: (context) => HomeView(),
                          ),
                        ).then((newWord) => _loadWordsFromDatabase(newWord));
                        break;
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
                            builder: (context) =>
                                const BookmarkedView(category: ''),
                          ),
                        );
                        break;
                      // case 3:
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const BookmarkedView(),
                      //     ),
                      //   );
                      //   break;
                      case 3:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Proponents(),
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
