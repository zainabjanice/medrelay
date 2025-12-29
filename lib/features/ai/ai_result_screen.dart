import 'package:flutter/material.dart';

class AIResultScreen extends StatelessWidget {
  final String risk;
  final String specialist;

  const AIResultScreen({
    super.key,
    required this.risk,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Recommendation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Risk Level: $risk", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(
              "Recommended Specialist: $specialist",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Transfer Patient"),
            ),
          ],
        ),
      ),
    );
  }
}
