class Gotocamping {
  String id;
  late String camping_name;
  late String place;
  late DateTime startDate;
  late DateTime finishDate;
  late int num_ppl;
  late int num_employee;

  Gotocamping({
     this.id = '', // Provide a default value for 'id'
    required this.camping_name,
    required this.num_employee,
    required this.num_ppl,
    required this.place,
    required this.startDate,
    required this.finishDate,
  });

  // Getter for 'id'
  String get getId => id;

  set setName(String name) {
    camping_name = name;
  }

  set setPlace(String p) {
    place = p;
  }

  set setStartDate(DateTime date) {
    startDate = date;
  }

  set setFinishDate(DateTime date) {
    finishDate = date;
  }

  set setNumPeople(int num) {
    num_ppl = num;
  }

  set setNumEmployee(int num) {
    num_employee = num;
  }
}
