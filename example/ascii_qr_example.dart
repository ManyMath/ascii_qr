import 'package:ascii_qr/ascii_qr.dart';
import 'package:qr/qr.dart';

void main() {
  final qrCode = AsciiQrGenerator.generate('https://cypherstack.com/',
      errorCorrectLevel: QrErrorCorrectLevel.H);
  print(qrCode);
}
