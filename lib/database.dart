import 'package:chelita_app/cliente.dart';
import 'package:chelita_app/pago.dart';
import 'package:chelita_app/pedido.dart';
import 'package:sqflite/sqflite.dart';

class ChelitaDatabase {
  Database chelitappDb;

  init() async {
    print('Initialize DB');
    chelitappDb = await openDatabase('chelitapp.db', version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          "CREATE TABLE cliente (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, deuda REAL)");
      db.execute(
          "CREATE TABLE pedido (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, cantidad INTEGER, costo REAL, fecha TEXT, hora TEXT)");
      db.execute(
          "CREATE TABLE pago (id INTEGER PRIMARY KEY AUTOINCREMENT, cliente_id INTEGER NOT NULL, monto REAL, fecha TEXT, hora TEXT)");
    });
  }

  insertCliente(Cliente cliente) {
    chelitappDb.insert("cliente", cliente.toMap());
  }

  insertPedido(Pedido pedido) {
    chelitappDb.insert("pedido", pedido.toMap());
  }

  Future<List<dynamic>> getAllEventosCliente(int idCliente) async {
    List<Map<String, dynamic>> resultsPed = await chelitappDb
        .query("pedido", where: "cliente_id=?", whereArgs: [idCliente]);
    List<Pedido> pedidos =
        resultsPed.map((map) => Pedido.fromMap(map)).toList();
    List<Map<String, dynamic>> resultsPag = await chelitappDb
        .query("pago", where: "cliente_id=?", whereArgs: [idCliente]);
    List<Pago> pagos = resultsPag.map((map) => Pago.fromMap(map)).toList();
    var eventos = new List.empty(growable: true);
    eventos.addAll(pedidos);
    eventos.addAll(pagos);
    eventos.sort((a, b) => (a.fecha + a.hora).compareTo(b.fecha + b.hora));
    return eventos;
  }

  Future<List<Cliente>> getAllClientes() async {
    List<Map<String, dynamic>> results = await chelitappDb.query("cliente");
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<List<Cliente>> getCliente(int idCliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("cliente", where: "id=?", whereArgs: [idCliente]);
    return results.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<List<Pedido>> getPedidosCliente(int idCliente) async {
    List<Map<String, dynamic>> results = await chelitappDb
        .query("pedido", where: "cliente_id=?", whereArgs: [idCliente]);
    return results.map((map) => Pedido.fromMap(map)).toList();
  }

  Future updateCliente(Cliente cliente) async {
    chelitappDb.update("cliente", cliente.toMap(),
        where: "id=?", whereArgs: [cliente.id]);
  }

  insertPago(Pago pago) {
    chelitappDb.insert("pago", pago.toMap());
  }
}
