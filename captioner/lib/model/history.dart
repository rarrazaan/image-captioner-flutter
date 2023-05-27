// ignore_for_file: file_names, unnecessary_this, prefer_collection_literals

import 'dart:io';
import 'dart:typed_data';

class History {
  int? id;
  String? caption;
  late Uint8List image;

  History({this.id, this.caption, required this.image});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['caption'] = caption;
    map['image'] = image;

    return map;
  }

  History.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.caption = map['caption'];
    this.image = map['image'];
  }
}
