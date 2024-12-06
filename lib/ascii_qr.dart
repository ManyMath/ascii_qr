import 'package:qr/qr.dart';

class AsciiQrGenerator {
  /// Generates an ASCII QR code for the given [data].
  ///
  /// [errorCorrectLevel]: The error correction level (L, M, Q, H).
  /// [horizontalScale]: How many times to repeat each module horizontally.
  /// [verticalScale]: How many times to repeat each output line vertically.
  ///
  /// Each line of output uses half-block characters to represent two QR rows.
  /// Vertical scaling repeats these lines, visually stretching the code.
  ///
  /// Example:
  /// ```dart
  /// print(AsciiQrGenerator.generate("https://cypherstack.com/",
  ///   errorCorrectLevel: QrErrorCorrectLevel.H
  /// ));
  /// ```
  ///
  /// Example output:
  /// ███████████████████████████████
  /// █ ▄▄▄▄▄ █▄▀▀ ▀  █▀▄ █ █ ▄▄▄▄▄ █
  /// █ █   █ █▄█ ▀▄▄█▀ ▀▄▀▄█ █   █ █
  /// █ █▄▄▄█ █▄█▀  ▄ ▀▀ ▄▄ █ █▄▄▄█ █
  /// █▄▄▄▄▄▄▄█ ▀▄█▄█ █ █▄█▄█▄▄▄▄▄▄▄█
  /// █▀▀███▄▄▀▀██   ▀  █  ██▄▀ █ ▀▄█
  /// █▄▀▄█▄▀▄█ ██ ▄█▄▀ ▄█▀ ▄ ▄▀▀▄███
  /// █▀ ▄▄▄▄▄█ ▀▀▀▀▄ ▄ ██▀▀▄ █▀▀█ ▀█
  /// █  ▄▄ ▄▄ ██▀▄▄  ▀   ▀  ▄▄▀▀▀▀▀█
  /// █▀█▄█ ▄▄▄█ ▄█▄ ▄ ▄ █▀▀▄▀▀▀▄▄█▀█
  /// █ ▄▄█  ▄ █▄▄▄▀█  ▀▄▄ █▀▀█ ▀██▄█
  /// █▄████▄▄▄ ▄ █  ▀▀ ▀▀█ ▄▄▄   ▄▄█
  /// █ ▄▄▄▄▄ █▀▄▀▄█▀▀█ ▀█  █▄█ ▀████
  /// █ █   █ ██▄  ▀▄▀▀▄ ▄  ▄▄ ▄▀█ ██
  /// █ █▄▄▄█ ██   ▄▄▀▄▀  ▄▄ ▄▄ ▀▀▄▀█
  /// █▄▄▄▄▄▄▄██▄▄▄▄██▄██▄▄█▄▄█▄█▄███
  /// ███████████████████████████████
  static String generate(
    String data, {
    int errorCorrectLevel = QrErrorCorrectLevel.L,
    int horizontalScale = 1,
    int verticalScale = 1,
  }) {
    // Create QR code
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: errorCorrectLevel,
    );
    // Create the QR image matrix
    final qrImage = QrImage(qrCode);
    final moduleCount = qrImage.moduleCount;

    // Define the block characters.
    // In this scheme:
    // - 'WHITE_ALL' = ' ' (represents a dark module pair visually as empty space)
    // - 'BLACK_ALL' = '█'
    // - 'BLACK_WHITE' = '▀'
    // - 'WHITE_BLACK' = '▄'
    // The logic is inverted to show dark modules as spaces and light as blocks.
    const blocks = {
      'BLACK_ALL': '█', // full block
      'BLACK_WHITE': '▀', // top half block
      'WHITE_BLACK': '▄', // bottom half block
      'WHITE_ALL': ' ', // space
    };

    final buffer = StringBuffer();

    // Print top border
    final topBorder = List.filled(moduleCount + 2, blocks['BLACK_ALL']!)
        .map((b) => _repeatBlock(b, horizontalScale))
        .join();
    for (int vs = 0; vs < verticalScale; vs++) {
      buffer.writeln(topBorder);
    }

    // Process rows in pairs
    final pairCount = moduleCount ~/ 2; // Number of full pairs.
    for (var pair = 0; pair < pairCount; pair++) {
      final row = pair * 2;
      final lineBuffer = StringBuffer();
      // Left border
      lineBuffer.write(_repeatBlock(blocks['BLACK_ALL']!, horizontalScale));

      for (var col = 0; col < moduleCount; col++) {
        final topDark = qrImage.isDark(row, col);
        final bottomDark = qrImage.isDark(row + 1, col);

        final char = switch ((topDark, bottomDark)) {
          (true, true) => blocks['WHITE_ALL'], // Both dark.
          (true, false) => blocks['WHITE_BLACK'], // Top dark only.
          (false, true) => blocks['BLACK_WHITE'], // Bottom dark only.
          (false, false) => blocks['BLACK_ALL'], // Both light.
        };

        lineBuffer.write(_repeatBlock(char!, horizontalScale));
      }

      // Right border
      lineBuffer.write(_repeatBlock(blocks['BLACK_ALL']!, horizontalScale));

      final line = lineBuffer.toString();
      for (int vs = 0; vs < verticalScale; vs++) {
        buffer.writeln(line);
      }
    }

    // If there's an odd row out, handle the last row.
    if (moduleCount % 2 == 1) {
      final lastRow = moduleCount - 1;
      final lineBuffer = StringBuffer();
      // Left border
      lineBuffer.write(_repeatBlock(blocks['BLACK_ALL']!, horizontalScale));

      for (var col = 0; col < moduleCount; col++) {
        final dark = qrImage.isDark(lastRow, col);
        // For a single row, we treat it like the "top" row of a pair:
        // dark = topDark = true means use 'WHITE_BLACK' (lower block) to show
        //   top dark.
        // Actually, since there's no bottom row, let's represent a single row
        //   by using a character that shows the top row condition only:
        // If dark: top row dark, bottom row missing => use 'WHITE_BLACK' to
        //   indicate top dark.
        // If light: no dark => full block 'BLACK_ALL'.
        lineBuffer.write(_repeatBlock(
            dark ? blocks['WHITE_BLACK']! : blocks['BLACK_ALL']!,
            horizontalScale));
      }

      // Right border.
      lineBuffer.write(_repeatBlock(blocks['BLACK_ALL']!, horizontalScale));

      final line = lineBuffer.toString();
      for (int vs = 0; vs < verticalScale; vs++) {
        buffer.writeln(line);
      }
    }

    // Bottom border.
    final bottomBorder = List.filled(moduleCount + 2, blocks['BLACK_ALL']!)
        .map((b) => _repeatBlock(b, horizontalScale))
        .join();
    for (int vs = 0; vs < verticalScale; vs++) {
      buffer.writeln(bottomBorder);
    }

    return buffer.toString();
  }

  /// Repeat a single block [ch] horizontally [count] times.
  static String _repeatBlock(String ch, int count) {
    if (count <= 1) return ch;
    final sb = StringBuffer();
    for (int i = 0; i < count; i++) {
      sb.write(ch);
    }
    return sb.toString();
  }
}
