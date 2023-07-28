import 'package:flutter/material.dart';
import 'package:kafil/Services/Events.dart';
import 'package:kafil/ui/stock.dart';
import 'package:kafil/widget/add_family_event.dart';
import 'package:kafil/widget/stockwithSearch.dart';
import '../widget/basics_fam_info.dart';

class MaterialScreen extends StatelessWidget {
  MaterialScreen({required this.titleController, required this.event});
  final String titleController;
  final Events event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: '$titleController',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            TextSpan(
              text: '  admin controller',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 103, 84, 84),
              ),
            ),
          ]),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddFamilyEvent(e: event,)));
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
                height: 2, width: double.infinity, color: Colors.deepPurple),
            SizedBox(height: 28),
            Expanded(
              child: Container(
                child: GetFamilies(
                  doc_id: event.doc_id,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
