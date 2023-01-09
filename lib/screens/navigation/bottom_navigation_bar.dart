import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitora/provider/favourite_provider.dart';
import 'package:visitora/screens/favourites_screen.dart';
import 'package:visitora/screens/home_screen.dart';
import 'package:visitora/screens/map_screen.dart';
import 'package:visitora/screens/qr_scanner_screen.dart';
import 'package:visitora/screens/route_screen.dart';
import 'package:visitora/colors/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentTabIndex = 0;

  final List screens = [
    HomeScreen(),
    MapScreen(),
    QRScannerScreen(),
    FavouritesScreen(),
    RouteScreen()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      // body: screens[currentTabIndex],
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                        listOfSights: provider.listOfSights,
                      )));
        },
        hoverElevation: 2,
        backgroundColor: const Color.fromARGB(255, 152, 9, 28),
        child: const Icon(
          Icons.qr_code_scanner_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 1,
        color: AppColors.navBar,
        shape: const CircularNotchedRectangle(),
        child: Container(
          color: AppColors.navBar,
          height: 55,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = HomeScreen();
                          currentTabIndex = 0;
                        });
                      },
                      child: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              MapScreen(listOfSights: provider.listOfSights);
                          currentTabIndex = 1;
                        });
                      },
                      child: const Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = FavouritesScreen(
                            favouriteSights: provider.favouriteSights,
                          );
                          currentTabIndex = 2;
                        });
                      },
                      child: const Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = RouteScreen();
                          currentTabIndex = 3;
                        });
                      },
                      child: const Icon(
                        Icons.place_outlined,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 70,
      //   decoration: BoxDecoration(color: AppColors.navBar),
      //   child: BottomNavigationBar(
      //     currentIndex: currentTabIndex,
      //     fixedColor: AppColors.navBar,
      //     backgroundColor: AppColors.navBar,
      //     onTap: (index) {
      //       setState(() {
      //         currentTabIndex = index;
      //       });
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.home_outlined,
      //           color: Colors.white,
      //         ),
      //         backgroundColor: AppColors.navBar,
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.map_outlined,
      //           color: Colors.white,
      //         ),
      //         label: '',
      //         backgroundColor: AppColors.navBar,
      //       ),

      //       // BottomNavigationBarItem(
      //       //   icon: const Icon(
      //       //     Icons.qr_code_scanner_outlined,
      //       //     color: Colors.white,
      //       //   ),
      //       //   label: '',
      //       //   backgroundColor: AppColors().navBar,
      //       // ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.favorite_outline,
      //           color: Colors.white,
      //         ),
      //         label: '',
      //         backgroundColor: AppColors.navBar,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: const Icon(
      //           Icons.place_outlined,
      //           color: Colors.white,
      //         ),
      //         label: '',
      //         backgroundColor: AppColors.navBar,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
