import 'package:flutter/material.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../model/entry.dart';
import '../theme_manager.dart';

class EntryUpdateDialog extends StatefulWidget {
  final Entry entry;

  EntryUpdateDialog({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  _EntryUpdateDialogState createState() => _EntryUpdateDialogState();
}

class _EntryUpdateDialogState extends State<EntryUpdateDialog> {
  late DateTime _selectedDate;

  late TextEditingController _titleController;
  late TextEditingController _descController;

  final Map<int, String> moodDropValues = {1: 'Happy', 2: 'Normal', 3: 'Sad'};
  final List<String> weatherValues = ['sunny', 'cloudy', 'rainy'];

  late int _selectedMood;
  late String _selectedWeather;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.entry.title!);
    _descController = TextEditingController(text: widget.entry.description!);
    _selectedDate = widget.entry.date!;
    _selectedMood = widget.entry.mood!;
    _selectedWeather = widget.entry.weather!;
    super.initState();
  }

  _showDatePicker() async {
    DateTime select;
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
      final t =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
    final theme = context.watch<ThemeNotifier>();
    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showDatePicker(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: theme.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: _buildTopWidget(context),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            //filled: true,
                            border: InputBorder.none,
                            hintText: "Title",
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildMoodDropDown(),
                  const SizedBox(width: 5),
                  _buildWeatherDropDown()
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _descController,
                      expands: true,
                      maxLines: null,
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(
                        //filled: true,
                        border: InputBorder.none,
                        hintText: "How about your day?",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
                color: theme.color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.reorder, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      final entry = Entry(
                        eid: widget.entry.eid,
                        title: _titleController.text,
                        description: _descController.text,
                        date: _selectedDate,
                        mood: _selectedMood,
                        weather: _selectedWeather,
                      );
                      context.read<EntryProvider>().update(entry);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.save, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Stack _buildTopWidget(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Column(
              children: [
                Text(
                  getMonth(_selectedDate.month)!,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getDayNumeric(_selectedDate.day),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getDay(_selectedDate.weekday)!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${_selectedDate.hour}:${_selectedDate.minute}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 2.0,
          top: 2.0,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.white),
          ),
        )
      ],
    );
  }

  DropdownButtonHideUnderline _buildMoodDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        iconSize: 0.0,
        value: _selectedMood,
        items: moodDropValues
            .map((k, v) {
              return MapEntry(
                k,
                DropdownMenuItem<int>(
                  value: k,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(getMoodIcons(k)),
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

  DropdownButtonHideUnderline _buildWeatherDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        iconSize: 0.0, // Hide dropdown arrow
        value: _selectedWeather,
        items: weatherValues.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(getWeatherIcons(value)),
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
}
