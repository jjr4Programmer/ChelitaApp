import 'package:intl/intl.dart';
import 'package:chelita_app/evento.dart';

class Pedido extends Evento {
  int idCliente, cantidad, id;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  double precioCerveza = 6.0;

  Pedido(int idCliente, int cantidad) {
    this.idCliente = idCliente;
    this.cantidad = cantidad;
    this.monto = cantidad * precioCerveza;
    List<String> fechaHora = dateFormat.format(DateTime.now()).split(' ');
    this.fecha = fechaHora[0];
    this.hora = fechaHora[1];
  }

  Map<String, dynamic> toMap() {
    return {
      "cliente_id": idCliente,
      "cantidad": cantidad,
      "costo": monto,
      "fecha": fecha,
      "hora": hora
    };
  }

  Pedido.fromMap(Map<String, dynamic> map) {
    this.idCliente = map['cliente_id'];
    this.cantidad = map['cantidad'];
    this.monto = map['costo'];
    this.fecha = map['fecha'];
    this.hora = map['hora'];
    this.id = map['id'];
    this.tipo = 'pedido';
  }
}
