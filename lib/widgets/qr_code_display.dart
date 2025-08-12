import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../color_list.dart';

/// Widget for displaying QR code with responsive sizing
class QRCodeDisplay extends StatelessWidget {
  final String data;
  final int colorIndex;
  final int backgroundColorIndex;
  final double size;
  final GlobalKey? repaintKey;

  const QRCodeDisplay({
    Key? key,
    required this.data,
    required this.colorIndex,
    required this.backgroundColorIndex,
    required this.size,
    this.repaintKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isExtensionPopup = screenWidth < 500 && screenHeight < 700;

    double qrDisplaySize;
    if (isExtensionPopup) {
      qrDisplaySize = (screenWidth * 0.75).clamp(120.0, 200.0);
    } else if (isMobile) {
      qrDisplaySize = screenWidth * 0.8;
    } else {
      qrDisplaySize = size;
    }

    return Container(
      width: isMobile ? double.infinity : null,
      alignment: isMobile ? Alignment.center : null,
      child: RepaintBoundary(
        key: repaintKey,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: qrDisplaySize.clamp(
                120.0, isExtensionPopup ? 200.0 : (isMobile ? 300.0 : 400.0)),
            height: qrDisplaySize.clamp(
                120.0, isExtensionPopup ? 200.0 : (isMobile ? 300.0 : 400.0)),
            child: QrImage(
              data: data,
              padding: EdgeInsets.all(isExtensionPopup ? 12 : 16),
              backgroundColor: qrBackgroundColors[backgroundColorIndex],
              foregroundColor: qrColors[colorIndex],
            ),
          ),
        ),
      ),
    );
  }
}
