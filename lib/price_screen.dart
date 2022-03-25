import 'cryptoBrain.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String choosenCrypto=currenciesList[0];
  var cardRate=List<double>.generate(cryptoList.length, (index) => 0,growable: false);
void initState(){
  super.initState();
  updateUI();
}

void updateUI()async{
  CryptoHandler cryptohandler=CryptoHandler();
  int i=0;
  for(String crypto in cryptoList){
    cardRate[i++]= await cryptohandler.getCryptoRate(convertCrypto: choosenCrypto,baseCrypto: crypto);
  }
  setState(() {
    cardRate;
    choosenCrypto;
  });
}


List<DropdownMenuItem<String>> getDropdownItems(){
  List<DropdownMenuItem<String>>   dropDownList=[];
  for(int i=0;i<currenciesList.length;i++){
    dropDownList.add(DropdownMenuItem(
      child: Text(currenciesList[i]),
      value: currenciesList[i],)) ;
  }
  return dropDownList;
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            baseCrypto: 'BTC',
            convertCrypto: choosenCrypto,
            rate: cardRate[0],
          ),
          CryptoCard(
            baseCrypto: 'ETH',
            convertCrypto: choosenCrypto,
            rate: cardRate[1],
          ),
          CryptoCard(
            baseCrypto: 'LTC',
            convertCrypto: choosenCrypto,
            rate: cardRate[2],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton<String>(
              value: choosenCrypto,
              items: getDropdownItems(),
                onChanged: (value ){

                      choosenCrypto=value as String;
                      updateUI();

                },),
          ),
        ],
      ),
    );
  }
}



class CryptoCard extends StatelessWidget {
  String baseCrypto;
  String convertCrypto;
  double rate;
  CryptoCard({required this.baseCrypto,required this.convertCrypto, required this.rate});

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
            '1 $baseCrypto = $rate $convertCrypto',
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