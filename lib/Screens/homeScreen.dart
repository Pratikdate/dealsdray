import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildSearchMenu() {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.black26,
              size: 30,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Image.asset("asset/img.png", width: 30),
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
                onSubmitted: (text_) {},
              ),
            ),
          ),
          SizedBox(width: 24),
          IconButton(
            icon: Icon(
              Octicons.bell,
              color: Colors.black26,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _tabSliderCard(String imgURL) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(imgURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _caroserTabSlider(List banners) {
    return Center(
      child: CarouselSlider(
        items: banners.map<Widget>((banner) {
          return _tabSliderCard(banner['banner']);
        }).toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 15 / 6,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 1200),
          viewportFraction: 0.8,
        ),
      ),
    );
  }

  _tabButton(String text, IconData icon, Color bgColore) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,

          child: Icon(icon, color: Colors.white),
          decoration: new BoxDecoration(
            color: bgColore,
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.5,],
              colors: [
                bgColore,
                bgColore.withOpacity(0.8),

              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text(text,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            style: GoogleFonts.roboto(
              fontSize: 14, //provide in %
              fontWeight: FontWeight.w500,
              color: Colors.black,
            )
        )
      ],
    );
  }

  _MobileCard(String perOff, String money, String model) {
    return Card(
      child: Stack(
        children: [

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: 180,
                padding: EdgeInsets.only(
                    left: 30, right: 30, bottom: 40, top: 20),
                margin: EdgeInsets.only(bottom: 60),
                child: Image.asset("asset/mobile.png", width: 100,),
              ),


              Container(

                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  money,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: 14, //provide in %
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ),

              Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                      fontSize: 12, //provide in %
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )),
              SizedBox(height: 20)

            ],

          ),
          Positioned(
            top: 20,
            right: 24,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1)),
                color: Colors.green,
              ),
              child: Text(perOff),

            ),
          ),


        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: (){},
          icon:Icon(Icons.chat, color: Colors.white,semanticLabel: "Chat",),
             label: Text("Chat",style: TextStyle(color: Colors.white),),

        ),

        body: FutureBuilder<Map<String, dynamic>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final data = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(height: 40),
                    _buildSearchMenu(),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 90,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _caroserTabSlider(data['banner_one']),
                            SizedBox(height: 20),
                            Container(
                              height: 140,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),

                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: [0.1, 0.5, 0.7, 0.9],
                                  colors: [
                                    Colors.deepPurple.shade900,
                                    Colors.deepPurple.shade800,
                                    Colors.deepPurple.shade700,
                                    Colors.deepPurple.shade400,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "KYC Pending",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.almarai(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "You need to provide the required",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.almarai(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "documents for your account activation.",
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.almarai(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Click Here",
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.almarai(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),

                            Row(


                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _tabButton("Mobile", Icons.mobile_screen_share,
                                    Colors.deepPurple),
                                _tabButton(
                                    "Laptop", Icons.laptop, Colors.green),
                                _tabButton("Camera", Icons.camera, Colors.red),
                                _tabButton(
                                    "LED", Icons.lightbulb, Colors.orange),


                              ],
                            ),


                            SizedBox(height: 20),
                            Container(
                              height: 420,
                              padding: EdgeInsets.all(20),
                              color: Colors.cyan,
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("EXCLUSIVE FOR YOU",
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.roboto(
                                          fontSize: 16, //provide in %
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 100),
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },

                                          icon: const Icon(
                                            Ionicons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),


                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 20,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          _MobileCard(
                                              "30%", "100",
                                              "POCO M3 (iron, 64GB)"),
                                          _MobileCard(
                                              "10%", "34000",
                                              "Nokia 8.1 (iron, 64GB)"),
                                          _MobileCard("20%", "28000",
                                              "Nokia 8.1  (iron, 64GB)"),

                                        ],


                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                      ),
                    ),
                  ],

                );
              }
            }
        )
    );
  }

}