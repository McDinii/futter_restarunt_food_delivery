import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

void addDataFromJsonToFirestore() async {
  final String response = await rootBundle.loadString('assets/data.json');
  final data = await json.decode(response);

  // Шаг 2: Получите ссылку на Firestore collection
  CollectionReference collection = FirebaseFirestore.instance.collection('restaurants');

  // Шаг 3: Добавьте данные в Firestore
  for (var item in data) {
    collection.add(item).then((docRef) {
      print('Document added with ID: ${docRef.id}');
    }).catchError((error) {
      print('Error adding document: $error');
    });
  }
}
