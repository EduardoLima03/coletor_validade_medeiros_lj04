import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/utils/snackbar_custom.dart';
import '../utils/save_log.dart';

class BuscaDesc {
  Future<Map> getDesc(ean, BuildContext context) async {
    var url = Uri.parse(
        'http://18.230.58.176/api/by-ean/${ean.text.toString()}');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    var _text = <dynamic, dynamic>{};

    if(response.statusCode == 200){
      var mJson = jsonDecode(response.body);
      _text['descricao'] = mJson['description'].toString();
      _text['code'] = mJson['code'].toString();
      return _text;
    }else if(response.statusCode != 200) {
      var url = Uri.parse(
        'https://cosmos.bluesoft.com.br/produtos/${ean.text.toString()}',
      );
      response = await http.get(url);
      // cria a lista com a respostas separada por "<"
      var list = response.body.split('<');
      //retorn com a descricao
      var desc;
      for (var t in list) {
        if (t.contains('product_description')) {
          var separacao = t.split('>');
          desc = separacao[1];
          break;
        }
      }
      _text['descricao'] = desc.toString();
      return _text;
    }else{
      SnackbarCustom().show(context, "Produto não localizado", Colors.red);
      _text['code'] = "Tente de novo";
      _text['descricao'] = "Tente de novo";
      SaveLog().log("Produto não localizado - ${ean.text.toString()}", "Loja 04 - getDesc");
      return _text;

    }
  }
}
