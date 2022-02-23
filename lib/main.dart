import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';
  List? data;

  @override
  void initState() {
    super.initState();
    data = new List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTTP Example'),
      ),
      body: Center(
        child: data!.isEmpty
            ? const Text(
                '데이터가 없습니다.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Text(data![index]['title'].toString()),
                        Text(data![index]['authors'].toString()),
                        Text(data![index]['sale_price'].toString()),
                        Text(data![index]['status'].toString()),
                        Image.network(
                          data![index]['thumbnail'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        )
                      ],
                    ),
                  );
                },
                itemCount: data!.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getJSONData();
        },
        child: const Icon(Icons.file_download),
      ),
    );
  }

  Future<String> getJSONData() async {
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&query=doit';
    var response = await http.get(Uri.parse(url),
        headers: {'Authorization': "KakaoAK 2f6ee3fb00ba02dcd4cfd694dd5dbdba"});
    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data!.addAll(result);
    });
    return response.body;
  }
}
