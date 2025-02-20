import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_colors.dart';

class BuildContainerItemInDrawer extends StatelessWidget {
  const BuildContainerItemInDrawer({
    super.key,
    required this.onTapFunction,
    required this.icon,
    required this.label,
    this.color = AppColorsDarkTheme.greyAppColor,
  });

  final void Function() onTapFunction;
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColorsDarkTheme.greyLighterAppColor,
          ),
          title: Text(
            label,
            style: const TextStyle(color: AppColors.offWhiteAppColor),
          ),
        ),
      ),
    );
  }
}
