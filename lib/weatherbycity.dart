import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class weatherByCity extends StatefulWidget {
  @override
  _weatherByCityState createState() => _weatherByCityState();
}

class _weatherByCityState extends State<weatherByCity> {
  Future<WeatherModel> data;
//  String textFieldCityName;
  var windDegree;
  var temprature;
  var celsTemp;
  var farnTemp;
  String citynameFromAutoField;
  Color celsActiveColor = Colors.white;
  Color farnActiveColor = Colors.black38;
  AutoCompleteTextField searchTextField;
  TextEditingController citynamecontroller = new TextEditingController();
  final autoFieldkey = new GlobalKey<AutoCompleteTextFieldState<String>>();

//Pakistan Cities List.......
  List<String> pkCities = [
    'lahore',
    'islamabad',
    'dir',
    'naran',
    'timergara',
    'chitral',
    'landi Kotal',
    'torkham',
    'karachi',
    'multan',
    'quetta',
    'hyderabad',
    'rawalpindi',
    'faisalabad',
    'peshawar',
    'gujranwala',
    'khuzdar',
    'chaman',
    'turbat',
    'sibi',
    'zhob',
    'gwadar',
    'nasirabad',
    'malakand',
    'murree',
    'kalam',
    'mardan',
    'kohat',
    'abbottabad',
    'bannu',
    'swabi',
    'dera Ismail Khan',
    'charsadda',
    'nowshera',
    'sargodha',
    'bahawalpur',
    'sialkot',
    'sheikhupura',
    'gujrat',
    'jhang',
    'sahiwal',
    'sukkar',
    'larkana',
    'nawabshah',
    'mirpur Khas',
    'jacobabad',
    'khairpur',
    'dadu',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//this is to load initial data to the screen before user search anything....
    data = getWeatherByCityName('peshawar');
  }

//weather api data fetching method...
  Future<WeatherModel> getWeatherByCityName(String cityname) async {
    final response = await http.get(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=5bc7860bbc2cb9d232bd3ebe876cd446&units=metric");
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var model = WeatherModel.fromJason(result);
      windDegree = result['wind']['deg'];
      temprature = result['main']['temp'];
      return model;
    } else {
      throw Exception("In-valid City name Plz Confirm City Name");
    }
  }

//wind direction method....
  Text degreeShow() {
    if (windDegree == 0) {
      return Text("North ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree >= 1 && windDegree <= 89) {
      return Text("NorthEast ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree == 90) {
      return Text("East ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree >= 91 && windDegree <= 179) {
      return Text("SouthEast ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree == 180) {
      return Text("North ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree >= 181 && windDegree <= 269) {
      return Text("NorthWest ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree == 270) {
      return Text("West ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree >= 271 && windDegree <= 359) {
      return Text("NorthWest ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else if (windDegree == 360) {
      return Text("North ($windDegree Degree)",
          style: TextStyle(color: Colors.white70));
    } else {
      return Text("$windDegree", style: TextStyle(color: Colors.white70));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WeatherModel model = snapshot.data;
            var fm = DateFormat.yMMMEd();
            var fm_hour = DateFormat("hh:mm");
            double windspeedInKiloHr = model.wind.speed * 18 / 5;
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // Image.asset(
                //   "assets/images/bg.jpg",
                //   fit: BoxFit.cover,
                // ),

                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.deepOrangeAccent,
                ),
//Data of Weather API Displying from here.....

                ListView(
                  children: <Widget>[
//search icon

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70.withOpacity(0.7),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          // title: TextField(
                          //   controller: citynamecontroller,
                          //   decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       hintText: 'City name here...'),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       textFieldCityName = value;
                          //     });
                          //   },
                          // ),
                          title: searchTextField =
                              AutoCompleteTextField<String>(
                            key: autoFieldkey,
                            controller: citynamecontroller,
                            clearOnSubmit: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'City name here...'),
                            suggestions: pkCities,
                            itemFilter: (item, query) {
                              return item
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b) {
                              return a.compareTo(b);
                            },
                            itemSubmitted: (item) async {
                              setState(() {
                                searchTextField.textField.controller.text =
                                    item;
                                citynameFromAutoField = item;

                                data = getWeatherByCityName(item);
                                farnTemp = null;
                                celsActiveColor = Colors.white;
                                farnActiveColor = Colors.black38;
//                                citynamecontroller.clear();
                                getWeatherByCityName(item);
                              });
                            },
                            itemBuilder: (context, item) {
                              //each suggestion UI.....
                              return row(item);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              if (citynamecontroller.text != '') {
                                setState(() {
                                  data = getWeatherByCityName(
                                      citynamecontroller.text);
                                  farnTemp = null;
                                  celsActiveColor = Colors.white;
                                  farnActiveColor = Colors.black38;
//                                citynamecontroller.clear();
                                  getWeatherByCityName(citynameFromAutoField);
                                });
                              } else {
                                 Fluttertoast.showToast(
                                    msg: "Plz Enter a City Name!!",
                                    textColor: Colors.red,
                                    gravity: ToastGravity.CENTER);
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    //Location Name
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 60),
                      alignment: Alignment.center,
                      child: Text(
                        "${model.name}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 25),
                      ),
                    ),

                    //Temp and Icon..
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Text(
                            //   '${temprature.toInt()}',
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w300,
                            //       color: Colors.white,
                            //       fontSize: 70),
                            // ),
                            farnTemp == null
                                ? Text(
                                    '${temprature.toInt()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        fontSize: 70),
                                  )
                                : farnTemp,

                            Column(
                              children: <Widget>[
                                InkWell(
                                  child: Text(
                                    " C°",
                                    style: TextStyle(
                                        fontSize: 50, color: celsActiveColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      celsActiveColor = Colors.white;
                                      farnActiveColor = Colors.black38;
//                                      temprature = temprature;
                                      farnTemp = null;
                                    });
                                  },
                                ),
                                InkWell(
                                  child: Text(
                                    " F°",
                                    style: TextStyle(
                                        fontSize: 50, color: farnActiveColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      farnActiveColor = Colors.white;
                                      celsActiveColor = Colors.black38;
//                                      temprature = (temprature * 9 / 5) + 32;
                                      farnTemp = tempShow('f');
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          '${model.weather[0].main}',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        Image.network(
                          "https://openweathermap.org/img/wn/${model.weather[0].icon}.png",
                        ),
                      ],
                    ),

                    //Date show....
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                      child: Text(
                        '${fm.format(new DateTime.fromMillisecondsSinceEpoch(model.dt * 1000))}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),

                    //info
                    DataTable(
                      headingRowHeight: 0,
                      horizontalMargin: 55,
                      dataRowHeight: MediaQuery.of(context).size.height / 13,
                      columns: [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text(""))
                      ],
                      rows: [
//sun rise.......
                        DataRow(
                          cells: [
                            DataCell(Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/icons/sunrise.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ],
                            )),
                            DataCell(
                              Text(
                                '${fm_hour.format(new DateTime.fromMillisecondsSinceEpoch(model.sys.sunrise * 1000))} AM',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          ],
                        ),
//sun site..........
                        DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/sunsit.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                '${fm_hour.format(new DateTime.fromMillisecondsSinceEpoch(model.sys.sunset * 1000))} AM',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          ],
                        ),
//wind speed.......
                        DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/windspeed.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(
                              "${windspeedInKiloHr.round()} Km/Hr",
                              style: TextStyle(color: Colors.white70),
                            ))
                          ],
                        ),
//wind direction..........
                        DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/winddirection.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
//                              Text("${model.wind.deg} Degree", style: TextStyle(color: Colors.white70),)
                                degreeShow())
                          ],
                        ),
//pressure.........
                        DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/icons/pressure.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                '${model.main.pressure} mbar',
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

//humidity.........

                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Humidity',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 10.0,
                            animation: true,
                            percent: model.main.humidity / 100,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${model.main.humidity} %',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0,
                                      color: Colors.white),
                                ),
                                Image.asset(
                                  "assets/icons/humidity.png",
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            );
          } else {
            return Center(
              child: SpinKitWave(
                size: 40,
                color: Colors.deepOrangeAccent,
                duration: Duration(seconds: 4),
              ),
            );
          }
        },
      ),
    );
  }

  Widget row(String item) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      width: MediaQuery.of(context).size.width / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            item,
            style: TextStyle(color: Colors.black, fontSize: 17),
          ),
          Text(
            'PK',
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget tempShow(String type) {
    if (type == 'c') {
      return Text(
        "$temprature",
        style: TextStyle(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 70),
      );
    } else if (type == 'f') {
      return Text(
        "${((temprature * 9 / 5) + 32).round()}",
        style: TextStyle(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 70),
      );
    } else {
      return Text(
        "$temprature",
        style: TextStyle(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 70),
      );
    }
  }
}
