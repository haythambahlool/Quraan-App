import 'package:flutter/material.dart';

class AyaModel {
  late String aya_text, sura_name_ar, aya_text_emlaey;
  late int aya_no, page, jozz, id, suranum;

  AyaModel(
      {required this.id,
      required this.suranum,
      required this.aya_no,
      required this.aya_text,
      required this.jozz,
      required this.page,
      required this.sura_name_ar,
      required this.aya_text_emlaey});

  AyaModel.fromjson(Map<String, dynamic> map) {
    aya_text = map['aya_text'];
    sura_name_ar = map['sura_name_ar'];
    aya_no = map['aya_no'];
    page = map['page'];
    jozz = map['jozz'];
    id = map['id'];
    suranum = map['sura_no'];
    aya_text_emlaey = map['aya_text_emlaey'];
  }
}

class Tafseermodel {
  String? text;
  int? aya_no, suranum;

  Tafseermodel({this.text});
  Tafseermodel.fromjson(Map<String, dynamic> map) {
    text = map['text'];
    aya_no = map['aya'];
    suranum = map['sura'];
  }
}
