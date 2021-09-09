import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:server_control/pdu_widgets/temperature.dart';
import 'package:server_control/tools/alt_client.dart';
import 'package:xml/xml.dart' as xml;

enum OutletState { ON, OFF }

extension OutletStateString on OutletState {
  String humanReadable() => this == OutletState.ON ? "ON" : "OFF";
}

extension OutletStateToggle on OutletState {
  OutletState toggle() =>
      this == OutletState.ON ? OutletState.OFF : OutletState.ON;
}

extension OutletStateApiID on OutletState {
  String get apiId => this == OutletState.ON ? "0" : "1";
}

@immutable
class PDUHostName {
  final String value;

  const PDUHostName(this.value);
}

@immutable
class PDULogin {
  final String username;
  final String password;

  const PDULogin(this.username, this.password);
}

class PDUHostnameWrapper extends ChangeNotifier {
  PDUHostName? _hostName;

  PDUHostnameWrapper() : _hostName = null;
  PDUHostnameWrapper.wrap(PDUHostName value) : _hostName = value;

  bool get hasValue => _hostName != null;
  PDUHostName get value => _hostName!;
  set value(PDUHostName x) {
    _hostName = x;
    notifyListeners();
  }
}

class PDULoginWrapper extends ChangeNotifier {
  PDULogin? _login;

  PDULoginWrapper() : _login = null;
  PDULoginWrapper.wrap(PDULogin value) : _login = value;

  bool get hasValue => _login != null;
  PDULogin get value => _login!;
  set value(PDULogin x) {
    _login = x;
    notifyListeners();
  }
}

class PDUCommander {
  final PDUHostName hostname;
  final PDULogin login;

  const PDUCommander({required this.hostname, required this.login});

  void setOutletState(int id, OutletState state) {
    if (id > 0) {
      final constructedURL =
          "http://${hostname.value}/control_outlet.htm?outlet$id=1&op=${state.apiId}&submit=Apply";
      print(constructedURL);
      print("username: '${login.username}'\npassword: '${login.password}'");
      final client = http_auth.BasicAuthClient(login.username, login.password,
          inner: AltIOClient());
      client.get(Uri.parse(constructedURL), headers: {
        "Accept": "*/*",
      }).then((response) => print(
          "${response.statusCode}: ${response.request!.headers.toString()}"));
    }
  }

  void powercycleOutlet(int id) {
    if (id > 0) {
      final constructedURL =
          "http://${hostname.value}/control_outlet.htm?outlet$id=1&op=2&submit=Apply";
      print(constructedURL);
      final client = http_auth.BasicAuthClient(login.username, login.password,
          inner: AltIOClient());
      client
          .get(Uri.parse(constructedURL))
          .then((response) => print(response.statusCode));
    }
  }
}

class PDUInfo {
  final Map<String, OutletState> outlets;
  final Temperature temperature;
  final double electricCurrent;
  final int humidity;

  PDUInfo(
      {required this.outlets,
      required this.temperature,
      required this.electricCurrent,
      required this.humidity});

  static Future<PDUInfo> fetch(
      {required PDUHostName hostname, required PDULogin login}) {
    return http
        .get(
      Uri.parse("http://${hostname.value}/status.xml"),
      //headers: {"Authorization": "Basic ${login.basicAuth}"}
    )
        .then((result) {
      final document = xml.XmlDocument.parse(result.body);

      final electricCurrent =
          document.getElement("response")!.getElement("cur0")!.text;

      final temperature =
          document.getElement("response")!.getElement("tempBan")!.text;

      final humidity =
          document.getElement("response")!.getElement("humBan")!.text;

      final outlets = document
          .getElement("response")!
          .children
          .where((x) =>
              x is xml.XmlElement &&
              x.name.toString().startsWith("outletStat"))
          .map((e) => e as xml.XmlElement);

      final outletMap = <String, OutletState>{};

      for (final outlet in outlets) {
        final id =
            int.parse(outlet.name.toString().replaceAll("outletStat", ""));
        final state = outlet.text == "on" ? OutletState.ON : OutletState.OFF;

        outletMap.addAll({"Outlet ${id + 1}": state});
      }

      return PDUInfo(
          outlets: outletMap,
          temperature: Temperature.fromCelsius(double.parse(temperature)),
          electricCurrent: double.parse(electricCurrent),
          humidity: int.parse(humidity));
    });
  }
}
