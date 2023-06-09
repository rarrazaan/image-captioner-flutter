// ignore_for_file: unrelated_type_equality_checks

import 'history_page.dart';
import 'result_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'api.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  late File _image;

  Future getImage(bool isCamera) async {
    XFile? image;

    if (isCamera) {
      image = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    File img = File(image!.path);
    uploadImage(img, uploadUrl);
    Toast.show("IMAGE UPLOADED !",
        duration: Toast.lengthLong,
        webTexColor: Colors.white,
        backgroundColor: Colors.black54,
        backgroundRadius: 15,
        gravity: Toast.bottom);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Captioner',
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.insert_drive_file),
                color: Colors.white,
                iconSize: 70,
                onPressed: () {
                  getImage(false);
                },
              ),
              const SizedBox(
                height: 70.0,
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                color: Colors.white,
                iconSize: 70,
                onPressed: () {
                  getImage(true);
                },
              ),
              const SizedBox(
                height: 45.0,
              ),
              IconButton(
                icon: const Icon(Icons.history_edu_outlined),
                color: Colors.white,
                iconSize: 45,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryPage()));
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_image != Null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultPage(
                            image: _image,
                            key: null,
                          )));
            }
          },
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 30,
          ),
          label: const Text(
            "Next",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
