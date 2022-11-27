import 'dart:convert';
import 'dart:math';

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
  int _mode = 0;
  RandomImage ri = RandomImage();
  RandomLocalImage rli = RandomLocalImage();

  void _changeImage() {
    setState(() {
      if(_mode==0) {
        ri.getRandomImage();
      }
      else{
        rli.changeImage();
      }
    });
  }

  void _changeMode(){
    setState(() {
      if (_mode == 1) {
        _mode = 0;
      }
      else {
        _mode = 1;
      }
    });
  }

  Widget _displayImage(){
    if(_mode==0){
      return ri.curImage;
    }
    else{
      return rli.image;
    }
  }

  Widget _displayMode(){
    if(_mode==0){
      return const Text("Network");
    }
    else{
      return const Text("Local");
    }
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
          children:<Widget>[
            _displayImage(),
            ElevatedButton(onPressed: _changeImage, child: const Text("Change Image")),
            ElevatedButton(onPressed: _changeMode, child: _displayMode()),
          ],
        ),
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

class RandomLocalImage{
  int n = 5;
  int cur = 1;
  late Widget image;

  RandomLocalImage(){
    image = Image.asset("asset/image1.jpeg");
  }
  void changeImage(){
    Random r = Random();
    int temp = r.nextInt(n)+1;
    while(temp==cur){
      temp = r.nextInt(n) + 1;
    }
    cur = temp;
    image = Image.asset("asset/image$cur.jpeg");
  }
}
