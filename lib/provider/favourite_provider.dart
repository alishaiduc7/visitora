import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavouriteProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot?> favouriteSights = [];
  late List<QueryDocumentSnapshot?> listOfSights = [];

  void toggleFavourites(QueryDocumentSnapshot? faveSight) {
    bool isFavourite = false;
    int index = 0;
    favouriteSights.forEach((sightTitle) {
      if (sightTitle!['title'].contains(faveSight!['title'])) {
        isFavourite = true;
        return;
      }
      index++;
    });
    if (isFavourite) {
      favouriteSights.removeAt(index);
    } else {
      favouriteSights.add(faveSight);
    }
    notifyListeners();
  }

  bool existsSightInFaves(QueryDocumentSnapshot? faveSight) {
    bool isFavourite = false;
    favouriteSights.forEach((sightTitle) {
      if (sightTitle!['title'].contains(faveSight!['title'])) {
        isFavourite = true;
      }
    });

    return isFavourite;
  }

  void clearFavouriteList() {
    favouriteSights = [];
    notifyListeners();
  }
}
