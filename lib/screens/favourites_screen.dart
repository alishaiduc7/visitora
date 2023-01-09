import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/provider/favourite_provider.dart';
import 'package:visitora/screens/detail_screen.dart';

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({this.favouriteSights, Key? key}) : super(key: key);
  List<QueryDocumentSnapshot?>? favouriteSights;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: AppColors.navBar,
      ),
      body: favouriteSights!.isEmpty
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(
                child: Text('You have no favourites yet!',
                    style: TextStyle(fontSize: 25)),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/images/favourite.png',
                    height: 70,
                  ))
            ])
          : ListView.builder(
              itemCount: favouriteSights!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.background,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (favouriteSights![index] != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SightDetailScreen(
                                detailedSight: favouriteSights![index]!,
                                previousScreen: 1,
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
                        color: AppColors.background,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                favouriteSights![index]!['title'],
                                style: const TextStyle(color: Colors.black),
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
                                        image: AssetImage(
                                            favouriteSights![index]!['cover']),
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
                                              favouriteSights![index])
                                          ? const Color.fromARGB(
                                              255, 191, 73, 88)
                                          : AppColors.background,
                                    ),
                                    onPressed: () {
                                      provider.toggleFavourites(
                                          favouriteSights![index]!);
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
            ),
    );
  }
}
