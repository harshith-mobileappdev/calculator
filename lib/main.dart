import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalculatorApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _displayedOutput = '0';
  String _currentInput = '';
  String _selectedOperator = '';
  double? A;
  double? B;

  void _onButtonPressed(String buttonValue) {
    setState(() {
      if (buttonValue == 'Clear') {
        _clearAll();
      } else if (_isOperator(buttonValue)) {
        _setOperator(buttonValue);
      } else if (buttonValue == '=') {
        _computeResult();
      } else {
        _appendInput(buttonValue);
      }
    });
  }

  void _clearAll() {
    _displayedOutput = '0';
    _currentInput = '';
    _selectedOperator = '';
    A = null;
    B = null;
  }

  void _setOperator(String operator) {
    if (_currentInput.isNotEmpty) {
      if (A != null && _selectedOperator.isNotEmpty) {
        _computeResult();
      } else {
        A = double.tryParse(_displayedOutput);
      }
      _selectedOperator = operator;
      _currentInput = '';
    }
  }

  void _appendInput(String value) {
    if (value == '.') {
      if (_currentInput.isEmpty) {
        _currentInput = '0.';
      } else if (!_currentInput.contains('.') &&
          _currentInput.split(' ').last.contains(RegExp(r'^\d+$'))) {
        _currentInput += value;
      }
    } else {
      if (_currentInput == '0' && value != '0') {
        _currentInput = value;
      } else {
        _currentInput += value;
      }
    }
    _displayedOutput = _currentInput;
  }

  void _computeResult() {
    if (A != null && _selectedOperator.isNotEmpty && _currentInput.isNotEmpty) {
      B = double.tryParse(_currentInput);
      double result = _performCalculation();
      _displayedOutput =
          result.isNaN || result.isInfinite ? 'Error' : result.toString();
      A = result;
      _currentInput = '';
      _selectedOperator = '';
      B = null;
    }
  }

  double _performCalculation() {
    switch (_selectedOperator) {
      case '+':
        return _add(A!, B!);
      case '-':
        return _subtract(A!, B!);
      case '*':
        return _multiply(A!, B!);
      case '/':
        return _divide(A!, B!);
      default:
        return 0;
    }
  }

  double _add(double a, double b) => a + b;
  double _subtract(double a, double b) => a - b;
  double _multiply(double a, double b) => a * b;
  double _divide(double a, double b) => b != 0 ? a / b : double.nan;

  bool _isOperator(String button) {
    return button == '+' || button == '-' || button == '*' || button == '/';
  }

  Widget _buildButton(String label,
      {Color? backgroundColor,
      Color textColor = Colors.black,
      bool hasBorder = false}) {
    return InkWell(
      onTap: () => _onButtonPressed(label),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade200,
          shape: BoxShape.circle,
          border: hasBorder ? Border.all(color: Colors.white, width: 2) : null,
        ),
        height: 140,
        width: 140,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 32,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              color: Colors.black,
              child: Text(
                _displayedOutput,
                style: const TextStyle(
                  fontSize: 120,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Buttons area
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the buttons vertically
              children: [
                _buildButtonRow(['7', '8', '9', '/']),
                _buildButtonRow(['4', '5', '6', '*']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['Clear', '0', '=', '+']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
        children: labels.map((label) {
          Color buttonColor;
          bool hasBorder = false;

          if (label == 'Clear') {
            buttonColor = Colors.red;
          } else if (label == '=') {
            buttonColor = Colors.green;
          } else if (_isOperator(label)) {
            buttonColor = Colors.lightBlue;
          } else {
            buttonColor = Colors.grey.shade800;
            hasBorder = true; // Only number buttons will have border
          }
          return Padding(
            padding:
                const EdgeInsets.all(4.0), // Reduced padding between buttons
            child: _buildButton(
              label,
              backgroundColor: buttonColor,
              textColor: Colors.white,
              hasBorder: hasBorder,
            ),
          );
        }).toList(),
      ),
    );
  }
}
