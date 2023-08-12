import 'package:flutter/material.dart';
import 'page_home.dart';
import 'page_calibrate.dart';
import 'page_settings.dart';
import 'package:flutter/cupertino.dart';






void main() {
  runApp(const MainApp());
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {


  int _currentIndex = 0;
  final tabs = [
    const HomePage(),
    const CalibratePage(),
    const SettingsPage(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HopperHawk',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(title: Image.asset('images/logo.png', fit: BoxFit.scaleDown, width: 220,)),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: "Calibrate"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
          ],
   
        onTap: (int index){
          setState((){
            _currentIndex = index;
          });
        },

      ),
        
      )
    );
  }
}













