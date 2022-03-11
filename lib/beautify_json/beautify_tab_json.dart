
import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';

import 'beautify_json.dart';

class BeautifyTabJsonWidget extends StatefulWidget {

  const BeautifyTabJsonWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyTabJsonWidgetState();
  }

}

class _BeautifyTabJsonWidgetState extends State<BeautifyTabJsonWidget> {

  @override
  Widget build(BuildContext context) {
    TabbedViewController controller = TabbedViewController([]);
    int num = 1;
    TabbedView tabbedView = TabbedView(
        controller: controller,
        tabsAreaButtonsBuilder: (context, tabsCount) {
          List<TabButton> buttons = [];
          buttons.add(TabButton(
              icon: IconProvider.data(Icons.add),
              onPressed: () {
                num++;
                controller.addTab(TabData(text: 'tab_$num', content: const BeautifyJsonWidget()));
              }));
          if (tabsCount > 0) {
            buttons.add(TabButton(
                icon: IconProvider.data(Icons.delete),
                onPressed: () {
                  if (controller.selectedIndex != null) {
                    controller.removeTab(controller.selectedIndex!);
                  }
                }));
          }
          return buttons;
        });
    return tabbedView;
  }

}