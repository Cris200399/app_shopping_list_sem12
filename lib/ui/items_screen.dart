import 'package:flutter/material.dart';
import 'package:shopping_list_sem_12/ui/list_item_dialog.dart';
import 'package:shopping_list_sem_12/util/dbhelper.dart';
import 'package:shopping_list_sem_12/models/shopping_list.dart';
import 'package:shopping_list_sem_12/models/list_items.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);

  DbHelper? helper = DbHelper();
  List<ListItem> items = [];

  ListItemDialog? dialog;

  @override
  void initState() {
    dialog = ListItemDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(shoppingList.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          //Aqui se crea el ListTile
          return Dismissible(
            key: Key(items[index].name),
            onDismissed: (direction) {
              String strName = items[index].name;
              helper!.deleteItem(items[index]);
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              title: Text(items[index].name),
              subtitle: Text("Quantity: ${items[index].quantity} - Note: ${items[index].note}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog!.buildDialog(context, items[index], false));
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog!.buildDialog(context, ListItem(0,this.shoppingList.id,"","",""), true));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.yellow,
        tooltip: "Add new Item",
      ),
    );
  }

  Future showData(int idList) async{
    await helper!.openDb();
    items = await helper!.getItems(idList);
    setState(() {
      items = items;
    });
  }

}
