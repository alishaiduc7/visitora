import 'package:flutter/material.dart';
import 'package:visitora/colors/app_colors.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Route'),
        backgroundColor: AppColors.navBar,
      ),
      body: Column(children: const [Text('Route screen')]),
    );
  }
}
