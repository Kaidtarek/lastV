import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/Events.dart';
import 'package:kafil/screens/material_item_screen.dart';

import '../Services/Family.dart';
import 'add_family.dart';

bool get = true;

class MyItems extends StatefulWidget {
  final istheAdmin;
  MyItems({required this.istheAdmin});
  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  final Stream<QuerySnapshot> _event_stream =
      FirebaseFirestore.instance.collection('Events').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.istheAdmin
            ? TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        title: Icon(
                          Icons.help,
                          size: 50,
                          color: Colors.green,
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Text(
                                "التطوعات",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 51, 73, 70),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "تستطيع هنا اضافة عدد لا نهائي من المساعدات استنادا على المنتوجات المتواجدة داخل المخزن",
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('مساعدة'),
              )
            : Text("view"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: widget.istheAdmin
          ? FloatingActionButton(
              onPressed: () async {
                var newItem = await showDialog<Events>(
                  context: context,
                  builder: (BuildContext context) => ItemDialog(),
                );
              },
              child: Image.asset('assets/add_item.png'),
            )
          : Container(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _event_stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              var color = int.parse("0x${data['color']}");
              Events e = Events(Color(color), data['icon'], data['name'],
                  doc_id: document.id);

              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext Context) {
                              return MaterialScreen(
                                  titleController: e.name,
                                  event: e,
                                  canto: widget.istheAdmin);
                            },
                          ),
                        );
                      },
                      icon: Icon(IconData(e.icon, fontFamily: 'MaterialIcons')),
                      iconSize: 40,
                      color: e.color,
                    ),
                    SizedBox(height: 5),
                    Text(
                      e.name,
                      style: TextStyle(
                        color: e.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add delete button for admin users
                    if (widget.istheAdmin)
                      widget.istheAdmin
                          ? ElevatedButton(
                              onPressed: () {
                                // Show the delete confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete item?'),
                                      content: Text(
                                          'Are you sure you want to delete this item?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await e.deleteEvent();
                                            // Call setState to trigger a rebuild of the UI
                                            setState(() {});
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Delete"),
                            )
                          : Container(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
//dddddddddd

class ItemDialog extends StatefulWidget {
  @override
  _ItemDialogState createState() => _ItemDialogState();
}

class _ItemDialogState extends State<ItemDialog> {
  final TextEditingController NameController = TextEditingController();
  IconData selectedIcon = Icons.add;
  Color selectedColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: NameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Icon:'),
                IconButton(
                  onPressed: () async {
                    var icon = await showDialog<IconData>(
                      context: context,
                      builder: (BuildContext context) => IconPickerDialog(),
                    );
                    if (icon != null) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    }
                  },
                  icon: Icon(selectedIcon),
                  iconSize: 40,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Color:'),
                IconButton(
                  onPressed: () async {
                    var color = await showDialog<Color>(
                      context: context,
                      builder: (BuildContext context) => ColorPickerDialog(),
                    );
                    if (color != null) {
                      setState(() {
                        selectedColor = color;
                      });
                    }
                  },
                  icon: Icon(Icons.color_lens),
                  color: selectedColor,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            String eventName = NameController.text;
            print(selectedIcon.codePoint);
            Events e = Events(selectedColor, selectedIcon.codePoint, eventName);
            e.add_event();
            Navigator.pop(
              context,
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

class IconPickerDialog extends StatelessWidget {
  final List<IconData> icons = [
    Icons.shopping_basket_outlined,
    Icons.dark_mode_outlined,
    Icons.mosque_outlined,
    Icons.checkroom_outlined,
    Icons.holiday_village,
    Icons.add_box,
    Icons.school,
    Icons.home,
    Icons.attach_money,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Icon'),
      content: SingleChildScrollView(
        child: Wrap(
          children: [
            for (var iconData in icons)
              IconButton(
                icon: Icon(iconData),
                onPressed: () {
                  Navigator.pop(context, iconData);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  @override
  final List<Color> MyColors = [
    Colors.black,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.lime,
    Colors.red,
    Colors.pink,
    Colors.pinkAccent,
    Color.fromARGB(255, 224, 0, 205),
    Color.fromARGB(255, 62, 123, 9),
    Colors.cyan,
  ];
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Color'),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          children: [
            for (var color in MyColors)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, color);
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
