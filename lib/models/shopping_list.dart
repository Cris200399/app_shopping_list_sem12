class ShoppingList {
  //Pongo los atributos que coinciden con la tabla
  int id;
  String name;
  int priority;

  ShoppingList(this.id, this.name, this.priority);

  //Se hace un mapeo
  Map<String, dynamic> toMap() {
    return{
      'id': (id == 0)? null : id,
      'name': name,
      'priority': priority
    };
  }
}
