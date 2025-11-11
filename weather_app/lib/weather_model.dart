class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown City',
      temperature: (json['main']['temp'] ?? 0.0).toDouble(),
      description: json['weather'][0]['description'] ?? 'No description',
      icon: json['weather'][0]['icon'] ?? '',
    );
  }
}
