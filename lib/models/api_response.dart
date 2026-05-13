import 'package:quran_ku/models/surah.dart';

class ApiResponse<T>{

  final int code;
  final String message;
  final T? data;

  ApiResponse({required this.code, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class SurahListResponse{
  final List<Surah> surahList;
  
  SurahListResponse({required this.surahList});

  factory SurahListResponse.fromJson(List<dynamic> json) {
    return SurahListResponse(
      surahList: json.map((item) => Surah.fromJson(item)).toList(),
    );
  }
}
