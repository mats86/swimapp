import 'package:flutter/material.dart';
import 'InputField.dart';

class InputCustomOpeningTime extends StatelessWidget {
  const InputCustomOpeningTime(
      {super.key,
      required this.controllerFrom,
      required this.controllerTo,
      required this.dayLabelText,
      this.inputTyp = "",
      this.confirmValue = "",
      this.maxLines = 1});
  final TextEditingController controllerFrom;
  final TextEditingController controllerTo;
  final String dayLabelText;
  final String inputTyp;
  final String confirmValue;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            dayLabelText,
            style: const TextStyle(
              fontSize: 16, // Passen Sie die Schriftgröße nach Bedarf an
              fontWeight: FontWeight.bold, // Fettgedruckt
              color: Colors.blue, // Ändern Sie die Textfarbe nach Bedarf
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: InputField(
            controller: controllerFrom,
            labelText: 'Von',
            // validatorText: 'Von'
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 4,
          child: InputField(
            controller: controllerTo,
            labelText: 'Bis',
            // validatorText: 'Bis'
          ),
        ),
      ],
    );
  }
}
