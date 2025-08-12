/// QR Code templates for quick generation
class QRTemplates {
  static const Map<String, String> templates = {
    'Website': 'https://example.com',
    'Email': 'mailto:someone@example.com',
    'Phone': 'tel:+1234567890',
    'SMS': 'sms:+1234567890',
    'WiFi': 'WIFI:T:WPA;S:NetworkName;P:Password;;',
    'Location': 'geo:37.7749,-122.4194',
    'WhatsApp': 'https://wa.me/1234567890',
    'Instagram': 'https://instagram.com/username',
    'LinkedIn': 'https://linkedin.com/in/username',
  };

  static List<String> get templateNames => templates.keys.toList();

  static String? getTemplate(String name) => templates[name];
}
