import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitora/colors/app_colors.dart';
import 'package:visitora/components/dummy_data.dart';
import 'package:visitora/screens/home_screen.dart';
import 'package:visitora/screens/navigation/bottom_navigation_bar.dart';
import 'package:visitora/widgets/custom_circular_indicator.dart';
import 'package:visitora/widgets/no_scroll_glow.dart';

class SightDetailScreen extends StatefulWidget {
  SightDetailScreen(
      {required this.detailedSight, this.previousScreen, Key? key})
      : super(key: key);

  final QueryDocumentSnapshot detailedSight;
  int? previousScreen;
  @override
  State<SightDetailScreen> createState() => _SightDetailScreenState();
}

class _SightDetailScreenState extends State<SightDetailScreen>
    with TickerProviderStateMixin {
  List<String> listOfImages = [];
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('sightseeingLocations/${widget.detailedSight.id}/images')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((val) {
        String data = val.data().toString();

        List<String> dataSplit;

        dataSplit = data.split(',');

        for (int i = 0; i < dataSplit.length; i++) {
          List<String> split = dataSplit[i].split(' ');
          split.forEach((element) {
            if (element.contains('assets')) {
              if (i == dataSplit.length - 1) {
                List<String> elemSplit = element.split('}');
                setState(() {
                  listOfImages.add(elemSplit[0]);
                });
              } else {
                setState(() {
                  listOfImages.add(element);
                });
              }
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    var images = FirebaseFirestore.instance
        .collection('sightseeingLocations/${widget.detailedSight.id}/images')
        .snapshots();

    return ScrollConfiguration(
        behavior: NoScrollGlow(),
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Container(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.detailedSight['title'],
                        style: const TextStyle(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 14,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              widget.detailedSight['address'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      )
                    ]),
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: (() {
                    if (widget.previousScreen == 1 ||
                        widget.previousScreen == 0) {
                      Navigator.pop(context);
                    } else if (widget.previousScreen == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBar(),
                          ));
                    } else
                      Navigator.pop(context);
                  })),
              backgroundColor: AppColors.navBar,
            ),
            body: SingleChildScrollView(
              child:
                  // padding: const EdgeInsets.only(right: 20, left: 20),
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: Image(
                          image: AssetImage(
                        widget.detailedSight['cover'],
                      ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: TabBar(
                      indicatorColor: AppColors.mainDarker,
                      labelColor: AppColors.mainDarker,
                      unselectedLabelColor: AppColors.black,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w400),
                      controller: _tabController,
                      tabs: const [
                        Tab(
                            child: Text(
                          'Description',
                          style: TextStyle(),
                        )),
                        Tab(
                            child: Text(
                          'Details',
                          style: TextStyle(),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(right: 25, left: 25, bottom: 20),
                    width: double.maxFinite,
                    height: 200,
                    child: TabBarView(controller: _tabController, children: [
                      Theme(
                        data: ThemeData(
                          highlightColor: AppColors.mainDarker, //Does not work
                        ),
                        child: Scrollbar(
                          interactive: true,
                          isAlwaysShown: true,
                          thickness: 3,
                          showTrackOnHover: true,
                          controller: _scrollController1,
                          child: ListView(
                            controller: _scrollController1,
                            shrinkWrap: true,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Text(
                                    widget.detailedSight['description'],
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Theme(
                          data: ThemeData(
                            highlightColor:
                                AppColors.mainDarker, //Does not work
                          ),
                          child: Scrollbar(
                              interactive: true,
                              thumbVisibility: true,
                              thickness: 3,
                              showTrackOnHover: true,
                              controller: _scrollController2,
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 25),
                                  child: ListView(
                                    controller: _scrollController2,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Opening hours:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        widget.detailedSight['visitingHours'],
                                        textAlign: TextAlign.center,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.0, top: 10),
                                        child: Text(
                                          'Entry fee:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        widget.detailedSight['entryFee'],
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )))),
                    ]),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      //emits a new value whenever data is changed in the collection & rebuilt children
                      stream: images,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const CustomLoadingIndicator();
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomLoadingIndicator();
                        }
                        if (snapshot.hasData) {
                          int idx = 0;
                          int listIndex = 0;
                          List<String> lista;
                          return CarouselSlider(
                            options: CarouselOptions(
                                height: 300.0,
                                aspectRatio: 16 / 9,
                                enableInfiniteScroll: true,
                                reverse: true),
                            items: listOfImages.map((i) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: const BoxDecoration(
                                    color: AppColors.background,
                                  ),
                                  child: Image.asset(i));
                            }).toList(),
                          );
                        }
                        return Container();
                      })
                ],
              ),
            )));
  }
}
