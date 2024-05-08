import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoundedButtonStyle extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool isEnable;
  final double verticalPadding;

  const RoundedButtonStyle({
    required this.text,
    required this.onTap,
    required this.isEnable,
    double? buttonVerticalPadding,
    super.key,
  }) : verticalPadding = buttonVerticalPadding ?? 10.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 32, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isEnable == true ? AppColor.primaryColor : Colors.green,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
