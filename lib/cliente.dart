class Cliente {
  String nombre;
  int id;
  double deuda = 0.0;

  Cliente(String nombre) {
    this.nombre = nombre;
  }

  Map<String, dynamic> toMap() {
    return {"nombre": nombre, "deuda": deuda};
  }

  Cliente.fromMap(Map<String, dynamic> map) {
    this.deuda = map['deuda'];
    this.nombre = map['nombre'];
    this.id = map['id'];
  }
}
