import 'package:flutter/material.dart';
import 'package:push_notification_full_flutter/test_notify_scree.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestNotifyScreen(),
    );
  }
}

