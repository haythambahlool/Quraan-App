import 'dart:collection';
import 'dart:convert';
import 'package:challenge/model/AyaModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class pagequraan extends StatefulWidget {
  const pagequraan({super.key});

  @override
  State<pagequraan> createState() => _pagequraanState();
}

class _pagequraanState extends State<pagequraan> {
  List<AyaModel> quraan = [];
  List<InlineSpan> span = [];
  bool backgroundaya = false;
  int? id;
  bool end = false;
  final _key = GlobalKey<ExpandableFabState>();

  Future<void> getdata() async {
    final String response =
        await rootBundle.loadString('asset/hafs_smart_v8.json');

    final body = await jsonDecode(response);

    for (var item in body) {
      quraan.add(AyaModel.fromjson(item));
      // gettafseer(ayahnum: item['aya_no'], suranum: item['sura_no']);
    }
    setState(() {
      end = true;
    });
  }

  List<Tafseermodel> tafseer = [];
  Future<void> gettafseer() async {
    final String response =
        await rootBundle.loadString('asset/ar_muyassar.json');

    final body = await jsonDecode(response);
    for (var item in body) {
      tafseer.add(Tafseermodel.fromjson(item));
    }
  }

  late PageController _pageController;
  @override
  void initState() {
    getdata();
    gettafseer();
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 206, 147, 45),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
            PageView.builder(
              reverse: true,
              //physics: ScrollPhysics(parent: PageScrollPhysics()),
              controller: _pageController,
              itemCount: end == false ? 604 : quraan.length,
              itemBuilder: (context, index) {
                if (end == true) {
                  List<AyaModel> ayatThispage = [];
                  String sura = '';
                  int jozz = 0;
                  bool isBasmalahShown = false;

                  span = [];
                  for (var sour in quraan) {
                    if (sour.page == index + 1) {
                      ayatThispage.add(sour);
                      sura = sour.sura_name_ar;
                      jozz = sour.jozz;
                    }
                  }
                  for (var ayahData in quraan) {
                    if (ayahData.page == index + 1) {
                      if (ayahData.aya_no == 1 &&
                          ayahData.sura_name_ar != 'الفَاتِحة' &&
                          ayahData.sura_name_ar != 'التوبَة') {
                        isBasmalahShown = true;
                        break;
                      }
                    }
                  }

                  return SafeArea(
                    child: Container(
                      decoration: index % 2 == 0
                          ? const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                  Colors.black26,
                                  Colors.black12,
                                  Colors.transparent
                                ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight))
                          : const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                  Colors.black26,
                                  Colors.black12,
                                  Colors.transparent
                                ],
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الجزء $jozz',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'hafs'),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //     top: 5,
                                //   ),
                                //   child: CircleAvatar(
                                //     backgroundColor: Colors.white,
                                //     child: IconButton(
                                //         color: Color.fromARGB(255, 136, 91, 14),
                                //         onPressed: () {
                                //           showSearch(
                                //                   context: context,
                                //                   delegate:
                                //                       customsearch(quraan))
                                //               .then((value) {
                                //             setState(() {
                                //               id = value['id'];
                                //               backgroundaya = true;
                                //               goToPage(value['page']);
                                //             });
                                //           });
                                //         },
                                //         icon: Icon(Icons.search)),
                                //   ),
                                // ),
                                Text(
                                  '$sura',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontFamily: 'hafs'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            isBasmalahShown
                                ? const Text(
                                    "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontFamily: 'Hafs', fontSize: 22),
                                    textAlign: TextAlign.center,
                                  )
                                : Container(),
                            Expanded(
                              //height: size.height - 220,
                              // width: size.width - 50,
                              child: Center(
                                child: SingleChildScrollView(
                                    child: ayattext(ayatThispage)),
                              ),
                            ),
                            // Text(
                            //   '${ayat}',
                            //   style: TextStyle(fontSize: 20, fontFamily: 'hafs'),
                            //   textDirection: TextDirection.rtl,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFb07a1a),
                                      padding: EdgeInsets.all(8),
                                      shape: CircleBorder()),
                                  onPressed: nextPage,
                                  child: Icon(
                                    Icons.keyboard_double_arrow_left,
                                    color: Colors.white,
                                  ),
                                ),
                                Text('${index + 1}'),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFb07a1a),
                                      padding: EdgeInsets.all(8),
                                      shape: CircleBorder()),
                                  onPressed: previousPage,
                                  child: Icon(
                                    Icons.keyboard_double_arrow_right,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: SpinKitSpinningLines(
                      color: Colors.black54,
                      size: 50.0,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 605,
        ),
        child: ExpandableFab(
          key: key,
          // duration: const Duration(seconds: 1),
          distance: 45.0,
          type: ExpandableFabType.left,
          // fanAngle: 70,
          child: const Icon(Icons.search),
          // foregroundColor: Colors.amber,
          backgroundColor: Color.fromARGB(255, 189, 133, 36),
          closeButtonStyle: const ExpandableFabCloseButtonStyle(
            //   child: Icon(Icons.abc),
            //   foregroundColor: Colors.deepOrangeAccent,
            backgroundColor: Color.fromARGB(255, 189, 133, 36),
          ),
          overlayStyle: ExpandableFabOverlayStyle(
            // color: Colors.black.withOpacity(0.5),
            blur: 5,
          ),

          children: [
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 189, 133, 36),
              heroTag: null,
              child: const Text('آيات'),
              onPressed: () {
                showSearch(context: context, delegate: customsearch(quraan))
                    .then((value) {
                  setState(() {
                    id = value['id'];
                    backgroundaya = true;
                    goToPage(value['page']);
                  });
                });
              },
            ),
            FloatingActionButton.small(
              backgroundColor: Color.fromARGB(255, 189, 133, 36),
              heroTag: null,
              child: const Text('سور'),
              onPressed: () {
                showSearch(context: context, delegate: searchSurah(quraan))
                    .then((value) {
                  setState(() {
                    goToPagewithsura(value);
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page!.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void goToPage(int pagenum) {
    _pageController.animateToPage(pagenum - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void goToPagewithsura(int suraname) {
    int? pagenum;
    for (var sura in quraan) {
      if (sura.suranum == suraname) {
        pagenum = sura.page;
        break;
      }
    }

    _pageController.animateToPage(pagenum! - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  // Paint paint = Paint()
  //   ..style = PaintingStyle.stroke
  //   ..strokeJoin = StrokeJoin.miter
  //   //..strokeWidth = 2
  //   ..strokeCap = StrokeCap.round
  //   ..color = Colors.black.withOpacity(0.2);
  Widget ayattext(List<AyaModel> myAyat) {
    for (var item in myAyat) {
      span.add(
        TextSpan(
            text: ' ${item.aya_text}',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'hafs',
              color: Colors.black,
              backgroundColor:
                  id == item.id ? Colors.black.withOpacity(0.2) : null,
            ),
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () {
                setState(() {
                  if (id == null) {
                    id = item.id;
                    backgroundaya = true;
                    _modalBottomSheetMenu(
                        ayaNum: item.aya_no, suraNum: item.suranum);
                  } else if (id != null) {
                    id = null;
                    backgroundaya = false;
                  }
                });
              }),
      );
    }

    return RichText(
        textAlign: TextAlign.justify,
        // textWidthBasis: TextWidthBasis.longestLine,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: span,
        ));
  }

  String? getaya({required int ayaNum, required suraNum}) {
    for (var item in tafseer) {
      if (ayaNum == item.aya_no && suraNum == item.suranum) {
        return item.text;
      }
    }
  }

  void _modalBottomSheetMenu({required int ayaNum, required suraNum}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (builder) {
          return Container(
            height: 350.0,
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.0),
                      topRight: Radius.circular(100.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Icon(
                            Icons.keyboard_double_arrow_down,
                            color: Color(0xFFb07a1a),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 280,
                    width: 350,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 10, bottom: 15),
                    alignment: Alignment.center,
                    child: RawScrollbar(
                      trackRadius: Radius.circular(15),
                      trackVisibility: true,
                      trackColor: const Color.fromARGB(255, 251, 238, 207),
                      thumbColor: Color(0xFFb07a1a),
                      thumbVisibility: true,
                      radius: Radius.circular(15),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          '${getaya(ayaNum: ayaNum, suraNum: suraNum)}',
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                          // "تفسير هذه الأية",
                          style: TextStyle(color: Colors.brown, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //  const Center(
              //   child: Text("تفسير هذه الأية"),
              // ),
            ),
          );
        });
  }
}

class searchSurah extends SearchDelegate {
  searchSurah(this.quraan);

  List<AyaModel> quraan;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Set<AyaModel> sura = {};
    bool isexist = false;
    for (var sur in quraan) {
      bool isexist = false;
      for (var check in sura) {
        if (sur.sura_name_ar == check.sura_name_ar) {
          isexist = true;
        }
      }
      if (isexist == false) {
        sura.add(sur);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, sura.elementAt(index).suranum.toInt());
              },
              child: Text(
                textDirection: TextDirection.rtl,
                sura.elementAt(index).sura_name_ar,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: sura.length,
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Set<AyaModel> sura = {};
    bool isexist = false;
    for (var sur in quraan) {
      bool isexist = false;
      for (var check in sura) {
        if (sur.sura_name_ar == check.sura_name_ar) {
          isexist = true;
        }
      }
      if (isexist == false) {
        sura.add(sur);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, sura.elementAt(index).suranum.toInt());
              },
              child: Text(
                textDirection: TextDirection.rtl,
                sura.elementAt(index).sura_name_ar,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: sura.length,
        ));
  }
}

class customsearch extends SearchDelegate {
  customsearch(this.quraan);
  List<AyaModel> quraan;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<AyaModel> matchQuery = [];

    for (var ayat in quraan) {
      if (ayat.aya_text_emlaey.contains(query)) {
        matchQuery.add(ayat);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'id': matchQuery[index].id,
                  'page': matchQuery[index].page,
                });
              },
              child: Text(
                textDirection: TextDirection.rtl,
                matchQuery[index].aya_text,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: matchQuery.length,
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AyaModel> matchQuery = [];
    for (var ayat in quraan) {
      if (ayat.aya_text_emlaey.contains(query)) {
        matchQuery.add(ayat);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20, left: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'id': matchQuery[index].id,
                  'page': matchQuery[index].page,
                });
              },
              child: Text(
                matchQuery[index].aya_text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: matchQuery.length,
        ));
  }
}

class customsearchtopage extends SearchDelegate {
  customsearchtopage(this.quraan);
  List<AyaModel> quraan;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<AyaModel> matchQuery = [];

    for (var ayat in quraan) {
      if (ayat.aya_text_emlaey.contains(query)) {
        matchQuery.add(ayat);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'id': matchQuery[index].id,
                  'page': matchQuery[index].page,
                });
              },
              child: Text(
                textDirection: TextDirection.rtl,
                matchQuery[index].aya_text,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: matchQuery.length,
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AyaModel> matchQuery = [];
    for (var ayat in quraan) {
      if (ayat.aya_text_emlaey.contains(query)) {
        matchQuery.add(ayat);
      }
    }
    return RawScrollbar(
        trackRadius: Radius.circular(15),
        trackVisibility: true,
        trackColor: Color.fromARGB(255, 251, 238, 207),
        thumbColor: Color(0xFFb07a1a),
        thumbVisibility: true,
        radius: Radius.circular(15),
        child: ListView.builder(
          padding: EdgeInsets.only(right: 20, left: 10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, {
                  'id': matchQuery[index].id,
                  'page': matchQuery[index].page,
                });
              },
              child: Text(
                matchQuery[index].aya_text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'hafs',
                  color: Colors.black,
                ),
              ),
            );
          },
          itemCount: matchQuery.length,
        ));
  }
}
