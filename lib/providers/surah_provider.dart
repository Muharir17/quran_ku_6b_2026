import 'package:flutter/foundation.dart';
import 'package:quran_ku/models/models.dart';
import 'package:quran_ku/services/api_service.dart';


class SurahProvider with ChangeNotifier {

  final ApiService _apiService = ApiService();
  
  List<Surah> _surahList = [];
  List<Surah> get surahList => _surahList;

  DetailedSurah? _selectedSurah;
  DetailedSurah? get selectedSurah => _selectedSurah;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchSurahList() async{
    _isLoading = true;
    notifyListeners();
    
    final response = await _apiService.getSurahList();

    if(response.code == 200 && response.data != null) {
      _surahList = response.data!.surahList;
    } else {
      _errorMessage = response.message;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSurahDetail(int surahNumber) async {
    _isLoading = true;
    notifyListeners();
    
    final response = await _apiService.getSurahDetail(surahNumber);
    
    if(response.code == 200 && response.data != null) {
      _selectedSurah = response.data!;
    } else {
      _errorMessage = response.message;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void clearSelectedSurah() {
    _selectedSurah = null;
    notifyListeners();
  }
  
}
