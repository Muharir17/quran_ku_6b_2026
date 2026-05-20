import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_ku/models/surah.dart';
import 'package:quran_ku/providers/providers.dart';

class ListSurahScreen extends StatelessWidget {
  const ListSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Surah'),
        centerTitle: false,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<SurahProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchSurahList();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (provider.surahList.isEmpty) {
            return Center(child: Text('Tidak ada data surah'));
          }

          return ListView.builder(
            itemCount: provider.surahList.length,
            itemBuilder: (context, index) {
              Surah surah = provider.surahList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        surah.nomor.toString(),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    surah.nama,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    '${surah.namaLatin}. ${surah.jumlahAyat} Ayat. ${surah.tempatTurun} . ${surah.arti}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/surah-detail',
                      arguments: surah.nomor,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
