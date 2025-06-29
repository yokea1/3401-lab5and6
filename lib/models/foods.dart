import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));


class Food {
    final String id;
    final String title;
    final List<String> foodTags;
    final List<String?> foodType;
    final String? code;
    final bool? isAvailable;
    final String? restaurant;
    final double? rating;
    final String? ratingCount;
    final String? description;
    final double price;
    final List<Additive> additives;
    final List<String> imageUrl;
    final int? v;
    final String? category;
    final String? time;
    bool? promotion;
    double? promotionPrice;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final DateTime? promStarts;
    final DateTime? promEnds;
    final bool? verified;

    Food({
        required this.id,
        required this.title,
        required this.foodTags,
        required this.foodType,
        this.code,
         this.isAvailable,
         this.restaurant,
         this.rating,
         this.ratingCount,
        required this.description,
        required this.price,
        required this.additives,
        required this.imageUrl,
         this.v,
        this.category,
         this.time,
        this.promotion,
        this.promotionPrice,
        this.createdAt,
        this.updatedAt,
        this.promStarts,
        this.promEnds,
        required this.verified,
    });

    factory Food.fromJson(Map<String, dynamic> json) {
        try{
            return Food(
                id: json["_id"],
                title: json["title"],
                foodTags: List<String>.from(json["foodTags"].map((x) => x)),
                foodType: List<String?>.from(json["foodType"].map((x) => x)),
                code: json["code"],
                isAvailable: json["isAvailable"],
                restaurant: json["restaurant"],
                rating: json["rating"]?.toDouble(),
                ratingCount: json["ratingCount"],
                description: json["description"],
                price: json["price"]?.toDouble(),
                additives: List<Additive>.from(json["additives"].map((x) => Additive.fromJson(x))),
                imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
                v: json["__v"],
                category: json["category"],
                time: json["time"],
                promotion: json["promotion"]??false,
                promotionPrice: json["promotionPrice"].toDouble(),
                verified: json["verified"],
                createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,  // Convert to DateTime
                updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
                promStarts: json["promStarts"] != null ? DateTime.parse(json["promStarts"]) : null,  // Convert to DateTime
                promEnds: json["promEnds"] != null ? DateTime.parse(json["promEnds"]) : null,
            );
        }catch(e, stackstrac){
            print("Error parsing response from restaurant item."
                " Exception: $e\nStacktrace: $stackstrac");
            throw Exception("Error parsing response from restaurant item: $e");
        }
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "foodTags": List<dynamic>.from(foodTags.map((x) => x)),
        "foodType": List<dynamic>.from(foodType.map((x) => x)),
        "code": code,
        "isAvailable": isAvailable,
        "restaurant": restaurant,
        "rating": rating,
        "ratingCount": ratingCount,
        "description": description,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "__v": v,
        "category": category,
        "time": time,
        "promotion":promotion,
        "promotionPrice":promotionPrice,
        "verified":verified,
        "createdAt": createdAt?.toIso8601String(),  // Convert DateTime to string
        "updatedAt": updatedAt?.toIso8601String(),
        "promStarts":promStarts?.toIso8601String(),
        "promEnds": promEnds?.toIso8601String(),
    };
}

class Additive {
    final int id;
    final String title;
    final String price;

    Additive({
        required this.id,
        required this.title,
        required this.price,
    });

    factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"],
        title: json["title"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
    };
}