import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './memo.dart';

class DBHelper {
 static Database _db;

 Future <Database> get db async {
   if(_db != null) return _db;

   _db = await initDB();
   return _db;
 }

 initDB() async {
   io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
   String path = join(documentsDirectory.path, "memo.db");
   var createdDB = await openDatabase(path, version: 1, onCreate: _onCreate);
   return createdDB;
 }

 _onCreate(Database db, int version) async {
   await db.execute(
     "create table Memo(id INTEGER PRIMARY KEY, content TEXT, finished BOOLEAN)"
   );
   print("CREATE!!"); //デバッグ用 あとで消しましょう
 }

 void saveMemo(Memo memo) async {
   var dbClient = await db;
   await dbClient.transaction( (txn) async {
     return await txn.rawInsert(
       'insert into Memo(content, finished) values(${memo.content}, ${memo.finished});'
     );
   });
 }

 Future<List<Memo>> getMemos() async {
   var dbClient = await db;
   List<Map> list = await dbClient.rawQuery('select * from Memo');

   List<Memo> memos = new List();
   list.map((item) {
     memos.add(new Memo(id: item['id'],content: item['content'], finished: item['finished']));
   });

   return memos;
 }
}