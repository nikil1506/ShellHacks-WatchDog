import 'package:intl/intl.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/bloc/camera_bloc.dart';
import 'package:watchdog_dashboard/modules/home/model/camera_model.dart';
import 'package:watchdog_dashboard/modules/home/ui/video_preview_screen.dart';
import 'package:watchdog_dashboard/modules/home/utils.dart';
import 'package:watchdog_dashboard/modules/login/bloc/user_bloc.dart';
import 'package:watchdog_dashboard/widgets/loading_widget.dart';

class DispatcherDashboard extends StatefulWidget {
  const DispatcherDashboard({super.key});

  @override
  State<DispatcherDashboard> createState() => _DispatcherDashboardState();
}

class _DispatcherDashboardState extends State<DispatcherDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text('Dispatcher Dashboard'),
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
          Expanded(
            child: StreamBuilder<List<AlertChatModel>>(
                stream: CameraBloc.instance.dispatcherStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [NoItemsWidget()],
                    );
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [NoItemsWidget()],
                    );
                  }
                  return LayoutBuilder(builder: (context, constraints) {
                    return Center(
                      child: SizedBox(
                        width: constraints.maxWidth > 450
                            ? 450
                            : constraints.maxWidth,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final event = snapshot.data![index];
                            return CustomEventTile2(model: event);
                          },
                        ),
                      ),
                    );
                  });
                }),
          ),
        ],
      ),
    );
  }
}

class CustomEventTile2 extends StatelessWidget {
  final AlertChatModel model;

  const CustomEventTile2({
    super.key,
    required this.model,
  });

  void onTap(BuildContext context, String videoUrl, int? eventTime) {
    context.push(VideoPreviewScreen(
      url: videoUrl,
      eventTime: eventTime,
    ));
  }

  String parseTime(DateTime time) {
    return DateFormat.yMd().add_jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.colorScheme.errorContainer,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Camera ${model.index + 1}',
            style: context.textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            parseTime(model.chatModel.timeStamp),
            style: context.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            model.chatModel.content,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onTap(context, model.chatModel.videoUrl!,
                        model.chatModel.videoOffset!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.colorScheme.surface,
                    ),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      'Watch Event',
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MapUtils.openMap(25.7574, -80.3733);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.colorScheme.surfaceDim,
                    ),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text(
                      'Get Directions',
                      style: context.textTheme.titleSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
