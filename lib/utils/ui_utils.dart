//Returns the priority color
import 'package:flutter/material.dart';

Color getPriorityColor(int priority) {
  switch (priority) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.yellow;
    default:
      return Colors.yellow;
  }
}

Icon getPriorityIcon(int priority) {
  switch (priority) {
    case 1:
      return const Icon(Icons.play_arrow);
    case 2:
      return const Icon(Icons.keyboard_arrow_right);
    default:
      return const Icon(Icons.keyboard_arrow_right);
  }
}
