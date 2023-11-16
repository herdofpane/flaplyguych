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
      home: const MyHomePage(title: 'Flappy Guych'),
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
  double _poitnDeSpawn = 0;

  double _distanceDepartTuyaux = 1300;
  double _distanceDepartTuyaux2 = 2700;
  double _distanceDepartTuyaux3 = 4000;

  // flappy
  double _bottomFlappy = 5.0;
  double _leftFlappy = 250;
  double _longueurFlappy = 171;
  double _hauteurFlappy = 104;

  double _hauteurImageTuyo = 280;
  double _longueurTuto = 57;

  // tuyaux 1
  double _bottomTuyo = 0;
  double _leftTuyo = 0;
  double _bottomTuyoInverse = 0;

  //tuyaux 2

  double _bottomTuyo2 = 0;
  double _leftTuyo2 = 0;
  double _bottomTuyoInverse2 = 0;

  //tuyaux 3

  double _bottomTuyo3 = 0;
  double _leftTuyo3 = 0;
  double _bottomTuyoInverse3 = 0;

  int condition = 255;
  late Timer _timer;
  final double _gravity = -5.0;
  final double _gravity2 = -10.0; // Gravité négative pour aller vers le haut
  final double _jumpStrength = 50.0; // Force de saut positive
  final int _refreshRate = 50;

  @override
  void initState() {
    super.initState();
    _leftTuyo = _distanceDepartTuyaux;
    _bottomTuyo = departHauteurTuyaux();
    // _bottomTuyoInverse = _bottomTuyo + _hauteurImageTuyo + 300;

    _leftTuyo2 = _distanceDepartTuyaux2;
    _bottomTuyo2 = departHauteurTuyaux();
    // _bottomTuyoInverse2 = _bottomTuyo2 + _hauteurImageTuyo + 300;

    _leftTuyo3 = _distanceDepartTuyaux3;
    _bottomTuyo3 = departHauteurTuyaux();
    // _bottomTuyoInverse3 = _bottomTuyo3 + _hauteurImageTuyo + 300;

    _poitnDeSpawn = _distanceDepartTuyaux3 - 200;

    _timer = Timer.periodic(Duration(milliseconds: _refreshRate), (timer) {
      setState(() {
        _bottomTuyoInverse = _bottomTuyo + _hauteurImageTuyo + 300;
        _bottomTuyoInverse2 = _bottomTuyo2 + _hauteurImageTuyo + 300;
        _bottomTuyoInverse3 = _bottomTuyo3 + _hauteurImageTuyo + 300;

        _bottomFlappy += _gravity;
        _leftTuyo += _gravity2;
        _leftTuyo2 += _gravity2;
        _leftTuyo3 += _gravity2;

        if (_bottomFlappy == 0) {
          resetGame();
        }
        if (_bottomFlappy > MediaQuery.of(context).size.height) {
          _bottomFlappy = MediaQuery.of(context).size.height;
        }
// gestion evenement 1er tuyaux
        // quand on touche le tuyaux
        if ((_bottomFlappy < _bottomTuyo + _hauteurImageTuyo &&
                _leftTuyo < _leftFlappy + _longueurFlappy &&
                _leftTuyo > _leftFlappy - _longueurTuto) ||
            (_bottomFlappy + _hauteurFlappy > _bottomTuyoInverse &&
                _leftTuyo < _leftFlappy + _longueurFlappy &&
                _leftTuyo > _leftFlappy - _longueurTuto)) {
          resetGame();
        }

        // quand le tuyaux touche la fin de la page
        if (_leftTuyo < -_longueurTuto) {
          _leftTuyo = _poitnDeSpawn;
          _bottomTuyo = departHauteurTuyaux();
        }

// gestion 2eme tuyaux
        // quand on touche le tuyaux
        if ((_bottomFlappy < _bottomTuyo2 + _hauteurImageTuyo &&
                _leftTuyo2 < _leftFlappy + _longueurFlappy &&
                _leftTuyo2 > _leftFlappy - _longueurTuto) ||
            (_bottomFlappy + _hauteurFlappy > _bottomTuyoInverse2 &&
                _leftTuyo2 < _leftFlappy + _longueurFlappy &&
                _leftTuyo2 > _leftFlappy - _longueurTuto)) {
          resetGame();
        }
        // quand le tuyaux touche la fin de la page
        if (_leftTuyo2 < -_longueurTuto) {
          _leftTuyo2 = _poitnDeSpawn;
          _bottomTuyo2 = departHauteurTuyaux();
        }
// gestion 3eme tuyaux
        // quand on touche le tuyaux
        if ((_bottomFlappy < _bottomTuyo3 + _hauteurImageTuyo &&
                _leftTuyo3 < _leftFlappy + _longueurFlappy &&
                _leftTuyo3 > _leftFlappy - _longueurTuto) ||
            (_bottomFlappy + _hauteurFlappy > _bottomTuyoInverse3 &&
                _leftTuyo3 < _leftFlappy + _longueurFlappy &&
                _leftTuyo3 > _leftFlappy - _longueurTuto)) {
          resetGame();
        }
        // quand le tuyaux touche la fin de la page
        if (_leftTuyo3 < -_longueurTuto) {
          _leftTuyo3 = _poitnDeSpawn;
          _bottomTuyo3 = departHauteurTuyaux();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  double departHauteurTuyaux() {
    double nbr = -1000;
    // while (nbr < -457 || nbr > -200) {
    nbr = random.nextDouble() * (270 - 50) - 270;
    // }
    return nbr;
  }

  void resetGame() {
    _bottomFlappy = 5;
    _leftTuyo = _distanceDepartTuyaux;
    _leftTuyo2 = _distanceDepartTuyaux2;
    _leftTuyo3 = _distanceDepartTuyaux3;
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
                  Image.asset('image/flappy2.png'), // Remplacez par votre image
            ),
            Positioned(
              bottom: _bottomTuyo,
              left: _leftTuyo,
              child: Image.asset('image/Tuyau22.png'),
            ),
            Positioned(
              bottom: _bottomTuyoInverse,
              left: _leftTuyo,
              child: Image.asset('image/tuyau22ALenvers.png'),
            ),
            Positioned(
              bottom: _bottomTuyo2,
              left: _leftTuyo2,
              child: Image.asset('image/Tuyau22.png'),
            ),
            Positioned(
              bottom: _bottomTuyoInverse2,
              left: _leftTuyo2,
              child: Image.asset('image/tuyau22ALenvers.png'),
            ),
            Positioned(
              bottom: _bottomTuyo3,
              left: _leftTuyo3,
              child: Image.asset('image/Tuyau22.png'),
            ),
            Positioned(
              bottom: _bottomTuyoInverse3,
              left: _leftTuyo3,
              child: Image.asset('image/tuyau22ALenvers.png'),
            ),

            // Autres widgets si nécessaire
          ],
        ),
      ),
    );
  }
}
