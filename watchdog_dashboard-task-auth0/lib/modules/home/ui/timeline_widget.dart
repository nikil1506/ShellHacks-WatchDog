import 'package:flutter/scheduler.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/bloc/camera_bloc.dart';
import 'package:watchdog_dashboard/modules/home/ui/video_preview_screen.dart';
import 'package:watchdog_dashboard/tiles/dynamic_timeline_tile_flutter.dart';
import 'package:watchdog_dashboard/widgets/loading_widget.dart';
import '../../../widgets/divider.dart';
import '../../login/bloc/user_bloc.dart';
import '../model/camera_model.dart';
import '../utils.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Timeline'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                UserBloc.instance.logOut();
              },
              icon: Icon(
                Icons.logout,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const DividerWidget(),
        const Expanded(child: TimelinePromptWidget()),
      ],
    );
  }
}

class TimelinePromptWidget extends StatefulWidget {
  const TimelinePromptWidget({super.key});

  @override
  State<TimelinePromptWidget> createState() => _TimelinePromptWidgetState();
}

class _TimelinePromptWidgetState extends State<TimelinePromptWidget> {
  final CameraBloc bloc = CameraBloc.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CameraModel>(
      stream: bloc.cameraStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingWidget(),
            ],
          );
        }
        int cIndex = snapshot.data!.index;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: MultiDynamicTimelineTileBuilder(
              itemCount: snapshot.data!.cameras[cIndex].length,
              itemBuilder: (context, index) {
                final chats =
                snapshot.data!.cameras[cIndex].values.elementAt(index);
                final date =
                snapshot.data!.cameras[cIndex].keys.elementAt(index);
                return MultiDynamicTimelineTile(
                  itemCount: chats.length,
                  crossSpacing: 15,
                  mainSpacing: 8,
                  indicatorRadius: 6,
                  indicatorWidth: 1,
                  starerChild: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Text(
                        date,
                        style: context.textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                  eventsList: [
                    chats.map((chat) {
                      return EventCard(
                        cardRadius: BorderRadius.circular(20),
                        cardColor: chat.flagged
                            ? context.colorScheme.errorContainer
                            : context.colorScheme.surfaceContainer,
                        child: CustomEventTile(
                          title: DateFormatUtils.parseTime(chat.timeStamp),
                          description: chat.content,
                          videoUrl: chat.videoUrl,
                          eventTime: chat.videoOffset,
                          flagged: chat.flagged,
                        ),
                      );
                    }).toList()
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DateTranscriptionModel {
  final DateTime date;
  final List<TranscriptionModel> chats;

  DateTranscriptionModel({required this.date, required this.chats});
}

class CustomEventTile extends StatelessWidget {
  final String title;
  final String description;
  final String? videoUrl;
  final int? eventTime;
  final bool flagged;

  const CustomEventTile({
    super.key,
    required this.title,
    required this.description,
    this.videoUrl,
    required this.eventTime,
    required this.flagged,
  });

  void onTap(BuildContext context, String videoUrl, int? eventTime) {
    context.push(VideoPreviewScreen(
      url: videoUrl,
      eventTime: eventTime,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (videoUrl != null) ...[
          GestureDetector(
            onTap: () {
              onTap(context, videoUrl!, eventTime);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: context.colorScheme.surface,
              ),
              width: 50,
              height: 50,
              child: Icon(
                Icons.play_arrow,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ],
    );
  }
}


