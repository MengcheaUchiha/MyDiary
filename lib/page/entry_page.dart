import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_mydiary/const.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:flutter_mydiary/widget/entry_item.dart';

import '../model/entry.dart';
import '../theme_manager.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({Key? key}) : super(key: key);
  List<int> _getMonths(List<Entry> entries) {
    Set<int> sets = {};
    sets = entries.map((e) => e.date!.month).toSet();
    List<int> months = sets.toList();
    months.sort((a, b) => b.compareTo(a));
    print("Month : $months");
    return months;
  }

  List<Widget> _buildListView(List<Entry> entries) {
    List<Widget> widgets = [];
    List<int> months = _getMonths(entries);
    for (var m in months) {
      List<Entry> filter =
          entries.where((element) => element.date!.month == m).toList();
      print("Month $m : ${filter.length} Entries");
      final sticky = StickyAndEntry(
        month: m,
        entries: filter,
        callback: () {
          print('Update');
        },
        onDeleteClicked: () {
          print('Delete');
        },
      );
      widgets.add(sticky);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<EntryProvider>().entries;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: _buildListView(entries),
      ),
      bottomNavigationBar: BottomRow(count: entries.length),
    );
  }
}

class StickyAndEntry extends StatelessWidget {
  final int month;
  final List<Entry> entries;
  final VoidCallback callback;
  final VoidCallback onDeleteClicked;

  StickyAndEntry({
    Key? key,
    required this.month,
    required this.entries,
    required this.callback,
    required this.onDeleteClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader.builder(
      sticky: false,
      builder: (context, state) => Container(
        alignment: Alignment.centerLeft,
        child: Center(
          child: Text(
            '$month',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ItemEntry(entry: entries[i]),
          childCount: entries.length,
        ),
      ),
    );
  }
}

class BottomRow extends StatelessWidget {
  final int count;
  BottomRow({Key? key, required this.count}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final themeManager = context.read<ThemeNotifier>();
    return Container(
      color: theme.color,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                context: context,
                builder: (context) {
                  return ThemeBottomSheet();
                },
              );
            },
            icon: Icon(Icons.reorder, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.image, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              themeManager.toggleTheme();
            },
            icon: Icon(
              theme.isDark ? CupertinoIcons.moon : CupertinoIcons.cloud_sun,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              context.locale == Locale('en', 'US')
                  ? context.setLocale(Locale('km', 'KM'))
                  : context.setLocale(Locale('en', 'US'));
            },
            icon: Icon(Icons.image, color: Colors.white),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.only(right: 7.5),
            child: Text(
              count == 0 ? "" : 'total_entries'.plural(count),
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
      ),
    );
  }
}

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({Key? key}) : super(key: key);

  final List<String> bg = const [
    'mitsuha',
    'taki',
    'aspirant',
    'fanny',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    final themeManager = context.read<ThemeNotifier>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5),
        Text(
          'Theme',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: bg.length,
            itemBuilder: (context, index) {
              return BackgroundItem(image: '${bg[index]}');
            },
          ),
        ),
        SwitchListTile(
          title: Row(
            children: [
              Icon(
                theme.isDark ? CupertinoIcons.moon : CupertinoIcons.cloud_sun,
              ),
              SizedBox(width: 10),
              Text(
                theme.isDark ? 'Dark' : 'Light',
                style: TextStyle(
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          onChanged: (bool value) {
            themeManager.toggleTheme();
          },
          value: theme.isDark,
        ),
      ],
    );
  }
}

class BackgroundItem extends StatelessWidget {
  final String image;
  const BackgroundItem({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          context.read<ThemeNotifier>().saveTheme(image);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 100,
                height: 150,
                child: Opacity(
                  opacity: theme.bg == image ? 0.5 : 1.0,
                  child: Image.asset(
                    "assets/${getBackground(image)}",
                    width: 100,
                    height: 150,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            if (theme.bg == image)
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.verified,
                  color: Colors.green,
                ),
              )
          ],
        ),
      ),
    );
  }
}
