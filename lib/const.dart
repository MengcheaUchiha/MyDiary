import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? getMonth(int m) {
  switch (m) {
    case 1:
      return "January";
    case 2:
      return "Febuary";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
  }
}

String? getDay(int d) {
  switch (d) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
  }
}

IconData? getMoodIcons(int key) {
  switch (key) {
    case 1:
      return Icons.sentiment_very_satisfied_outlined;
    case 2:
      return CupertinoIcons.smiley; //Icons.sentiment_neutral;
    case 3:
      return Icons.sentiment_very_dissatisfied;
  }
}

String? getMoodImage(int key) {
  switch (key) {
    case 1:
      return "happy.png";
    case 2:
      return "love.png";
    case 3:
      return "sad.png";
    case 4:
      return 'crazy.png';
  }
}

IconData? getWeatherIcons(String v) {
  switch (v) {
    case 'sunny':
      return CupertinoIcons.cloud_sun;
    case 'cloudy':
      return CupertinoIcons.cloud_bolt_rain_fill;
    case 'rainy':
      return CupertinoIcons.cloud_heavyrain_fill;
  }
}

String? getWeatherImage(String v) {
  switch (v) {
    case 'sunny':
      return "sunny.png";
    case 'cloudy':
      return "cloudy.png";
    case 'rainy':
      return "heavy_rain.png";
  }
}

String getDayNumeric(int day) {
  return day < 10 ? "0$day" : "$day";
}

bool isEngLocale(BuildContext context) {
  return context.locale == Locale('en', 'US');
}

String? getBackground(String bg) {
  switch (bg) {
    case 'mitsuha':
      return 'theme1.jpg';
    case 'taki':
      return 'theme2.jpg';
    case 'aspirant':
      return 'aspirant.jpg';
    case 'fanny':
      return 'fanny.jpg';
  }
}

Color? getColor(String theme) {
  switch (theme) {
    case 'taki':
      return Colors.blue[400]; //.withOpacity(0.9);
    case 'mitsuha':
      return Colors.pink[300]; //.withOpacity(0.7);
    case 'aspirant':
      return Colors.red;
    case 'fanny':
      return Colors.orange;
  }
}

String? getTitle(String bg) {
  switch (bg) {
    case 'taki':
      return 'Taki'; //.withOpacity(0.9);
    case 'mitsuha':
      return 'Mitsuha Miyamizu'; //.withOpacity(0.7);
    case 'aspirant':
      return 'Layla Miss Hakari';
    case 'fanny':
      return 'Fanny Blade of Kibuo';
  }
}
