import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  RandomImage ri = RandomImage();

  void _incrementCounter() {
    setState(() {
      _counter++;
      ri.getRandomImage();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ri.curImage,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.abc),
      ),
    );
  }
}

class RandomImage{
  late Widget curImage;

  Future<String> fetchImageUrl() async {
    final response = await http
        .get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
    if (response.statusCode == 200) {
      Map<String,dynamic> json;
      json = jsonDecode(response.body)[0];
      return json["url"];
    } else {
      throw Exception('Failed to load album');
    }
  }

  RandomImage() {
    Future<String> imageUrl = fetchImageUrl();
    curImage = FutureBuilder(
      future: imageUrl,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.network(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  void getRandomImage(){
    Future<String> imageUrl = fetchImageUrl();
    curImage = FutureBuilder(
        future: imageUrl,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.network(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }
}
