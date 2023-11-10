import 'package:flutter/material.dart';
import 'package:shopping_list_sem_12/models/list_items.dart';
import 'package:shopping_list_sem_12/util/dbhelper.dart';
import 'package:shopping_list_sem_12/models/shopping_list.dart';

class ListItemDialog{
  // Creo los controles para el campo name y prioridad
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  //Creo el método buildDialog
  Widget buildDialog(BuildContext context, ListItem item, bool isNew){
    DbHelper helper = DbHelper();
    if(!isNew){
      txtName.text = item.name;
      txtQuantity.text = item.quantity.toString();
      txtNote.text = item.note.toString();
    }
    else{
      txtName.text = "";
      txtQuantity.text = "";
      txtNote.text = "";
    }
    return AlertDialog(
      title: Text( (isNew) ? "New shopping item" : "Edit shopping item"),
      content: SingleChildScrollView( //Este widget genera la barra de desplazamiento
          child: Column(
            children: <Widget>[
              TextField(
                controller: txtName,
                decoration: const InputDecoration(
                    hintText: "Shopping Item Name"
                ),
              ),
              TextField(
                controller: txtQuantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: "Shopping Item Quantity"
                ),
              ),
              TextField(
                controller: txtNote,
                decoration: const InputDecoration(
                    hintText: "Shopping Item Note"
                ),
              ),
              ElevatedButton(
                child: const Text("Save shopping Item"),
                onPressed: (){
                  item.name = txtName.text;
                  item.quantity = txtQuantity.text;
                  item.note = txtNote.text;
                  print(" ${item.name} - ${item.quantity} - ${item.note} - ${item.idList}");
                  helper.insertItem(item);
                  Navigator.pop(context);
                },
              )
            ],
          )
      ),
    );
  }
}