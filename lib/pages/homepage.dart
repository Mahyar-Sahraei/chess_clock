import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'clockpage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mainFieldController = TextEditingController();
  final fischerFieldController = TextEditingController();
  bool _mainValidated = true;
  bool _fischerValidated = true;

  @override
  void dispose() {
    mainFieldController.dispose();
    fischerFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(
              height: 200,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  if (mainFieldController.text.isEmpty | fischerFieldController.text.isEmpty) {
                    setState(() {
                      if (mainFieldController.text.isEmpty) {
                        _mainValidated = false;
                      }
                      else {
                        _mainValidated = true;
                      }
                      if (fischerFieldController.text.isEmpty) {
                        _fischerValidated = false;
                      }
                      else {
                        _fischerValidated = true;
                      }
                    });
                    return;
                  }
                  int main = int.parse(mainFieldController.text);
                  int fischer = int.parse(fischerFieldController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ClockPage(main: main, fischer: fischer))
                  );
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70.0),
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary)
                )
              ),
              child: Text(
                "Tap to start!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 30,
                  )
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.0,
                  width: 120.0,
                  child: TextFormField(
                    controller: mainFieldController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Main (min)',
                      errorText: _mainValidated ? null : 'This field must be non-empty',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  height: 100.0,
                  width: 120.0,
                  child: TextFormField(
                    controller: fischerFieldController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Ficsher (sec)',
                      errorText: _fischerValidated ? null : 'This field must be non-empty',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}