// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_function_literals_in_foreach_calls, non_constant_identifier_captions, unused_element, unused_local_variable, sized_box_for_whitespace

import 'package:captioner/history_item.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // backgroundColor: Color(0x44000000),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "History",
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                          child: Container(
                            height: 100,
                            child: ListTile(
                              leading: Image.memory(history.image),
                              tileColor: Colors.white,
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              visualDensity: VisualDensity(vertical: 4),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HistoryItemPage(
                                              imageBytes: history.image,
                                              captions_en: history.caption,
                                              captions_id: history.keterangan,
                                              key: null,
                                            )));
                              },
                              trailing: FittedBox(
                                fit: BoxFit.fill,
                                child: Row(
                                  children: [
                                    // Button delete
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
                                                    "Delete '${history.caption}' ?")
                                              ],
                                            ),
                                          ),
                                          //terdapat 2 button.
                                          //jika ya maka jalankan _deleteHistory() dan tutup dialog
                                          //jika tidak maka tutup dialog
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  _deleteHistory(
                                                      history, index);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes")),
                                            TextButton(
                                              child: Text('No'),
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
                          ));
                    }),
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
