import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
