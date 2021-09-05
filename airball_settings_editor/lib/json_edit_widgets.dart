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

  final String url;
  Map<String, dynamic> _json;

  dynamic getValue(String name) {
    return _json[name];
  }

  void setValue(String name, dynamic value) {
    print('setValue(' + name + ',' + value.toString() + ')');
    _json[name] = value;
    _postToUrl();
    notifyListeners();
  }

  void _getFromUrl() {
    Future<http.Response> f = http.get(Uri.parse(url));
    f.then((r) => {_json = jsonDecode(r.body), print(_json), notifyListeners()},
        onError: (err) => print(err.toString()));
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
  DoubleEditWidget(String name) : super(name);
  @override
  Widget build(BuildContext context) {
    return Consumer<JSONDocumentModel>(
        builder: (context, model, child) => SpinBox(
              min: 1,
              max: 100,
              value: getValue(model, 0.0),
              decimals: 1,
              step: 0.1,
              acceleration: 0.001,
              onChanged: (value) => setValue(model, value),
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
