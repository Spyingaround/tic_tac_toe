import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum Player {
  circle,
  cross,
  empty,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int?> initGameArray = List.filled(9, null);
  List<int?> gameArray = [];
  int turnsCounter = 0;
  var playerTurn = Player.empty;

  @override
  void initState() {
    super.initState();
    gameArray = initGameArray.toList();
    playerTurn = Player.circle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 100, 24, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Tic Tac Hoe',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'QuicksandBold',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500]!,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: false,
                  itemCount: 9,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      child: Tile(
                          index: index,
                          value: gameArray[index].toString(),
                          callBack: updateGameArray),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffFF6E60),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 50,
                  width: 300,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    child: const Text(
                      "Give up",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFamily: "QuicksandBold"),
                    ),
                    onPressed: () {
                      resetGame();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateGameArray(int index) {
    setState(() {
      if (gameArray[index] == null) {
        turnsCounter++;
        if (turnsCounter == 9) {
          resetGame();
        } else {
          gameArray[index] = playerTurn == Player.circle ? 0 : 1;
          if (playerTurn == Player.empty) {
            playerTurn == Player.circle;
          } else if (playerTurn == Player.circle) {
            playerTurn = Player.cross;
          } else {
            playerTurn = Player.circle;
          }
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      gameArray = initGameArray.toList();
      turnsCounter = 0;
    });
  }
}

class Tile extends StatefulWidget {
  Tile({Key? key, this.value, this.index, required this.callBack})
      : super(key: key);

  String? value;
  final int? index;
  final Function callBack;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  int? gameArrayIndex;
  bool checked = false;
  String? value;

  @override
  void initState() {
    super.initState();
    gameArrayIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    value = widget.value;

    return GestureDetector(
      onTap: () {
        setState(() {
          checked = true;
          print(gameArrayIndex);
          widget.callBack(gameArrayIndex);
          //voidCallBack update gameArray;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: gameArrayIndex == 0
              ? const BorderRadius.only(topLeft: Radius.circular(15))
              : gameArrayIndex == 2
                  ? const BorderRadius.only(topRight: Radius.circular(15))
                  : gameArrayIndex == 6
                      ? const BorderRadius.only(bottomLeft: Radius.circular(15))
                      : gameArrayIndex == 8
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(15))
                          : null,
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Text(value.toString() == "null"
            ? ""
            : value.toString() == "0"
                ? "O"
                : "X",
        style: TextStyle(
          fontFamily: "QuicksandRegular",
          fontSize: 25,
          fontWeight: FontWeight.w500
        ),),
      ),
    );
  }
}
