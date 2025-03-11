import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';
import 'button.dart';

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
            result = calculatePercentage(input);  // Вычисление процентов
          } else {
            result = evalExpression(input);  // Вычисление выражения
          }
        } catch (e) {
          result = "Ошибка";
        }
      } else if (value == "ln") {
        try {
          double num = double.parse(input);
          result = log(num).toStringAsFixed(6);  // Натуральный логарифм
        } catch (e) {
          result = "Ошибка";
        }
      } else if (value == "π") {
        input += pi.toString();  // Вставляем число Пи в выражение
      } else {
        input += value;
      }
    });
  }

  /// Функция вычисления выражения
  String evalExpression(String expression) {
    try {
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      Parser parser = ShuntingYardParser();
      Expression exp = parser.parse(expression);
      ContextModel cm = ContextModel();
      cm.bindVariable(Variable('π'), Number(pi));  // Добавляем переменную π
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      return eval.toString();
    } catch (e) {
      return "Ошибка";
    }
  }

  /// Функция вычисления процентов (например, 100 + 30% = 130)
  String calculatePercentage(String expression) {
    expression = expression.replaceAll(" ", ""); // Убираем пробелы

    // Обновленное регулярное выражение для обработки процентов
    RegExp regex = RegExp(r"(\d+)([\+\-\*/])(\d+)%");
    Match? match = regex.firstMatch(expression);

    if (match != null) {
      double base = double.parse(match.group(1)!); // Извлекаем первое число (например, 100)
      String operation = match.group(2)!; // Извлекаем операцию (+ или -)
      double percentage = double.parse(match.group(3)!) / 100; // Извлекаем число процента (например, 30 -> 0.30)

      double result;

      // В зависимости от операции выполняем соответствующие вычисления
      if (operation == "+") {
        result = base + (base * percentage); // Добавляем процент
      } else if (operation == "-") {
        result = base - (base * percentage); // Вычитаем процент
      } else {
        return "Ошибка"; // Если операция неизвестна
      }
      if (operation == null){
        // Просто выводим процент от числа
        return (base * percentage).toString(); // Например: 30% => 0.30
      }
      return result.toString(); // Возвращаем результат
    }

    return "Ошибка"; // Если формат выражения неверный
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 237),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: TextStyle(fontSize: 32, color: Color.fromARGB(255, 46, 58, 72)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    result,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
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

  /// Создаём строку кнопок
  Widget buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons
            .map((label) => CalculatorButton(
          label: label,
          onTap: () => onButtonClick(label),
          isOperation: ["C", "ln", "%", "÷", "×", "-", "+", "=", "π"]
              .contains(label),
        ))
            .toList(),
      ),
    );
  }
}
