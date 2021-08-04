import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ShowCountries extends StatefulWidget {
  @override
  _ShowCountriesState createState() => _ShowCountriesState();
}

class _ShowCountriesState extends State<ShowCountries> {
  List countries = List();
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text('Show Countries'),
              backgroundColor: Colors.indigo,
              centerTitle: true,
            ),
          ];
        },
        body: _biuldBody(),
      ),
    );
  }

  Widget _biuldBody() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (BuildContext context, int index) {
                  var country = countries[index];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Material(
                      elevation: 3.0,
                      child: ListTile(
                        title: Text(country['Country']),
                        trailing: Image.asset(
                          'assets/flags/${country['ISO2'].toLowerCase()}.png',
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _setData() async {
    var url = 'https://api.covid19api.com/countries';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('status:200');
      var jsonResponse = convert.jsonDecode(response.body);
      countries = jsonResponse;
    } else {
      print('something went wrong');
    }
    setState(() {
      loading = false;
    });
  }
}
