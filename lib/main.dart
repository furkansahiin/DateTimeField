  // Furkan SAHIN
  // Istanbul Rumeli University
  // Computer Engineer
  // Furkaniha@gmail.com


  // Flutterda hazır olarak sunulan DateTimeField widgetımızı kendi fonksiyonlarını kullanarak 
  // başlangıç ve bitiş olmak üzere iki dateTimeField'ımızı birbiriyle iletişim halide yaptım 
  // buradaki amaç başlangıç tarihi bitişi geçemez bitiş tarihi de başlangıçtan düşük olamaz 
  // ve bu seçilen tarihleri ekrana card olarak atadığım alana yazdırıyor eğer hiçbir işlem
  // yapmazsak(seçim yapılmazsa) otomatik tanımlanan değer atanıyor. 

  //! Not : Eğer kodu kullanacaksanız pubspec.yaml dosyanızın içerisinde bulunan 'dev_dependencies:' 
  //! kısmının altına güncel pub.dev sitesinden date time classını import ediniz. 
  //! örneğin ; 'datetime_picker_formfield: ^2.0.1'


import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

final format = DateFormat("yyyy-MM-dd HH:mm");

String result = '';

class _MyAppState extends State<MyApp> {
  DateTime? _fromfirstDate;
  DateTime? _fromendDate;

  DateTime newValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
        // ignore: prefer_const_literals_to_create_immutables
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text(
            "Date Time Field",
            
          ),
          backgroundColor: Colors.green,
          
          toolbarHeight: 80,
        ),

        body: ListView(children: [
          const SizedBox(
            height: 30.0,
          ),
          Text('Başlangıç Tarihi Giriniz.'),
          DateTimeField(
            initialValue:
                DateTime.now().subtract(Duration(days: DateTime.now().month)),
            format: format,
            onChanged: (DateTime? newValue) {
              setState(() {
                _fromfirstDate = newValue;
              });
            },
            onShowPicker: (context, currentValue) async {
              final _startdate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime.now());
              if (_startdate != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(_startdate, time);
              } else {
                return currentValue;
              }
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text('Bitiş Tarihi Giriniz.'),
          DateTimeField(
            initialValue: DateTime.now().add(Duration(days: 1)),
            format: format,
            keyboardType: TextInputType.datetime,
            onChanged: (newValue) {
              setState(() {
                _fromendDate = newValue;
              });
            },
            onShowPicker: (context, currentValue) async {
              if (_fromfirstDate != null) {
                final _dateend = await showDatePicker(
                    context: context,
                    firstDate: DateTime.parse(_fromfirstDate.toString()),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 1)));
                if (_dateend != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(_dateend, time);
                }
              }
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (_fromfirstDate == null) {
                setState(() {
                  _fromfirstDate = DateTime.now()
                      .subtract(Duration(days: DateTime.now().month));
                  _fromendDate = DateTime.now().add(Duration(days: 1));
                  result = "Başlangıç Tarihi : " +
                      _fromfirstDate.toString() +
                      "\nBitiş Tarihi : " +
                      _fromendDate.toString();
                });
              } else if (_fromendDate == null) {
                setState(() {
                  _fromendDate = DateTime.now().add(Duration(days: 1));
                  result = "Başlangıç Tarihi : " +
                      _fromfirstDate.toString() +
                      "\nBitiş Tarihi : " +
                      _fromendDate.toString();
                });
              } else {
                setState(() {
                  result = "Başlangıç Tarihi : " +
                      _fromfirstDate.toString() +
                      "\nBitiş Tarihi : " +
                      _fromendDate.toString();
                });
              }
            },
            child: const Text('Göster',
                style: TextStyle(color: Colors.white, fontSize: 24)),
            style: ElevatedButton.styleFrom(
                // foregroundColor: Colors.green,
                fixedSize: const Size(75, 75),
                shape: const CircleBorder(),
                backgroundColor: Colors.green),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                style: BorderStyle.solid,
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(children: [
              Text(result),
            ]),
          )
        ]),
      ),
    );
  }
}
