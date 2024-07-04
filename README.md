# Currency Exchange Rate Scraper

This Dart script extracts currency exchange rates from Google search results for a list of countries and their respective currencies.

## How It Works

1. **Reading the JSON File**:
   - The script reads a `countries.json` file that contains a list of countries with their names, codes, currency codes, and regex codes.
   - The JSON file is parsed into a list of `Country` objects.

2. **Fetching Exchange Rates**:
   - For each country, the script constructs a Google search URL for converting USD to the country's currency.
   - It sends an HTTP GET request to fetch the search results.

3. **Extracting Exchange Rates**:
   - The script uses a regular expression to search for the exchange rate in the HTML content of the search results.
   - If the exchange rate is found, it is printed in the format: `1 USD in [Country] = [Rate]/[Currency]`.
   - If the exchange rate is not found or there is an error, an appropriate message is printed.

## Code Explanation

### Main Function

```dart
void main() async {
  // Read the JSON file
  File file = File('countries.json');
  List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(jsonDecode(await file.readAsString()));
  
  // Parse JSON data into a list of Country objects
  List<Country> countryList = data.map(Country.fromJson).toList();
  
  print("Total countries = ${countryList.length}");
  
  // Fetch and print exchange rates for each country
  for (var country in countryList) {
    String conversion = country.currency;
    String regexCod = country.regexCode;
    
    var url = Uri.parse('https://www.google.com/search?q=US+to+$conversion');
    
    try {
      var response = await http.get(url);
      
      if (response.statusCode == 200) {
        // Search currency on HTML result
        var rate = extractExchangeRate(response.body, regexCod);
        
        if (rate != null) {
          print('1 USD in ${country.name} = $rate/${country.currency}');
        } else {
          print('Could not find exchange rate for ${country.name}');
        }
      } else {
        print('Request error: ${response.statusCode} for ${country.name}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
```

### Extract Exchange Rate Function

```dart
String? extractExchangeRate(String html, String regexC) {
  // Regular expression to find the exchange rate in the HTML content
  var pattern = RegExp(r'([\d,]+(?:\.\d+)?) ' + regexC);
  
  var match = pattern.firstMatch(html);
  if (match != null) {
    var rateString = match.group(1)?.replaceAll(',', '');
    var rate = double.tryParse(rateString ?? '');
    
    return rate?.toStringAsFixed(2);
  }
  
  return null;
}
```

## JSON File Format

The `countries.json` file should have the following format:

```json
[
  {
    "name": "Argentina",
    "code": "AR",
    "currency": "ARS",
    "regex_code": "Ar"
  },
  {
    "name": "Brazil",
    "code": "BR",
    "currency": "BRL",
    "regex_code": "Br"
  }
]
```

## Notes

- Ensure that you have the Dart SDK installed and the necessary packages (`http` package) included in your `pubspec.yaml`.
- This script relies on the structure of Google's search results, which may change over time. If the HTML structure of the search results changes, the regular expression may need to be updated.

### Improve the code at your convenience 😁.