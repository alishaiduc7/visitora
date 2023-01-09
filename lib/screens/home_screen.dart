import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/managers/authentication_manager.dart';
import 'package:visitora/provider/favourite_provider.dart';
import 'package:visitora/screens/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visitora/screens/login_screen.dart';
import 'package:visitora/widgets/custom_circular_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
  }

  final Stream<QuerySnapshot> _locationsStream =
      FirebaseFirestore.instance.collection('sightseeingLocations').snapshots();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text('ORADEA'),
            ),
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: (() {
                  AuthenticationManager.signOutUser();

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                })),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.navBar,
      ),
      body: StreamBuilder<QuerySnapshot>(
          //emits a new value whenever data is changed in the collection & rebuilt children
          stream: _locationsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const CustomLoadingIndicator();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomLoadingIndicator();
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (provider.listOfSights.length < 16) {
                    provider.listOfSights.add(snapshot.data?.docs[index]);
                  }

                  return Container(
                    padding:
                        const EdgeInsets.only(top: 15, right: 20, left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.background,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (snapshot.data?.docs[index] != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SightDetailScreen(
                                  detailedSight: snapshot.data!.docs[index],
                                  previousScreen: 0,
                                ),
                              ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.background,
                        ),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          color: AppColors.background,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  snapshot.data?.docs[index]['title'],
                                  style: const TextStyle(
                                      color: AppColors.mainDarker,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      image: DecorationImage(
                                          image: AssetImage(snapshot
                                              .data?.docs[index]['cover']),
                                          fit: BoxFit.cover),
                                    ),
                                    child: Container(),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        color: provider.existsSightInFaves(
                                                snapshot.data?.docs[index])
                                            ? const Color.fromARGB(
                                                255, 191, 73, 88)
                                            : AppColors.background,
                                      ),
                                      onPressed: () {
                                        provider.toggleFavourites(
                                            snapshot.data?.docs[index]);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CustomLoadingIndicator());
          }),
    );
  }
}
