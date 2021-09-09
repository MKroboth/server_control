import '../tools/drop_last_if.dart';

class Temperature {
  final int _millikelvin;

  Temperature({required int millikelvin}) : _millikelvin = millikelvin;
  Temperature.fromKelvin(num kelvin)
      : this(millikelvin: (kelvin * 1000).truncate());
  Temperature.fromCelsius(num celsius)
      : this(millikelvin: ((celsius + 273.15) * 1000).truncate());

  String toKelvinString() =>
      "${(_millikelvin / 1000).toStringAsFixed(4).dropLastWhile((x) => x == "0" || x == ".")} K";
  String toCelsiusString() =>
      "${((_millikelvin / 1000) - 273.15).toStringAsFixed(4).dropLastWhile((x) => x == "0" || x == ".")} °C";
}
