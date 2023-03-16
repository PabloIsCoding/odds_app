import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OddsProbabilityConverter(),
    );
  }
}

class OddsProbabilityConverter extends StatefulWidget {
  @override
  _OddsProbabilityConverterState createState() =>
      _OddsProbabilityConverterState();
}

class _OddsProbabilityConverterState extends State<OddsProbabilityConverter> {
  TextEditingController _oddsAController = TextEditingController();
  TextEditingController _oddsBController = TextEditingController();
  TextEditingController _probabilityController = TextEditingController();
  TextEditingController _houseOddsAForController = TextEditingController();
  TextEditingController _houseOddsBForController = TextEditingController();
  TextEditingController _houseOddsAAgainstController = TextEditingController();
  TextEditingController _houseOddsBAgainstController = TextEditingController();
  String _optimalBetMessage = '';

  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }

  void _updateProbability() {
    if (_oddsAController.text.isNotEmpty && _oddsBController.text.isNotEmpty) {
      int oddsA = int.parse(_oddsAController.text);
      int oddsB = int.parse(_oddsBController.text);
      double probability = oddsA / (oddsA + oddsB);
      _probabilityController.text = (probability * 100).toStringAsFixed(2);
    }
  }

  void _updateOdds() {
    if (_probabilityController.text.isNotEmpty) {
      double probability = double.parse(_probabilityController.text) / 100;
      int a = (probability * 10000).round();
      int b = ((1 - probability) * 10000).round();
      int gcd = _gcd(a, b);
      _oddsAController.text = (a ~/ gcd).toString();
      _oddsBController.text = (b ~/ gcd).toString();
    }
  }

  void _calculateOptimalBet() {
    if (_houseOddsAForController.text.isNotEmpty &&
        _houseOddsBForController.text.isNotEmpty &&
        _houseOddsAAgainstController.text.isNotEmpty &&
        _houseOddsBAgainstController.text.isNotEmpty &&
        _probabilityController.text.isNotEmpty) {
      double probabilityA = double.parse(_probabilityController.text) / 100;
      double probabilityB = 1 - probabilityA;
      double houseOddsAFor = double.parse(_houseOddsAForController.text);
      double houseOddsBFor = double.parse(_houseOddsBForController.text);
      double houseOddsAAgainst =
          double.parse(_houseOddsAAgainstController.text);
      double houseOddsBAgainst =
          double.parse(_houseOddsBAgainstController.text);

      double payoffFor = (houseOddsBFor / houseOddsAFor);
      double payoffAgainst = (houseOddsAAgainst / houseOddsBAgainst);
      double expectedGainFor = probabilityA * payoffFor - (1 - probabilityA);
      double expectedGainAgainst =
          (1 - probabilityA) * payoffAgainst - probabilityA;

      if (expectedGainFor > expectedGainAgainst) {
        _optimalBetMessage =
            'Given your probabilities and the quotes from the betting house, your optimal bet is for the event, which will have an expected gain of ${expectedGainFor.toStringAsFixed(2)}';
        double kellyFraction = probabilityA - probabilityB / payoffFor;
        _optimalBetMessage +=
            ', and you should bet ${kellyFraction.toStringAsFixed(2)} fraction of your bankroll.';
      } else {
        _optimalBetMessage =
            'Given your probabilities and the quotes from the betting house, your optimal bet is against the event, which will have an expected gain of ${expectedGainAgainst.toStringAsFixed(2)}';
        double kellyFraction = probabilityB - probabilityA / payoffAgainst;
        _optimalBetMessage +=
            ', and you should bet ${kellyFraction.toStringAsFixed(2)} fraction of your bankroll.';
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odds Probability Converter'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _oddsAController,
                    decoration: InputDecoration(labelText: 'User Odds A'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateProbability(),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextFormField(
                    controller: _oddsBController,
                    decoration: InputDecoration(labelText: 'User Odds B'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateProbability(),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _probabilityController,
              decoration:
                  InputDecoration(labelText: 'User probability for event'),
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateOdds(),
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _houseOddsAForController,
                    decoration:
                        InputDecoration(labelText: 'House odds A for event'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateOptimalBet(),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextFormField(
                    controller: _houseOddsBForController,
                    decoration:
                        InputDecoration(labelText: 'House odds B for event'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateOptimalBet(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _houseOddsAAgainstController,
                    decoration: InputDecoration(
                        labelText: 'House odds A against event'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateOptimalBet(),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: TextFormField(
                    controller: _houseOddsBAgainstController,
                    decoration: InputDecoration(
                        labelText: 'House odds B against event'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _calculateOptimalBet(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              _optimalBetMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
