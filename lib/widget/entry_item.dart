import 'package:flutter/material.dart';
import 'package:flutter_mydiary/theme_manager.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import '../model/entry.dart';
import 'entry_dialog.dart';
import 'entry_update_dialog.dart';

class ItemEntry extends StatelessWidget {
  final Entry entry;

  ItemEntry({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final iconSize = 20.0;
    return GestureDetector(
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return EntryDialog(entry: entry);
          },
        );
      },
      onLongPress: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return EntryUpdateDialog(entry: entry);
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        color: theme.isDark
            ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75)
            : Colors.white.withOpacity(0.75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        entry.date!.day < 10
                            ? "0${entry.date!.day}"
                            : "${entry.date!.day}",
                        style: TextStyle(
                          color: theme.color,
                          fontSize: 30,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${getDay(entry.date!.weekday)!.substring(0, 3)}.",
                        style: TextStyle(
                          color: theme.color,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        entry.date!.minute < 10
                            ? "${entry.date!.hour}:0${entry.date!.minute}"
                            : "${entry.date!.hour}:${entry.date!.minute}",
                        style: TextStyle(
                          color: theme.color,
                          fontSize: 10,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        entry.title!,
                        style: TextStyle(
                          color: theme.color,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        entry.description!,
                        maxLines: 1,
                        style: TextStyle(
                          color: theme.color,
                          fontSize: 12,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/image/${getMoodImage(entry.mood!)}",
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    "assets/image/${getWeatherImage(entry.weather!)}",
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.bookmark_border,
                    color: theme.color,
                    size: iconSize,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
