class ListItem {
  //Pongo los atributos que coinciden con la tabla
  int id;
  int idList;
  String name;
  String quantity;
  String note;

  ListItem(this.id, this.idList, this.name, this.quantity, this.note);

  //Se hace un mapeo
  Map<String, dynamic> toMap() {
    return{
      'id': (id == 0) ? null : id,
      'idlist': idList,
      'quantity': quantity,
      'name': name,
      'note' : note
    };
  }
}
