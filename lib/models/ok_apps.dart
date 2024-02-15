class OkAppItem {
  final int id;
  final bool isPublished;
  final String firstPublishDate;
  final String iconUrl;
  final OkAppName name;
  final OkAppLink links;

  OkAppItem({
    required this.id,
    required this.isPublished,
    required this.firstPublishDate,
    required this.iconUrl,
    required this.name,
    required this.links,
  });

  factory OkAppItem.fromJson(Map<String, dynamic> json) {
    return OkAppItem(
      id: json['id'],
      isPublished: json['isPublished'],
      firstPublishDate: json['firstPublishDate'],
      iconUrl: json['iconUrl'],
      name: OkAppName.fromJson(json['name']),
      links: OkAppLink.fromJson(json['links']),
    );
  }
}

class OkAppName {
  final String tr;
  final String en;

  OkAppName({
    required this.tr,
    required this.en,
  });

  factory OkAppName.fromJson(Map<String, dynamic> json) {
    return OkAppName(
      tr: json['tr'],
      en: json['en'],
    );
  }
}

class OkAppLink {
  final String android;
  final String ios;

  OkAppLink({
    required this.android,
    required this.ios,
  });

  factory OkAppLink.fromJson(Map<String, dynamic> json) {
    return OkAppLink(
      android: json['android'],
      ios: json['ios'],
    );
  }
}
