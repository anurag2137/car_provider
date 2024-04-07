// Define your model class
class CarData {
  final int id;
  final String car_name;
  final String car_version;
  final String car_model;



  CarData({
    required this.id,
    required this.car_name,
    required this.car_version,
    required this.car_model,
   // required this.comment_list,
  });

  factory CarData.fromJson(Map<String, dynamic> data) {
    return CarData(
      id: data['id'],
      car_name: data['car_name'].toString(),
      car_version: data['car_version'].toString(),
      car_model: data['car_model'].toString(),
     // comment_list: commentList,
    );
  }
}