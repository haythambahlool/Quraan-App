import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class neww extends StatelessWidget {
  const neww({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  List _items = [];
  String SurahName = '';

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["sura"];
    });
  }

  @override
  void initState() {
    readJson();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeab676),
      body: PageView.builder(
        reverse: true,
        itemCount: 604,
        itemBuilder: (BuildContext context, int index) {
          if (_items.isNotEmpty) {
            String byPage = '';
            String surahName = '';
            int jozzName = 0;

            for (Map ayah in _items) {
              if (ayah['page'] == index + 1) {
                byPage = byPage + ' ${ayah['aya_text']}';
                print(_items[index]['aya_text']);
              }
            }

            for (Map surhName in _items) {
              if (surhName['page'] == index + 1) {
                surahName = surhName['sura_name_ar'];
                print(_items[index]['sura_name_ar']);
              }
            }

            for (Map jozzNum in _items) {
              if (jozzNum['page'] == index + 1) {
                jozzName = jozzNum['jozz'];
                print(_items[index]['jozz']);
              }
            }

            return SafeArea(
              child: Container(
                decoration: index % 2 == 0
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                            Colors.black12,
                            Colors.transparent,
                            Colors.transparent
                          ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight))
                    : BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                            Colors.black12,
                            Colors.transparent,
                            Colors.transparent
                          ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الجزء $jozzName',
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                surahName,
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          byPage,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontFamily: 'Hafs', fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontFamily: 'Kitab', fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
