import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ClockPage extends StatefulWidget {
  final int fischer;
  final int main;

  const ClockPage({super.key, required this.main, required this.fischer});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late double firstPlayerClock;
  late double secondPlayerClock;
  late double main;
  late double fischer;

  late Timer timer;
  final FocusNode _focusNode = FocusNode();

  bool firstPlayerTurn = true;
  bool started = false;
  bool finished = false;
  bool paused = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    main = widget.main.toDouble();
    fischer = widget.fischer.toDouble();
    firstPlayerClock = (main * 60 + fischer).toDouble();
    secondPlayerClock = (main * 60 + fischer).toDouble();
  }

  void onClockPressed(bool firstButtonPressed) {
    if (finished) {
      return;
    }
    if (!started) {
      timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (firstPlayerTurn) {
          setState(() {
            firstPlayerClock -= 0.1;
            if (firstPlayerClock <= 0) {
              firstPlayerClock = 0;
              onTimeout();
            }
          });
        }
        else {
          setState(() {
            secondPlayerClock -= 0.1;
            if (secondPlayerClock <= 0) {
              secondPlayerClock = 0;
              onTimeout();
            }
          });
        }
      });
    }
    setState(() {
      if (firstButtonPressed & firstPlayerTurn) {
        firstPlayerClock += started ? fischer : 0;
        firstPlayerTurn = false;
      }
      else if (!firstButtonPressed & !firstPlayerTurn) {
        secondPlayerClock += started ? fischer : 0;
        firstPlayerTurn = true;
      }
      started = true;
      paused = false;
    });
  }

  void onTimeout() {
    timer.cancel();
    setState(() {
      finished = true;
      paused = true;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      return super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Format clocks
    var firstPlayerMins = (firstPlayerClock / 60).toInt().toString().padLeft(2, '0');
    var firstPlayerSecs = (firstPlayerClock % 60).toInt().toString().padLeft(2, '0');
    var secondPlayerMins = (secondPlayerClock / 60).toInt().toString().padLeft(2, '0');
    var secondPlayerSecs = (secondPlayerClock % 60).toInt().toString().padLeft(2, '0');

    // Set buttons background
    var primary = Theme.of(context).colorScheme.primary;
    var secondary = Theme.of(context).colorScheme.secondary;
    var firstButtonBackgroundColor = secondary;
    var secondButtonBackgroundColor = secondary;
    if (!finished) {
      if (started & firstPlayerTurn) {
        firstButtonBackgroundColor = primary;
        secondButtonBackgroundColor = secondary;
      }
      else if (started & !firstPlayerTurn) {
        firstButtonBackgroundColor = secondary;
        secondButtonBackgroundColor = primary;
      }
    }
    else {
      if (firstPlayerClock <= 0) {
        firstButtonBackgroundColor = Theme.of(context).colorScheme.error;
        secondButtonBackgroundColor = secondary;
      }
      else {
        firstButtonBackgroundColor = secondary;
        secondButtonBackgroundColor = Theme.of(context).colorScheme.error;
      }
    }

    return KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          onClockPressed(firstPlayerTurn);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Chess Clock", 
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: TextButton(
                      onPressed: () => onClockPressed(true),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(firstButtonBackgroundColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          )
                        )
                      ),
                      child: Text(
                        "$firstPlayerMins:$firstPlayerSecs",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 65,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: TextButton(
                      onPressed: () => onClockPressed(false),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(secondButtonBackgroundColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          )
                        )
                      ),
                      child: Text(
                        "$secondPlayerMins:$secondPlayerSecs",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 65,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          firstPlayerClock = (main * 60 + fischer).toDouble();
                          secondPlayerClock = (main * 60 + fischer).toDouble();
                          firstPlayerTurn = true;
                          started = false;
                          finished = false;
                          timer.cancel();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface
                      ),
                      child: Icon(
                        Icons.restart_alt_outlined, 
                        color: Theme.of(context).colorScheme.surface,
                      )
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  SizedBox(
                    height: 70,
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () {
                        paused = !paused;
                        if (paused) {
                          timer.cancel();
                          setState(() {
                            started = false;
                          });
                        }
                        else {
                          onClockPressed(!firstPlayerTurn);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface
                      ),
                      child: Icon(
                        paused ? Icons.play_arrow_outlined : Icons.pause_outlined,
                        color: Theme.of(context).colorScheme.surface,
                      )
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}