class PassagerModel {
  String? sId;
  String? name;
  int? trips;
  List<Airline>? airline;
  int? iV;

  PassagerModel({this.sId, this.name, this.trips, this.airline, this.iV});

  PassagerModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    trips = json['trips'];
    if (json['airline'] != null) {
      airline = <Airline>[];
      json['airline'].forEach((v) {
        airline!.add(new Airline.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['trips'] = this.trips;
    if (this.airline != null) {
      data['airline'] = this.airline!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Airline {
  int? id;
  String? name;
  String? country;
  String? logo;
  String? slogan;
  String? headQuaters;
  String? website;
  String? established;

  Airline(
      {this.id,
      this.name,
      this.country,
      this.logo,
      this.slogan,
      this.headQuaters,
      this.website,
      this.established});

  Airline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    logo = json['logo'];
    slogan = json['slogan'];
    headQuaters = json['head_quaters'];
    website = json['website'];
    established = json['established'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    data['logo'] = this.logo;
    data['slogan'] = this.slogan;
    data['head_quaters'] = this.headQuaters;
    data['website'] = this.website;
    data['established'] = this.established;
    return data;
  }
}