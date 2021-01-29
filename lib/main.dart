import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(Escaner());

class Escaner extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<Escaner> {
  String lecturaEscaner = '';

  @override
  void initState() {
    super.initState();
  }


// -------------------- CÓDIGO DE BARRAS
  Future<void> escanerCodigoBarras() async {
    String lecturaCodigoBarras;

    try {
      lecturaCodigoBarras = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true, ScanMode.BARCODE);
    }
    on PlatformException {
      lecturaCodigoBarras = 'Falló al obtener la versión de la plataforma';
    }

    if (!mounted) return;

    setState(() {
      lecturaEscaner = lecturaCodigoBarras;
    });
  }

// -------------------- CÓDIGO QR
  Future<void> escanerQR() async {
    String lecturaQR;

    try {
      lecturaQR = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancelar", true, ScanMode.QR);
    } on PlatformException {
      lecturaQR = 'Falló al obtener la versión de la plataforma';
    }

    if (!mounted) return;

    setState(() {
      lecturaEscaner = lecturaQR;
    });
  }



  // -------------------- CÓDIGO DE BARRAS FLUJO
  codigoBarrasStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }



  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Lector de códigos')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            onPressed: () => escanerCodigoBarras(),
                            child: Text("Código de Barras")),
                        RaisedButton(
                            onPressed: () => escanerQR(),
                            child: Text("Código QRn")),
                        RaisedButton(
                            onPressed: () => codigoBarrasStream(),
                            child: Text("Flujo de código de barras")),
                        Text('Valor: $lecturaEscaner\n',
                            style: TextStyle(fontSize: 20))
                      ]));
            })




        )
  );
}