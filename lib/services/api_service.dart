import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'https://equran.id/api/v2';

  Future<ApiResponse<SurahListResponse>> getSurahList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat'));

      if(response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData, (data) => SurahListResponse.fromJson(data as List<dynamic>));
        return apiResponse;
      }else{
        return ApiResponse(code: response.statusCode, message: 'gagal mengambil data surah', data: null,);
      }
      
    } catch (e) {
      return ApiResponse(code: 500, message: 'terjadi kesalahan $e', data: null);
    }
  }

  Future<ApiResponse<DetailedSurah>> getSurahDetail(int surahNumber) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surat/$surahNumber'));

      if(response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData, (data) => DetailedSurah.fromJson(data as Map<String, dynamic>));
        return apiResponse;
      }else{
        return ApiResponse(code: response.statusCode, message: 'gagal mengambil detail surah', data: null,);
      }
    } catch (e) {
      return ApiResponse(code: 500, message: 'terjadi kesalahan $e', data: null);
    }
  }


  
}
