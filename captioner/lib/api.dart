import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String uploadUrl = "http://10.0.2.2:5000/api";
String downloadUrl = "http://10.0.2.2:5000/result";

Future getData(Uri url) async {
  http.Response response = await http.get(url);
  print(response.body);
  return json.decode(response.body);
}

uploadImage(File imageFile, String url) async {
  String base64Image = base64Encode(imageFile.readAsBytesSync());
  Response response = await Dio().post(url, data: base64Image);
  // ignore: avoid_print
  print(response);
}
