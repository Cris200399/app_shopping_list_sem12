import 'package:flutter/material.dart';
import 'package:shopping_list_sem_12/ui/items_screen.dart';
import 'package:shopping_list_sem_12/ui/shopping_list_dialog.dart';
import 'package:shopping_list_sem_12/util/dbhelper.dart';

import 'package:shopping_list_sem_12/models/shopping_list.dart';
import 'package:shopping_list_sem_12/models/list_items.dart';

//llamamos a la clase DbHelper
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Llamo a DbHelper
    // DbHelper helper = DbHelper();
    // Llamo al método testDb
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ShowList());
  }
}

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList = [];

  ShoppingListDialog? dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          //Aqui se crea el ListTile
          return Dismissible(
            key: Key(shoppingList[index].name),
            onDismissed: (direction) {
              String strName = shoppingList[index].name;
              helper.deleteList(shoppingList[index]);
              setState(() {
                shoppingList.removeAt(index);
                setState(() {
                  shoppingList = shoppingList;
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
                title: Text(shoppingList[index].name),
                leading: CircleAvatar(
                  child: Text(shoppingList[index].priority.toString()),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //Aqui se llama al dialogo
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog!
                            .buildDialog(context, shoppingList[index], false));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemsScreen(shoppingList[index]),
                    ),
                  );
                }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog!.buildDialog(context, ShoppingList(0, "", 0), true));
        },
        child: const Icon(Icons.add),
        elevation: 6.0,
        backgroundColor: Colors.red,
      ),
    );
  }

  Future showData() async {
    await helper.openDb(); // Abro la BD
    // Llamo al método que me devuelve todas las listas
    shoppingList = await helper.getLists();
    // print(shoppingList[1].id);

    // Actualizo la lista con setState
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
