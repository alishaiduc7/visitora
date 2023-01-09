import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:visitora/colors/app_colors.dart';

class CustomMarkerWindow extends StatefulWidget {
  const CustomMarkerWindow({Key? key}) : super(key: key);

  @override
  State<CustomMarkerWindow> createState() => _CustomMarkerWindowState();
}

class _CustomMarkerWindowState extends State<CustomMarkerWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              height: 68,
              color: AppColors.mainLighter,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.church,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "Moon Church",
                        style: TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      print('yay');
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.white,
                      size: 20,
                    )),
              ])),
          ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                color: AppColors.mainLighter,
                width: 20.0,
                height: 7.0,
              )),
        ],
      ),
    );
  }
}
