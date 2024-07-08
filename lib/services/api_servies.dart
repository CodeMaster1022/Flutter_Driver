import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/driver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      "http://127.0.0.1:8000/api/"; // Replace with your actual base URL

  // ignore: prefer_typing_uninitialized_variables
  var token;

  Future<void> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token') ?? '{}')['token'];
  }

  Future<Map<String, dynamic>> authData(
      Map<String, dynamic> data, String apiUrl) async {
    var fullUrl = Uri.parse(baseUrl + apiUrl); // Use Uri.parse to parse the URL
    await getToken(); // Ensure the token is retrieved before making the request
    final response = await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<Map<String, dynamic>> getData(String apiUrl) async {
    var fullUrl = Uri.parse(baseUrl + apiUrl);
    await getToken();
    final response = await http.get(fullUrl, headers: _setHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Map<String, String> _setHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> registerDriver(DriverModel driver) async {
    print('number:${driver.carNumber}===========>');
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/register"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': driver.fullName,
        'email': driver.email,
        'phone_number': driver.phoneNumber,
        'password': driver.password,
        'city': driver.city,
        'car_type': driver.carType,
        'car_color': driver.carColor,
        'car_number': driver.carNumber,
        'rating': driver.rating,
        'license_verification': driver.licenseVerification,
        'driver_photo': driver.driverPhoto,
        'car_photo': driver.carPhoto,
        'license_number': driver.licenseNo
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register driver');
    }
  }

  static Future<void> loginDriver(
      String email, String password, String method) async {
    print("===============>");
    final String flag = method == 'email'
        ? 'email'
        : 'phone_number'; // Determine the flag based on the method
    final url = Uri.parse('http://127.0.0.1:8000/api/loginDriver');
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'method': method, flag: email, 'password': password});
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Data Sending Success.');
    } else {
      throw Exception('Failed to login');
    }
  }
}
