import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:financial_app/bloc/models/ModelsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'FinancialRatingsEvent.dart';
part 'FinancialRatingsState.dart';

class FinancialRatingsBloc
    extends Bloc<FinancialRatingsEvent, FinancialRatingsState> {
  FinancialRatingsBloc() : super(FinancialRatingsInitial());

  Stream<FinancialRatingsState> mapEventToState(
    FinancialRatingsEvent event,
  ) async* {
    //waiting for event
    if (event is GetFinancialRatings) {
      //send query to api
      var client = http.Client();
      try {
        final response = await client.get(
          Uri.parse('http://api.nbp.pl/api/exchangerates/tables/a/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ).timeout(const Duration(seconds: 1));
        client.close();
        final decodeResponse = json.decode(response.body);
        TableRates tableRates = TableRates.fromJson(decodeResponse[0]);

        final prefs = await SharedPreferences.getInstance();

        prefs.setString(
            "date", tableRates.effectiveDate.toString().substring(0, 11));

        for (Rate rate in tableRates.rates) {
          prefs.setString(rate.code, rate.mid.toString());
        }

        yield FinancialRatingsLoaded();
      } on TimeoutException catch (_) {
        client.close();
        final response = 408;
        print(response);
        yield ConnectionError();
      }
    }
  }
}
