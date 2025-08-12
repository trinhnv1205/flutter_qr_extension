import 'package:flutter/material.dart';
import '../models/qr_config.dart';
import '../models/qr_templates.dart';
import '../services/qr_service.dart';
import '../services/qr_history_service.dart';
import '../widgets/qr_code_display.dart';
import '../widgets/color_selector.dart';
import '../widgets/template_selector.dart';
import '../widgets/history_section.dart';
import '../widgets/action_buttons.dart';
import '../color_list.dart';

/// Main QR code generator page
class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  late final TextEditingController _textController;
  late final FocusNode _textFocus;
  final GlobalKey _qrKey = GlobalKey();

  QRConfig _config = const QRConfig(
    text: '',
    colorIndex: 0,
    backgroundColorIndex: 0,
    size: 200.0,
  );

  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _config.text);
    _textFocus = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  void _updateConfig(QRConfig newConfig) {
    setState(() {
      _config = newConfig;
      _textController.text = newConfig.text;
      if (newConfig.text.isNotEmpty) {
        _history = QRHistoryService.addToHistory(_history, newConfig.text);
      }
    });
  }

  void _onTextChanged(String value) {
    _updateConfig(_config.copyWith(text: value));
  }

  void _onTemplateSelected(String templateName) {
    final template = QRTemplates.getTemplate(templateName);
    if (template != null) {
      _updateConfig(_config.copyWith(text: template));
    }
  }

  void _onHistoryItemSelected(String text) {
    _updateConfig(_config.copyWith(text: text));
  }

  void _onClearHistory() {
    setState(() {
      _history = QRHistoryService.clearHistory();
    });
  }

  Future<void> _onCopyToClipboard() async {
    final success = await QRService.copyToClipboard(_config.text);
    _showSnackBar(
        success ? 'Text copied to clipboard!' : 'Failed to copy text');
  }

  Future<void> _onDownloadQR() async {
    final success = await QRService.downloadQRCode(
      text: _config.text,
      colorIndex: _config.colorIndex,
      backgroundColorIndex: _config.backgroundColorIndex,
    );

    if (success) {
      _showSnackBar('QR Code downloaded successfully!');
    } else {
      _showSnackBar(_config.text.isEmpty
          ? 'Please enter text to generate QR code'
          : 'Error downloading QR code');
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
        QRCodeDisplay(
          data: _config.text,
          colorIndex: _config.colorIndex,
          backgroundColorIndex: _config.backgroundColorIndex,
          size: _config.size,
          repaintKey: _qrKey,
        ),
        _buildControlsSection(),
      ],
    );
  }

  Widget _buildExtensionLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          QRCodeDisplay(
            data: _config.text,
            colorIndex: _config.colorIndex,
            backgroundColorIndex: _config.backgroundColorIndex,
            size: _config.size,
            repaintKey: _qrKey,
          ),
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
          QRCodeDisplay(
            data: _config.text,
            colorIndex: _config.colorIndex,
            backgroundColorIndex: _config.backgroundColorIndex,
            size: _config.size,
            repaintKey: _qrKey,
          ),
          const SizedBox(height: 24),
          _buildControlsSection(),
        ],
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
            _buildTextField(),
            const SizedBox(height: 16),
            ActionButtons(
              onCopy: _onCopyToClipboard,
              onDownload: _onDownloadQR,
              templateSelector: TemplateSelector(
                onTemplateSelected: _onTemplateSelected,
                isCompact: false,
              ),
              isCompact: false,
            ),
            HistorySection(
              history: _history,
              onHistoryItemSelected: _onHistoryItemSelected,
              onClearHistory: _onClearHistory,
              isCompact: false,
            ),
            if (!isMobile) _buildSizeSlider(),
            const SizedBox(height: 24),
            ColorSelector(
              title: 'Choose QR Color',
              colors: qrColors,
              selectedIndex: _config.colorIndex,
              onColorSelected: (index) => _updateConfig(
                _config.copyWith(colorIndex: index),
              ),
            ),
            const SizedBox(height: 24),
            ColorSelector(
              title: 'Choose QR Background Color',
              colors: qrBackgroundColors,
              selectedIndex: _config.backgroundColorIndex,
              onColorSelected: (index) => _updateConfig(
                _config.copyWith(backgroundColorIndex: index),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(isCompact: true),
        const SizedBox(height: 12),
        ActionButtons(
          onCopy: _onCopyToClipboard,
          onDownload: _onDownloadQR,
          templateSelector: TemplateSelector(
            onTemplateSelected: _onTemplateSelected,
            isCompact: true,
          ),
          isCompact: true,
        ),
        HistorySection(
          history: _history,
          onHistoryItemSelected: _onHistoryItemSelected,
          onClearHistory: _onClearHistory,
          isCompact: true,
        ),
        const SizedBox(height: 16),
        ColorSelector(
          title: 'QR Color',
          colors: qrColors,
          selectedIndex: _config.colorIndex,
          onColorSelected: (index) => _updateConfig(
            _config.copyWith(colorIndex: index),
          ),
          itemSize: 16.0,
          spacing: 6.0,
        ),
        const SizedBox(height: 16),
        ColorSelector(
          title: 'Background Color',
          colors: qrBackgroundColors,
          selectedIndex: _config.backgroundColorIndex,
          onColorSelected: (index) => _updateConfig(
            _config.copyWith(backgroundColorIndex: index),
          ),
          itemSize: 16.0,
          spacing: 6.0,
        ),
      ],
    );
  }

  Widget _buildTextField({bool isCompact = false}) {
    return TextField(
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
      onChanged: _onTextChanged,
    );
  }

  Widget _buildSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                value: _config.size,
                min: 150.0,
                max: 400.0,
                divisions: 10,
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                onChanged: (value) => _updateConfig(
                  _config.copyWith(size: value),
                ),
              ),
            ),
            const Text('Large', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
