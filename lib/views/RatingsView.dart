import 'package:financial_app/views/CurrencyDetails.dart';
import 'package:financial_app/views/Helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:financial_app/bloc/FinancialRatingsBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingsViewProvider extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FinancialRatingsBloc(), child: RatingsView());
  }
}

class RatingsView extends StatefulWidget {
  RatingsView({Key? key}) : super(key: key);

  @override
  _RatingsViewState createState() => _RatingsViewState();
}

class _RatingsViewState extends State<RatingsView> {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: buildBlocBuilder()));
  }

  Widget buildBlocBuilder() {
    return BlocBuilder<FinancialRatingsBloc, FinancialRatingsState>(
      builder: (context, state) {
        if (state is FinancialRatingsInitial) {
          BlocProvider.of<FinancialRatingsBloc>(context)
              .add(GetFinancialRatings());
          _loadRatesData();
          _loadDate();
          return buildLoadingView();
        } else if (state is FinancialRatingsLoaded) {
          return ratingsView(context, state);
        } else if (state is ConnectionError) {
          print(_rates[0].runtimeType);
          // ignore: unnecessary_null_comparison
          if (_rates[0] == "null") {
            _rates = helperRates;
          }
          return alert(context, state);
        } else {
          return ratingsView(context, state);
        }
      },
    );
  }

  String _raportdate = "b/d";
  List<String> _rates = [];

  List _codeCurrency = helperCode;

  Widget buildLoadingView() => CircularProgressIndicator();

  void _loadRatesData() async {
    final prefs = await SharedPreferences.getInstance();
    var i = 0;
    List<String> rates = [];
    for (var code in _codeCurrency) {
      rates.insert(i, prefs.getString(code).toString());
      i++;
    }
    setState(() {
      _rates = rates;
    });
  }

  void _loadDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _raportdate = (prefs.getString('date'))!;
    });
  }

  Widget ratingsView(BuildContext context, state) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 90.0, left: 40.0, right: 40.0),
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("NOTOWANIA WALUT", style: TextStyle(fontSize: 20)),
              Ink(
                decoration: const ShapeDecoration(
                  color: Colors.teal,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RatingsViewProvider()));
                  },
                ),
              ),
            ]),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                for (var i = 1; i < _codeCurrency.length; i++)
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CurrencyDetails(
                                code: _codeCurrency[i].toString(),
                                date: _raportdate,
                                rate: _rates[i].toString())));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_codeCurrency[i].toString(),
                              style: TextStyle(fontSize: 20)),
                          Text(_rates[i].toString() + " zł",
                              style: TextStyle(fontSize: 20))
                        ],
                      )),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget alert(BuildContext context, state) {
    return AlertDialog(
      title: const Text('Bląd połączenia'),
      content: const Text(
          'Brak połączenia z siecią. Czy chcesz kontynuować w trybie offline?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ratingsView(context, state)));
          },
          child: Text('Tak'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RatingsViewProvider()));
          },
          child: Text('Nie'),
        ),
      ],
    );
  }
}
