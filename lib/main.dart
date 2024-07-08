import 'package:flutter/material.dart';
import 'package:kenorider_driver/views/splashpage.dart';
import 'package:kenorider_driver/view_models/driver_view_model.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Set HomePage as the initial screen
    );
  }
}
