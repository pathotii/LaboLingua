import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../user_details.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'user_library_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // If your primary key is an integer
  Future<void> removeBookmark(int id) async {
    final db = await database;

    await db.delete(
      'bookmarked_words',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        definitionLabo TEXT,
        definitionFilipino TEXT,
        definitionEnglish TEXT,
        audioFilePath TEXT
      )
    ''');

    // Create table for bookmarked words
    await db.execute('''
      CREATE TABLE bookmarked_words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        definitionLabo TEXT,
        definitionFilipino TEXT,
        definitionEnglish TEXT
        audioFilePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT,
        last_name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<void> insertUser(UserDetails user) async {
    final db = await database;
    int id = await db.insert(
      'user_details',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("User inserted with id: $id"); // Add this line to confirm insertion
  }

  Future<List<UserDetails>> users() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_details');

    return List.generate(maps.length, (i) {
      return UserDetails.fromMap(maps[i]);
    });
  }

  Future<void> createBookmarkedWordsTable() async {
    final db = await database;
    try {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS bookmarked_words (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, definitionLabo TEXT, definitionFilipino TEXT, definitionEnglish TEXT, audioFilePath TEXT)',
      );
      print('Table created or already exists.');
    } catch (e) {
      print('Error creating table: $e');
    }
  }

  Future<void> createUserDetailsTable() async {
  final db = await database;
  try {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT,
        last_name TEXT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
    print('User details table created or already exists.');
  } catch (e) {
    print('Error creating user details table: $e');
  }
}


  // Insert a new note into the database
  Future<int> insertNote(Map<String, dynamic> note) async {
    Database db = await database;
    return await db.insert('notes', note,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert a new bookmarked word into the database
  Future<int> insertBookmark(Map<String, dynamic> bookmark) async {
    Database db = await database;
    return await db.insert('bookmarked_words', bookmark,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch all bookmarked words from the database
  Future<List<Map<String, dynamic>>> getBookmarkedWords() async {
    final db = await database;
    final result = await db.query('bookmarked_words'); // Adjust table name as needed
    return result;
  }

  // Fetch all words from the notes table
  Future<List<Map<String, dynamic>>> fetchWords() async {
    final db = await database;
    return db.query('notes');
  }

  Future<List<Map<String, dynamic>>> fetchAllWords() async {
    final db = await database; // Replace with your database instance retrieval
    return await db.query('notes'); // Replace 'notes' with your actual table name
  }


  // Close the database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
