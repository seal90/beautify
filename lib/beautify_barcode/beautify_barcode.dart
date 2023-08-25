
import 'package:beautify/beautify_barcode/barcode.dart';
import 'package:beautify/beautify_barcode/barcode_conf.dart';
import 'package:beautify/beautify_barcode/barcode_info.dart';
import 'package:beautify/beautify_barcode/settings.dart';
import 'package:flutter/material.dart';

class BeautifyBarcodeWidget extends StatefulWidget {
  final BarcodeConf conf = BarcodeConf();
  @override
  State<StatefulWidget> createState() {
    return _BeautifyBarcodeWidgetState();
  }

}

class _BeautifyBarcodeWidgetState extends State<BeautifyBarcodeWidget> {


  @override
  void initState() {
    widget.conf.addListener(confListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.conf.removeListener(confListener);
    super.dispose();
  }

  void confListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          Settings(conf: widget.conf),
          BarcodeView(conf: widget.conf),
          BarcodeInfo(conf: widget.conf),
        ],

    );
  }
}