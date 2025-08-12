import 'package:flutter/material.dart';
import '../models/qr_templates.dart';

/// Widget for displaying QR templates as a dropdown
class TemplateSelector extends StatelessWidget {
  final Function(String) onTemplateSelected;
  final bool isCompact;

  const TemplateSelector({
    Key? key,
    required this.onTemplateSelected,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onTemplateSelected,
      itemBuilder: (context) => QRTemplates.templateNames
          .map((name) => PopupMenuItem(
                value: name,
                child: Text(name),
              ))
          .toList(),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isCompact ? 8 : 12,
          horizontal: isCompact ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dashboard,
              size: isCompact ? 16 : 18,
              color: Colors.black,
            ),
            SizedBox(width: isCompact ? 4 : 8),
            Text(
              isCompact ? 'Templates' : 'Quick Templates',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
