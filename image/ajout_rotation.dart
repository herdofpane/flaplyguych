#dans le homepage tu rajoute cette variable

 double birdRotation = 0.0;


#dans ta méthode jump tu rajoute cette variable

birdRotation = -0.5;

#toujours dans le jump tu rajoute ça pour le temps d'attente av que ça repasse à l'image de base

Future.delayed(Duration(milliseconds: 200), () {
    setState(() {
      birdRotation = 0.0;
    });
  });

#rajoute ça au widget build là où y'a l'oiseau

child: Transform.rotate(
                  angle: birdRotation,
                  child: Container(
                    width: birdSize,
                    height: birdSize,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/hahaha.jpg'), 
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              )