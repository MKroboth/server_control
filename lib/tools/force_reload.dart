import 'package:flutter/foundation.dart';

class ForceReload extends ChangeNotifier {
  bool _value;

  ForceReload([this._value = false]);

  bool get value => _value;
  set value(bool x) {
    if (value != x) {
      _value = x;
      notifyListeners();
    }
  }
}
