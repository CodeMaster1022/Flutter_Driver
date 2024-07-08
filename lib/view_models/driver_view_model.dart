import 'package:flutter/material.dart';
import 'package:kenorider_driver/services/api_servies.dart';
import '../models/driver_model.dart'; // Adjust the import path as needed
import 'package:shared_preferences/shared_preferences.dart';

class DriverViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DriverModel _driver = DriverModel();
  String? get carPhoto => _driver.carPhoto;
  String? get licenseVerification => _driver.licenseVerification;
  String? get driverPhoto => _driver.driverPhoto;
  String? get errorMessage => _errorMessage;
  bool get isRegistrationSuccessful => _isRegistrationSuccessful;
  bool get isLoginSuccessful => _isLoginSuccessful;

  String? _errorMessage;
  bool _isRegistrationSuccessful = false;
  bool _isLoginSuccessful = false;

  DriverModel get driver => _driver;

  void setFullName(String fullName) {
    _driver.fullName = fullName;
    notifyListeners();
  }

  void setEmail(String email) {
    _driver.email = email;
    notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _driver.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setPassword(String password) {
    _driver.password = password;
    notifyListeners();
  }

  void setPasswordConfirmation(String passwordConfirmation) {
    _driver.passwordConfirmation = passwordConfirmation;
    notifyListeners();
  }

  void setCity(String city) {
    _driver.city = city;
    notifyListeners();
  }

  void setCarNumber(String carNumber) {
    _driver.carNumber = carNumber;
    notifyListeners();
  }

  void setRating(int rating) {
    _driver.rating = rating;
    notifyListeners();
  }

  void setCarType(String type) {
    _driver.carType = type;
    notifyListeners();
  }

  void setCarColor(String color) {
    _driver.carColor = color;
    notifyListeners();
  }

  void setLicenseVerification(String licenseVerification) {
    _driver.licenseVerification = licenseVerification;
    notifyListeners();
  }

  void setDriverPhoto(String driverPhoto) {
    _driver.driverPhoto = driverPhoto;
    notifyListeners();
  }

  void setCarPhoto(String carPhoto) {
    _driver.carPhoto = carPhoto;
    notifyListeners();
  }

  void setLienceNo(String licenseNo) {
    _driver.licenseNo = licenseNo;
    notifyListeners();
  }

  Future<void> clearLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('driver');
    prefs.remove('token');
  }

  Future<void> registerDriver() async {
    try {
      final result = await _apiService.registerDriver(_driver);
      if (result['statusCode'] == true) {
        _isRegistrationSuccessful = true;
        await clearLocalData();
      } else {
        _isRegistrationSuccessful = false;
        _errorMessage = result['message'];
      }
    } catch (e) {
      _isRegistrationSuccessful = false;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Future<void> loginDriver(String email, String password, String method) async {
  //   try {
  //     final result = await _apiService.loginDriver(email, password, method);
  //     if (result['statusCode'] == 200) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString(
  //           'token', jsonEncode({'token': result['access_token']}));
  //       _driver.email = email;
  //       _isLoginSuccessful = true;
  //       _errorMessage = null;
  //     } else {
  //       _isLoginSuccessful = false;
  //       _errorMessage = result['message'];
  //     }
  //   } catch (e) {
  //     _isLoginSuccessful = false;
  //     _errorMessage = e.toString();
  //   }
  //   notifyListeners();
  // }
}
