import 'dart:async';
import 'dart:math';

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
  Random random = Random();

  double _bottomFlappy = 5.0;
  double _leftFlappy = 250;
  double _longueurFlappy = 447;

  double _hauteurImageTuyo = 615;
  double _longueurTuto = 425;
  double _bottomTuyo = -315;
  double _leftTuyo = 1000;

  int condition = 255;
  late Timer _timer;
  final double _gravity = -5.0;
  final double _gravity2 = -10.0; // Gravité négative pour aller vers le haut
  final double _jumpStrength = 50.0; // Force de saut positive
  final int _refreshRate = 50;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: _refreshRate), (timer) {
      setState(() {
        _bottomFlappy += _gravity;
        _leftTuyo += _gravity2;
        if (_bottomFlappy > MediaQuery.of(context).size.height) {
          _bottomFlappy = MediaQuery.of(context).size.height;
        }
        if (_bottomFlappy == 0 ||
            _bottomFlappy < _bottomTuyo + _hauteurImageTuyo &&
                _leftTuyo < _leftFlappy + _longueurFlappy &&
                _leftTuyo > _leftFlappy - _longueurTuto) {
          _bottomFlappy = 5;
          _leftTuyo = 1000;
        }
        if (_leftTuyo == 0) {
          _leftTuyo = 1000;
          double nbr = -1000;
          // print(-nbr);

          while (nbr < -457 || nbr > -200) {
            nbr = -random.nextDouble() * 1000;
          }
          print(nbr);
          _bottomTuyo = nbr;
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
      _bottomFlappy += _jumpStrength;
      if (_bottomFlappy == 0) {
        _bottomFlappy = 50;
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
              bottom: _bottomFlappy,
              left: _leftFlappy,
              child:
                  Image.asset('image/flappy.png'), // Remplacez par votre image
            ),
            Positioned(
              bottom: _bottomTuyo,
              left: _leftTuyo,
              child: Image.asset('image/tuyo.png'),
            ),

            // Autres widgets si nécessaire
          ],
        ),
      ),
    );
  }
}
