import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._(); // construtor privado, aonde outras partes do codigo nao conseguem acessar
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  static Future<Database> get database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'login.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        """
            CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
        """
      ),
    );
    return _db!;
  }

  // cadastra user
  Future<bool> registrar(String nome, String email, String senha) async {
    final db = await database;
    try {
      await db.insert('users', {
        'name': nome.trim(),
        'email': email.trim(),
        'password': senha.trim().toLowerCase(),
      });
      return true;
    } on DatabaseException {
      return false; // email ja existe (UNIQUE)
    }
  }

  // login
  Future<Map<String, Object?>?> login(String email, String senha) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), senha],
      limit: 1,
    );
    return result.isEmpty ? null : result.first;
  }
}
