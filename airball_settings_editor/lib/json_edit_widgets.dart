import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:http/http.dart' as http;

T? cast<T>(x) => x is T ? x : null;

class JSONDocument extends InheritedWidget {
  JSONDocument({required this.url, required Widget child})
      : _json = {},
        super(child: child) {
    _getFromUrl();
  }

  final String url;
  Map<String, dynamic> _json;

  static JSONDocument of(BuildContext context) {
    final JSONDocument? result =
        context.dependOnInheritedWidgetOfExactType<JSONDocument>();
    assert(result != null, 'No JSONDocument found in context');
    return result!;
  }

  dynamic getValue(String name) {
    print('getValue(' + name + ') -> ' + _json[name].toString());
    print('_json = ' + _json.toString());
    return _json[name];
  }

  void setValue(String name, dynamic value) {
    print('setValue(' + name + ',' + value.toString() + ')');
    _json[name] = value;
    _postToUrl();
  }

  void _getFromUrl() {
    Future<http.Response> f = http.get(Uri.parse(url));
    f.then((r) => _json = jsonDecode(r.body),
        onError: (err) => print(err.toString()));
  }

  void _postToUrl() {}

  @override
  bool updateShouldNotify(JSONDocument old) => true;
}

abstract class JSONPropertyEditWidget<T> extends StatefulWidget {
  final String _name;
  JSONPropertyEditWidget(this._name);
}

class IntEditWidget extends JSONPropertyEditWidget<int> {
  IntEditWidget(String name) : super(name);
  _IntEditWidgetState createState() => _IntEditWidgetState();
}

class _IntEditWidgetState extends State<IntEditWidget> {
  int getValue(BuildContext context, int def) {
    var x = cast<int>(JSONDocument.of(context).getValue(widget._name));
    return (x == null) ? def : x;
  }

  void setValue(BuildContext context, int value) {
    setState(() {
      JSONDocument.of(context).setValue(widget._name, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpinBox(
      min: 1,
      max: 100,
      value: getValue(context, 0).toDouble(),
      decimals: 0,
      step: 1,
      acceleration: 0.001,
      onChanged: (value) => setValue(context, value.toInt()),
    );
  }
}

class DoubleEditWidget extends JSONPropertyEditWidget<double> {
  DoubleEditWidget(String name) : super(name);
  _DoubleEditWidgetState createState() => _DoubleEditWidgetState();
}

class _DoubleEditWidgetState extends State<DoubleEditWidget> {
  double getValue(BuildContext context, double def) {
    var x = cast<double>(JSONDocument.of(context).getValue(widget._name));
    return (x == null) ? def : x;
  }

  void setValue(BuildContext context, double value) {
    setState(() {
      JSONDocument.of(context).setValue(widget._name, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpinBox(
      min: 1,
      max: 100,
      value: getValue(context, 0.0).toDouble(),
      decimals: 1,
      step: 0.1,
      acceleration: 0.001,
      onChanged: (value) => setValue(context, value),
    );
  }
}

class BoolEditWidget extends JSONPropertyEditWidget<bool> {
  BoolEditWidget(String name) : super(name);
  _BoolEditWidgetState createState() => _BoolEditWidgetState();
}

class _BoolEditWidgetState extends State<BoolEditWidget> {
  bool getValue(BuildContext context, bool def) {
    var x = cast<bool>(JSONDocument.of(context).getValue(widget._name));
    return (x == null) ? def : x;
  }

  void setValue(BuildContext context, bool value) {
    setState(() {
      JSONDocument.of(context).setValue(widget._name, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: getValue(context, false),
      onChanged: (bool? value) =>
          setValue(context, value == null ? false : value),
    );
  }
}
