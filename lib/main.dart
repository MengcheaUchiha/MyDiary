import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mydiary/const.dart';
import 'package:flutter_mydiary/model/entry.dart';
import 'package:flutter_mydiary/model/entry_provider.dart';
import 'package:flutter_mydiary/page/calendar_page.dart';
import 'package:flutter_mydiary/page/diary_page.dart';
import 'package:flutter_mydiary/theme_manager.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'page/entry_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => EntryProvider()),
      ],
      child: EasyLocalization(
        supportedLocales: [
          Locale('en', 'US'),
          Locale('km', 'KM'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('km', 'KM'),
        startLocale: Locale('km', 'KM'),
        saveLocale: true,
        child: const MyMaterialApp(),
      ),
    ),
  );
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    return MaterialApp(
      title: 'My Diary',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontFamily: isEngLocale(context) ? 'Nunito' : 'Kantumruy',
            fontSize: isEngLocale(context) ? 16 : 12,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontFamily: isEngLocale(context) ? 'Nunito' : 'Kantumruy',
            fontSize: isEngLocale(context) ? 16 : 12,
          ),
        ),
      ),
      themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      duration: 3000,
      imageSrc: 'assets/splash_screen.png',
      imageSize: 100,
      navigateRoute: MyMain(),
    );
  }
}

class MyMain extends StatefulWidget {
  @override
  _MyMainState createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> {
  final PageController _pageController = PageController(initialPage: 0);

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    print("Build Main");
    final theme = context.watch<ThemeNotifier>();
    final entryProvider = context.watch<EntryProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              buildSegmentControl(theme),
              Text(
                "Diary - ${getTitle(theme.bg)!}",
                style: Theme.of(context).textTheme.headline6,
              ),
              AnimatedCrossFade(
                crossFadeState: _selectedPage == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                      value: entryProvider.selectedYear,
                      items: entryProvider.years.map((y) {
                        return DropdownMenuItem<int>(
                          value: y,
                          child: Text('$y'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        context.read<EntryProvider>().setSelectedYear(value!);
                      }),
                ),
                secondChild: const SizedBox(),
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/${getBackground(theme.bg)!}"),
                        fit: BoxFit.fill),
                  ),
                  child: PageView(
                    controller: _pageController,
                    children: [
                      const EntryPage(),
                      const CalendarPage(),
                      DiaryPage(),
                    ],
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _selectedPage = index;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSegmentControl(ThemeNotifier theme) {
    final _textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: FontWeight.bold,
        );
    return AnimatedScale(
      duration: const Duration(milliseconds: 400),
      scale: isEngLocale(context) ? 0.9 : 1,
      child: Container(
        padding: EdgeInsets.all(10),
        child: MaterialSegmentedControl(
          selectionIndex: _selectedPage,
          borderColor: Colors.grey,
          selectedColor: theme.color,
          unselectedColor: theme.isDark
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
          borderRadius: 6.0,
          verticalOffset: 8.0,
          children: {
            0: Text(
              'segments.entries'.tr(),
              style: _textStyle,
            ),
            1: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'segments.calendar'.tr(),
                style: _textStyle,
              ),
            ),
            2: Text(
              'segments.diary'.tr(),
              style: _textStyle,
            ),
          },
          onSegmentChosen: (index) {
            setState(() {
              _selectedPage = index as int;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 3),
                curve: Curves.decelerate,
              );
            });
          },
        ),
      ),
    );
  }
}
