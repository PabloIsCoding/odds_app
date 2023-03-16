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
  TextEditingController _houseOddsAController = TextEditingController();
  TextEditingController _houseOddsBController = TextEditingController();
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
    if (_houseOddsAController.text.isNotEmpty &&
        _houseOddsBController.text.isNotEmpty &&
        _probabilityController.text.isNotEmpty) {
      double probabilityA = double.parse(_probabilityController.text) / 100;
      double probabilityB = 1 - probabilityA;
      double houseOddsA = double.parse(_houseOddsAController.text);
      double houseOddsB = double.parse(_houseOddsBController.text);

      double expectedGainA = probabilityA * houseOddsA - probabilityB;
      double expectedGainB = probabilityB * houseOddsB - probabilityA;

      if (expectedGainA > expectedGainB) {
        _optimalBetMessage =
            'Given your probabilities and the quotes from the betting house, your optimal bet is for A, which will have an expected gain of ${expectedGainA.toStringAsFixed(2)}';
      } else {
        _optimalBetMessage =
            'Given your probabilities and the quotes from the betting house, your optimal bet is against A, which will have an expected gain of ${expectedGainB.toStringAsFixed(2)}';
      }

      setState(() {});
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
        _calculateOptimalBet();
      },
    );
  }

  Widget _buildHouseOddsInput() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: _houseOddsAController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'House Odds A'),
            onChanged: (_) {
              _calculateOptimalBet();
            },
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          child: TextFormField(
            controller: _houseOddsBController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'House Odds B'),
            onChanged: (_) {
              _calculateOptimalBet();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptimalBetMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        _optimalBetMessage,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
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
            SizedBox(height: 16),
            _buildHouseOddsInput(),
            _buildOptimalBetMessage(),
          ],
        ),
      ),
    );
  }
}
