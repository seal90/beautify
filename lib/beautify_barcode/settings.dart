
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

    final generateOrParses = <GenerateOrParse, String>{};
    for (var item in GenerateOrParse.values) {
      generateOrParses[item] = item.name;
    }

    return Column(
      children: <Widget>[
        DropdownPreference<GenerateOrParse>(
          title: 'Generate or Parse',
          onRead: (context) => conf.generateOrParse,
          onWrite: (context, dynamic value) => conf.generateOrParse = value,
          values: generateOrParses,
        ),
        DropdownPreference<BarcodeType>(
          title: 'Barcode Type',
          onRead: (context) => conf.type,
          onWrite: (context, dynamic value) => conf.type = value,
          values: types,
        ),
        conf.generateOrParse == GenerateOrParse.generate ? TextPreference(
          title: 'Data',
          onRead: (context) => conf.data,
          onWrite: (context, value) => conf.data = value,
        ) : const Text('')
      ],
    );
  }
}
