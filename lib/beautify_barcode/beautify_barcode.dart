
import 'package:beautify/beautify_barcode/barcode.dart';
import 'package:beautify/beautify_barcode/barcode_conf.dart';
import 'package:beautify/beautify_barcode/barcode_info.dart';
import 'package:beautify/beautify_barcode/settings.dart';
import 'package:flutter/material.dart';

class BeautifyBarcodeWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BeautifyBarcodeWidgetState();
  }

}

class _BeautifyBarcodeWidgetState extends State<BeautifyBarcodeWidget> {
  final BarcodeConf conf = BarcodeConf();

  @override
  void initState() {
    conf.addListener(confListener);
    super.initState();
  }

  @override
  void dispose() {
    conf.removeListener(confListener);
    super.dispose();
  }

  void confListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          Settings(conf: conf),
          BarcodeView(conf: conf),
          BarcodeInfo(conf: conf),
        ],

    );
  }
}