/*
 * Copyright (C) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:barcode/barcode.dart';
import 'package:beautify/beautify_barcode/widget.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:image/image.dart';
import 'dart:typed_data';

import 'barcode_conf.dart';
import 'barcode_error.dart';
import 'download.dart';

class BarcodeView extends StatelessWidget {
  const BarcodeView({
    Key? key,
    required this.conf,
  }) : super(key: key);

  final BarcodeConf conf;

  @override
  Widget build(BuildContext context) {
    try {
      conf.barcode.verify(conf.normalizedData);
    } on BarcodeException catch (error) {
      return BarcodeError(message: error.message);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Card(
          child: Column(
            children: [
              BarcodeWidget(
                barcode: conf.barcode,
                data: conf.normalizedData,
                width: conf.width,
                height: conf.height,
                style: TextStyle(
                  fontSize: conf.fontSize,
                  color: Colors.black,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Download(conf: conf),
            ],
          ),
        ),
      ),
    );
  }
}


/// Store the width and height of a rendered text
class BitmapFontMetrics {
  /// Create a BitmapFontMetrics structure
  const BitmapFontMetrics(this.width, this.height);

  /// The width of the text in pixels
  final int width;

  /// The height of the text in pixels
  final int height;
}

/// Extension on BitmapFont to add metrics calculation
extension BitmapFontMetricsFunctions on BitmapFont {
  /// Calculate the width and height in pixels of a text string
  BitmapFontMetrics getMetrics(String string) {
    if (string.isEmpty) {
      return const BitmapFontMetrics(0, 0);
    }

    var width = 0;
    var height = 0;
    final cu = string.codeUnits;

    for (var c in cu.sublist(0, cu.length - 1)) {
      if (!characters.containsKey(c)) {
        continue;
      }

      final ch = characters[c]!;
      width += ch.xadvance;
      if (height < ch.height + ch.yoffset) {
        height = ch.height + ch.yoffset;
      }
    }

    final c = cu.last;
    if (characters.containsKey(c)) {
      final ch = characters[c]!;
      width += ch.width;
      if (height < ch.height + ch.yoffset) {
        height = ch.height + ch.yoffset;
      }
    }

    return BitmapFontMetrics(width, height);
  }
}

/// Create a Barcode
void drawBarcode(
    im.Image image,
    Barcode barcode,
    String data, {
      int x = 0,
      int y = 0,
      int? width,
      int? height,
      BitmapFont? font,
      int? textPadding,
      int color = 0xff000000,
    }) {
  width ??= image.width;
  height ??= image.height;
  textPadding ??= 0;

  final recipe = barcode.make(
    data,
    width: width.toDouble(),
    height: height.toDouble(),
    drawText: font != null,
    fontHeight: font?.lineHeight.toDouble(),
    textPadding: textPadding.toDouble(),
  );

  _drawBarcode(image, recipe, x, y, font, color);
}

/// Create a Barcode
void drawBarcodeBytes(
    im.Image image,
    Barcode barcode,
    Uint8List bytes, {
      int x = 0,
      int y = 0,
      int? width,
      int? height,
      BitmapFont? font,
      int? textPadding,
      int color = 0xff000000,
    }) {
  width ??= image.width;
  height ??= image.height;
  textPadding ??= 0;

  final recipe = barcode.makeBytes(
    bytes,
    width: width.toDouble(),
    height: height.toDouble(),
    drawText: font != null,
    fontHeight: font?.lineHeight.toDouble(),
    textPadding: textPadding.toDouble(),
  );

  _drawBarcode(image, recipe, x, y, font, color);
}

void _drawBarcode(
    im.Image image,
    Iterable<BarcodeElement> recipe,
    int x,
    int y,
    BitmapFont? font,
    int color,
    ) {
  // Draw the barcode
  for (var elem in recipe) {
    if (elem is BarcodeBar) {
      if (elem.black) {
        // Draw one black bar
        fillRect(
          image,
          (x + elem.left).round(),
          (y + elem.top).round(),
          (x + elem.right).round(),
          (y + elem.bottom).round(),
          color,
        );
      }
    } else if (elem is BarcodeText) {
      // Get string dimensions
      final metrics = font!.getMetrics(elem.text);
      final top = y + elem.top + elem.height - font.size;
      late double left;

      // Center the text
      switch (elem.align) {
        case BarcodeTextAlign.left:
          left = x + elem.left;
          break;
        case BarcodeTextAlign.center:
          left = x + elem.left + (elem.width - metrics.width) / 2;
          break;
        case BarcodeTextAlign.right:
          left = x + elem.left + elem.width - metrics.width;
          break;
      }

      // Draw some text using 14pt arial font
      drawString(
        image,
        font,
        left.round(),
        top.round(),
        elem.text,
        color: color,
      );
    }
  }
}