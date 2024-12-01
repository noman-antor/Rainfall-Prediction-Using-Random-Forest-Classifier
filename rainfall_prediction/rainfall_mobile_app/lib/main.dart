
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      theme: ThemeData(fontFamily: "Times New Roman",backgroundColor: Colors.deepPurpleAccent,),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  text_field tf=text_field();

  TextEditingController take_humid=TextEditingController();
  TextEditingController take_wind_speed=TextEditingController();
  TextEditingController temp_max=TextEditingController();
  TextEditingController temp_min=TextEditingController();

  List<int> year=[];
  int year_value=2000;
  List<int> month=[];
  int month_value=1;
  double lat=0.0;
  double lon=0.0;

  String rain_label="";
  double prob=0.0;
  int error=0;
  int check_predict=0;


  void load_location() async{

    if(!await Permission.location.isGranted)
      {
        await Permission.location.request();
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          lat = position.latitude;
          lon = position.longitude;
        });
      }
    else
      {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          lat = position.latitude;
          lon = position.longitude;
        });

      }

  }

  void load_year_month()
  {
    for(int i=2000;i<2100;i++)
      {
        year.add(i);
      }
    for(int i=1;i<=12;i++)
    {
      month.add(i);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_year_month();
    load_location();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
         height: double.infinity,
         width: double.infinity,
         padding: EdgeInsets.only(left: 7,right: 7),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Container(
                 width: (MediaQuery.of(context).size.width),
                 height: 100,
                 decoration: BoxDecoration(color: Colors.deepPurpleAccent,
                     borderRadius: BorderRadius.all(Radius.circular(10)),
                 boxShadow: [
                   BoxShadow(
                       color: Colors.black.withOpacity(0.5),
                       spreadRadius: 2,
                       blurRadius: 10,
                       offset: Offset(0, 5))
                 ]),
                 child: Center(child:Text("\n\nRainfall Prediction",style: TextStyle(color: Colors.white,fontSize: 25)))),


               SizedBox(height: 20),
               Text("Current Location",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
               Text("Lat: $lat  &  Lon: $lon",style: TextStyle(fontSize: 18)),
               SizedBox(height: 30),
               Container(
                 width: (MediaQuery.of(context).size.width),
                 decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                 border: Border.all(color: Colors.deepPurpleAccent,width: 2)),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [

                     //Build Year & Month Dropdown button
                     SizedBox(height:15),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [


                         //Build Year_Dropdown
                         Text("Year? ",style: TextStyle(fontSize: 18),),
                         Container(
                           width: 60,
                           height: 28,
                           child: DropdownButton(
                               value: year_value,
                               underline: const SizedBox(),
                               icon: Icon(Icons.arrow_drop_down,color: Colors.deepPurpleAccent),
                               items: year.map((int item){
                                 return DropdownMenuItem(child: Text("$item"),value: item);
                               }).toList(),
                               onChanged: (int? newvalue){
                                 setState(() {
                                   year_value=newvalue!;
                                 });
                               }
                               ),
                         ),


                         //Build Month_Dropdown
                         SizedBox(width: 80),
                         Container(
                           width: 60,
                           height: 28,
                           child: DropdownButton(
                               value: month_value,
                               underline: const SizedBox(),
                               icon: Icon(Icons.arrow_drop_down,color: Colors.deepPurpleAccent),
                               items: month.map((int item){
                                 return DropdownMenuItem(child: Text("$item"),value: item);
                               }).toList(),
                               onChanged: (int? newvalue){
                                 setState(() {
                                   month_value=newvalue!;
                                 });
                               }
                           ),
                         ),
                         Text("Month? ",style: TextStyle(fontSize: 18),),
                       ],
                     ),


                     //Build Humidity textfield
                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Humidity? ",style: TextStyle(fontSize: 18),),
                         tf.get_text_field(take_humid),
                       ],
                     ),


                     //Build Wind_Speed textfield
                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Wind Speed? ",style: TextStyle(fontSize: 18),),
                         tf.get_text_field(take_wind_speed),
                       ],
                     ),


                     //Build Temp max textfield
                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Temparature (max)? ",style: TextStyle(fontSize: 18),),
                         tf.get_text_field(temp_max),
                       ],
                     ),


                     //Build Wind_Speed textfield
                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text("Temparature (min)? ",style: TextStyle(fontSize: 18),),
                         tf.get_text_field(temp_min),
                       ],
                     ),



                     SizedBox(height: 20),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [

                         //Building Result Button
                         SizedBox(width: 50),
                         ElevatedButton(onPressed: ()async{
                           double humd=double.parse(take_humid.text);
                           double wind_speed=double.parse(take_wind_speed.text);
                           double max_temp=double.parse(temp_max.text);
                           double min_temp=double.parse(temp_min.text);
                           Dio dio = Dio();
                           var response = await dio.post("https://bizarre-ellen-antor-f2021dea.koyeb.app/predict",
                               data: jsonEncode(
                                   {
                                     "year": year_value,
                                     "month": month_value,
                                     "max_temp": max_temp,
                                     "min_temp": min_temp,
                                     "humidity": humd,
                                     "wind_speed": wind_speed,
                                     "lat": lat,
                                     "lon": lon
                                   })
                           );
                           if(response.statusCode==200)
                           {
                             String x=response.data.toString();//x=[4,85.56]
                             print(x);
                             setState(() {
                               rain_label=x.split(",").first.split("[").last;
                               prob=double.parse(x.split(",").last.split("]").first);
                               check_predict=1;
                             });
                           }
                           else
                           {
                             setState(() {
                               error=1;
                             });
                           }
                         },
                           child: Text("Result"),),



                         //Building Refresh Button
                         IconButton(onPressed: (){
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                         },
                             icon: Icon(Icons.refresh,size: 30,color: Colors.blue,)),
                       ],
                     ),
                     SizedBox(height: 15),
                   ],
                 ),
               ),
               SizedBox(height: 30),
               if(check_predict==1)
                 (error==0)?Text("Chances of $rain_label ($prob)%", style: TextStyle(fontSize: 20,
                     color: Colors.deepPurple,fontWeight: FontWeight.bold)):
                   Text("Unexpected Error Occured",style: TextStyle(fontSize: 20,
                       color: Colors.deepPurple,fontWeight: FontWeight.bold)),
               SizedBox(height: 50,)
             ],
           ),
         )
       ),
    );
  }
}
