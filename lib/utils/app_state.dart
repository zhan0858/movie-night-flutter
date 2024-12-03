import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String? _deviceId;
  String? _sessionId;

  setDeviceId(String deviceId) {
    _deviceId = deviceId;
    notifyListeners();
  }

  String get deviceId {
    return _deviceId ?? "Unknown Device ID";
  }

  void setSessionId(sessionId) {
    _sessionId = sessionId;
    notifyListeners();
  }
}