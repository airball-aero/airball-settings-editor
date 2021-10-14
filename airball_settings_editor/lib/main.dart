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
          create: (context) => JSONDocumentModel('/settings'),
          child: AirballSettingsEditor()),
    );
  }
}

class AirballSettingsEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(builder: (context, model, child) {
      return AbsorbPointer(
        absorbing: false /* !model.initialized */,
        child: child == null ? _makeChild() : child,
      );
    });
  }

  Widget _makeChild() {
    int index = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(airballSettingsTitle),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(pageMargin),
            child: Table(
              children: <TableRow>[
                editRow(
                    index++, _label('V', 'R'), DoubleEditWidget('v_r'), 'kias'),
                editRow(index++, _label('V', 'FE'), DoubleEditWidget('v_fe'),
                    'kias'),
                editRow(index++, _label('V', 'NO'), DoubleEditWidget('v_no'),
                    'kias'),
                editRow(index++, _label('V', 'NE'), DoubleEditWidget('v_ne'),
                    'kias'),
                editRow(index++, _label('α', 'X'), DoubleEditWidget('alpha_x'),
                    'degrees'),
                editRow(index++, _label('α', 'Y'), DoubleEditWidget('alpha_y'),
                    'degrees'),
                editRow(index++, _label('α', 'REF'),
                    DoubleEditWidget('alpha_ref'), 'degrees'),
                editRow(index++, _label('α', 'CRIT'),
                    DoubleEditWidget('alpha_stall'), 'degrees'),
                editRow(index++, _label('α', 'MIN'),
                    DoubleEditWidget('alpha_min'), 'degrees'),
                editRow(index++, _label('V', 'FS'),
                    DoubleEditWidget('ias_full_scale'), 'degrees'),
                editRow(index++, _label('β', 'FS'),
                    DoubleEditWidget('beta_full_scale'), 'degrees'),
                editRow(index++, _label('β', 'BIAS'),
                    DoubleEditWidget('beta_bias'), 'degrees'),
                editRow(index++, _label('QNH', ''),
                    DoubleEditWidget('baro_setting'), 'in Hg'),
                editRow(index++, _label('f', 'BALL'),
                    DoubleEditWidget('ball_smoothing_factor'), ''),
                editRow(index++, _label('f', 'VSI'),
                    DoubleEditWidget('vsi_smoothing_factor'), ''),
              ],
            ),
          ),
        ));
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
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGreen = Color.fromRGBO(225, 255, 225, 1);
}
