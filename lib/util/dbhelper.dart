//importo los 2 paquetes
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:shopping_list_sem_12/models/shopping_list.dart';
import 'package:shopping_list_sem_12/models/list_items.dart';

//En esta clase, vamos a crear la BD y las tablas!!

class DbHelper {
  //Las BD siempre manejan versiones
  final int version = 1;

  //Creo un objeto de la clase Database, clase de sqflite
  Database? db;

  //Código para que solo se abra una instancia de la BD.
  static final DbHelper dbHelper = DbHelper.internal();

  DbHelper.internal();

  factory DbHelper() {
    return dbHelper;
  }

  //Creo el metodo asíncrono openDB
  Future<Database> openDb() async {
    //Este if es fundamental, ya que si NO EXISTE la BD la CREA.
    db ??= await openDatabase(
        join(await getDatabasesPath(), "shoppingverfinal.db"),
        onCreate: (database, version) {
      //aqui corro un SQL

      database.execute('CREATE TABLE lists (id INTEGER PRIMARY KEY, '
          'name TEXT, priority INTEGER)');

      //creo la otra tabla

      database.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, idlist INTEGER, name TEXT, quantity INTEGER, note TEXT, FOREIGN KEY(idlist) REFERENCES lists(id))');
    }, version: version);
    //el if no tiene else
    //esto quiere que si la BD ya existe, solo la devuelve.
    return db!;
  }

  Future testDB() async {
    db = await openDb(); //aqui llamo al metodo que hicimos hace un momento
    //Voy a insertar 1 dato para ver si funciona
    await db!.execute('INSERT INTO lists VALUES(0, "Frutas", 1)');
    await db!.execute(
        'INSERT INTO items VALUES(0, 0, "Manzana", "20 unds", "De preferencia roja")');
    //haré un select y la respuesta se grabará e una lista
    //se usa rawQuery para hacer consultas
    List list = await db!.rawQuery('SELECT * from lists');
    List item = await db!.rawQuery('SELECT * from items');
    //imprimimos en consola la clase
    print(list[0]);
    print(item[0]);
  }

  //Insert List
  Future<int> insertList(ShoppingList list) async {
    int id = await this.db!.insert('lists', list.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace // Esto permite actualizar el registro
        );
    return id;
  }

  // Lo mismo para la tabla items
  Future<int> insertItem(ListItem item) async {
    int id = await this.db!.insert('items', item.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace // Esto permite actualizar el registro
        );
    return id;
  }

  //list tabla list
  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');
    return List.generate(maps.length, (i) {
      return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['priority']);
    });
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db!.query('items', where: 'idlist = ?', whereArgs: [idList]);
    // final List<Map<String, dynamic>> maps = await db!.query('items');
    // print("maps: $maps");

    return List.generate(maps.length, (i) {
      return ListItem(maps[i]['id'], maps[i]['idlist'], maps[i]['name'],
          maps[i]['quantity'].toString(), maps[i]['note']);
    });
  }

  //borrar tabla lists
  Future<int> deleteList(ShoppingList list) async {

    int result =
        await db!.delete('items', where: 'idList = ?', whereArgs: [list.id]);
    // int result = await db!.rawDelete('DELETE FROM items WHERE idList = ?', [list.id]);
    result = await db!.delete('lists', where: 'id = ?', whereArgs: [list.id]);

    return result;
  }

  //borrar tabla items
  Future<int> deleteItem(ListItem item) async {
    int result = await db!.delete('items', where: 'id = ?', whereArgs: [item.id]);
    return result;
  }
}
