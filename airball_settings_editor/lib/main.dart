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
        absorbing: !model.initialized,
        child: child == null ? makeChild() : child,
      );
    });
  }

  Widget makeChild() {
    int index = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text(airballSettingsTitle),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(pageMargin),
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: <TableRow>[
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'X'),
                        FixedUnitsEditWidget('alpha_x',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'Y'),
                        FixedUnitsEditWidget('alpha_y',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'REF'),
                        FixedUnitsEditWidget('alpha_ref',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'CRIT'),
                        FixedUnitsEditWidget('alpha_stall',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'MIN'),
                        FixedUnitsEditWidget('alpha_min',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('α', 'MAX'),
                        FixedUnitsEditWidget('alpha_max',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('β', 'FS'),
                        FixedUnitsEditWidget('beta_full_scale',
                            decimals: 0,
                            step: 5.0,
                            min: 5.0,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('β', 'BIAS'),
                        FixedUnitsEditWidget('beta_bias',
                            decimals: 1,
                            step: 0.1,
                            min: -angleExtreme,
                            max: angleExtreme,
                            units: '°')),
                    editRow(
                        index++,
                        mathSymbolLabel('V', 'R'),
                        VariableUnitsEditWidget('v_r',
                            decimals: 0,
                            step: 1.0,
                            min: 0.0,
                            max: vExtreme,
                            unitsProperty: 'speed_units')),
                    editRow(
                        index++,
                        mathSymbolLabel('V', 'FE'),
                        VariableUnitsEditWidget('v_fe',
                            decimals: 0,
                            step: 1.0,
                            min: 0.0,
                            max: vExtreme,
                            unitsProperty: 'speed_units')),
                    editRow(
                        index++,
                        mathSymbolLabel('V', 'NO'),
                        VariableUnitsEditWidget('v_no',
                            decimals: 0,
                            step: 1.0,
                            min: 0.0,
                            max: vExtreme,
                            unitsProperty: 'speed_units')),
                    editRow(
                        index++,
                        mathSymbolLabel('V', 'NE'),
                        VariableUnitsEditWidget('v_ne',
                            decimals: 0,
                            step: 1.0,
                            min: 0.0,
                            max: vExtreme,
                            unitsProperty: 'speed_units')),
                    editRow(
                        index++,
                        mathSymbolLabel('V', 'FS'),
                        VariableUnitsEditWidget('ias_full_scale',
                            decimals: 0,
                            step: 10.0,
                            min: 50.0,
                            max: vExtreme,
                            unitsProperty: 'speed_units')),
                    editRow(
                        index++,
                        plainTextLabel('Ball smoothing'),
                        FixedUnitsEditWidget('ball_smoothing_factor',
                            decimals: 3, step: 0.005, min: 0.0, max: 1.0)),
                    editRow(
                        index++,
                        plainTextLabel('Sound scheme'),
                        StringEnumEditWidget(
                          'sound_scheme',
                          allowedValues: ["flyonspeed", "stallfence"],
                        )),
                    editRow(
                        index++,
                        plainTextLabel('Audio volume'),
                        FixedUnitsEditWidget('audio_volume',
                            decimals: 2, step: 0.05, min: 0.0, max: 1.0)),
                    editRow(index++, plainTextLabel('Show altimeter'),
                        BoolEditWidget('show_altimeter')),
                    editRow(index++, plainTextLabel('Declutter'),
                        BoolEditWidget('declutter')),
                    editRow(
                        index++,
                        plainTextLabel('Baro setting'),
                        FixedUnitsEditWidget('baro_setting',
                            decimals: 2,
                            step: 0.01,
                            min: 25.90,
                            max: 32.01,
                            units: 'in Hg')),
                    editRow(
                        index++,
                        plainTextLabel('VSI smoothing'),
                        FixedUnitsEditWidget('vsi_smoothing_factor',
                            decimals: 2, step: 0.05, min: 0.0, max: 1.0)),
                    editRow(
                        index++,
                        plainTextLabel('Speed units'),
                        StringEnumEditWidget('speed_units',
                            allowedValues: ["knots", "mph"])),
                  ],
                ),
              ),
            )));
  }

  Widget mathSymbolLabel(String symbol, String subscript) {
    return RichText(
      text: TextSpan(
        text: symbol + ' ',
        style: TextStyle(
            color: black,
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontFamily: 'EBGaramond'),
        children: <TextSpan>[
          TextSpan(
              text: subscript,
              style: TextStyle(fontSize: 15, fontFamily: 'EBGaramond')),
        ],
      ),
    );
  }

  Widget plainTextLabel(String text) {
    return Text(text,
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'EBGaramond',
        ));
  }

  TableRow editRow(int idx, Widget label, JSONPropertyEditWidget widget) {
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
    ]);
  }

  Color stripe(int idx) {
    return (idx % 2 == 0) ? white : lightGreen;
  }

  static const double vExtreme = 200.0;
  static const double angleExtreme = 30.0;
  static const double pageMargin = 20.0;
  static const double titleFontSize = 20.0;
  static const double rowHeight = 100.0;
  static const double cellPadding = 10.0;
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color grey50 = Color.fromRGBO(128, 128, 128, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
  static const Color lightGreen = Color.fromRGBO(225, 255, 225, 1);
}
