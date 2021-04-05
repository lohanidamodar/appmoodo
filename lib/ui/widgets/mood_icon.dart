import 'package:appmoodo/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MoodIcon extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final bool isExpanded;
  final bool isSelected;
  final String emoji;
  const MoodIcon({
    Key key,
    @required this.icon,
    this.onTap,
    this.isExpanded = false,
    this.isSelected = false,
    this.emoji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(
            child: _buildIcon(),
          )
        : _buildIcon();
  }

  Material _buildIcon() {
    return Material(
      shape: CircleBorder(),
      color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: AppColors.primaryColor,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 12.0,
          ),
          child: emoji != null ? Text(emoji, style: TextStyle(
            fontSize: 70,
          ),) :  SvgPicture.asset(
            icon,
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
