enum ActivityStatus { ongoing, done }

class Activity {
  String name;
  String image;
  String id;
  String city;
  double price;
  ActivityStatus status;
  Activity({
    required this.name,
    required this.city,
    required this.id,
    required this.image,
    required this.price,
    this.status = ActivityStatus.ongoing,
  });
}
