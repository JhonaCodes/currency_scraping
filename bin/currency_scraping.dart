import 'dart:convert';
import 'dart:io';
import 'country.dart';
import 'package:http/http.dart' as http;

void main() async {

  File file = File('countries.json');

  List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(await file.readAsString()));

  List<Country> countryList = data.map(Country.fromJson).toList();

  print("Total countries = ${countryList.length}");

  for (var country in countryList) {

    String conversion = country.currency;
    String regexCod = country.regexCode;

    var url = Uri.parse('https://www.google.com/search?q=US+to+$conversion');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // Search currency on HTML result.
        var rate = extractExchangeRate(response.body, regexCod);

        if (rate != null) {
          print('1 USD on ${country.name}  = $rate/${country.currency}');
        } else {
          print('Could not find exchange rate. ${country.name}');
        }
      } else {
        print('Request error: ${response.statusCode} ${country.name}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


}

String? extractExchangeRate(String html, String regexC) {

  var pattern = RegExp(r'([\d,]+(?:\.\d+)?) ' + regexC);

  var match = pattern.firstMatch(html) ;
  if (match != null) {
    var rateString = match.group(1)?.replaceAll(',', '');
    var rate = double.tryParse(rateString ?? '');

    return rate?.toStringAsFixed(2);
  }

  return null;

}
