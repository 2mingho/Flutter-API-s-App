import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1; // Índice de la página principal

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couteau',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'COUTEAU',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 4,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  // 'https://cdn.pixabay.com/photo/2013/07/12/19/04/swiss-army-knife-154314_1280.png',
                  // 'https://cdn-icons-png.flaticon.com/512/1973/1973399.png',
                  'https://www.materiel-aventure.fr/10854-large_default/couteau-suisse-victorinox-ranger.webp',
                  width: 350,
                  height: 350,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Gender',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month, color: Colors.white),
          label: 'Age',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school, color: Colors.white),
          label: 'University',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: Color.fromARGB(255, 208, 138, 220), size: 40),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sunny, color: Colors.white),
          label: 'Weather',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article, color: Colors.white),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info, color: Colors.white),
          label: 'About',
        ),
      ],
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
