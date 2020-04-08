import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:weather_app/weatherbycity.dart';
import 'dart:convert';
import 'weathermodel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  var windDegree;
  var temprature;
  var celsTemp;
  var farnTemp;
  Color celsActiveColor = Colors.white;
  Color farnActiveColor = Colors.black38;
  var connectionstate = 'Unkuown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  String error;
  LocationData currentLocation;
  Location location = new Location();
  StreamSubscription<LocationData> locationSub;

//weather api data fetching method...
  Future<WeatherModel> getWeatherByLatLong(String lat, String lng) async {
    final response = await http.get(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=5bc7860bbc2cb9d232bd3ebe876cd446&units=metric");
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var model = WeatherModel.fromJason(result);

      windDegree = result['wind']['deg'];
      temprature = result['main']['temp'];

      return model;
    } else {
      throw Exception("can't Get Weather Data.....");
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

//internet connectivity checking...
  @override
  void initState() {
    super.initState();
//instance of the connectivity class...
    connectivity = new Connectivity();
//subscription veriable is listning to the change in the network connection.
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult connection) {
//inside listen...
//converting network staus to string and the checking in if statment...
      connectionstate = connection.toString();
      if (connectionstate == ConnectivityResult.mobile.toString() ||
          connectionstate == ConnectivityResult.wifi.toString()) {
//this empty set state is call to regain the state of the application on runtime when the user get connected to the net.
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Connection Error"),
              content: Text("Plz Check Your Internet Connection!!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    });

    initPlateformState();

    locationSub = location.onLocationChanged().listen((LocationData result) {
      setState(() {
        currentLocation = result;
      });
    });

//location get......
//    getLocation();
  }

//   void getLocation() {
// //check for errors .....
//   }
//initial platform funtion is used to check form exception occure during location get...
  void initPlateformState() async {
    LocationData my_location;
    try {
      my_location = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error =
            'Permission Denied. Please Ask the user to enable it from settings.';
      my_location = null;
    }
    setState(() {
      currentLocation = my_location;
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//in the body i make a statment that if the currentLocation has my location then load the data of my location
//else it will show a spinner or loader......
//this method is to handel the error that occures due to delay of location data fetching......
      body: Center(
        child: currentLocation == null
            ? SpinKitWave(
                size: 40,
                color: Colors.brown,
                duration: Duration(seconds: 4),
              )
            : FutureBuilder(
                future: getWeatherByLatLong(currentLocation.latitude.toString(),
                    currentLocation.longitude.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WeatherModel model = snapshot.data;
                    var fm = DateFormat.yMMMEd();
                    var fm_hour = DateFormat("hh:mm");
                    double windspeedInKiloHr = model.wind.speed * 18 / 5;
//            double farnTemp = (temprature * 9 / 5) + 32;
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
                          color: Colors.brown,
                        ),
//Data of Weather API Displying from here.....

                        ListView(
                          children: <Widget>[
//search icon
                            Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new CupertinoPageRoute(
                                          builder: (context) =>
                                              weatherByCity()));
                                },
                              ),
                            ),

//Location Name
                            Container(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 40),
                              alignment: Alignment.center,
                              // child: Text(
                              //   "${model.name}",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w400,
                              //       color: Colors.white,
                              //       fontSize: 25),
                              // ),
                              child: Icon(
                                Icons.home,
                                color: Colors.white,
                                size: 60,
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
                                                fontSize: 50,
                                                color: celsActiveColor),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              celsActiveColor = Colors.white;
                                              farnActiveColor = Colors.black38;
                                              temprature = temprature;
                                              farnTemp = null;
                                            });
                                          },
                                        ),
                                        InkWell(
                                          child: Text(
                                            " F°",
                                            style: TextStyle(
                                                fontSize: 50,
                                                color: farnActiveColor),
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
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 5),
                              child: Text(
                                '${fm.format(new DateTime.fromMillisecondsSinceEpoch(model.dt * 1000))}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),

//info
                            DataTable(
                              headingRowHeight: 0,
                              horizontalMargin: 55,
                              dataRowHeight:
                                  MediaQuery.of(context).size.height / 13,
                              columns: [
                                DataColumn(label: Text("")),
                                DataColumn(label: Text(""))
                              ],
                              rows: [
//sun rise.......
                                DataRow(
                                  cells: [
                                    DataCell(Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 18),
                                  ),
                                  CircularPercentIndicator(
                                    radius: 120.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    percent: model.main.humidity / 100,
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        color: Colors.brown,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                },
              ),
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
