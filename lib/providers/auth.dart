import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/Models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;
  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userID;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUP(String email, password) async {
    const API_KEY = 'AIzaSyD3oJQsNrHfEu1wzf2Vtr7ReZbxwAHhDWM';

    final urlString =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY';
    var url = Uri.parse(urlString);

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
      // print('$_userID   $_token');
    } catch (error) {
      throw error;
    }
  }

  Future<void> logIN(String email, password) async {
    const API_KEY = 'AIzaSyD3oJQsNrHfEu1wzf2Vtr7ReZbxwAHhDWM';

    final urlString =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY';
    var url = Uri.parse(urlString);

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String()
      });
      prefs.setString('userData', userData);
      // print('$_userID   $_token');
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogIn() async {
    print('Starting auto stuff');
    print('Phase : 1');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print('Phase : 2');

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    print('Phase : 3');

    _token = extractedUserData['token'];
    _userID = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    print('in success auto log in');
    return true;
  }

  Future<void> logout() async {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _userID = null;
    _expiryDate = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
