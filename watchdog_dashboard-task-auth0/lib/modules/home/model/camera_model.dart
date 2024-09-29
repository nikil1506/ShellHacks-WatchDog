class CameraModel {
  final List<Map<String, List<TranscriptionModel>>> cameras;
  final int index;

  CameraModel({required this.cameras, required this.index});

  CameraModel copyWith({
    List<Map<String, List<TranscriptionModel>>>? cameras,
    int? index,
  }) {
    return CameraModel(
      cameras: cameras ?? this.cameras,
      index: index ?? this.index,
    );
  }
}

class AlertChatModel {
  final TranscriptionModel chatModel;
  final int index;
  final bool dispatched;

  AlertChatModel({
    required this.dispatched,
    required this.chatModel,
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatModel': chatModel.toMap(),
      'index': index,
    };
  }

  factory AlertChatModel.fromMap(
      Map<String, dynamic> map, String id, bool dispatched) {
    return AlertChatModel(
      dispatched: dispatched,
      chatModel: TranscriptionModel.fromMap(map['chatModel'], id),
      index: map['index'] as int,
    );
  }
}

class TranscriptionModel {
  final String content;
  final DateTime timeStamp;
  final String? videoUrl;
  final int? videoOffset;
  final bool flagged;
  final String id;

  TranscriptionModel({
    required this.content,
    required this.timeStamp,
    required this.id,
    this.flagged = false,
    this.videoUrl,
    this.videoOffset,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': content,
      'timestamp': timeStamp.toString(),
      'video_url': videoUrl,
      'offset': videoOffset,
      'threat_level': flagged,
    };
  }

  factory TranscriptionModel.fromMap(Map<String, dynamic> map, String id) {
    return TranscriptionModel(
      id: id,
      content: map['description'] as String,
      timeStamp: DateTime.parse((map['timestamp'] as String)),
      videoUrl: map['video_url'] as String,
      videoOffset: map['offset'] as int,
      flagged: map['threat_level'] as bool,
    );
  }
}
