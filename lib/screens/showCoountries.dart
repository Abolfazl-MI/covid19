import 'package:covid19/screens/countryPersianName.dart';
import 'package:covid19/screens/showcountryinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCountries extends StatefulWidget {
  @override
  _ShowCountriesState createState() => _ShowCountriesState();
}

class _ShowCountriesState extends State<ShowCountries> {
  List iteam = List();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(
                  'نمایش لیست کشور ها ',
                  style: TextStyle(fontFamily: 'Yekan'),
                ),
                backgroundColor: Colors.indigo,
                centerTitle: true,
              ),
            ];
          },
          body: _biuldBody(),
        ),
      ),
    );
  }

  Widget _biuldBody() {
    if (loading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitRing(
            color: Colors.indigo[700],
            lineWidth: 3.5,
          ),
          SizedBox(height: 10),
          Text(
            'در حال دریافت اطلاعات',
            style: TextStyle(
                fontFamily: 'Yekan', fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      );
    }
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, left: 8, right: 8),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: (String value) {
                iteam.clear();
                if (value.isEmpty) {
                  iteam.addAll(countries);
                } else {
                  countries.forEach((element) {
                    if (element['Country']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        element['PersianName']
                            .toString()
                            .toLowerCase()
                            .contains(value)) {
                      iteam.add(element);
                    }
                  });
                }

                setState(() {});
              },
              decoration: InputDecoration(
                  // enabled: false,
                  hintText: 'جستجو',
                  prefixIcon: Icon(CupertinoIcons.search),
                  border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(25)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: iteam.length,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  var country = iteam[index];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Material(
                      elevation: 3.0,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowInfo(
                                        country: country,
                                      )));
                        },
                        title: Text(
                          country['PersianName'],
                          style: TextStyle(fontSize: 20, fontFamily: 'Yekan'),
                        ),
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

  Widget _loading() {}

  void _setData() async {
    var url = 'https://api.covid19api.com/countries';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('status:200');
      List jsonResponse = convert.jsonDecode(response.body);
      jsonResponse.forEach((element) {
        element['PersianName'] =
            convertCountryISO2ToPersianName[element['ISO2']];
        print(element);
      });
      countries = jsonResponse;
      iteam.addAll(jsonResponse);
    } else {
      print('something went wrong');
    }
    setState(() {
      loading = false;
    });
  }
}
