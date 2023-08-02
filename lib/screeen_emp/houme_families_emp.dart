import 'package:flutter/material.dart';
import 'package:kafil/ui/employee.dart';

class home_of_fam_emp extends StatelessWidget {
  const home_of_fam_emp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ProfilePage(canto: false)),
    );
  }
}