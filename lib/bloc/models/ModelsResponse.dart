import 'dart:convert';

List<TableRates> tableRatesFromJson(String str) =>
    List<TableRates>.from(json.decode(str).map((x) => TableRates.fromJson(x)));

String tableRatesToJson(List<TableRates> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TableRates {
  TableRates({
    required this.table,
    required this.no,
    required this.effectiveDate,
    required this.rates,
  });

  String table;
  String no;
  DateTime effectiveDate;
  List<Rate> rates;

  factory TableRates.fromJson(Map<String, dynamic> json) => TableRates(
        table: json["table"],
        no: json["no"],
        effectiveDate: DateTime.parse(json["effectiveDate"]),
        rates: List<Rate>.from(json["rates"].map((x) => Rate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table": table,
        "no": no,
        "effectiveDate":
            "${effectiveDate.year.toString().padLeft(4, '0')}-${effectiveDate.month.toString().padLeft(2, '0')}-${effectiveDate.day.toString().padLeft(2, '0')}",
        "rates": List<dynamic>.from(rates.map((x) => x.toJson())),
      };
}

class Rate {
  Rate({
    required this.currency,
    required this.code,
    required this.mid,
  });

  String currency;
  String code;
  double mid;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        currency: json["currency"],
        code: json["code"],
        mid: json["mid"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "code": code,
        "mid": mid,
      };
}
