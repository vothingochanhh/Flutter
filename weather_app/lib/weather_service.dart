import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'weather_model.dart'; // Chúng ta sẽ tạo file này ở bước 6

class WeatherService {
  final String _apiKey = dotenv.env['OPENWEATHER_API_KEY']!;

  // Hàm "kết hợp" - Hàm này UI sẽ gọi
  Future<Weather> getCurrentWeather() async {
    try {
      // 1. Lấy vị trí
      Position position = await _getCurrentLocation();

      // 2. Dùng vị trí để lấy thời tiết
      final String apiUrl =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // 3. Phân tích JSON và trả về
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Bắt các lỗi (ví dụ: từ chối quyền, API hỏng)
      throw Exception('Error: ${e.toString()}');
    }
  }

  // --- Hàm nội bộ ---

  // Hàm 1: Lấy vị trí (dùng geolocator)
  Future<Position> _getCurrentLocation() async {
    // 1. Kiểm tra xem dịch vụ vị trí có bật không
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 2. Kiểm tra quyền
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Yêu cầu quyền
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // 3. Lấy vị trí
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // Tăng độ chính xác
    );
  }
}
