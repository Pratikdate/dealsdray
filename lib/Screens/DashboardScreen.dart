
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


import 'homeScreen.dart';



class DashboardScreen extends StatelessWidget {
  static const routeName = '/';
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      // AnalysisScreen(),
      // QRScanScreen(),
      // ChatScreen(),
      // ProfileScreen(),
    ];
  }

   _navBarItems() {
    return PersistentTabView(
        tabs:[

          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              title: "Home",
              icon: Icon(Icons.home),
                activeForegroundColor: Colors.deepOrange
           
            ),
          ),
          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              icon: Icon(AntDesign.appstore_o),
              title: "Category",
                activeForegroundColor: Colors.deepOrange
              
            ), 
          ),
          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              icon: Icon(AntDesign.appstore_o),
              title: "Deals",
                activeForegroundColor: Colors.deepOrange
            ),
          ),
          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              icon: Icon(Zocial.cart,),

              title: "Cart",
                activeForegroundColor: Colors.deepOrange
            ),
          ),
          PersistentTabConfig(
            screen: HomeScreen(),
            item: ItemConfig(
              icon: Icon(Ionicons.md_person_outline),
              title: "Profile",
              activeForegroundColor: Colors.deepOrange
            ),
          ),
    ], 
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
     navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            border: Border.all(color: Colors.black26)
          ),
     )
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Persistent Bottom Navigation Bar Demo',
        home: _navBarItems()
    );
  }


  
}
