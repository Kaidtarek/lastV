import 'package:flutter/material.dart';
import 'package:kafil/widget/add_camp.dart';
import 'package:kafil/widget/edit_camp.dart';
import 'package:kafil/widget/stockwithSearch.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Services/Camps.dart';

class Camp extends StatefulWidget {
  final bool canto;
  Camp({required this.canto});
  @override
  State<Camp> createState() => _CampState();
}

class _CampState extends State<Camp> {
  List<Gotocamping> camping_info = [];

  // Function to delete camping data from both screen and Firebase
  Future<void> _deleteCamping(String campingId) async {
    try {
      // Delete the camping data from Firebase
      await FirebaseFirestore.instance
          .collection('camping')
          .doc(campingId)
          .delete();

      // Update the camping_info list to remove the deleted camping
      setState(() {
        camping_info.removeWhere((camping) => camping.id == campingId);
      });
    } catch (e) {
      print('Error deleting camping: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.canto
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddCamping(
                      onCampingAdded: (itemCamp) {
                        setState(() {
                          camping_info.add(itemCamp);
                        });
                      },
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : SizedBox(height: 0, width: 0),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 150,
              child: StockwithSearch(),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.deepPurple,
              height: 2,
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('camping')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  camping_info = snapshot.data!.docs.map((doc) {
                    // Map the Firestore document data to your Gotocamping model class
                    return Gotocamping(
                      id: doc.id, // Add the camping document ID to the model
                      camping_name: doc['camping_name'],
                      place: doc['place'],
                      startDate: doc['startDate'].toDate(),
                      finishDate: doc['finishDate'].toDate(),
                      num_ppl: doc['num_ppl'],
                      num_employee: doc['num_employee'],
                    );
                  }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: camping_info
                          .map(
                            (camping) => Card(
                              color: const Color.fromARGB(255, 255, 250, 250),
                              child: ListTile(
                                title: Text(camping.camping_name ?? ''),

                                subtitle: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  child: AlertDialog(
                                                    title: Text(
                                                      "معلومات الرحلة",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Destination:  "),
                                                            Text(
                                                              '${camping.place ?? ''}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .deepPurple),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Start Date: "),
                                                            Text(
                                                              '${DateFormat.yMd().format(camping.startDate!)}',
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Finish Date: "),
                                                            Text(
                                                              '${DateFormat.yMd().format(camping.finishDate!)}',
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Number of People: "),
                                                            Text(
                                                              '${camping.num_ppl}',
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "Number of Employees: "),
                                                            Text(
                                                              '${camping.num_employee}',
                                                            ),
                                                            Text(" employees"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.info)),
                                  ],
                                ),
                                
                                trailing: widget.canto
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return EditCamping(
                                                    camping: camping,
                                                    onCampingEdited:
                                                        (editedCamp) {
                                                      setState(() {
                                                        camping = editedCamp;
                                                      });
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              // Show a confirmation dialog before deleting
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Delete Camping?'),
                                                    content: Text(
                                                        'Are you sure you want to delete this camping?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await _deleteCamping(
                                                              camping.id!);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 0, width: 0),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 70,)
          ],
        ),
      ),
    );
  }
}
