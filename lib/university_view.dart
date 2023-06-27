import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UniversityView extends StatefulWidget {
  @override
  _UniversityViewState createState() => _UniversityViewState();
}

class _UniversityViewState extends State<UniversityView> {
  String country = '';
  List<University> universities = [];
  int visibleUniversities = 5;

  Future<void> fetchUniversities(String country) async {
    final url =
        Uri.parse('http://universities.hipolabs.com/search?country=$country');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<University> fetchedUniversities = [];

      for (var universityData in data) {
        final university = University(
          name: universityData['name'],
          domain: universityData['domains'][0],
          webPage: universityData['web_pages'][0],
        );
        fetchedUniversities.add(university);
      }

      setState(() {
        universities = fetchedUniversities;
      });
    } else {
      setState(() {
        universities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  country = value;
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter country name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchUniversities(country);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Visible universities:'),
                SizedBox(width: 10),
                DropdownButton<int>(
                  value: visibleUniversities,
                  onChanged: (int? value) {
                    setState(() {
                      visibleUniversities = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<int>(
                      value: 5,
                      child: Text('5'),
                    ),
                    DropdownMenuItem<int>(
                      value: 10,
                      child: Text('10'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(universities[index].name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Domain: ${universities[index].domain}'),
                        Text('Web Page:'),
                        GestureDetector(
                          onTap: () {
                            // Open web page
                          },
                          child: Text(
                            universities[index].webPage,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class University {
  final String name;
  final String domain;
  final String webPage;

  University({
    required this.name,
    required this.domain,
    required this.webPage,
  });
}
