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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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

  Future<List<String>> getUserDetailsColumns() async {
  final db = await database;

  // Use PRAGMA to get the column info of user_details
  final List<Map<String, dynamic>> result = 
      await db.rawQuery("PRAGMA table_info(user_details)");

  // Extract column names from the result
  List<String> columns = [];
  for (var row in result) {
    columns.add(row['name'] as String);
  }

  // Print the list of columns
  print('Columns in user_details: $columns');
  return columns;
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
        audioFilePath TEXT,
        status TEXT DEFAULT 'pending'
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarked_words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT,
        definitionLabo TEXT,
        definitionFilipino TEXT,
        definitionEnglish TEXT,
        audioFilePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT,
        last_name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        userType TEXT CHECK(userType IN ('Teacher', 'Student')) NOT NULL DEFAULT 'Student'
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Creating a new table for user_details to include userType
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_details_new(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name TEXT,
          last_name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          userType TEXT CHECK(userType IN ('Teacher', 'Student')) NOT NULL DEFAULT 'Student'
        )
      ''');

      // Copy data from the old user_details table to the new one, setting a default userType
      await db.execute('''
        INSERT INTO user_details_new (id, first_name, last_name, email, password)
        SELECT id, first_name, last_name, email, password FROM user_details
      ''');

      // Drop the old table
      await db.execute('DROP TABLE IF EXISTS user_details');

      // Rename the new table to the original name
      await db.execute('ALTER TABLE user_details_new RENAME TO user_details');

      print("Database upgraded: user_details table updated to include userType.");
    }
  }

  Future<void> upgradeDatabase() async {
  final db = await database;

  try {
    // Check current version and manually upgrade if needed
    int oldVersion = await db.getVersion();
    int newVersion = 2; // Define the target version

    if (oldVersion < newVersion) {
      await _onUpgrade(db, oldVersion, newVersion);
      print("Database upgraded from version $oldVersion to $newVersion.");
    } else {
      print("Database is already up-to-date.");
    }
  } catch (e) {
    print("Error upgrading database: $e");
  }
}

  Future<void> deleteAllData() async {
    final db = await database;
    await Future.wait([
      db.delete('notes'),
      db.delete('user_details'),
      db.delete('bookmarked_words'),
    ]);
    print("All data deleted from users and user_details");
  }

  Future<List<String>> getExistingTables() async {
  final db = await database;

  // Query sqlite_master to get all table names
  final List<Map<String, dynamic>> result = 
      await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

  // Extract table names from the result
  List<String> tables = [];
  for (var row in result) {
    tables.add(row['name'] as String);
  }

  // Print the list of tables
  print('Existing tables: $tables');
  return tables;
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
          password TEXT,
          user_type TEXT CHECK(user_type IN ('Teacher', 'Student')) NOT NULL DEFAULT 'Student'
        )
      ''');
      print('user_details table created or already exists.');
    } catch (e) {
      print('Error creating user_details table: $e');
    }
  }

  // Insert a new note into the database
  Future<int> insertNote(Map<String, dynamic> note) async {
    Database db = await database;
    return await db.insert('notes', note,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> fetchStudentName() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('user_details', limit: 1);
    if (results.isNotEmpty) {
      String firstName = results.first['first_name'] as String? ?? '';
      String lastName = results.first['last_name'] as String? ?? '';
      return '$firstName $lastName';
    }
    return null;
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
    final result =
        await db.query('bookmarked_words'); // Adjust table name as needed
    return result;
  }

  // Fetch all words from the notes table
  Future<List<Map<String, dynamic>>> fetchWords() async {
    final db = await database;
    return db.query('notes');
  }

  Future<List<Map<String, dynamic>>> fetchAllWords() async {
    final db = await database; // Replace with your database instance retrieval
    return await db
        .query('notes'); // Replace 'notes' with your actual table name
  }

  // Close the database
  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
