import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'custom_text_form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstInputController = TextEditingController();
  final TextEditingController secondInputController = TextEditingController();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String addition = '';
  String subtraction = '';
  String multiplication = '';
  String division = '';
  String exponent = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.calculator),
      ),
      body: Form(
        key: widget._formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.shortestSide > 550
                  ? MediaQuery.of(context).size.width * 0.5
                  : double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: widget.firstInputController,
                    label: AppLocalizations.of(context)!.firstNum,
                  ),
                  CustomTextFormField(
                    controller: widget.secondInputController,
                    label: AppLocalizations.of(context)!.secondNum,
                    isSecond: true,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: kPrimaryColor,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        if (widget._formKey.currentState!.validate()) {
                          calculate(widget.firstInputController.text,
                              widget.secondInputController.text);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.calculate,
                      ),
                    ),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.addition}$addition',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.subtraction}$subtraction',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.multiplication}$multiplication',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.division}$division',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.exponentiation}$exponent',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void calculate(String firstInput, String secondInput) {
    setState(() {
      addition = '${int.parse(firstInput) + int.parse(secondInput)}';
      subtraction = '${int.parse(firstInput) - int.parse(secondInput)}';
      multiplication =
          '${BigInt.parse(firstInput) * BigInt.parse(secondInput)}';
      division = '${int.parse(firstInput) / int.parse(secondInput)}';

      if (int.parse(secondInput) > 1000 && int.parse(secondInput).abs() != 1) {
        exponent = AppLocalizations.of(context)!
            .expTooBig; //An arbitrary value after multiple trials, the app crashes at large exponents due to lack of memory
        return;
      }
      BigInt exponentResult = BigInt.parse(firstInput).pow(
          int.parse(secondInput)
              .abs()); //BigInt pow() doesn't accept negative numbers
      if (int.parse(secondInput) < 0) {
        exponent =
            '${BigInt.from(1) / exponentResult}'; //to calculate negative power
      } else {
        exponent = '$exponentResult';
      }
    });
  }
}
