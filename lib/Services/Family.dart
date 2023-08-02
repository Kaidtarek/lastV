import 'package:cloud_firestore/cloud_firestore.dart';

class Family {
  String family_name;
  String father_name;
  String mother_name;
  bool fatherInLife;
  bool motherInLife;
  String father_sick;
  String mother_sick;
  late List<Kids> kids;
  String location;
  late String house_type;
  late String life_formula_inHouse;
  late String elc_power;
  late String gaz_power;
  late String family_need;
  late String doc_id;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Family({
    required this.life_formula_inHouse,
    required this.family_need,
    required this.gaz_power,
    required this.elc_power,
    required this.house_type,
    required this.family_name,
    required this.location,
    required this.father_name,
    required this.mother_name,
    required this.father_sick,
    required this.mother_sick,
    required this.fatherInLife,
    required this.motherInLife,
    required this.kids,
  });
  Family.custom(
      {required this.family_name,
      required this.location,
      required this.father_name,
      required this.mother_name,
      required this.father_sick,
      required this.mother_sick,
      required this.fatherInLife,
      required this.motherInLife,
      required this.doc_id});
  Map<String, dynamic> toMap() {
    return {
      'life_formula_inHouse': life_formula_inHouse,
      'family_need': family_need,
      'family_name': family_name,
      'location': location,
      'father_name': father_name,
      'father_alive': fatherInLife,
      'father_sick': father_sick,
      'mother_name': mother_name,
      'mother_alive': motherInLife,
      'mother_sick': mother_sick,
      'house_type': house_type,
      'elc_power': elc_power,
      'gaz_power': gaz_power,
    };
  }

  Future<bool> add_family() async {
    try {
      DocumentReference familyDocRef =
          await db.collection("family").add(this.toMap());
      CollectionReference KidsCollectionref = familyDocRef.collection("Kids");
      for (var kid in kids) {
        await KidsCollectionref.add(kid.toMap());
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> edit_family(String id) async {
    print("THIS IS ID $id");
    db
        .collection('family')
        .doc(id)
        .set(this.toMap())
        .onError((error, stackTrace) => print("this is the error $error"));
    try {
      CollectionReference KidsCollectionref =
          db.collection("family").doc(id).collection("Kids");
      QuerySnapshot snapshot = await KidsCollectionref.get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
      for (var kid in kids) {
        await KidsCollectionref.add(kid.toMap());
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<void> delete_family(String familyDocId) async {
    DocumentReference familyRef =
        FirebaseFirestore.instance.collection('family').doc(familyDocId);

    try {
      CollectionReference kidsRef = familyRef.collection('Kids');

      QuerySnapshot kidsSnapshot = await kidsRef.get();
      for (DocumentSnapshot kidDoc in kidsSnapshot.docs) {
        await kidDoc.reference.delete();
      }

      await familyRef.delete();

      print('Family and kids successfully deleted!');
    } catch (e) {
      print('Error deleting family and kids: $e');
    }
  }
}

class Kids {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String name;
  int age;
  String work;
  String sick;

  Kids({
    required this.name,
    required this.age,
    required this.work,
    required this.sick,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'job': work,
      'sick': sick,
    };
  }
}