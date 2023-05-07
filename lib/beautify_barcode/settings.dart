
import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';

import 'barcode_conf.dart';
import 'settings_widgets.dart';

/// Settings widget
class Settings extends StatelessWidget {
  /// Manage the barcode settings
  const Settings({Key? key, required this.conf}) : super(key: key);

  /// Barcode configuration
  final BarcodeConf conf;

  @override
  Widget build(BuildContext context) {
    final types = <BarcodeType, String>{};
    for (var item in BarcodeType.values) {
      types[item] = Barcode.fromType(item).name;
    }

    return Column(
      children: <Widget>[
        DropdownPreference<BarcodeType>(
          title: 'Barcode Type',
          onRead: (context) => conf.type,
          onWrite: (context, dynamic value) => conf.type = value,
          values: types,
        ),
        TextPreference(
          title: 'Data',
          onRead: (context) => conf.data,
          onWrite: (context, value) => conf.data = value,
        )
      ],
    );
  }
}
