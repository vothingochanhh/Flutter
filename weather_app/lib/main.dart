import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_service.dart';
import 'weather_model.dart';

Future<void> main() async {
  // Tải file .env
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Dùng 1 service và 1 future để gọi
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Bắt đầu gọi ngay khi app mở
    _weatherFuture = _weatherService.getCurrentWeather();
  }

  // Hàm để lấy icon (OpenWeatherMap có cung cấp link)
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Weather')),
      // Dùng FutureBuilder để xử lý việc "chờ"
      body: Center(
        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            // 1. TRẠNG THÁI: ĐANG CHỜ (Loading)
            // (Đang chờ GPS hoặc đang chờ API)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Finding your location...'),
                ],
              );
            }

            // 2. TRẠNG THÁI: BỊ LỖI (Error)
            if (snapshot.hasError) {
              // Hiển thị lỗi (ví dụ: "Vui lòng bật GPS")
              return Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            }

            // 3. TRẠNG THÁI: THÀNH CÔNG (Success)
            if (snapshot.hasData) {
              final weather = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tên thành phố
                    Text(
                      weather.cityName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),

                    // Icon thời tiết
                    Image.network(
                      getWeatherIconUrl(weather.icon),
                      width: 150,
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.cloud_off, size: 100),
                    ),
                    const SizedBox(height: 20),

                    // Nhiệt độ (làm tròn)
                    Text(
                      '${weather.temperature.round()}°C',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 10),

                    // Mô tả
                    Text(
                      weather.description,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            // Trường hợp rỗng (ít khi xảy ra)
            return const Text('No weather data.');
          },
        ),
      ),
    );
  }
}
