import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';
import 'button.dart';
import 'doc_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String input = "";
  String result = "0";

  void onButtonClick(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "0";
      } else if (value == "=") {
        try {
          if (input.contains("%")) {
            result = calculatePercentage(input);
          } else {
            result = evalExpression(input);
          }
        } catch (e) {
          result = "Ошибка";
        }
      } else if (value == "ln") {
        try {
          double num = double.parse(input);
          result = log(num).toStringAsFixed(6);
        } catch (e) {
          result = "Ошибка";
        }
      } else if (value == "π") {
        input += pi.toString();
      } else {
        input += value;
      }
    });
  }

  String evalExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      Parser parser = ShuntingYardParser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('π'), Number(pi));
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return eval.toString();
    } catch (e) {
      return "Ошибка";
    }
  }

  String calculatePercentage(String expression) {
    expression = expression.replaceAll(" ", "");

    RegExp regex = RegExp(r"(\d+)([\+\-\*/])(\d+)%");
    Match? match = regex.firstMatch(expression);

    if (match != null) {
      double base = double.parse(match.group(1)!);
      String operation = match.group(2)!;
      double percentage = double.parse(match.group(3)!) / 100;

      double result;
      if (operation == "+") {
        result = base + (base * percentage);
      } else if (operation == "-") {
        result = base - (base * percentage);
      } else {
        return "Ошибка";
      }
      return result.toString();
    }

    return "Ошибка";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 237),
      body: Column(
        children: [
          Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomRight, // Фиксируем текст справа внизу
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Чтобы длинные выражения скроллились
                      reverse: true, // Сначала показываем правую сторону
                      child: Text(
                        input,
                        style: TextStyle(fontSize: 32, color: Color.fromARGB(255, 46, 58, 72)),
                        textAlign: TextAlign.right, // Выравниваем текст вправо
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        result,
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.help_outline, size: 30, color: Colors.grey[700]),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DocumentationScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
          Expanded(
            flex: 3,
            child: Container(
              color: Color(0xFFC9BAFF),
              child: Column(
                children: [
                  buildRow(["π", "ln", "C", "/"]),
                  buildRow(["7", "8", "9", "×"]),
                  buildRow(["4", "5", "6", "-"]),
                  buildRow(["1", "2", "3", "+"]),
                  buildRow(["%", "0", ".", "="]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons
            .map((label) => CalculatorButton(
          label: label,
          onTap: () => onButtonClick(label),
          isOperation: ["C", "ln", "%", "÷", "×", "-", "+", "=", "π"].contains(label),
        ))
            .toList(),
      ),
    );
  }
}
