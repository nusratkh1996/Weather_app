class Coord {
  final double lon;
  final double lat;

  Coord({this.lat, this.lon});
  factory Coord.fromJason(Map<String, dynamic> jason) {
    return Coord(lon: (jason['lon'].toDouble()), lat: (jason['lat'].toDouble()));
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({this.id, this.description, this.icon, this.main});

  factory Weather.fromJason(Map<String, dynamic> jason) {
    return Weather(
        id: jason['id'],
        main: jason['main'],
        description: jason['description'],
        icon: jason['icon']);
  }
}

class Main {
  final double temp;
  final double pressure;
  final int humidity;
  final double temp_min;
  final double temp_max;

  Main({this.temp, this.pressure, this.humidity, this.temp_min, this.temp_max});

  factory Main.fromJason(Map<String, dynamic> jason) {
    return Main(
        temp: double.parse(jason['temp'].toString()),
        pressure: double.parse(jason['pressure'].toString()),
        humidity: jason['humidity'],
        temp_min: double.parse(jason['temp_min'].toString()),
        temp_max: double.parse(jason['temp_max'].toString()));
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({this.speed, this.deg});

  factory Wind.fromJason(Map<String, dynamic> jason) {
    return Wind(
        speed: double.parse(jason['speed'].toString()),
        deg: int.parse(jason['deg'].toString()));
  }
}

class Clouds {
  final int all;
  Clouds({this.all});

  factory Clouds.fromJason(Map<String, dynamic> jason) {
    return Clouds(all: jason['all']);
  }
}

class Sys {
  final double message;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({this.message, this.country, this.sunrise, this.sunset});

  factory Sys.fromJason(Map<String, dynamic> jason) {
    return Sys(
        message: jason['message'],
        country: jason['country'],
        sunrise: jason['sunrise'],
        sunset: jason['sunset']);
  }
}

class WeatherModel {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int id;
  final String name;
  final int cod;

  WeatherModel(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.id,
      this.name,
      this.cod});

  factory WeatherModel.fromJason(Map<String, dynamic> jason) {
    return WeatherModel(
        coord: Coord.fromJason(jason['coord']),
        weather: (jason['weather'] as List)
            .map((item) => Weather.fromJason(item))
            .toList(),
        base: jason['base'],
        main: Main.fromJason(jason['main']),
        wind: Wind.fromJason(jason['wind']),
        clouds: Clouds.fromJason(jason['clouds']),
        dt: jason['dt'],
        sys: Sys.fromJason(jason['sys']),
        id: jason['id'],
        name: jason['name'],
        cod: jason['cod']);
  }
}
