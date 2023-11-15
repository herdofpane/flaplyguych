import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _imageYPosition = 5.0;
  double _imageYPosition2 = 50;
  double _imageXPosition2 = 50;
  late Timer _timer;
  final double _gravity = -5.0; // Gravité négative pour aller vers le haut
  final double _jumpStrength = 50.0; // Force de saut positive
  final int _refreshRate = 50;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: _refreshRate), (timer) {
      setState(() {
        _imageYPosition += _gravity;
        if (_imageYPosition > MediaQuery.of(context).size.height) {
          _imageYPosition = MediaQuery.of(context).size.height;
        }
        if (_imageYPosition == 0) {
          _imageYPosition = 5;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      _jump();
    }
  }

  void _jump() {
    setState(() {
      _imageYPosition += _jumpStrength;
      if (_imageYPosition == 0) {
        _imageYPosition = 50;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _onKey,
        autofocus: true,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              bottom: _imageYPosition,
              child:
                  Image.asset('image/carlito.jpg'), // Remplacez par votre image
            ),
            Positioned(
              bottom: _imageYPosition2,
              left: _imageXPosition2,
              child: Image.asset('image/your_second_image.jpg'),
            ),

            // Autres widgets si nécessaire
          ],
        ),
      ),
    );
  }
}
