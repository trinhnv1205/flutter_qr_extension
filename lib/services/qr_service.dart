import 'dart:html' as html;
import 'package:qr_flutter/qr_flutter.dart';
import '../color_list.dart';

/// Service for handling QR code operations
class QRService {
  /// Downloads QR code as PNG image
  static Future<bool> downloadQRCode({
    required String text,
    required int colorIndex,
    required int backgroundColorIndex,
  }) async {
    try {
      if (text.isEmpty) return false;

      // Create QR painter with current settings
      final painter = QrPainter(
        data: text,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        color: qrColors[colorIndex],
        emptyColor: qrBackgroundColors[backgroundColorIndex],
      );

      // Convert to image data
      final picData = await painter.toImageData(300);
      if (picData != null) {
        final bytes = picData.buffer.asUint8List();

        // Create download for web
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'qr_code.png';
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Copies text to clipboard
  static Future<bool> copyToClipboard(String text) async {
    if (text.isEmpty) return false;

    try {
      await html.window.navigator.clipboard?.writeText(text);
      return true;
    } catch (e) {
      return false;
    }
  }
}
