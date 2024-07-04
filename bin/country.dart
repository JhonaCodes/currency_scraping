import 'dart:convert';

class Country {
  final String name;
  final String code;
  final String currency;
  final String regexCode;

  Country({
    required this.name,
    required this.code,
    required this.currency,
    required this.regexCode,
  });

  Country copyWith({
    String? name,
    String? code,
    String? currency,
    String? regexCode,
  }) =>
      Country(
        name: name ?? this.name,
        code: code ?? this.code,
        currency: currency ?? this.currency,
        regexCode: regexCode ?? this.regexCode,
      );

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"],
    code: json["code"],
    currency: json["currency"],
    regexCode: json["regex_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "currency": currency,
    "regex_code": regexCode,
  };
}
