import 'package:flutter/material.dart';
import '../services/qr_history_service.dart';

/// Widget for displaying QR code history
class HistorySection extends StatelessWidget {
  final List<String> history;
  final Function(String) onHistoryItemSelected;
  final VoidCallback onClearHistory;
  final bool isCompact;

  const HistorySection({
    Key? key,
    required this.history,
    required this.onHistoryItemSelected,
    required this.onClearHistory,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isCompact ? 12 : 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCompact ? 'Recent' : 'Recent QR Codes',
              style: TextStyle(
                color: Colors.black,
                fontSize: isCompact ? 14 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: onClearHistory,
              child: Text(
                isCompact ? 'Clear' : 'Clear All',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: isCompact ? 12 : 14,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isCompact ? 8 : 12),
        SizedBox(
          height: isCompact ? 30 : 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: isCompact ? 6 : 10),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final maxLength = isCompact ? 20 : 25;
              final displayText =
                  QRHistoryService.getDisplayText(item, maxLength: maxLength);

              return GestureDetector(
                onTap: () => onHistoryItemSelected(item),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 12,
                    vertical: isCompact ? 4 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(isCompact ? 6 : 10),
                    border:
                        isCompact ? null : Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    displayText,
                    style: TextStyle(fontSize: isCompact ? 11 : 13),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
