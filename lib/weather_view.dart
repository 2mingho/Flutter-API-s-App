import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherView extends StatefulWidget {
  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String cityName = '';
  String countryAbbreviation = '';
  String weatherMain = '';
  String weatherDescription = '';
  String weatherIcon = '';
  double temperature = 0.0;

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Santo+Domingo,Dominican+Republic&APPID=2287f61ff3dfa5855c50d1726c3c361c');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        cityName = data['name'];
        countryAbbreviation = data['sys']['country'];
        weatherMain = data['weather'][0]['main'];
        weatherDescription = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
        temperature = (data['main']['temp'] - 273.15); // Convert to Celsius
      });
    } else {
      setState(() {
        cityName = '';
        countryAbbreviation = '';
        weatherMain = '';
        weatherDescription = '';
        weatherIcon = '';
        temperature = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cityName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  countryAbbreviation,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  getCountryFlag(countryAbbreviation),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              weatherMain,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Image.network(
              getWeatherIconUrl(weatherIcon),
              width: 64,
              height: 64,
            ),
            SizedBox(height: 8),
            Text(
              weatherDescription,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCountryFlag(String countryCode) {
    final flagOffset = 0x1F1E6;
    final asciiOffset = 0x41;

    final firstChar = countryCode.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = countryCode.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/w/$iconCode.png';
  }
}
