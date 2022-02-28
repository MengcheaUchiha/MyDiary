import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:flutter_mydiary/theme_manager.dart';
import 'package:flutter_mydiary/widget/entry_item.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/entry.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
//   @override
//   void initState() {
//     super.initState();
//     FocusManager.instance.primaryFocus!.unfocus();
//   }

  bool isShowCalendar = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final entryProvider = context.watch<EntryProvider>();
    final _textStyle = Theme.of(context).textTheme.bodyText1!;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isShowCalendar
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: TableCalendar<Entry>(
                locale:
                    context.locale == Locale('en', 'US') ? 'en_US' : 'km_KM',
                headerStyle: HeaderStyle(
                  titleTextStyle: _textStyle.copyWith(fontSize: 17.0),
                  formatButtonTextStyle: _textStyle,
                ),
                daysOfWeekHeight: 28.0,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: Theme.of(context).textTheme.bodyText1!,
                  weekendStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                calendarStyle: CalendarStyle(
                  todayTextStyle: _textStyle,
                  defaultTextStyle: _textStyle,
                  weekendTextStyle:
                      _textStyle.copyWith(color: const Color(0xFF5A5A5A)),
                  outsideTextStyle:
                      _textStyle.copyWith(color: const Color(0xFFAEAEAE)),
                  markerSize: 12,
                ),
                eventLoader: (day) {
                  final dt = DateTime(day.year, day.month, day.day);
                  return entryProvider.eventDays[dt] ?? [];
                },
                focusedDay: entryProvider.focusedDate,
                firstDay: DateTime.utc(2019, 10, 16),
                lastDay: DateTime.utc(2025, 10, 16),
                selectedDayPredicate: (day) {
                  return isSameDay(entryProvider.selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(selectedDay, entryProvider.selectedDate)) {
                    context
                        .read<EntryProvider>()
                        .setSelectedDay(selectedDay, focusedDay);
                  }
                },
                availableCalendarFormats: {
                  CalendarFormat.month: 'calendarFormat.month'.tr(),
                  CalendarFormat.twoWeeks: 'calendarFormat.twoWeek'.tr(),
                  CalendarFormat.week: 'calendarFormat.week'.tr(),
                },
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, day, entry) => Container(
                    width: 7.5,
                    height: 7.5,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  todayBuilder: (context, day, dt) => Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text('${day.day}'),
                  ),
                ),
              ),
              secondChild: Container(),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isShowCalendar = !isShowCalendar;
                });
              },
              icon: Icon(Icons.info),
            ),
            entryProvider.entriesByDate.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entryProvider.entriesByDate.length,
                    itemBuilder: (context, index) {
                      return ItemEntry(
                          entry: entryProvider.entriesByDate[index]);
                    },
                  )
                : EmptyList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 500),
      child: Container(
        child: Center(
          child: Text(
            'no_entries'.tr(),
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    return Container(
      color: theme.color,
      child: Row(
        children: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.reorder, color: Colors.grey),
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.edit, color: Colors.grey),
          ),
          IconButton(
            onPressed: null,
            icon: Icon(Icons.image, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
