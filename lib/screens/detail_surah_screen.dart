import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/providers.dart';

class DetailSurahScreen extends StatelessWidget {
  final int surahNumber;

  const DetailSurahScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    // Fetch the surah detail when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SurahProvider>(context, listen: false)
          .fetchSurahDetail(surahNumber);
    });

    return Scaffold(
      appBar: AppBar(
        title: Consumer<SurahProvider>(
          builder: (context, provider, child) {
            if (provider.selectedSurah != null) {
              return Text('${provider.selectedSurah!.nomor}. ${provider.selectedSurah!.nama ?? 'Tidak Diketahui'}');
            }
            return const Text('Detail Surah');
          },
        ),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<SurahProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.selectedSurah == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchSurahDetail(surahNumber);
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (provider.selectedSurah == null) {
            return const Center(
              child: Text('Tidak ada data surah'),
            );
          }

          final surah = provider.selectedSurah!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Surah Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    surah.nomor.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surah.nama ?? 'Tidak Diketahui',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      surah.namaLatin ?? 'Tidak Diketahui',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildInfoChip(surah.jumlahAyat.toString(), 'Ayat'),
                              const SizedBox(width: 8),
                              _buildInfoChip(surah.tempatTurun ?? 'Tidak Diketahui', 'Turun'),
                              const SizedBox(width: 8),
                              _buildInfoChip(surah.arti ?? 'Tidak Diketahui', 'Arti'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Audio player for the entire surah
                          if (surah.audioFull.isNotEmpty)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.play_circle_outline, color: Colors.green),
                                  onPressed: () {
                                    //TODO: Implement surah audio playback
                                    print('Playing surah audio: ${surah.audioFull['01']}');
                                  },
                                ),
                                const Text(
                                  'Dengarkan Surat',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),
                          ExpansionTile(
                            title: const Text(
                              'Deskripsi Surat',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Html(
                                  data: surah.deskripsi ?? 'Tidak ada deskripsi',
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(14),
                                      color: Colors.grey[700],
                                    ),
                                    "i": Style(
                                      fontStyle: FontStyle.italic,
                                    ),
                                    "br": Style(
                                      margin: Margins.only(top: 8.0),
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ayat List
                  const Text(
                    'Daftar Ayat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Display all ayat without collapse for easy reading
                  ...surah.ayat.asMap().entries.map((entry) {
                    int index = entry.key;
                    final ayah = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Header with ayah number
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ayah.nomorAyat.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Arabic text
                            Text(
                              ayah.teksArab ?? '',
                              style: const TextStyle(
                                fontSize: 24,
                                height: 2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 12),
                            // Latin transliteration
                            Text(
                              ayah.teksLatin ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Translation
                            Text(
                              ayah.textIndonesia ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Audio player
                            if (ayah.audio.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.play_circle_outline),
                                    onPressed: () {
                                      //TODO: Implement audio playback
                                      // For now, we'll just print the audio URL
                                      print('Playing audio: ${ayah.audio['01']}');
                                    },
                                  ),
                                  const Text(
                                    'Audio',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(String label, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}