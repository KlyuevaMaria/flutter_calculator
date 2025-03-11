import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperation;

  const CalculatorButton({
    required this.label,
    required this.onTap,
    this.isOperation = false,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEAEBED),
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onTap,
              child: Text(
                label,
                style: TextStyle(fontSize: 24, color: label == "C" ? Color(0xFF937CE6) : Color(0xFF2E3A48)),
              ),
            ),
          ),
        );
  }
}