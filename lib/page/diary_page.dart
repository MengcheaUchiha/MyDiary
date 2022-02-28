import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:flutter_mydiary/model/entry_db.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../model/entry.dart';
import '../theme_manager.dart';

class DiaryPage extends StatefulWidget {
  DiaryPage({Key? key}) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  final Map<int, String> moodValues = {
    1: 'Happy',
    2: 'Love',
    3: 'Sad',
    4: 'Crazy',
  };
  final List<String> weatherValues = ['sunny', 'cloudy', 'rainy'];

  late int _selectedMood;
  late String _selectedWeather;

  @override
  void initState() {
    super.initState();
    _selectedMood = moodValues.keys.first;
    _selectedWeather = weatherValues.first;
  }

  _showDatePicker() async {
    DateTime select = _selectedDate;
    final DateTime? dt = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1995),
      lastDate: DateTime(2025),
    );
    if (dt != null) {
      select = DateTime(dt.year, dt.month, dt.day);
      setState(() {
        _selectedDate = select;
      });
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (t != null)
        select = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          t.hour,
          t.minute,
        );
      setState(() {
        _selectedDate = select;
      });
    }

    print(_selectedDate.toString());
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();
    final theme = context.watch<ThemeNotifier>();

    final bgColor =
        theme.isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white;

    final _textStyle = Theme.of(context).textTheme.bodyText1;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            _showDatePicker();
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: theme.color,
            child: Column(
              children: [
                const SizedBox(height: 7.5),
                Text(
                  "months.${getMonth(_selectedDate.month)!.toLowerCase()}".tr(),
                  style: _textStyle?.copyWith(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getDayNumeric(_selectedDate.day),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "days.${getDay(_selectedDate.weekday)!.toLowerCase()}"
                          .tr(),
                      style: _textStyle?.copyWith(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${_selectedDate.hour}:${getDayNumeric(_selectedDate.minute)}",
                      style: _textStyle?.copyWith(
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.5)
              ],
            ),
          ),
        ),
        Row(
          children: [
            _titleTextField(_textStyle, bgColor),
            _buildMoodDropdown(theme),
            const SizedBox(width: 3),
            _buildWeatherDropdown(theme),
            const SizedBox(width: 3),
          ],
        ),
        const SizedBox(height: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: bgColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _descController,
                  expands: true,
                  maxLines: null,
                  style: _textStyle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'how'.tr(),
                    hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        _buildBottomBar(theme, entryProvider),
      ],
    );
  }

  Expanded _titleTextField(TextStyle? _textStyle, Color bgColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: bgColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: _titleController,
              style: _textStyle?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'title'.tr(),
                hintStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 12,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline _buildMoodDropdown(ThemeNotifier theme) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        iconSize: 0.0,
        value: _selectedMood,
        items: moodValues
            .map((k, v) {
              return MapEntry(
                k,
                DropdownMenuItem<int>(
                  value: k,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: theme.isDark
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.white,
                    ),
                    child: Image.asset("assets/image/${getMoodImage(k)}"),
                    // child: Icon(
                    //   getMoodIcons(k),
                    //   color: theme.isDark ? Colors.white : Colors.black,
                    // ),
                  ),
                ),
              );
            })
            .values
            .toList(),
        onChanged: (int? value) {
          setState(() {
            _selectedMood = value!;
            print('Mood $value');
          });
        },
      ),
    );
  }

  DropdownButtonHideUnderline _buildWeatherDropdown(ThemeNotifier theme) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        underline: null,
        iconSize: 0.0, // Hide dropdown arrow
        value: _selectedWeather,
        items: weatherValues.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.isDark
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Colors.white,
              ),
              child: Image.asset("assets/image/${getWeatherImage(value)}"),
              // child: Icon(
              //   getWeatherIcons(value),
              //   color: theme.isDark ? Colors.white : Colors.black,
              // ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _selectedWeather = value!;
            print('Weather $value');
          });
        },
      ),
    );
  }

  Container _buildBottomBar(ThemeNotifier theme, EntryProvider entryProvider) {
    return Container(
      color: theme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.location_off_sharp, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.photo_camera, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              EntryDB.db.deleteAll();
            },
            icon: Icon(Icons.close, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _descController.text.isNotEmpty) {
                final entry = Entry(
                  title: _titleController.text,
                  description: _descController.text,
                  date: _selectedDate,
                  mood: _selectedMood,
                  weather: _selectedWeather,
                );
                entryProvider.add(entry);
                _titleController.clear();
                _descController.clear();
                entryProvider.getEventsDay();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Empty'),
                      content: Text('Please enter title and description'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        )
                      ],
                    );
                  },
                );
              }
            },
            icon: Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
