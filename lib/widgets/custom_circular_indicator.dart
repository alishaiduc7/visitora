import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      value: null,
      strokeWidth: 10,
      color: const Color.fromARGB(255, 192, 84, 84),
      backgroundColor: Colors.grey[400],
    ));
  }
}
