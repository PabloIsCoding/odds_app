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
  _OddsProbabilityConverterState createState() => _OddsProbabilityConverterState();
}

class _OddsProbabilityConverterState extends State<OddsProbabilityConverter> {
  TextEditingController _oddsAController = TextEditingController();
  TextEditingController _oddsBController = TextEditingController();
  TextEditingController _probabilityController = TextEditingController();

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
    int a = (probability*10000).round();
    int b = ((1-probability)*10000).round();
    //double oddsRatio = probability / (1 - probability);
    //int denominator = 10000;
    //int numerator = (oddsRatio * denominator).round();
    //int gcd = _gcd(numerator, denominator);
    //_oddsAController.text = (numerator ~/ gcd).toString();
    //_oddsBController.text = (denominator ~/ gcd).toString();
    int gcd = _gcd(a, b);
    _oddsAController.text = (a ~/ gcd).toString();
    _oddsBController.text = (b ~/ gcd).toString();
  }
}


  Widget _buildOddsInput() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: _oddsAController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Odds A'),
            onChanged: (_) {
              _updateProbability();
            },
          ),
        ),
        Text(' : '),
        Flexible(
          child: TextFormField(
            controller: _oddsBController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Odds B'),
            onChanged: (_) {
              _updateProbability();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProbabilityInput() {
    return TextFormField(
      controller: _probabilityController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Probability (%)'),
      onChanged: (_) {
        _updateOdds();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odds to Probability Converter'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOddsInput(),
            SizedBox(height: 16),
            _buildProbabilityInput(),
          ],
        ),
      ),
    );
  }
}
