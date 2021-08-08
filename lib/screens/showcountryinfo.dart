import 'package:persian_date/persian_date.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ShowInfo extends StatefulWidget {
  final country;
  ShowInfo({this.country});
  @override
  _ShowInfoState createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  List more_info = List();
  bool loading = true;
  PersianDate persianDate = PersianDate();
  var toDate;
  var fromDate;
  var date = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toDate = date.toString().split(' ')[0];
    fromDate =
        DateTime(date.year, date.month - 1, date.day).toString().split(' ')[0];

    _setData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.indigo[600],
                  centerTitle: true,
                  actions: [
                    Image.asset('assets/flags/${widget.country['ISO2']}.png'
                        .toLowerCase()),
                  ],
                  title: Text(
                    '${widget.country['PersianName']}'.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Yekan',
                      color: Colors.white,
                    ),
                  ),
                  elevation: 7,
                  brightness: Brightness.dark,
                )
              ];
            },
            body: _biuldBody()),
      ),
    );
  }

  Widget _biuldBody() {
    return Column(children: [
      Expanded(
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: more_info.length,
              itemBuilder: (BuildContext context, int index) {
                var showinfo = more_info[index];
                if (index == 0) {
                  print('has done');
                  return Container();
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Material(
                    shadowColor: Colors.indigo.withOpacity(0.5),
                    elevation: 3,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'مبتلایان جدید :${more_info[index]['Confirmed'] - more_info[index - 1]['Confirmed']}',
                            style: TextStyle(
                                fontFamily: 'Yekan',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'فوتی ها    :${more_info[index]['Deaths'] - more_info[index - 1]['Deaths']}',
                            style: TextStyle(
                                fontFamily: 'Yekan',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Text(
                            ' بیماران بستری  :${more_info[index]['Active'] - more_info[index - 1]['Active']}',
                            style: TextStyle(
                                fontFamily: 'Yekan',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '${persianDate.gregorianToJalali(showinfo['Date'], "yyyy\/m\/d ")}',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ),
                );
              }))
    ]);
  }

  void _setData() async {
    var url =
        'https://api.covid19api.com/country/${widget.country['Slug']}?from=${fromDate}T00:00:00Z&to=${toDate}T00:00:00Z';
    print(url);
    var responce = await http.get(url);
    if (responce.statusCode == 200) {
      var jsonResponc = convert.jsonDecode(responce.body);
      more_info.addAll(jsonResponc);
    }
    setState(() {
      loading = false;
    });
  }
}
