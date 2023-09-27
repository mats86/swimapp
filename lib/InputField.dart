import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  final GestureTapCallback? onTap;
  const InputField(
      {this.controller,
      this.labelText,
      this.onChanged,
      this.onSubmitted,
      this.errorText,
      this.keyboardType,
      this.textInputAction,
      this.autoFocus = false,
      this.obscureText = false,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          autofocus: autoFocus,
          onChanged: onChanged,
          // onSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          decoration: InputDecoration(
            label: FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  Text(
                    labelText!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  const Text('*',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            errorText: errorText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onTap: onTap,
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
