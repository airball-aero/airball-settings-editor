import 'package:flutter/material.dart';
import 'json_edit_widgets.dart';
import 'package:provider/provider.dart';

final String airballSettingsTitle = "Airball Settings";

void main() {
  runApp(AirballSettingsEditorApp());
}

class AirballSettingsEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: airballSettingsTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (context) =>
              JSONDocumentModel('http://localhost:8088/airball-settings.json'),
          child: AirballSettingsEditor()),
    );
  }
}

class AirballSettingsEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return AbsorbPointer(
      absorbing: false, // TODO: Add "disabled" state while loading
      child: Scaffold(
        appBar: AppBar(
          title: Text(airballSettingsTitle),
        ),
        body: Container(
          margin: EdgeInsets.all(pageMargin),
          child: Table(
            children: <TableRow>[
              editRow(
                  index++, _label('V', 'FE'), DoubleEditWidget('v_fe'), 'kias'),
              editRow(index++, _label('α', 'X'), DoubleEditWidget('alpha_x'),
                  'degrees'),
              editRow(index++, _label('β', 'FS'),
                  DoubleEditWidget('beta_full_scale'), 'degrees'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String param, String subs) {
    return RichText(
      text: TextSpan(
        text: param + ' ',
        style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
        children: <TextSpan>[
          TextSpan(
              text: subs,
              style: TextStyle(
                fontSize: 30,
              )),
        ],
      ),
    );
  }

  TableRow editRow(
      int idx, Widget label, JSONPropertyEditWidget widget, String units) {
    Color bgColor = stripe(idx);
    return TableRow(children: <Widget>[
      Container(
        height: rowHeight,
        padding: EdgeInsets.all(cellPadding),
        color: bgColor,
        child: label,
      ),
      Container(
        height: rowHeight,
        padding: EdgeInsets.all(cellPadding),
        color: bgColor,
        child: widget,
      ),
      Container(
        height: rowHeight,
        padding: EdgeInsets.all(cellPadding),
        color: bgColor,
        child: Text(units),
      ),
    ]);
  }

  Color stripe(int idx) {
    return (idx % 2 == 0) ? white : lightGreen;
  }

  static const double pageMargin = 20.0;
  static const double titleFontSize = 20.0;
  static const double rowHeight = 100.0;
  static const double cellPadding = 10.0;
  static const Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color lightGreen = Color.fromRGBO(225, 255, 225, 1.0);
}
