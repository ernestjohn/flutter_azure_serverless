
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_rest_api/rest_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Azure for Android'),
      ),
      body: FutureBuilder(
        future: ApiService.getEvents(),
        builder: (context, snapshot) {
          final events = snapshot.data;
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 2,
                  color: Colors.black,
                );
              },
              itemBuilder: (context, index) {
                
                //This is where the Event list is populated
                return ListTile(
                  title: Text(events[index]['name']),
                  subtitle: Text('Venue: ${events[index]['venue']}'),
                  
                );

              },
              itemCount: events.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewEventPage(),
            ),
          );
        },
        tooltip: 'New Event',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

class AddNewEventPage extends StatefulWidget {
  AddNewEventPage({Key key}) : super(key: key);

  _AddNewEventPageState createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  final _eventNameController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventAttendeesController = TextEditingController();
  final _eventVenueController = TextEditingController();
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Event'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(hintText: 'Event Name'),
              ),
              TextField(
                controller: _eventDateController,
                decoration: InputDecoration(hintText: 'Event Date'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _eventAttendeesController,
                decoration: InputDecoration(hintText: 'Number of Attendees'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _eventVenueController,
                decoration: InputDecoration(hintText: 'Venue'),
                keyboardType: TextInputType.datetime,
              ),
              RaisedButton(
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.purple,
                //This is where the Json is Built
                onPressed: () {
                  final body = {
                    "id": Uuid().generateV4(),
                    "name": _eventNameController.text,
                    "date": _eventDateController.text,
                    "attendees": _eventAttendeesController.text,
                    "venue": _eventVenueController.text,
                  };


                  ApiService.addEvent(body).then((success) {
                    if (success) {
                      showDialog(
                        builder: (context) => AlertDialog(
                          title: Text('Congratulations, Event has been added!'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                               
                                _eventNameController.text = '';
                                _eventDateController.text = '';
                                _eventAttendeesController.text = '';
                                _eventVenueController.text = '';
                              },
                              child: Text('OK'),
                            )
                          ],
                        ),
                        context: context,
                      );
                      return;
                    }else{
                      showDialog(
                        builder: (context) => AlertDialog(
                          title: Text('Error Adding Event!!!'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            )
                          ],
                        ),
                        context: context,
                      );
                      return;
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
