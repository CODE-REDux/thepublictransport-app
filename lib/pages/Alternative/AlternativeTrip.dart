import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:sprung/next.dart';
import 'package:thepublictransport_app/backend/models/main/Trip.dart';
import 'package:thepublictransport_app/framework/theme/ThemeEngine.dart';
import 'package:thepublictransport_app/framework/time/UnixTimeParser.dart';
import 'package:thepublictransport_app/pages/Alternative/AlternativeFlixbus.dart';
import 'package:thepublictransport_app/pages/Alternative/AlternativeSparpreis.dart';
import 'package:thepublictransport_app/ui/animations/Marquee.dart';

class AlternativeTrip extends StatefulWidget {
  final Trip trip;

  const AlternativeTrip({Key key, this.trip}) : super(key: key);

  @override
  _AlternativeTripState createState() => _AlternativeTripState(trip);
}

class _AlternativeTripState extends State<AlternativeTrip> {
  final Trip trip;

  _AlternativeTripState(this.trip);

  PageController _pageController = new PageController();
  int _selectedIndex = 0;

  var theme = ThemeEngine.getCurrentTheme();

  @override
  Widget build(BuildContext context) {
    var time = UnixTimeParser.parse(trip.firstDepartureTime);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      floatingActionButton: FloatingActionButton(
        heroTag: "HEROOOO2",
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: theme.floatingActionButtonColor,
        child: Icon(Icons.arrow_back, color: theme.floatingActionButtonIconColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: theme.backgroundColor,
        opacity: .2,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Sprung.overDamped());
        }),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.center, //new
        hasNotch: true, //new
        hasInk: true,
        inkColor: Colors.black12,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.train,
                color: theme.iconColor,
              ),
              activeIcon: Icon(
                Icons.train,
                color: Colors.red,
              ),
              title: Text("Deutsche Bahn")
          ),
          BubbleBottomBarItem(
              backgroundColor: Colors.lightGreen,
              icon: Icon(
                Icons.directions_bus,
                color: theme.iconColor,
              ),
              activeIcon: Icon(
                Icons.directions_bus,
                color: Colors.lightGreen,
              ),
              title: Text("Flixbus")
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "Günstige Alternative",
                    style: TextStyle(
                        color: theme.titleColor,
                        fontSize: 30,
                        fontFamily: 'NunitoSansBold'
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Von:", style: TextStyle(color: theme.textColor)),
                              Text("Nach:", style: TextStyle(color: theme.textColor))
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Marquee(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    trip.from.name + (trip.from.place != null ? ", " + trip.from.place : ""),
                                    style: TextStyle(
                                        fontFamily: 'NunitoSansBold',
                                        color: theme.textColor
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Marquee(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    trip.to.name + (trip.to.place != null ? ", " + trip.to.place : ""),
                                    style: TextStyle(
                                        fontFamily: 'NunitoSansBold',
                                        color: theme.textColor
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            time.hour.toString() + ":" + time.minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                                color: theme.textColor
                            ),
                          ),
                          Text(
                            time.day.toString().padLeft(2, '0') + "." + time.month.toString().padLeft(2, '0') + "." + time.year.toString().padLeft(4, '0'),
                            style: TextStyle(
                                color: theme.textColor
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              controller: _pageController,
              children: <Widget>[
                AlternativeSparpreis(fromID: trip.from.id, toID: trip.to.id, dateTime: time),
                AlternativeFlixbus(fromID: trip.from.id, toID: trip.to.id, dateTime: time),
              ],
            ),
          ),
        ],
      ),
    );
  }
}