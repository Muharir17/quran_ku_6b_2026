import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_ku/providers/surah_provider.dart';
import 'package:quran_ku/screens/detail_surah_screen.dart';
import 'package:quran_ku/screens/list_surah_screen.dart';


void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SurahProvider()..fetchSurahList(),
      child: MaterialApp(
        title: 'Quran App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ListSurahScreen(),
          '/surah-detail': (context) {
            final surahNumber = ModalRoute.of(context)!.settings.arguments as int;
            return DetailSurahScreen(surahNumber: surahNumber);
          },
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}