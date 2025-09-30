import 'package:flutter/material.dart';

class SortChip extends StatelessWidget {
  const SortChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('#', style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(width: 4),
          Icon(Icons.arrow_downward, size: 16),
        ],
      ),
    );
  }
}
