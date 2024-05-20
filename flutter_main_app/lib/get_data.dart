import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> downloadFirestoreData() async {
  CollectionReference collection = FirebaseFirestore.instance.collection('restaurants');

  // Получение данных
  QuerySnapshot querySnapshot = await collection.get();

  // Преобразование данных в список объектов Dart
  List<Map<String, dynamic>> documents = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

  // Преобразование списка объектов Dart в строку JSON
  String jsonString = jsonEncode(documents);
  print(jsonString);
}
