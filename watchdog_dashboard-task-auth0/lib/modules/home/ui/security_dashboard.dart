import 'package:intl/intl.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/model/camera_model.dart';
import 'package:watchdog_dashboard/modules/home/ui/video_preview_screen.dart';
import '../../../widgets/loading_widget.dart';
import '../bloc/camera_bloc.dart';
import 'timeline_widget.dart';

class SecurityDashboard extends StatelessWidget {
  const SecurityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool showAlerts = constraints.maxWidth >= 850;
      return Scaffold(
        body: Row(
          children: [
            const CameraSelectorRowWidget(),
            const Expanded(child: TimelineWidget()),
            if (showAlerts) const AlertWindowWidget(),
          ],
        ),
        endDrawer: Drawer(
          backgroundColor: context.colorScheme.surfaceContainer,
          shape: Border.all(color: Colors.transparent, width: 0),
          child: const AlertWindowWidget(),
        ),
        floatingActionButton: Visibility(
          visible: !showAlerts,
          child: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: const Icon(Icons.notification_important),
            );
          }),
        ),
      );
    });
  }
}

class CameraSelectorRowWidget extends StatefulWidget {
  const CameraSelectorRowWidget({super.key});

  @override
  State<CameraSelectorRowWidget> createState() =>
      _CameraSelectorRowWidgetState();
}

class _CameraSelectorRowWidgetState extends State<CameraSelectorRowWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CameraModel>(
      stream: CameraBloc.instance.cameraStream,
      builder: (context, snapshot) {
        return Container(
          width: 70,
          color: context.colorScheme.surfaceContainer,
          child: ListView.separated(
            itemCount: snapshot.data?.cameras.length ?? 0,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final selected = snapshot.data?.index == index;
              return GestureDetector(
                onTap: () {
                  CameraBloc.instance.changeIndex(index);
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(selected ? 16 : 100),
                      color: selected
                          ? context.colorScheme.inversePrimary
                          : context.colorScheme.surface,
                    ),
                    child: Center(
                      child: Text(
                        "C${index + 1}",
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AlertWindowWidget extends StatefulWidget {
  const AlertWindowWidget({super.key});

  @override
  State<AlertWindowWidget> createState() => _AlertWindowWidgetState();
}

class _AlertWindowWidgetState extends State<AlertWindowWidget> {
  String parseTime(DateTime time) {
    return DateFormat.yMd().add_jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          AppBar(
            title: const Text('All Alerts 🚩'),
            actions: const [SizedBox()],
          ),
          Expanded(
            child: StreamBuilder<List<AlertChatModel>>(
              stream: CameraBloc.instance.alertStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [LoadingWidget()],
                  );
                }
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(10),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final chat = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        CameraBloc.instance.changeIndex(chat.index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceDim,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: CustomEventTile1(
                          eventTime: chat.chatModel.videoOffset,
                          title:
                              'Camera ${chat.index + 1}: ${parseTime(chat.chatModel.timeStamp)}',
                          description: chat.chatModel.content,
                          videoUrl: chat.chatModel.videoUrl,
                          flagged: false,
                          onTapAlert: () {
                            CameraBloc.instance.alertDispatcher(chat);
                            setState(() {});
                          },
                          alerted: chat.dispatched,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomEventTile1 extends StatelessWidget {
  final String title;
  final String description;
  final String? videoUrl;
  final int? eventTime;
  final bool flagged;
  final bool alerted;
  final Function onTapAlert;

  const CustomEventTile1({
    super.key,
    required this.title,
    required this.description,
    this.videoUrl,
    required this.eventTime,
    required this.flagged,
    required this.onTapAlert,
    required this.alerted,
  });

  void onTap(BuildContext context, String videoUrl, int? eventTime) {
    context.push(VideoPreviewScreen(
      url: videoUrl,
      eventTime: eventTime,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: context.textTheme.labelMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            onTap(context, videoUrl!, eventTime);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.colorScheme.surface,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              'Watch Event',
              style: context.textTheme.titleSmall,
            ),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () {
            if (!alerted) onTapAlert();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: !alerted
                  ? context.colorScheme.errorContainer
                  : context.colorScheme.surfaceDim,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            child: Text(
              alerted ? 'Alerted ✅︎' : 'Alert Dispatcher',
              style: context.textTheme.titleSmall,

            ),
          ),
        ),
      ],
    );
  }
}
