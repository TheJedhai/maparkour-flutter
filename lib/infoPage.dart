import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maparkour/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(InfoPage());
}

class InfoPage extends StatefulWidget {
  var spot;
  InfoPage({Key key, @required this.spot}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

List buildImageList(List imagesStings) {
  List finalImages = [];
  for (var photo in imagesStings) {
    finalImages.add(Image.network(photo));
  }
  return finalImages;
}

class _InfoPageState extends State<InfoPage> {
  List carouselImages;
  // LatLng _center;
  @override
  void initState() {
    super.initState();
    carouselImages = buildImageList(widget.spot['img']);
  }

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  static final MarkerId markerId = MarkerId('mainLocation');

  @override
  Widget build(BuildContext context) {
    String userName = '';
    final FirebaseAuth fireAuth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          centerTitle: true,
          title: Container(
            height: 30.0,
            child: Image.asset('img/maparkor-black.png'),
          ),
        ),
        endDrawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            Container(
              height: 80.0,
              child: DrawerHeader(
                child: Text(
                  userName,
                  // style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent[700],
                ),
              ),
            ),
            ListTile(
              title: Text('Cadastre um novo pico'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Sair da conta'),
              onTap: () {
                fireAuth.signOut();
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MainApp()));
              },
            ),
          ]),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  widget.spot['name'],
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              CarouselSlider(
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                items: carouselImages.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 3.0),
                        // decoration: BoxDecoration(color: Colors.black),
                        child: i,
                      );
                    },
                  );
                }).toList(),
              ),
              Center(
                child: Text('Arraste para o lado para carregar mais fotos'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width * 0.9,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.spot['coordinates'].latitude,
                        widget.spot['coordinates'].longitude),
                    zoom: 17.0,
                  ),
                  markers: Set<Marker>.of({
                    Marker(
                      markerId: markerId,
                      position: LatLng(widget.spot['coordinates'].latitude,
                          widget.spot['coordinates'].longitude),
                      infoWindow:
                          InfoWindow(title: widget.spot['name'], snippet: '*'),
                      onTap: () {
                        // _onMarkerTapped(markerId);
                      },
                    )
                  }),
                ),
              )
            ],
          ),
        ));
  }
}
