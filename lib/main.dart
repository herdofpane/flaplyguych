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
  double _pointDeSpawn = 0;

  double _distanceDepartTuyaux = 700;
  int nbrDeTuyaux = 3;

  double _bottomFlappy = 5.0;
  double _leftFlappy = 250;
  double _longueurFlappy = 171;
  double _hauteurFlappy = 104;

  List<Tuyau> tuyaux = [];
  List<Tuyau> tuyauxInverse = [];

  late Timer _timer;
  final double _gravity = -5.0;
  final double _gravity2 = -10.0;
  final double _jumpStrength = 50.0;
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
          bottom: tuyaux[i].bottom + _hauteurFlappy + 500,
          left: tuyaux[i].left,
          hauteur: 280,
          longueur: 57,
        ),
      );
    }

    _timer = Timer.periodic(Duration(milliseconds: _refreshRate), (timer) {
      setState(() {
        // Mise à jour des positions
        _bottomFlappy += _gravity;
        //tuyaux a l'endroit
        for (Tuyau tuyau in tuyaux) {
          tuyau.left += _gravity2;
          if (_bottomFlappy < tuyau.bottom + tuyau.hauteur &&
              tuyau.left < _leftFlappy + _longueurFlappy &&
              tuyau.left > _leftFlappy - tuyau.longueur) {
            resetGame();
          }

          if (tuyau.left < -tuyau.longueur) {
            tuyau.left = _distanceDepartTuyaux * nbrDeTuyaux;
          }
        }

        if (_bottomFlappy == 0) {
          resetGame();
        }
        //tuyaux a l'envers
        for (Tuyau tuyau in tuyauxInverse) {
          tuyau.left += _gravity2;
          if (_bottomFlappy + _hauteurFlappy > tuyau.bottom &&
              tuyau.left < _leftFlappy + _longueurFlappy &&
              tuyau.left > _leftFlappy - tuyau.longueur) {
            resetGame();
          }
          if (tuyau.left < -tuyau.longueur) {
            tuyau.left = _distanceDepartTuyaux * nbrDeTuyaux;
          }
        }

        // Vérification des collisions et remise à zéro si nécessaire
        // checkCollisions();

        // Réinitialisation des tuyaux sortis de l'écran
        // resetTuyaux();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  double departHauteurTuyaux() {
    double nbr = random.nextDouble() * (270 - 50) - 270;
    return nbr;
  }

  void resetGame() {
    _bottomFlappy = 5;

    for (int i = 0; i < tuyaux.length; i++) {
      tuyaux[i].bottom = departHauteurTuyaux();
      tuyaux[i].left = _distanceDepartTuyaux * (i + 2);
    }
    for (int i = 0; i < tuyauxInverse.length; i++) {
      tuyauxInverse[i].bottom = tuyaux[i].bottom + _hauteurFlappy + 500;
      tuyauxInverse[i].left = tuyaux[i].left;
    }
  }

  // void checkCollisions() {
  //   // ... Vérifications de collisions avec les tuyaux
  //   // Ajoutez votre logique de collision ici et appelez resetGame() si nécessaire
  // }

  // void resetTuyaux() {
  //   for (int i = 0; i < tuyaux.length; i++) {
  //     if (tuyaux[i].left < -_longueurFlappy) {
  //       tuyaux[i].left = _pointDeSpawn;
  //       tuyaux[i].bottom = departHauteurTuyaux();
  //     }
  //   }
  // }

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
