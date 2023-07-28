import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Services/Family.dart';

late Family? selected_fam = null;

class ShowFamilies extends StatefulWidget {
  final bool Check_box;
  ShowFamilies({required this.Check_box});
  @override
  State<ShowFamilies> createState() => _ShowFamiliesState();
}

class _ShowFamiliesState extends State<ShowFamilies> {
  final Stream<QuerySnapshot> _familiesStream =
      FirebaseFirestore.instance.collection('family').snapshots();

  Future<List<Kids>> change(
      DocumentSnapshot familyDocument, String familyId) async {
    List<Kids> kids = [];
    final kidsDocuments = await getKidsDocuments(familyDocument);
    final kidsData = kidsDocuments.map((doc) => doc.data()).toList();
    for (var (kidData as Map) in kidsData) {
      Kids k = Kids(
        age: kidData['age'],
        name: kidData['name'],
        work: kidData['job'],
        sick: kidData['sick'],
      );
      kids.add(k);
    }

    return kids;
  }

  Future<List<DocumentSnapshot>> getKidsDocuments(
      DocumentSnapshot familyDocument) async {
    final kidsSnapshot =
        await familyDocument.reference.collection('Kids').get();
    return kidsSnapshot.docs;
  }

  bool check(String doc_id) {
    if (selected_fam == null) {
      return false;
    }
    return doc_id.compareTo(selected_fam!.doc_id) == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Families",
              style: TextStyle(fontSize: 35),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _familiesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('No families found'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    String familyId = document.id;

                    return FutureBuilder<List<Kids>>(
                      future: change(document, familyId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Kids>> kidsSnapshot) {
                        if (kidsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (kidsSnapshot.hasError) {
                          return Text('Error: ${kidsSnapshot.error}');
                        }

                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Family f = Family.custom(
                            family_name: data['family_name'],
                            location: data['location'],
                            father_name: data['father_name'],
                            mother_name: data['mother_name'],
                            father_sick: data['father_sick'],
                            mother_sick: data['mother_sick'],
                            fatherInLife: data['father_alive'],
                            motherInLife: data['mother_alive'],
                            doc_id: document.id);
                        return Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text(f.family_name),
                                subtitle: Center(
                                    child: Column(
                                  children: [
                                    if (widget.Check_box == true)
                                      Checkbox(
                                          value: check(familyId),
                                          onChanged: ((value) {
                                            print(
                                                "fam id : $familyId .... selected : $selected_fam");
                                            if (value == false) {
                                              setState(() {
                                                selected_fam = null;
                                              });
                                            } else {
                                              setState(() {
                                                selected_fam = f;
                                              });
                                            }
                                          }))
                                  ],
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
