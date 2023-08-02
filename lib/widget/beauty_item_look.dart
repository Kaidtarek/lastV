import 'package:flutter/material.dart';
class see_info extends StatelessWidget {
  see_info({required this.itemName, required this.calledName});
  Text calledName;
  String itemName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('$itemName :',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
        Expanded(
            
            child: Text(
              calledName.data.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple,fontSize: 20),
            )),
      ],
    );
  }
}
