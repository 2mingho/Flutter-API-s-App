import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgeView extends StatefulWidget {
  @override
  _AgeViewState createState() => _AgeViewState();
}

class _AgeViewState extends State<AgeView> {
  String name = '';
  String ageCategory = '';
  Color backgroundColor = Colors.white;

  Future<void> fetchAge(String name) async {
    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final int age = data['age'];

      setState(() {
        if (age < 18) {
          ageCategory = 'Joven';
          backgroundColor = Colors.green;
        } else if (age >= 18 && age < 50) {
          ageCategory = 'Adulto';
          backgroundColor = Colors.yellow;
        } else {
          ageCategory = 'Anciano';
          backgroundColor = Colors.red;
        }
      });
    } else {
      setState(() {
        ageCategory = '';
        backgroundColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
            TextField(
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Ingresa un nombre',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchAge(name);
              },
              child: Text('Obtener Edad'),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Categoría de edad: $ageCategory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          // Implementa el código para cambiar de vista según el índice seleccionado
          // Puedes utilizar un método similar al que se utiliza en el main.dart
          // o utilizar un enfoque diferente según tus necesidades
        },
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
