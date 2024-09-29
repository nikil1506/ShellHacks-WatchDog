import '../config.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: context.colorScheme.outlineVariant,
      width: double.infinity,
    );
  }
}
