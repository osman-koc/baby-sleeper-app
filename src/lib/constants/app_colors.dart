import 'package:flutter/material.dart';

class AppColors {
  final BuildContext context;

  AppColors(this.context);

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get appGrey => Colors.grey;
  Color get appBlue => Colors.blue;
  Color get appRed => Colors.red;

  Color get dropdownButtonBg {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  Color get timerBg {
    return isDarkMode ? const Color.fromARGB(255, 49, 49, 49) : Colors.white;
  }

  Color get appDefaultBgColor {
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color get appDefaultTextColor {
    return isDarkMode ? Colors.black : Colors.white;
  }

  Color get timerButtonBg => const Color(0xFF415b6e); //Colors.blueGrey;
  Color get white => Colors.white;
}

class AppPlatte {
  static Map<int, Color> buttonBgColors = {
    50: const Color(0xFF58768b),
    100: const Color(0xFF4e6b80),
    200: const Color(0xFF415b6e),
    300: const Color(0xFF344b5c),
    400: const Color(0xFF273947),
    500: const Color(0xFF1c2b36),
    600: const Color(0xFF121c24),
    700: const Color(0xFF090e12),
    800: const Color(0xFF030608),
    900: const Color(0xFF000000),
  };
}
