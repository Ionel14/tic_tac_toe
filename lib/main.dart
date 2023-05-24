import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _taps = 0;
  List<Color> _colors = List<Color>.generate(9, (int index) => Colors.white);
  bool _restartIsVisible = false;

  void _restartGame() {
    _colors = List<Color>.generate(9, (int index) => Colors.white);
    _taps = 0;
    _restartIsVisible = false;
  }

  bool _existWinner() {
    final List<bool> rows = <bool>[true, true, true];
    final List<bool> columns = <bool>[true, true, true];
    bool primaryDiagonal = true;
    bool secondaryDiagonal = true;
    Color winnerColor;
    int nrFailures = 0;

    for (int i = 0; i < 3; i++) {
      if (nrFailures >= 8) {
        break;
      }
      for (int j = 0; j < 3; j++) {
        //rows check
        if (rows[j]) {
          if (_colors[i + 3 * j] != Colors.white) {
            if (i != 0 && _colors[i + 3 * j] != _colors[i + 3 * j - 1]) {
              rows[j] = false;
              nrFailures++;
            }
          } else {
            rows[j] = false;
            nrFailures++;
          }
        }

        //columns check
        if (columns[j]) {
          if (_colors[3 * i + j] != Colors.white) {
            if (i != 0 && _colors[3 * i + j] != _colors[3 * (i - 1) + j]) {
              columns[j] = false;
              nrFailures++;
            }
          } else {
            columns[j] = false;
            nrFailures++;
          }
        }
      }

      //primary diagonal check
      if (primaryDiagonal) {

        if (_colors[i + i * 3] != Colors.white) {
          if (i != 0 && _colors[i + i * 3] != _colors[i - 1 + (i - 1) * 3]) {
            primaryDiagonal = false;
            nrFailures++;
          }
        } else {
          primaryDiagonal = false;
          nrFailures++;
        }
      }

      //secondary diagonal check
      if (secondaryDiagonal) {
        if (_colors[i * 3 + 3 - i - 1] != Colors.white) {
          if (i != 0 && _colors[i * 3 + 3 - i - 1] != _colors[(i - 1) * 3 + 3 - i]) {
            secondaryDiagonal = false;
            nrFailures++;
          }
        } else {
          secondaryDiagonal = false;
          nrFailures++;
        }
      }
    }

    if (nrFailures < 8) {
      if (primaryDiagonal || secondaryDiagonal || rows[1] || columns[1]) {
        winnerColor = _colors[4];
      } else if (rows[0] || columns[0]) {
        winnerColor = _colors[0];
      } else {
        winnerColor = _colors[8];
      }

      int index = rows.indexOf(true);
      _colors = List<Color>.generate(9, (int index) => Colors.white);
      if (index != -1) {
        _colors.fillRange(index * 3, (index + 1) * 3, winnerColor);
        return true;
      }

      index = columns.indexOf(true);
      if (index != -1) {
        for (int i = 0; i < 3; i++) {
          _colors[index + i * 3] = winnerColor;
        }
        return true;
      }

      if (primaryDiagonal) {
        for (int i = 0; i < 3; i++) {
          _colors[i + i * 3] = winnerColor;
        }
        return true;
      }

      if (secondaryDiagonal) {
        for (int i = 0; i < 3; i++) {
          _colors[i * 3 + 3 - i - 1] = winnerColor;
        }
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(
          child: Text(
            'tic-tac-toe',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                children: List<Widget>.generate(9, (int index) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_restartIsVisible) {
                          return;
                        }
                        setState(() {
                          if (_colors[index] == Colors.white) {
                            _taps++;
                            if (_taps.isOdd) {
                              _colors[index] = Colors.blue;
                            } else {
                              _colors[index] = Colors.red;
                            }
                            if (!_colors.any((Color element) => element == Colors.white) ||
                                (_taps > 4 && _existWinner())) {
                              _restartIsVisible = true;
                            }
                          }
                        });
                      },
                      child: AnimatedContainer(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: _colors[index],
                        ),
                      ),
                    ),
                  );
                })),
          ),
          Visibility(
            visible: _restartIsVisible,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _restartGame();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
