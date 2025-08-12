import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

import 'color_list.dart';

class QRView extends StatefulWidget {
  const QRView({Key? key}) : super(key: key);

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  late final TextEditingController _textController;
  late final FocusNode _textFocus;
  final GlobalKey _qrKey = GlobalKey();
  String qrText = '';
  int qrColorIndex = 0;
  int qrBackgroundColorIndex = 0;
  double qrSize = 200.0;

  @override
  void initState() {
    _textController = TextEditingController(text: qrText);
    _textFocus = FocusNode();

    super.initState();
  }

  Future<void> _downloadQRCode() async {
    try {
      if (qrText.isEmpty) {
        _showSnackBar('Please enter text to generate QR code');
        return;
      }

      // Create QR painter with current settings
      final painter = QrPainter(
        data: qrText,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        color: qrColors[qrColorIndex],
        emptyColor: qrBackgroundColors[qrBackgroundColorIndex],
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

        _showSnackBar('QR Code downloaded successfully!');
      }
    } catch (e) {
      _showSnackBar('Error downloading QR code');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;
    final isExtensionPopup = screenWidth < 500 && screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isExtensionPopup ? 8.0 : (isMobile ? 12.0 : 16.0),
            vertical: isExtensionPopup ? 12.0 : (isMobile ? 16.0 : 24.0),
          ),
          child: isExtensionPopup
              ? _buildExtensionLayout()
              : (isMobile ? _buildMobileLayout() : _buildDesktopLayout()),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQRCodeSection(),
        _buildControlsSection(),
      ],
    );
  }

  Widget _buildExtensionLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildQRCodeSection(),
          const SizedBox(height: 16),
          _buildCompactControlsSection(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildQRCodeSection(),
          const SizedBox(height: 24),
          _buildControlsSection(),
        ],
      ),
    );
  }

  Widget _buildCompactControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          focusNode: _textFocus,
          decoration: InputDecoration(
            labelText: 'QR Text',
            labelStyle: const TextStyle(
              color: Color(0xFF80919F),
            ),
            hintText: 'Enter text / URL',
            hintStyle: const TextStyle(
              color: Color(0xFF80919F),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) => setState(() {
            qrText = value;
          }),
        ),
        const SizedBox(height: 16),
        const Text(
          'QR Color',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemCount: qrColors.length,
            itemBuilder: (context, index) {
              return InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => setState(() {
                  qrColorIndex = index;
                }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: qrColorIndex == index ? 19 : 18,
                      backgroundColor:
                          qrColorIndex == index ? Colors.black : Colors.black26,
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: qrColors[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Background Color',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemCount: qrBackgroundColors.length,
            itemBuilder: (context, index) {
              return InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => setState(() {
                  qrBackgroundColorIndex = index;
                }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: qrBackgroundColorIndex == index ? 19 : 18,
                      backgroundColor: qrBackgroundColorIndex == index
                          ? Colors.black
                          : Colors.black26,
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: qrBackgroundColors[index],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _downloadQRCode,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Download QR Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
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
      qrDisplaySize = qrSize;
    }

    return Container(
      width: isMobile ? double.infinity : null,
      alignment: isMobile ? Alignment.center : null,
      child: RepaintBoundary(
        key: _qrKey,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: qrDisplaySize.clamp(
                120.0, isExtensionPopup ? 200.0 : (isMobile ? 300.0 : 400.0)),
            height: qrDisplaySize.clamp(
                120.0, isExtensionPopup ? 200.0 : (isMobile ? 300.0 : 400.0)),
            child: QrImage(
              data: qrText,
              padding: EdgeInsets.all(isExtensionPopup ? 12 : 16),
              backgroundColor: qrBackgroundColors[qrBackgroundColorIndex],
              foregroundColor: qrColors[qrColorIndex],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlsSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Expanded(
      flex: isMobile ? 0 : 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 24.0,
          vertical: isMobile ? 0 : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              focusNode: _textFocus,
              decoration: InputDecoration(
                labelText: 'QR Text',
                labelStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                hintText: 'Enter text / URL',
                hintStyle: const TextStyle(
                  color: Color(0xFF80919F),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black54,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) => setState(() {
                qrText = value;
              }),
            ),
            if (!isMobile) ...[
              const SizedBox(height: 24),
              const Text(
                'QR Code Size',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Small', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: qrSize,
                      min: 150.0,
                      max: 400.0,
                      divisions: 10,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black26,
                      onChanged: (value) => setState(() {
                        qrSize = value;
                      }),
                    ),
                  ),
                  const Text('Large', style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Choose QR Color',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: qrColors.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => setState(() {
                      qrColorIndex = index;
                    }),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: qrColorIndex == index ? 23 : 22,
                          backgroundColor: qrColorIndex == index
                              ? Colors.black
                              : Colors.black26,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: qrColors[index],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose QR Background Color',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: qrBackgroundColors.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => setState(() {
                      qrBackgroundColorIndex = index;
                    }),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: qrBackgroundColorIndex == index ? 23 : 22,
                          backgroundColor: qrBackgroundColorIndex == index
                              ? Colors.black
                              : Colors.black26,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: qrBackgroundColors[index],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloadQRCode,
                icon: const Icon(Icons.download, size: 20),
                label: const Text('Download QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
