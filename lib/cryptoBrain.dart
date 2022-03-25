import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coin_data.dart';

class CryptoHandler{
  int apiCount=0;
  Future<double> getCryptoRate({required String baseCrypto,required String convertCrypto})async{
try{
  var cryptoData;
  if(baseCrypto==convertCrypto){
    return 1.0;
  }

  cryptoData=await getCryptoRateJson(coinValue: convertCrypto, baseCoin: baseCrypto);
  double rate=cryptoData['rate'];
  if(rate>10){
    rate=double.parse(rate.toStringAsFixed(4));
  }
  else{
    rate=double.parse(rate.toStringAsFixed(5));
  }
  return rate;
}
catch(e){
  print(e);
  return 0.0;
}

  }
  Future<dynamic> getCryptoRateJson({required String coinValue,required String baseCoin}) async{
    print('getting json');

      var url='https://rest.coinapi.io/v1/exchangerate/$baseCoin/$coinValue?apiKey=${apiKeys[apiCount]}';
      print('got json');
      http.Response response=await http.get(Uri.parse(url));
      if(response.statusCode==200){
        print('status 200');
        String data=response.body;
        return jsonDecode(data);
      }
      else if(response.statusCode>400){
        print(response.statusCode);
        print('Cant Get data');
        apiCount++;
        if(apiCount>4){
          apiCount=0;
        }
        throw Exception('apierror');
      }



  }
}