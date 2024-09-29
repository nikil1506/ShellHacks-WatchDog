import 'package:watchdog_dashboard/config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinearProgressIndicator();
  }
}

class NoItemsWidget extends StatelessWidget {
  const NoItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'No Records',
      style: context.textTheme.titleMedium,
    );
  }
}
