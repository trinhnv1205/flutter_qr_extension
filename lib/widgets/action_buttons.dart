import 'package:flutter/material.dart';

/// Widget for action buttons (copy, download)
class ActionButtons extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onDownload;
  final Widget? templateSelector;
  final bool isCompact;

  const ActionButtons({
    Key? key,
    this.onCopy,
    this.onDownload,
    this.templateSelector,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onCopy != null && templateSelector != null) ...[
          Row(
            children: [
              Expanded(
                flex: isCompact ? 1 : 2,
                child: ElevatedButton.icon(
                  onPressed: onCopy,
                  icon: Icon(Icons.copy, size: isCompact ? 16 : 18),
                  label: Text(isCompact ? 'Copy' : 'Copy Text'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: isCompact ? 8 : 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: isCompact ? 8 : 12),
              Expanded(
                flex: isCompact ? 1 : 3,
                child: templateSelector!,
              ),
            ],
          ),
        ],
        if (onDownload != null) ...[
          SizedBox(height: isCompact ? 12 : 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onDownload,
              icon: Icon(Icons.download, size: isCompact ? 18 : 20),
              label: const Text('Download QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isCompact ? 12 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
