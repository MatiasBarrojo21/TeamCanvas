import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      onChanged: (locale) {
        if (locale != null) {
          context.setLocale(locale);
        }
      },
      items: const [
        DropdownMenuItem(
          value: Locale('es'),
          child: Text('Español'),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
      ],
    );
  }
}
