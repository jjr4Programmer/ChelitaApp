class Evento {
  String fecha, hora, tipo;
  double monto;
  int cantidad;

  String getFecha() {
    var fechal = this.fecha.split('-');
    var fecha2 = fechal[2] + "-" + fechal[1];
    return fecha2;
  }
}
