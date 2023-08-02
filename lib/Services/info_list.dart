import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafil/Services/Family.dart';
import 'package:kafil/widget/beauty_item_look.dart';

List<Widget> infoList(DocumentSnapshot document, AsyncSnapshot<List<Kids>> kidsSnapshot) {
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  return [
    see_info(
      itemName: 'العائلة',
      calledName: Text(data['family_name']),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    see_info(
      itemName: 'عدد الأطفال',
      calledName: Text('${kidsSnapshot.data?.length ?? 0}'),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    see_info(
      itemName: 'نوعية ملكية المنزل',
      calledName: Text(data['life_formula_inHouse']),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    see_info(
      itemName: 'اسم الأب',
      calledName: Text(data['father_name']),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
        see_info(
      itemName: 'اسم الأم',
      calledName: Text(data['mother_name']),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    see_info(
      itemName: 'نوع المنزل',
      calledName: Text(data['house_type'],textAlign: TextAlign.right,),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    
    see_info(
      itemName: 'الكهرباء',
      calledName: Text(data['elc_power']),
    ),
    Container(height: 2,width: double.infinity, color: Colors.deepOrange,),
    see_info(
      itemName: 'الغاز',
      calledName: Text(data['gaz_power']),
    ),

  ];
}
