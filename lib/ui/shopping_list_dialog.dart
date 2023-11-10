import 'package:flutter/material.dart';
import 'package:shopping_list_sem_12/util/dbhelper.dart';
import 'package:shopping_list_sem_12/models/shopping_list.dart';

class ShoppingListDialog{
  // Creo los controles para el campo name y prioridad
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  //Creo el método buildDialog
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }
    else{
      txtName.text = "";
      txtPriority.text = "";
    }
    return AlertDialog(
      title: Text( (isNew) ? "New shopping list" : "Edit shopping list"),
      content: SingleChildScrollView( //Este widget genera la barra de desplazamiento
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: const InputDecoration(
                hintText: "Shopping List Name"
              ),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Shopping List Priority (1-3)"
              ),
            ),
            ElevatedButton(
              child: const Text("Save shopping List"),
              onPressed: (){
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                txtName.clear();
                txtPriority.clear();
                Navigator.pop(context);
              },
            )
          ],
        )

      ),
    );
  }
}