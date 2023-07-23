import 'package:my_news_app/consts/sqflite_consts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  String colId = "0";
  intialDb() async {
    String databasePath = await getDatabasesPath();
    // String path = join(databasePath, 'historydb.db');//SqfliteDbConstatnts.tableName
    String path = join(databasePath, SqfliteDbConstatnts.dbName); //.tableName

    Database noteDb = await openDatabase(path,
        onCreate: _onCreate, version: 1); // onUpgrade: _onUpgrade
    return noteDb;
  }

  _onCreate(Database db, int version) async {
    //colBookmarkKey
    await db.execute('''
CREATE TABLE ${SqfliteDbConstatnts.tableName} (${SqfliteDbConstatnts.colBookmarkKey} TEXT NOT NULL PRIMARY KEY , ${SqfliteDbConstatnts.colNewsId} TEXT , ${SqfliteDbConstatnts.colSourceName} TEXT ,
${SqfliteDbConstatnts.colAuthorName} TEXT , ${SqfliteDbConstatnts.colTitle} TEXT , ${SqfliteDbConstatnts.colDescription} TEXT ,
${SqfliteDbConstatnts.colUrl} TEXT, ${SqfliteDbConstatnts.colUrlToImage} BLOB, ${SqfliteDbConstatnts.colPublishedAt} TEXT , 
${SqfliteDbConstatnts.colDateToShow} TEXT , ${SqfliteDbConstatnts.colContent} TEXT , ${SqfliteDbConstatnts.colReadingTimeText} TEXT  )
'''); //id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT

    print("database is created successfuly ___________________________");
  }

//_______________________
//   _onCreate(Database db, int version) async {
//     await db.execute('''
// CREATE TABLE ${SqfliteDbConstatnts.tableName} (${SqfliteDbConstatnts.colId} TEXT NOT NULL  , ${SqfliteDbConstatnts.colName} TEXT ,
// ${SqfliteDbConstatnts.colPrice} INTEGER , ${SqfliteDbConstatnts.colImg} TEXT , ${SqfliteDbConstatnts.colQuantity} INTEGER ,
// ${SqfliteDbConstatnts.colIsExit} INTEGER, ${SqfliteDbConstatnts.colTime} TEXT )
// '''); //id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT

//     print("database is created successfuly ___________________________");
//   }

}
