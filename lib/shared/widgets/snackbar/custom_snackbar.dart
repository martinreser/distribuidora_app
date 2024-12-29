import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  info,
  warning,
}

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final colors = {
      SnackBarType.success: Colors.green,
      SnackBarType.error: Colors.red,
      SnackBarType.info: Colors.blue,
      SnackBarType.warning: Colors.orange,
    };

    final icons = {
      SnackBarType.success: Icons.check_circle,
      SnackBarType.error: Icons.error,
      SnackBarType.info: Icons.info,
      SnackBarType.warning: Icons.warning,
    };

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icons[type],
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: colors[type],
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
