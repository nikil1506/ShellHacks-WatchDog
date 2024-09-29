import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watchdog_dashboard/modules/home/model/camera_model.dart';
import 'package:watchdog_dashboard/modules/home/utils.dart';

class CameraBloc {
  static CameraBloc get instance => _instance ??= CameraBloc._();

  static CameraBloc? _instance;

  CameraBloc._() {
    loadData();
  }

  final BehaviorSubject<CameraModel> _cameraSubject =
      BehaviorSubject<CameraModel>();

  final BehaviorSubject<List<AlertChatModel>> _alertSubject =
      BehaviorSubject<List<AlertChatModel>>();

  final BehaviorSubject<List<AlertChatModel>> _dispatcherSubject =
      BehaviorSubject<List<AlertChatModel>>();

  Stream<CameraModel> get cameraStream => _cameraSubject.stream;

  Stream<List<AlertChatModel>> get alertStream => _alertSubject.stream;

  Stream<List<AlertChatModel>> get dispatcherStream =>
      _dispatcherSubject.stream;

  CameraModel cameraModel = CameraModel(cameras: [{}, {}], index: 0);

  List<AlertChatModel> dispatches = [];

  final db = FirebaseFirestore.instance;

  StreamSubscription? _subscription1;
  StreamSubscription? _subscription2;
  StreamSubscription? _subscription3;

  void loadData() async {
    _subscription1 = db
        .collection("cam0")
        .snapshots()
        .listen((event) => _loadData(event.docs, 0));
    await Future.delayed(const Duration(milliseconds: 100));
    _subscription2 = db
        .collection("cam1")
        .snapshots()
        .listen((event) => _loadData(event.docs, 1));
    _subscription3 = db
        .collection("dispatched_events")
        .snapshots()
        .listen((event) => _loadDispatchedAlerts(event.docs));
  }

  void _loadData(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots, int index) {
    for (var element in snapshots) {
      final transcript = TranscriptionModel.fromMap(element.data(), element.id);
      final date = DateFormatUtils.parseDate(transcript.timeStamp);
      if (cameraModel.cameras[index].containsKey(date)) {
        cameraModel.cameras[index][date]!.add(transcript);
      } else {
        cameraModel.cameras[index][date] = [transcript];
      }
    }
    _cameraSubject.sink.add(cameraModel);
    _updateAlerts();
  }

  void _updateAlerts() {
    final List<AlertChatModel> alerts = [];
    for (var element in cameraModel.cameras) {
      element.forEach(
        (key, value) {
          for (var element2 in value) {
            if (element2.flagged) {
              alerts.add(AlertChatModel(
                chatModel: element2,
                index: (element == cameraModel.cameras[0]) ? 0 : 1,
                dispatched: !dispatches
                    .every((nElement) => nElement.chatModel.id != element2.id),
              ));
            }
          }
        },
      );
    }
    _alertSubject.sink.add(alerts);
  }

  void changeIndex(int index) {
    _cameraSubject.sink.add(cameraModel.copyWith(index: index));
  }

  void alertDispatcher(AlertChatModel model) {
    db
        .collection("dispatched_events")
        .doc(model.chatModel.id)
        .set(model.toMap());
  }

  void _loadDispatchedAlerts(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    dispatches = [];
    for (var element in snapshots) {
      dispatches.add(AlertChatModel.fromMap(element.data(), element.id, true));
    }
    _dispatcherSubject.sink.add(dispatches);
    _updateAlerts();
  }

  void dispose() {
    _subscription1?.cancel();
    _subscription2?.cancel();
    _subscription3?.cancel();
    _cameraSubject.close();
    _alertSubject.close();
  }
}
