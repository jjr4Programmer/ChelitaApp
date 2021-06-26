import 'dart:async';

import 'package:chelita_app/cliente.dart';
import 'package:chelita_app/database.dart';
import 'package:chelita_app/pedidoState.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChelitaDatabase db = ChelitaDatabase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: db.init(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return showListClients(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _addClient,
          tooltip: 'Increment',
          icon: Icon(Icons.add),
          label: Text(
              'Nuevo cliente')), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _addClient() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(icon: Icon(Icons.person_add)),
                onSubmitted: (text) {
                  setState(() {
                    db.insertCliente(Cliente(text));
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  showListClients(BuildContext context) {
    return FutureBuilder(
      future: db.getAllClientes(),
      builder: (BuildContext context, AsyncSnapshot<List<Cliente>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              for (Cliente cliente in snapshot.data)
                OutlineButton(
                  child: Text(
                    cliente.nombre + ' / Deuda: ' + cliente.deuda.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  highlightedBorderColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => MyClientPageState(
                              title: 'Cliente ' + cliente.nombre,
                              cliente: cliente,
                              db: db,
                            ));
                    Navigator.push(context, route).then(_stateUpdate);
                  },
                ),
            ],
          );
        } else {
          return Center(
            child: Text("Sin clientes"),
          );
        }
      },
    );
  }

  FutureOr _stateUpdate(dynamic value) {
    setState(() {});
  }
}