import 'package:flutter/material.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../model/entry.dart';
import '../theme_manager.dart';

class EntryDialog extends StatelessWidget {
  final Entry entry;

  const EntryDialog({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = context.watch<ThemeNotifier>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 24.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: themeManager.color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              getMonth(entry.date!.month)!,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              getDayNumeric(entry.date!.day),
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
                                  getDay(entry.date!.weekday)!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  entry.date!.minute < 10
                                      ? "${entry.date!.hour}:0${entry.date!.minute}"
                                      : "${entry.date!.hour}:${entry.date!.minute}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(getMoodIcons(entry.mood!),
                                    color: Colors.white),
                                const SizedBox(width: 5),
                                Icon(getWeatherIcons(entry.weather!),
                                    color: Colors.white),
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
                ),
              ),
              // End Top
              // Middle
              const SizedBox(height: 15),
              Center(
                child: Text(
                  entry.title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: Text(
                      entry.description!,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ),
              ),
              // End Middle
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                  color: themeManager.color,
                ),
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
                      icon: Icon(Icons.image, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<EntryProvider>().delete(entry);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
