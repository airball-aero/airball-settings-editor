import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

T? cast<T>(x) => x is T ? x : null;

class JSONDocumentModel extends ChangeNotifier {
  JSONDocumentModel(this.url) : _json = {} {
    _getFromUrl();
  }

  bool initialized = true;
  final String url;
  Map<String, dynamic> _json;

  dynamic getValue(String name) {
    return _json[name];
  }

  bool isInitialized() {
    return initialized;
  }

  void setValue(String name, dynamic value) {
    print('setValue(' + name + ',' + value.toString() + ')');
    _json[name] = value;
    _postToUrl();
    notifyListeners();
  }

  void _getFromUrl() {
    try {
      Future<http.Response> f = http.get(Uri.parse(url));
      f.then(
          (r) => {
                _json = jsonDecode(r.body),
                print(_json),
                initialized = true,
                notifyListeners()
              },
          onError: (err) => print(err.toString()));
    } catch (err) {
      print("Request error: " + err.toString());
    }
  }

  void _postToUrl() {
    print('postToUrl');
    http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode(_json));
  }
}

abstract class JSONPropertyEditWidget<T> extends StatelessWidget {
  final String _name;
  JSONPropertyEditWidget(this._name);
  JSONDocumentModel getModel(BuildContext context) {
    return Provider.of<JSONDocumentModel>(context, listen: false);
  }

  T getValue(JSONDocumentModel model, T def) {
    var x = cast<T>(model.getValue(_name));
    return (x == null) ? def : x;
  }

  void setValue(JSONDocumentModel model, T value) {
    model.setValue(_name, value);
  }
}

class IntEditWidget extends JSONPropertyEditWidget<int> {
  IntEditWidget(String name) : super(name);
  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(
        builder: (context, model, child) => SpinBox(
              min: 1,
              max: 100,
              value: getValue(model, 0).toDouble(),
              decimals: 0,
              step: 1,
              acceleration: 0.001,
              onChanged: (value) => setValue(model, value.toInt()),
            ));
  }
}

class DoubleEditWidget extends JSONPropertyEditWidget<double> {
  final double min;
  final double max;
  final double step;
  final String units;
  final int decimals;

  DoubleEditWidget(
    String name, {
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.units = '',
    this.decimals = 1,
  }) : super(name);

  double checkValue(double value) {
    if (value < min) value = min;
    if (value > max) value = max;
    return (value / step).round() * step;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(
        builder: (context, model, child) => SpinBox(
              decoration: InputDecoration(
                suffixText: this.units,
              ),
              min: this.min,
              max: this.max,
              value: getValue(model, this.min),
              decimals: this.decimals,
              step: this.step,
              acceleration: 0.001,
              textStyle: TextStyle(fontSize: 30),
              onChanged: (value) => setValue(model, checkValue(value)),
            ));
  }
}

class BoolEditWidget extends JSONPropertyEditWidget<bool> {
  BoolEditWidget(String name) : super(name);
  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(
        builder: (context, model, child) => Checkbox(
              value: getValue(model, false),
              onChanged: (bool? value) =>
                  setValue(model, value == null ? false : value),
            ));
  }
}

class StringEnumEditWidget extends JSONPropertyEditWidget<String> {
  final List<String> allowedValues = [];

  StringEnumEditWidget(String name, {allowedValues}) : super(name) {
    if (allowedValues != null) {
      for (String v in allowedValues) {
        this.allowedValues.add(v);
      }
    }
  }

  List<DropdownMenuItem<String>> menuItems() {
    return allowedValues.map((String s) {
      return DropdownMenuItem<String>(
        value: s,
        child: Text(s, style: TextStyle(fontSize: 20)),
      );
    }).toList();
  }

  String checkValue(Object? value) {
    if (value == null || !allowedValues.contains(value) || !(value is String)) {
      return allowedValues[0];
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(
        builder: (context, model, child) => DropdownButton(
            items: menuItems(),
            value: getValue(model, allowedValues[0]),
            onChanged: (value) => setValue(model, checkValue(value))));
  }
}
