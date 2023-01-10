import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot>? favouriteSights;
  List<QueryDocumentSnapshot>? listOfSights;

  Future<void> toggleFavourites(QueryDocumentSnapshot? faveSight) async {
    bool isFavourite = false;
    int index = 0;
    if (favouriteSights != null) {
      favouriteSights!.forEach((sightTitle) {
        if (isFavourite != true) {
          if (sightTitle['title'].contains(faveSight!['title'])) {
            isFavourite = true;
            return;
          }
          index++;
        }
      });
    }
    if (isFavourite) {
      favouriteSights!.removeAt(index);
    } else {
      favouriteSights ??= [];
      favouriteSights!.add(faveSight!);
    }

    notifyListeners();
  }

  bool existsSightInFaves(QueryDocumentSnapshot faveSight) {
    bool isFavourite = false;
    if (favouriteSights != null) {
      favouriteSights!.forEach((sightTitle) {
        if (sightTitle['title'].contains(faveSight['title'])) {
          isFavourite = true;
        }
      });
    }

    return isFavourite;
  }

  void clearFavouriteList() {
    favouriteSights = [];
    notifyListeners();
  }
}
