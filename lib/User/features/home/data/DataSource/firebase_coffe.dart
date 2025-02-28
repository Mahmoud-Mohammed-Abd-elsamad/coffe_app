import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/coffe_item.dart';

class CoffeeDataSource {
  Future<List> getCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    List categories = [];
    for (var doc in querySnapshot.docs) {
      categories.add(doc.data());
    }
    return categories;
  }

  Future<List<CoffeeItem>> fetchCoffeeItems() async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await fireStore.collection('coffee_items').get();
      List<CoffeeItem> coffeeItems = snapshot.docs.map((doc) {
        return CoffeeItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      log('Fetched ${coffeeItems.length} coffee items done');
      log('Fetched ${coffeeItems[0].sizes["medium"]} coffee sizes done');
      return coffeeItems;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching coffee items: $e');
      }
      return [];
    }
  }
}
