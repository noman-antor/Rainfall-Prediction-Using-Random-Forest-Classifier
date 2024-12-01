import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class text_field
{
  Widget get_text_field(TextEditingController a)
  {
    return Container(
      height: 40,
      width: 150,
      child: TextField(
        controller: a,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.deepPurpleAccent,
            suffixIcon: IconButton(icon: Icon(Icons.clear,size: 15,color: Colors.deepPurpleAccent),
              onPressed: (){a.clear();},)),
        cursorColor: Colors.deepPurpleAccent,
      ),
    );
  }
}