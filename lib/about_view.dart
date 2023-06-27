import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String username = '';
  String fullName = '';
  String email = '';
  String avatarUrl = '';
  List<String> repositories = [];

  Future<void> fetchGitHubProfile() async {
    final username =
        'your_username'; // Reemplaza con tu nombre de usuario de GitHub
    final url = Uri.parse('https://api.github.com/users/$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        this.username = data['login'];
        this.fullName = data['name'];
        this.email = data['email'] ?? 'N/A';
        this.avatarUrl = data['avatar_url'];
      });

      await fetchGitHubRepositories(username);
    } else {
      setState(() {
        this.username = '';
        this.fullName = '';
        this.email = '';
        this.avatarUrl = '';
        this.repositories = [];
      });
    }
  }

  Future<void> fetchGitHubRepositories(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username/repos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        repositories = data
            .where((repo) =>
                repo['name'] != null) // Filtrar repositorios sin nombre
            .map((repo) =>
                repo['name'] as String) // Asignar nombre del repositorio
            .toList();
      });
    } else {
      setState(() {
        repositories = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGitHubProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              fullName,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text(email),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Repositories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (repositories.isNotEmpty)
              Column(
                children: repositories
                    .map(
                      (repo) => ListTile(
                        leading: Icon(Icons.code),
                        title: Text(repo),
                      ),
                    )
                    .toList(),
              )
            else
              Text(
                'No repositories found.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
