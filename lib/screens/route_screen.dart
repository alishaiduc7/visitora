import 'package:flutter/material.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/models/sight.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({this.route, Key? key}) : super(key: key);
  final List<Sight>? route;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Route'),
        backgroundColor: AppColors.navBar,
      ),
      body: route == null
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(
                child: Text('This feature is coming soon!',
                    style: TextStyle(fontSize: 25)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/images/coming_soon.png',
                  ))
            ])
          : Column(children: const [Text('')]),
    );
  }
}
