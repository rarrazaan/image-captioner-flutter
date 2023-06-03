// ignore_for_file: non_constant_identifier_names, no_logic_in_create_state

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'database/db_helper.dart';
import 'model/history.dart';

// ignore: must_be_immutable
class HistoryItemPage extends StatefulWidget {
  final Uint8List imageBytes;
  final History? history;
  final String? captions_en;
  final String? captions_id;
  const HistoryItemPage(
      {Key? key,
      required this.imageBytes,
      this.history,
      required this.captions_en,
      required this.captions_id})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      HistoryItemPageState(imageBytes, captions_en!, captions_id!);
}

class HistoryItemPageState extends State<HistoryItemPage> {
  DbHelper db = DbHelper();
  // ignore: prefer_typing_uninitialized_variables
  var data;
  Uint8List imageBytes;
  String captions_en;
  String captions_id;
  FlutterTts ftts = FlutterTts();

  HistoryItemPageState(this.imageBytes, this.captions_en, this.captions_id);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.2, 0.6, 0.8],
          colors: [
            Color.fromRGBO(44, 83, 100, 1),
            Color.fromRGBO(32, 58, 67, 1),
            Color.fromRGBO(15, 32, 39, 1),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // backgroundColor: Color(0x44000000),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Captions",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: displayImage(imageBytes),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  captions_en,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 200,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  captions_id,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center),
                    child: const Text(
                      "Audio-EN",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    // elevation: 5.0,
                    // color: Colors.white,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () => speakCaptionEN(),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center),
                    child: const Text(
                      "Audio-ID",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    // elevation: 5.0,
                    // color: Colors.white,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () => speakCaptionID(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  speakCaptionEN() async {
    await ftts.setLanguage("en-US");
    await ftts.setPitch(1);
    await ftts.speak(captions_en);
  }

  speakCaptionID() async {
    await ftts.setLanguage("id-ID");
    await ftts.setPitch(1);
    await ftts.speak(captions_id);
  }

  Widget displayImage(Uint8List imageBytes) {
    return SizedBox(
      height: 250.0,
      width: 200.0,
      // ignore: unnecessary_null_comparison
      child: imageBytes == null ? Container() : Image.memory(imageBytes),
    );
  }
}
