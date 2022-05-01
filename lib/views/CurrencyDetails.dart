import 'package:flutter/material.dart';

class CurrencyDetails extends StatelessWidget {
  CurrencyDetails(
      {Key? key, required this.code, required this.rate, required this.date})
      : super(key: key);

  final String code;
  final String rate;
  final String date;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 90.0, left: 40.0, right: 40.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                border: Border.all(width: 6, color: Colors.white54),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(date,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(code,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                      Text(rate + ' zł',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
