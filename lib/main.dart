import 'package:dart_code_algorithms/dart_examples/type_map.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dart Code Algorithm Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> sports = ['kriket', 'futbol', 'tenis', 'beyzbol'];
  var mixList = [1, "a", 2, "b", 3, "c", 4, "d"];
  String? result;
  List<num> items = [5, 5, 5, 5, 5];
  List<dynamic> items2 = [
    "s",
    "b",
    null,
    4,
    null,
    " ",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Code Algorithms"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: onPressed,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (result ?? "İşlem başlat").toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 18),
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onPressed(),
        child: const Icon(Icons.add),
      ),
    );
  }

  onPressed() {
    result = listAddData(sports, "basketbol").toString();
    setState(() {});
  }
}
