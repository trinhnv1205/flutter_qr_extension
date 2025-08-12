import 'package:flutter/material.dart';

/// Widget for selecting QR code colors
class ColorSelector extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final int selectedIndex;
  final Function(int) onColorSelected;
  final double itemSize;
  final double spacing;

  const ColorSelector({
    Key? key,
    required this.title,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
    this.itemSize = 20.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: itemSize > 18 ? 16 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: spacing),
        SizedBox(
          height: (itemSize + 6) * 2,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: spacing * 0.75),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => onColorSelected(index),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius:
                          selectedIndex == index ? itemSize + 3 : itemSize + 2,
                      backgroundColor: selectedIndex == index
                          ? Colors.black
                          : Colors.black26,
                    ),
                    CircleAvatar(
                      radius: itemSize,
                      backgroundColor: colors[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
