import 'package:chelita_app/evento.dart';
import 'package:intl/intl.dart';

class Pago extends Evento {
  int idCliente, id;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Pago(int idCliente, double monto) {
    this.idCliente = idCliente;
    this.monto = monto;
    List<String> fechaHora = dateFormat.format(DateTime.now()).split(' ');
    this.fecha = fechaHora[0];
    this.hora = fechaHora[1];
  }

  Map<String, dynamic> toMap() {
    return {
      "cliente_id": idCliente,
      "monto": monto,
      "fecha": fecha,
      "hora": hora
    };
  }

  Pago.fromMap(Map<String, dynamic> map) {
    this.idCliente = map['cliente_id'];
    this.monto = map['monto'];
    this.fecha = map['fecha'];
    this.hora = map['hora'];
    this.id = map['id'];
    this.tipo = 'pago';
  }
}
