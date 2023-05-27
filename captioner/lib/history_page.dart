// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls, non_constant_identifier_captions, unused_element, unused_local_variable, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'database/db_helper.dart';
import 'model/history.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FlutterTts ftts = FlutterTts();
  String captions = "Check Audio";
  List<History> listHistory = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    //menjalankan fungsi getallhistory saat pertama kali dimuat
    _getAllHistory();
    super.initState();
  }

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Container(
                //color: Colors.white,
                //margin: EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text(
                  "History",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listHistory.length,
                    itemBuilder: (context, index) {
                      History history = listHistory[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ListTile(
                          leading: Image.memory(history.image),
                          title: Text('${history.caption}'),
                          tileColor: Colors.white,
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // children: [
                            //     Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 8,
                            //     ),
                            //     child: Text("Email: ${history.email}"),
                            //     ),
                            //     Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 8,
                            //     ),
                            //     child: Text("Phone: ${history.mobileNo}"),
                            //     ),
                            //     Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 8,
                            //     ),
                            //     child: Text("Company: ${history.company}"),
                            //     )
                            // ],
                          ),
                          trailing: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              children: [
                                // button edit
                                IconButton(
                                    onPressed: () {
                                      captions = '${history.caption}';
                                      speakCaption();
                                      // _openFormEdit(history);
                                    },
                                    icon: Icon(Icons.audiotrack)),
                                // button hapus
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    //membuat dialog konfirmasi hapus
                                    AlertDialog hapus = AlertDialog(
                                      title: Text("Information"),
                                      content: Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                                "Yakin ingin Menghapus Data ${history.caption}")
                                          ],
                                        ),
                                      ),
                                      //terdapat 2 button.
                                      //jika ya maka jalankan _deleteHistory() dan tutup dialog
                                      //jika tidak maka tutup dialog
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              _deleteHistory(history, index);
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ya")),
                                        TextButton(
                                          child: Text('Tidak'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                    showDialog(
                                        context: context,
                                        builder: (context) => hapus);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                //membuat button mengapung di bagian bawah kanan layar
                // floatingActionButton: FloatingActionButton(
                //     child: Icon(Icons.add),
                //     onPressed: (){
                //     _openFormCreate();
                //     },
                // ),,
              )
            ],
          ),
        ),
      ),
    );
  }

  //mengambil semua data History
  Future<void> _getAllHistory() async {
    //list menampung data dari database
    var list = await db.getAllHistory();

    //ada perubahanan state
    setState(() {
      //hapus data pada listHistory
      listHistory.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((history) {
        //masukan data ke listHistory
        listHistory.add(History.fromMap(history));
      });
    });
  }

  //menghapus data History
  Future<void> _deleteHistory(History history, int position) async {
    await db.deleteHistory(history.id!);
    setState(() {
      listHistory.removeAt(position);
    });
  }

  speakCaption() async {
    await ftts.setLanguage("en-US");
    await ftts.setPitch(1);
    await ftts.speak(captions);
  }

  // // membuka halaman tambah History
  // Future<void> _openFormCreate() async {
  // var result = await Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => FormHistory()));
  // if (result == 'save') {
  //     await _getAllHistory();
  // }
  // }

  // //membuka halaman edit History
  // Future<void> _openFormEdit(History history) async {
  // var result = await Navigator.push(context,
  //     MaterialPageRoute(builder: (context) => FormHistory(history: history)));
  // if (result == 'update') {
  //     await _getAllHistory();
  // }
  // }
}
