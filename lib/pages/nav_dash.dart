import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pickone/pages/home_page.dart';
import 'package:pickone/pages/add_page.dart';
import 'package:pickone/pages/profile_page.dart';

class NavPage extends StatefulWidget{
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage>{

  int currentTab = 0;
  final List<Widget> screens = [
    const HomePage(),
    const AddPage(),
    const ProfilePage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: const EdgeInsets.all(16),
              tabs: [

                GButton( icon: Icons.home, text: 'Home',onPressed: (){
                  setState(() {
                    currentScreen = const HomePage();
                  });
                },),
                GButton( icon: Icons.add, text: 'Add Friends',onPressed: (){
                  setState(() {
                    currentScreen = const AddPage();
                  });
                },),
                GButton( icon: Icons.person, text: 'Profile', onPressed: (){
                  setState(() {
                    currentScreen = const ProfilePage();
                  });
                },),
              ]
          ),
        ),
      ),
    );

  }
}