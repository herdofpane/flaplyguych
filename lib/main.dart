import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tuyau {
  double bottom;
  double left;
  double hauteur;
  double longueur;

  Tuyau(
      {required this.bottom,
      required this.left,
      required this.hauteur,
      required this.longueur});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random random = Random();
  int point = 0;
  double _pointDeSpawn = 0;
  bool executed = false;

  double _distanceDepartTuyaux = 700;
  int nbrDeTuyaux = 3;

  double _bottomFlappy = 5.0;
  double _leftFlappy = 250;
  double _longueurFlappy = 171;
  double _hauteurFlappy = 104;

  double _hauteurImageTuyo = 280;
  double _longueurTuto = 57;

  List<Tuyau> tuyaux = [];
  List<Tuyau> tuyauxInverse = [];

  late Timer _timer;
  final double _gravityFlappy = -8.0;
  final double _gravityTuyau = -10.0;
  final double _jumpStrength = 60.0;
  final int _refreshRate = 50;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < nbrDeTuyaux; i++) {
      tuyaux.add(
        Tuyau(
          bottom: departHauteurTuyaux(),
          left: _distanceDepartTuyaux * (i + 2),
          hauteur: 280,
          longueur: 57,
        ),
      );
    }

    for (int i = 0; i < nbrDeTuyaux; i++) {
      tuyauxInverse.add(
        Tuyau(
          bottom: tuyaux[i].bottom + _hauteurImageTuyo + _hauteurFlappy + 100,
          left: tuyaux[i].left,
          hauteur: 280,
          longueur: 57,
        ),
      );
    }

    _timer = Timer.periodic(Duration(milliseconds: _refreshRate), (timer) {
      setState(() {
        // Mise à jour des positions
        _bottomFlappy += _gravityFlappy;
        verifTuyauDroit();
        verifTuyauInvers();

        verifFlappy();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void verifFlappy() {
    if (_bottomFlappy < 1) {
      resetGame();
    }
    if (_bottomFlappy + _hauteurFlappy > MediaQuery.of(context).size.height) {
      _bottomFlappy = MediaQuery.of(context).size.height - _hauteurFlappy;
    }
  }

  void verifTuyauDroit() {
    for (Tuyau tuyau in tuyaux) {
      tuyau.left += _gravityTuyau;
      if (_bottomFlappy < tuyau.bottom + tuyau.hauteur &&
          tuyau.left < _leftFlappy + _longueurFlappy &&
          tuyau.left > _leftFlappy - tuyau.longueur) {
        resetGame();
      }

      if (tuyau.left < -tuyau.longueur) {
        tuyau.left = _distanceDepartTuyaux * nbrDeTuyaux;
        executed = false;
      }
      if (!executed) {
        if (tuyau.left < _leftFlappy - tuyau.longueur) {
          point++;
          executed = true;
        }
      }
    }
  }

  void verifTuyauInvers() {
    for (Tuyau tuyau in tuyauxInverse) {
      tuyau.left += _gravityTuyau;
      if (_bottomFlappy + _hauteurFlappy > tuyau.bottom &&
          tuyau.left < _leftFlappy + _longueurFlappy &&
          tuyau.left > _leftFlappy - tuyau.longueur) {
        resetGame();
      }
      if (tuyau.left < -tuyau.longueur) {
        tuyau.left = _distanceDepartTuyaux * nbrDeTuyaux;
      }
    }
  }

  double departHauteurTuyaux() {
    double nbr = random.nextDouble() * (550) - 270;
    return nbr;
  }

  void resetGame() {
    _bottomFlappy = _gravityFlappy.abs();
    point = 0;

    for (int i = 0; i < tuyaux.length; i++) {
      tuyaux[i].bottom = departHauteurTuyaux();
      tuyaux[i].left = _distanceDepartTuyaux * (i + 2);
    }
    for (int i = 0; i < tuyauxInverse.length; i++) {
      tuyauxInverse[i].bottom =
          tuyaux[i].bottom + _hauteurImageTuyo + _hauteurFlappy + 100;
      tuyauxInverse[i].left = tuyaux[i].left;
    }
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
              child: Image.asset('image/flappy2.png'),
            ),
            Positioned(
              top: 50, // ajustez ces valeurs en fonction de vos besoins
              left: 20,
              child: Text(
                point.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            for (Tuyau tuyau in tuyaux)
              Positioned(
                bottom: tuyau.bottom,
                left: tuyau.left,
                child: Image.asset('image/Tuyau22.png'),
              ),
            for (Tuyau tuyau in tuyauxInverse)
              Positioned(
                bottom: tuyau.bottom,
                left: tuyau.left,
                child: Image.asset('image/tuyau22ALenvers.png'),
              ),
          ],
        ),
      ),
    );
  }
}
