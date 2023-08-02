import 'package:flutter/material.dart';
import 'package:kafil/ui/items.dart';

class action_items extends StatelessWidget {
  const action_items({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: MyItems(istheAdmin: false)),
    );
  }
}