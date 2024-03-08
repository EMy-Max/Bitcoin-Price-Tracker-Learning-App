import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  dynamic selectedCurrency = 'AUD';
  bool isloading = false;

  DropdownButton<dynamic> andriodDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = (currenciesList[i]);
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<dynamic>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      Text(currency);
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  // Widget ?getPicker(){
  //   if (Platform.isIOS) {
  //     return iOSPicker();
  //   }else if (Platform.isAndroid){
  //     return andriodDropdown();
  //   }
  // }
  // This widget method above is what is actually used for automatically selecting which  display to use, either a dropdown for andriod or acupertino picker for ios, but since i dont have an andriod and ios emulator, it wont work on my browser display. i just have to choose the andriod display  for the purpose of this project.

   Map<String, String> bitcoinValue = {};
  void getData() async {
    setState(() {
      isloading  = true;
    });
    try {
      Map<String, String> data = await CoinData().getAllCoinData(selectedCurrency);
      setState(() {
        bitcoinValue = data;
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: [
              CryptoCard(
                bitcoinValue: isloading? '?' : bitcoinValue['BTC'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'BTC',
              ),
              CryptoCard(
                bitcoinValue: isloading? '?' : bitcoinValue['ETH'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'ETH',
              ),
              CryptoCard(
                bitcoinValue: isloading? '?' : bitcoinValue['LTC'],
                selectedCurrency: selectedCurrency,
                cryptoCurrency: 'LTC',
              ),
            ],
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: andriodDropdown()),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.bitcoinValue,
      required this.selectedCurrency,
      required this.cryptoCurrency});

  final bitcoinValue;
  final selectedCurrency;
  final cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
