import 'dart:convert';

List<HomeDataModel> homeDataModelFromJson(String str) =>
    List<HomeDataModel>.from(
        json.decode(str).map((x) => HomeDataModel.fromJson(x)));

class HomeDataModel {
  String? id;
  int? width;
  int? height;
  String? altDescription;
  Urls? urls;
  int? likes;

  HomeDataModel({
    this.id,
    this.width,
    this.height,
    this.altDescription,
    this.urls,
    this.likes,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        altDescription: json["alt_description"],
        urls: json["urls"] == null ? null : Urls.fromJson(json["urls"]),
        likes: json["likes"],
      );
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;

  Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });

  factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
      );
}
