import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafil/ui/stock.dart';
import 'package:kafil/ui/camping.dart';
import 'package:kafil/screens/houses.dart';
import 'package:kafil/ui/Family_page.dart';
import 'package:kafil/ui/employee.dart';
import 'package:kafil/ui/items.dart';

import '../ui/add_family.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedpage = 0;
  final _pageNo = [
    FamilyPage(brief_info_family: true,),
    MyItems(),
    ProfilePage(),
    //houses(),
    Camp(),
    My_stock()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Admin model'),
        ),
        body: _pageNo[selectedpage],
        bottomNavigationBar: ConvexAppBar(
          height: 80,
          items: [
            TabItem(icon: Icons.family_restroom, title: 'العائلات' , ),
            TabItem(icon: Icons.volunteer_activism_rounded, title: 'نشاطات'),
            TabItem(icon: Icons.group, title: 'الأعضاء'),
            TabItem(icon: Icons.forest, title: 'التخييمات'),
            TabItem(icon: Icons.store, title: 'المخزن'),
          ],
          initialActiveIndex: selectedpage,
          onTap: (int index) {
            setState(() {
              selectedpage = index;
            });
          },
        ),
      ),
    );
  }
}
