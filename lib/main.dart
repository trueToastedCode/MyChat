import 'package:any1/composition_root.dart';
import 'package:any1/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  final firstPage = CompositionRoot.start();
  runApp(MyApp(firstPage));
}

class MyApp extends StatelessWidget {
  final Widget firstPage;
  const MyApp(this.firstPage);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChat',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: firstPage
    );
  }
}
