import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// const apiUrl = 'https://api.hgbrasil.com/finance?format=json&key=60df7606';

void main() {
  runApp(
    MaterialApp(
      home: const ConverterHome(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

Future<Map> getData() async {
  var url = Uri.parse('https://api.hgbrasil.com/finance');
  var response = await http.get(url);
  return json.decode(response.body);
}

class ConverterHome extends StatefulWidget {
  const ConverterHome({Key? key}) : super(key: key);

  @override
  _ConverterHomeState createState() => _ConverterHomeState();
}

class _ConverterHomeState extends State<ConverterHome> {
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  late double dollar;
  late double euro;

  void _onRealChange(String text) {
    if(text.isEmpty) {
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _onDollarChange(String text) {
    if(text.isEmpty) {
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _onEuroChange(String text) {
    if(text.isEmpty) {
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          '\$ Converter \$',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar dados :(',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: Text(
                'Loading data...',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.data != null) {
            dollar = (snapshot.data!['results']['currencies']['USD']['buy']);
            euro = (snapshot.data!['results']['currencies']['EUR']['buy']);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 150.0,
                  color: Colors.amber,
                ),
                buildTextField('Reais', 'R\$', realController, _onRealChange),
                const Divider(),
                buildTextField('Dollars', 'US\$', dollarController, _onDollarChange),
                const Divider(),
                buildTextField('Euros', '€', euroController, _onEuroChange),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildTextField(
  String label,
  String prefix,
  TextEditingController textEditingController,
  void Function(String string) function,
) {
  return TextField(
    controller: textEditingController,
    onChanged: function,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    style: const TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    decoration: InputDecoration(
      border: InputBorder.none,
      prefixText: prefix,
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.amber,
      ),
    ),
  );
}
