import 'package:flutter/material.dart';

import '../ui/employee.dart';

class members_emp extends StatelessWidget {
  const members_emp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ProfilePage(canto: false,)),
    );
  }
}