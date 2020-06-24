

import 'package:prueba_gbp/src/model/user_model.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class UserRepository{

  String _url = "https://api.github.com/users";

  Future<List<UserModel>> getUsers() async{

    try {
      final resp = await http.get(_url);
      if(resp.statusCode == 200){
        final users = userModelFromJson(resp.body);
        return users; 
      }else{
        return null;
      }
      
    } catch (e) {
      return null;
    }

  }

}