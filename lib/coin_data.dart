import 'dart:convert';
import 'package:http/http.dart' as http;
import 'price_screen.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = 'D4609951-6C60-4DA2-BD76-39D8DE9BC28A';
const apiURL = 'https://rest.coinapi.io/v1/exchangerate';


class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String,String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      var url = Uri.parse('$apiURL/$crypto/$selectedCurrency?apikey=$apiKey');
      http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double lastPrice = (decodedData['rate']);
      cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
    }else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
    }
    return cryptoPrices;
  }
  Future getAllCoinData(String selectedCurrency) async {
    Map<String,String> filteredCryptoRates = {};
      var url = Uri.parse('$apiURL/$selectedCurrency?apikey=$apiKey');
      print('********Loading*********');
      http.Response response = await http.get(url);
    print('********Finished*********');
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        List<dynamic> exchangeRates= decodedData['rates'];
        for (var crypto in cryptoList){
          for (var item in exchangeRates){
            if (item['asset_id_quote']==crypto){
              filteredCryptoRates[crypto]=item['rate'].toStringAsFixed(4);
            }
          }

        }
        print('********${filteredCryptoRates}*********');
      }else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }

    return filteredCryptoRates;
  }
}






