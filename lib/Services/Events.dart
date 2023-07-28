import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/Family.dart';
import 'package:kafil/Services/Stock.dart';

class Events {
  final db = FirebaseFirestore.instance;
  String name;
  Color color;
  int icon;
  String doc_id;
  Events(this.color, this.icon, this.name, {this.doc_id = ""});

  Map<String, dynamic> toMap() {
    return {'name': name, 'color': color.value.toRadixString(16), 'icon': icon};
  }

  Future<void> add_family(String fam_name, List<String> products) async {
    db
        .collection('Events')
        .doc(doc_id)
        .collection('families')
        .add({'family_name': fam_name, 'products': products});
  }

  Future<void> add_event() async {
    await db.collection('Events').add(this.toMap());
  }
}
