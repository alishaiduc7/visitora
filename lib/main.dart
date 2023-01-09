import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitora/managers/authentication_manager.dart';
import 'package:visitora/provider/favourite_provider.dart';
import 'package:visitora/screens/login_screen.dart';
import 'package:visitora/screens/navigation/bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

//TODO: add google maps on iOS
class MyApp extends StatelessWidget {
  MyApp({required this.sharedPreferences, Key? key}) : super(key: key);
  SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavouriteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthenticationManager().isLoggedIn(sharedPreferences)
            ? const BottomNavBar()
            : const LoginScreen(),
      ),
    );
  }
}
