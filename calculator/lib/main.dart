import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

import 'dart:core';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalculatorApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String btnTxt) {
    setState(() {
      if (btnTxt == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (btnTxt == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (btnTxt == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = btnTxt;
        } else {
          equation = equation + btnTxt;
        }
      }
    });
  }

  Widget _buildButton(btnTxt, btnHeight, btnColor) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.15 * btnHeight,
      child: ElevatedButton(
        onPressed: () => buttonPressed(btnTxt),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(btnColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                color: Colors.white,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        child: Text(
          btnTxt,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Column(
        children: [
          Container(

            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(
                fontSize: equationFontSize,
              ),
            ),
          ),
          Container(

            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: resultFontSize,
              ),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        _buildButton("C", 1, Colors.redAccent),
                        _buildButton("⌫", 1, Colors.blue),
                        _buildButton("÷", 1, Colors.blue),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildButton("7", 1, Colors.black12),
                        _buildButton("8", 1, Colors.black12),
                        _buildButton("9", 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildButton("4", 1, Colors.black12),
                        _buildButton("5", 1, Colors.black12),
                        _buildButton("6", 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildButton("1", 1, Colors.black12),
                        _buildButton("2", 1, Colors.black12),
                        _buildButton("3", 1, Colors.black12),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildButton(".", 1, Colors.black12),
                        _buildButton("0", 1, Colors.black12),
                        _buildButton("00", 1, Colors.black12),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .25,
                child: Table(
                  children: [
                    TableRow(children: [
                      _buildButton("×", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildButton("-", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildButton("+", 1, Colors.blue),
                    ]),
                    TableRow(children: [
                      _buildButton("=", 2, Colors.redAccent),
                    ]),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
