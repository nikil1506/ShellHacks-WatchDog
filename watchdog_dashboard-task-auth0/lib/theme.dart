import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff001140),
      surfaceTint: Color(0xff465b9d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff193070),
      onPrimaryContainer: Color(0xffb2c2ff),
      secondary: Color(0xff565d79),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdde2ff),
      onSecondaryContainer: Color(0xff404862),
      tertiary: Color(0xff290039),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4d215e),
      onTertiaryContainer: Color(0xffe8b0f8),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1b1b20),
      onSurfaceVariant: Color(0xff444650),
      outline: Color(0xff757681),
      outlineVariant: Color(0xffc5c6d2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3035),
      inversePrimary: Color(0xffb5c4ff),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff00164d),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff2d4384),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff131a33),
      secondaryFixedDim: Color(0xffbec5e5),
      onSecondaryFixedVariant: Color(0xff3e4660),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff310343),
      tertiaryFixedDim: Color(0xffebb3fb),
      onTertiaryFixedVariant: Color(0xff623472),
      surfaceDim: Color(0xffdbd9df),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f3f9),
      surfaceContainer: Color(0xffefedf3),
      surfaceContainerHigh: Color(0xffe9e7ee),
      surfaceContainerHighest: Color(0xffe3e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff001140),
      surfaceTint: Color(0xff465b9d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff193070),
      onPrimaryContainer: Color(0xfff2f2ff),
      secondary: Color(0xff3b425c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6c7390),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff290039),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4d215e),
      onTertiaryContainer: Color(0xffffedff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1b1b20),
      onSurfaceVariant: Color(0xff40424c),
      outline: Color(0xff5d5e69),
      outlineVariant: Color(0xff797a85),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3035),
      inversePrimary: Color(0xffb5c4ff),
      primaryFixed: Color(0xff5d72b5),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff44599b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6c7390),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff545b76),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9362a3),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff794989),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdbd9df),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f3f9),
      surfaceContainer: Color(0xffefedf3),
      surfaceContainerHigh: Color(0xffe9e7ee),
      surfaceContainerHighest: Color(0xffe3e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff001140),
      surfaceTint: Color(0xff465b9d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff193070),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1a213a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3b425c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff290039),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4d215e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff21242d),
      outline: Color(0xff40424c),
      outlineVariant: Color(0xff40424c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3035),
      inversePrimary: Color(0xffe8ebff),
      primaryFixed: Color(0xff293f7f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0e2868),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3b425c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff242c45),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5d306e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff451856),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdbd9df),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f3f9),
      surfaceContainer: Color(0xffefedf3),
      surfaceContainerHigh: Color(0xffe9e7ee),
      surfaceContainerHighest: Color(0xffe3e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb5c4ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff132c6c),
      primaryContainer: Color(0xff001954),
      onPrimaryContainer: Color(0xff92a7ef),
      secondary: Color(0xffbec5e5),
      onSecondary: Color(0xff282f49),
      secondaryContainer: Color(0xff383f59),
      onSecondaryContainer: Color(0xffcdd4f4),
      tertiary: Color(0xffebb3fb),
      onTertiary: Color(0xff491c5a),
      tertiaryContainer: Color(0xff350646),
      onTertiaryContainer: Color(0xffcc96dc),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121317),
      onSurface: Color(0xffe3e2e8),
      onSurfaceVariant: Color(0xffc5c6d2),
      outline: Color(0xff8f909b),
      outlineVariant: Color(0xff444650),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e2e8),
      inversePrimary: Color(0xff465b9d),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff00164d),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff2d4384),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff131a33),
      secondaryFixedDim: Color(0xffbec5e5),
      onSecondaryFixedVariant: Color(0xff3e4660),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff310343),
      tertiaryFixedDim: Color(0xffebb3fb),
      onTertiaryFixedVariant: Color(0xff623472),
      surfaceDim: Color(0xff121317),
      surfaceBright: Color(0xff38393e),
      surfaceContainerLowest: Color(0xff0d0e12),
      surfaceContainerLow: Color(0xff1b1b20),
      surfaceContainer: Color(0xff1f1f24),
      surfaceContainerHigh: Color(0xff292a2e),
      surfaceContainerHighest: Color(0xff343439),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbbc9ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff001241),
      primaryContainer: Color(0xff798ed4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc3c9ea),
      onSecondary: Color(0xff0d152d),
      secondaryContainer: Color(0xff8890ae),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffefb7ff),
      onTertiary: Color(0xff2a003b),
      tertiaryContainer: Color(0xffb27ec1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121317),
      onSurface: Color(0xfffcfaff),
      onSurfaceVariant: Color(0xffc9cad6),
      outline: Color(0xffa1a2ae),
      outlineVariant: Color(0xff81828e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e2e8),
      inversePrimary: Color(0xff2f4485),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff000d36),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff1a3272),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff081028),
      secondaryFixedDim: Color(0xffbec5e5),
      onSecondaryFixedVariant: Color(0xff2e354f),
      tertiaryFixed: Color(0xfff9d8ff),
      onTertiaryFixed: Color(0xff220030),
      tertiaryFixedDim: Color(0xffebb3fb),
      onTertiaryFixedVariant: Color(0xff4f2360),
      surfaceDim: Color(0xff121317),
      surfaceBright: Color(0xff38393e),
      surfaceContainerLowest: Color(0xff0d0e12),
      surfaceContainerLow: Color(0xff1b1b20),
      surfaceContainer: Color(0xff1f1f24),
      surfaceContainerHigh: Color(0xff292a2e),
      surfaceContainerHighest: Color(0xff343439),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffcfaff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffbbc9ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffcfaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc3c9ea),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffefb7ff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121317),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffcfaff),
      outline: Color(0xffc9cad6),
      outlineVariant: Color(0xffc9cad6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e2e8),
      inversePrimary: Color(0xff092565),
      primaryFixed: Color(0xffe1e6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbbc9ff),
      onPrimaryFixedVariant: Color(0xff001241),
      secondaryFixed: Color(0xffe1e6ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc3c9ea),
      onSecondaryFixedVariant: Color(0xff0d152d),
      tertiaryFixed: Color(0xfffbddff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffefb7ff),
      onTertiaryFixedVariant: Color(0xff2a003b),
      surfaceDim: Color(0xff121317),
      surfaceBright: Color(0xff38393e),
      surfaceContainerLowest: Color(0xff0d0e12),
      surfaceContainerLow: Color(0xff1b1b20),
      surfaceContainer: Color(0xff1f1f24),
      surfaceContainerHigh: Color(0xff292a2e),
      surfaceContainerHighest: Color(0xff343439),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
