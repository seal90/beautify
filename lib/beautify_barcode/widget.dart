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

import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:beautify/beautify_barcode/barcode_conf.dart';
import 'package:buffer_image/buffer_image.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/multi.dart';
import 'package:zxing_lib/zxing.dart';

import 'painter.dart';

class BarcodeParseWidget extends StatefulWidget {

  BarcodeParseWidget({Key? key, required this.conf});

  final BarcodeConf conf;

  @override
  State<StatefulWidget> createState() {
    return _BarcodeParseWidgetState();
  }
}

class _BarcodeParseWidgetState extends State<BarcodeParseWidget> {

  @override
  Widget build(BuildContext context) {
    BarcodeParseData? barcodeParseData = widget.conf.barcodeParseData;
    barcodeParseData = barcodeParseData?? BarcodeParseData();
    return Column(children: [
      Row(children: [
          const Text("Parsed value is:"),
          Text(barcodeParseData.parseErrInfo, style: const TextStyle(color: Colors.red),)
        ],
      ),
      Column(
        children: barcodeParseData.parsedText.map((e){
          return Row(children: [
            IconButton(
                hoverColor: Colors.transparent,
                onPressed: (){Clipboard.setData(ClipboardData(text: e));},
                icon: const Icon(Icons.copy)),
            Expanded(child:
            SelectableText(
              e,
              // style: TextStyle(overflow: TextOverflow.ellipsis),
              maxLines: 1,
              scrollPhysics: const AlwaysScrollableScrollPhysics(),
            ))
          ],);
        }).toList(),
      ),
      ElevatedButton(
        child: const Text("选择图片"),
        onPressed: selectImage,
      ),

      SizedBox(
        width: 500,
        height: 500,
        child: barcodeParseData.image,),
    ],);
  }

  void selectImage() async {

    setState(() {
      widget.conf.barcodeParseData = BarcodeParseData();
    });

    XTypeGroup typeGroup = const XTypeGroup(
      label: 'Image',
      extensions: <String>['jpg', 'jpeg', 'png', 'svg'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
      // initialDirectory: initialDirectory,
    );
    if (file == null) {
      // Operation was canceled by the user.
      return;
    }


    Uint8List imageBytes = await file.readAsBytes();
    setState(() {
      BarcodeParseData? barcodeParseData = widget.conf.barcodeParseData;
      if(null == barcodeParseData) {
        widget.conf.barcodeParseData = BarcodeParseData();
      }
      widget.conf.barcodeParseData!.image = Image.memory(imageBytes);
    });

    BufferImage? image = await BufferImage.fromFile(imageBytes);
    if (image == null) {
      return;
    }
    int imageWidth = image.width;
    int imageHeight = image.height;
    final pixels = Uint8List(imageWidth * imageHeight);
    for (int i = 0; i < pixels.length; i++) {
      pixels[i] = getLuminanceSourcePixel(image.buffer, i * 4);
    }

    final imageSource = RGBLuminanceSource.orig(
      imageWidth,
      imageHeight,
      pixels,
    );

    final bitmap = BinaryBitmap(HybridBinarizer(imageSource));

    final reader = GenericMultipleBarcodeReader(MultiFormatReader());
    Map<DecodeHintType, Object>? hints = {DecodeHintType.POSSIBLE_FORMATS:[BarcodeFormat.QR_CODE]};
    try {
      var results = reader.decodeMultiple(
        bitmap,
        hints,
      );

      List<String> parsedText = [];
      for (var element in results) {
        parsedText.add(element.text);
      }
      setState(() {
        BarcodeParseData? barcodeParseData = widget.conf.barcodeParseData;
        if(null == barcodeParseData) {
          widget.conf.barcodeParseData = BarcodeParseData();
        }
        widget.conf.barcodeParseData!.parsedText = parsedText;
      });

    } on Exception catch (e) {
      setState(() {
        BarcodeParseData? barcodeParseData = widget.conf.barcodeParseData;
        if(null == barcodeParseData) {
          widget.conf.barcodeParseData = BarcodeParseData();
        }
        widget.conf.barcodeParseData!.parseErrInfo = e.toString();
      });
    }

    // Print the decoded text
  }

}

int getLuminanceSourcePixel(List<int> byte, int index) {
  if (byte.length <= index + 3) {
    return 0xff;
  }
  final r = byte[index] & 0xff; // red
  final g2 = (byte[index + 1] << 1) & 0x1fe; // 2 * green
  final b = byte[index + 2]; // blue
  // Calculate green-favouring average cheaply
  return ((r + g2 + b) ~/ 4);
}

/// Error builder callback
typedef BarcodeErrorBuilder = Widget Function(
    BuildContext context, String error);

/// Flutter widget to draw a [Barcode] on screen.
class BarcodeWidget extends StatelessWidget {
  /// Draw a barcode on screen
  const BarcodeWidget({
    Key? key,
    required String data,
    required this.barcode,
    this.color = Colors.black,
    this.backgroundColor,
    this.decoration,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.drawText = true,
    this.style,
    this.textPadding = 5,
    this.errorBuilder,
  })  : _dataBytes = null,
        _dataString = data,
        super(key: key);

  /// Draw a barcode on screen using Uint8List data
  const BarcodeWidget.fromBytes({
    Key? key,
    required Uint8List data,
    required this.barcode,
    this.color = Colors.black,
    this.backgroundColor,
    this.decoration,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.drawText = true,
    this.style,
    this.textPadding = 5,
    this.errorBuilder,
  })  : _dataBytes = data,
        _dataString = null,
        super(key: key);

  /// The barcode data to display
  final Uint8List? _dataBytes;
  final String? _dataString;
  Uint8List get data => _dataBytes ?? utf8.encoder.convert(_dataString!);

  /// Is this raw bytes
  bool get isBytes => _dataBytes != null;

  /// The type of barcode to use.
  /// use:
  ///   * Barcode.code128()
  ///   * Barcode.ean13()
  ///   * ...
  final Barcode barcode;

  /// The bars color
  /// should be black or really dark color
  final Color color;

  /// The background color.
  /// this should be white or really light color
  final Color? backgroundColor;

  /// Padding to apply
  final EdgeInsetsGeometry? padding;

  /// Margin to apply
  final EdgeInsetsGeometry? margin;

  /// Width of the barcode with padding
  final double? width;

  /// Height of the barcode with padding
  final double? height;

  /// Whether to draw the text with the barcode
  final bool drawText;

  /// Text style to use to draw the text
  final TextStyle? style;

  /// Padding to add between the text and the barcode
  final double textPadding;

  /// Decoration to apply to the barcode
  final Decoration? decoration;

  /// Displays a custom widget in case of error with the barcode.
  final BarcodeErrorBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }

    Widget child = isBytes
        ? BarcodePainter.fromBytes(
            _dataBytes,
            barcode,
            color,
            drawText,
            effectiveTextStyle,
            textPadding,
          )
        : BarcodePainter(
            _dataString,
            barcode,
            color,
            drawText,
            effectiveTextStyle,
            textPadding,
          );

    if (errorBuilder != null) {
      try {
        if (isBytes) {
          barcode.verifyBytes(_dataBytes!);
        } else {
          barcode.verify(_dataString!);
        }
      } catch (e) {
        child = errorBuilder!(context, e.toString());
      }
    }

    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }

    if (decoration != null) {
      child = DecoratedBox(
        decoration: decoration!,
        child: child,
      );
    } else if (backgroundColor != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: child,
      );
    }

    if (width != null || height != null) {
      child = SizedBox(width: width, height: height, child: child);
    }

    if (margin != null) {
      child = Padding(padding: margin!, child: child);
    }

    return child;
  }
}
