import 'package:flutter/material.dart';

class LoadingCircularProgressWidget extends StatelessWidget {
  const LoadingCircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100, //100
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), //50
          color: Theme.of(context).colorScheme.secondary,
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
