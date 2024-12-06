# ascii_qr
Generate QR codes as ASCII art in your terminal.

This package creates scannable QR codes using Unicode block characters, making 
them work well in monospace terminal fonts while maintaining proper proportions.

## Installation
Add this package to your Dart project with:
```bash
dart pub add ascii_qr
```

Or add it to your `pubspec.yaml` manually:
```yaml
dependencies:
  ascii_qr: ^1.0.1
```

## Usage
The package provides a simple interface through the `AsciiQrGenerator` class:
```dart
import 'package:ascii_qr/ascii_qr.dart';

void main() {
  print(AsciiQrGenerator.generate(
    'https://cypherstack.com/',
    errorCorrectLevel: QrErrorCorrectLevel.H,
  ));
}
```

This produces a scannable QR code in your terminal:
```
███████████████████████████████
█ ▄▄▄▄▄ █▄▀▀ ▀  █▀▄ █ █ ▄▄▄▄▄ █
█ █   █ █▄█ ▀▄▄█▀ ▀▄▀▄█ █   █ █
█ █▄▄▄█ █▄█▀  ▄ ▀▀ ▄▄ █ █▄▄▄█ █
█▄▄▄▄▄▄▄█ ▀▄█▄█ █ █▄█▄█▄▄▄▄▄▄▄█
█▀▀███▄▄▀▀██   ▀  █  ██▄▀ █ ▀▄█
█▄▀▄█▄▀▄█ ██ ▄█▄▀ ▄█▀ ▄ ▄▀▀▄███
█▀ ▄▄▄▄▄█ ▀▀▀▀▄ ▄ ██▀▀▄ █▀▀█ ▀█
█  ▄▄ ▄▄ ██▀▄▄  ▀   ▀  ▄▄▀▀▀▀▀█
█▀█▄█ ▄▄▄█ ▄█▄ ▄ ▄ █▀▀▄▀▀▀▄▄█▀█
█ ▄▄█  ▄ █▄▄▄▀█  ▀▄▄ █▀▀█ ▀██▄█
█▄████▄▄▄ ▄ █  ▀▀ ▀▀█ ▄▄▄   ▄▄█
█ ▄▄▄▄▄ █▀▄▀▄█▀▀█ ▀█  █▄█ ▀████
█ █   █ ██▄  ▀▄▀▀▄ ▄  ▄▄ ▄▀█ ██
█ █▄▄▄█ ██   ▄▄▀▄▀  ▄▄ ▄▄ ▀▀▄▀█
█▄▄▄▄▄▄▄██▄▄▄▄██▄██▄▄█▄▄█▄█▄███
███████████████████████████████
```
## Configuration Options
The `generate` method accepts several parameters to customize the output:

```dart
String generate(
  String data, {
  int errorCorrectLevel = QrErrorCorrectLevel.L,
  int horizontalScale = 1,
  int verticalScale = 1,
})
```

`errorCorrectLevel` determines the QR code's error correction capability:
- `QrErrorCorrectLevel.L`: Recovers 7% of data
- `QrErrorCorrectLevel.M`: Recovers 15% of data
- `QrErrorCorrectLevel.Q`: Recovers 25% of data
- `QrErrorCorrectLevel.H`: Recovers 30% of data

`horizontalScale` and `verticalScale` let you adjust the QR code's aspect ratio 
to match your terminal's font metrics. Some terminals may need a 
`horizontalScale` of 2 to create properly square QR codes.

## How it works

The generator creates QR codes using Unicode block characters to represent pairs 
of modules vertically:
- Full block (█) for light modules
- Space ( ) for dark modules
- Upper half-block (▀) and lower half-block (▄) for mixed pairs

This approach creates compact, scannable QR codes that maintain proper 
proportions in most terminal fonts.

## License

MIT License.  See LICENSE file for details.
