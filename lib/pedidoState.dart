import 'package:chelita_app/pago.dart';
import 'package:chelita_app/pedido.dart';
import 'package:flutter/material.dart';
import 'package:chelita_app/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'cliente.dart';
import 'evento.dart';

class MyClientPageState extends StatefulWidget {
  MyClientPageState({Key key, this.title, this.cliente, this.db})
      : super(key: key);
  final String title;
  final Cliente cliente;
  final ChelitaDatabase db;

  @override
  _MyClientPageState createState() => _MyClientPageState();
}

class _MyClientPageState extends State<MyClientPageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
      ),
      body: showListPedidosPagos(context, widget.cliente),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        backgroundColor: Color(0xFF801E48),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // Bot 1
          SpeedDialChild(
              child: Icon(Icons.monetization_on_outlined),
              backgroundColor: Color(0xFF801E48),
              onTap: _addPago,
              label: 'Nuevo pago',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48)),
          // Bot 2
          SpeedDialChild(
              child: Icon(Icons.liquor),
              backgroundColor: Color(0xFF801E48),
              onTap: _addPedido,
              label: 'Nuevo Pedido',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xFF801E48))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addPedido() {
    Cliente cliente = widget.cliente;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                decoration:
                    new InputDecoration(labelText: "Cantidad de cervezas"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text) {
                  setState(() {
                    Pedido pedido = Pedido(cliente.id, int.parse(text));
                    widget.db.insertPedido(pedido);
                    cliente.deuda += pedido.monto;
                    widget.db.updateCliente(cliente);
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  _addPago() {
    Cliente cliente = widget.cliente;
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                decoration: new InputDecoration(labelText: "Ingrese monto"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSubmitted: (text) {
                  setState(() {
                    Pago pago = Pago(cliente.id, double.parse(text));
                    widget.db.insertPago(pago);
                    cliente.deuda -= pago.monto;
                    widget.db.updateCliente(cliente);
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  showListPedidosPagos(BuildContext context, Cliente cliente) {
    print("PedidosPagos");
    return FutureBuilder(
      future: widget.db.getAllEventosCliente(cliente.id),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            ListView view = ListView(
              children: <Widget>[
                for (Evento ev in snapshot.data)
                  if (ev.tipo == 'pedido')
                    OutlineButton(
                      child: Text(
                        'Cervezas: ' +
                            ev.cantidad.toString() +
                            ' / ' +
                            ev.getFecha2() +
                            ' ' +
                            ev.hora,
                        style: TextStyle(fontSize: 15.0),
                      ),
                      hoverColor: Colors.blue,
                      highlightedBorderColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () {},
                    )
                  else
                    RaisedButton(
                      child: Text(
                        'Ingreso: ' +
                            ev.monto.toString() +
                            ' / ' +
                            ev.getFecha2() +
                            ' ' +
                            ev.hora,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {},
                    ),
              ],
            );
            return view;
          } else {
            return Center(
              child: Text("Sin Pedidos"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
