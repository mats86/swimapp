import 'package:flutter/material.dart';

class CustomerDetails extends StatelessWidget {
  final String data;
  const CustomerDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
