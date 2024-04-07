import 'package:car_provider/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'API/function.dart';
import 'main.dart';

class PostDataForm extends StatefulWidget {
  const PostDataForm({super.key});

  @override
  _PostDataFormState createState() => _PostDataFormState();
}

class _PostDataFormState extends State<PostDataForm> {
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carVersionController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  late final _navigator = Navigator.of(context);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'POST YOUR CARS !',
          style: TextStyle(
            color: Colors.white,


          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/download1.jpeg'),
                fit: BoxFit.cover)),

        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please Enter some Text';
                      }
                      return null;
                    },
                    controller: _carNameController,
                    decoration: const InputDecoration(
                        labelText: 'Car Name',
                        labelStyle: TextStyle(color: Colors.white)
                    )
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please Enter some text';
                    }
                    return null;
                  },
                  controller: _carVersionController,
                  decoration: const InputDecoration(
                      labelText: 'Car Version',
                      labelStyle: TextStyle(color: Colors.white)
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please Enter some text';
                    }
                    return null;
                  },
                  controller: _carModelController,
                  decoration: const InputDecoration(
                      labelText: 'Car Model',
                      labelStyle: TextStyle(color: Colors.white)
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.brown[600]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],),
                    onPressed: ()  {
                      // Show circular progress indicator while waiting


                      try {
                        // Perform your data submission logic here
                        // For demonstration, I'm using a delay to simulate the submission process

                        // final result = await postData(
                        //   carName: _carNameController.text,
                        //   carVersion: _carVersionController.text,
                        //   carModel: _carModelController.text,
                        // );
                        authProvider.postData
                          (carName: _carNameController.text,
                            carVersion: _carVersionController.text ,
                            carModel:_carModelController.text,
                        );
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Success'),
                                content: Text('Your data is submitted'),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const CarGridScreen()),);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Error'),
                                content: Text('Failed to submit data'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context,
                                        MaterialPageRoute(builder: (context) => const CarGridScreen()),);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      } on Exception catch (exp) {
                        print(exp.toString());
                        // Handle error here
                      }

                      // Dismiss the progress dialog

                      // Show appropriate message based on submission result
                    },
                    child: const Text(
                      'Submit',

                      style: TextStyle(
                        color: Colors.white,

                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
