/// QR Code configuration and state model
class QRConfig {
  final String text;
  final int colorIndex;
  final int backgroundColorIndex;
  final double size;

  const QRConfig({
    required this.text,
    required this.colorIndex,
    required this.backgroundColorIndex,
    required this.size,
  });

  QRConfig copyWith({
    String? text,
    int? colorIndex,
    int? backgroundColorIndex,
    double? size,
  }) {
    return QRConfig(
      text: text ?? this.text,
      colorIndex: colorIndex ?? this.colorIndex,
      backgroundColorIndex: backgroundColorIndex ?? this.backgroundColorIndex,
      size: size ?? this.size,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QRConfig &&
        other.text == text &&
        other.colorIndex == colorIndex &&
        other.backgroundColorIndex == backgroundColorIndex &&
        other.size == size;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        colorIndex.hashCode ^
        backgroundColorIndex.hashCode ^
        size.hashCode;
  }
}
