import 'package:quran_ku/models/ayah.dart';
import 'package:quran_ku/models/surah.dart';


class DetailedSurah extends Surah{

  final List<Ayah> ayat;

  DetailedSurah({
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audioFull,
    required this.ayat,
  });

  factory DetailedSurah.fromJson(Map<String, dynamic> json) {
    return DetailedSurah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: (json['audioFull'] as Map<String, dynamic>? ?? {}).map((key, value) => MapEntry(key, value.toString())),
      ayat: (json['ayat'] as List<dynamic>?)
          ?.map((ayah) => Ayah.fromJson(ayah as Map<String, dynamic>))
          .toList() ?? [],
    );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audioFull': audioFull,
      'ayat': ayat.map((ayah) => ayah.toJson()).toList(),
    };
  }

}