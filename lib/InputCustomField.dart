import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class InputCustomField extends StatelessWidget {
  const InputCustomField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.validatorText,
      this.inputTyp = "",
      this.confirmValue = "",
      this.maxLines = 1});
  final String labelText;
  final TextEditingController controller;
  final String validatorText;
  final String inputTyp;
  final String confirmValue;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE0E0E0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            label: FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  Text(labelText),
                  const Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          enableInteractiveSelection: inputTyp == "email" ? false : true,
          keyboardType:
              inputTyp == "number" ? TextInputType.phone : TextInputType.text,
          validator: (value) {
            if (inputTyp == "email" && !EmailValidator.validate(value!)) {
              return "Please enter a valid email";
            } else if (inputTyp == "emailConfirm" && value != confirmValue) {
              return validatorText;
            } else {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
            }
            return null;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
