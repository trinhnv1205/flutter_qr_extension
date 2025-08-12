/// Service for managing QR code history
class QRHistoryService {
  static const int maxHistoryItems = 10;

  /// Adds text to history if not already present
  static List<String> addToHistory(List<String> currentHistory, String text) {
    if (text.isEmpty || currentHistory.contains(text)) {
      return currentHistory;
    }

    final newHistory = List<String>.from(currentHistory);
    newHistory.insert(0, text);

    if (newHistory.length > maxHistoryItems) {
      newHistory.removeLast();
    }

    return newHistory;
  }

  /// Clears all history
  static List<String> clearHistory() {
    return <String>[];
  }

  /// Gets display text for history item
  static String getDisplayText(String text, {int maxLength = 25}) {
    return text.length > maxLength
        ? '${text.substring(0, maxLength)}...'
        : text;
  }
}
