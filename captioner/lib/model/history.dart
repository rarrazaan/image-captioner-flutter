// ignore_for_file: file_names, unnecessary_this, prefer_collection_literals

import 'dart:typed_data';

class History {
  int? id;
  String? caption;
  String? keterangan;
  late Uint8List image;

  History({this.id, this.caption, this.keterangan, required this.image});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['caption'] = caption;
    map['keterangan'] = keterangan;
    map['image'] = image;

    return map;
  }

  History.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.caption = map['caption'];
    this.keterangan = map['keterangan'];
    this.image = map['image'];
  }
}
