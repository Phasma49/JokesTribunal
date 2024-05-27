import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4287319844),
      surfaceTint: Color(4287319844),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294958279),
      onPrimaryContainer: Color(4281406208),
      secondary: Color(4286729334),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294957041),
      onSecondaryContainer: Color(4281665583),
      tertiary: Color(4285354891),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4293843967),
      onTertiaryContainer: Color(4280749379),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294965493),
      onBackground: Color(4280424981),
      surface: Color(4294965493),
      onSurface: Color(4280424981),
      surfaceVariant: Color(4294237907),
      onSurfaceVariant: Color(4283581500),
      outline: Color(4286870634),
      outlineVariant: Color(4292330424),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281871913),
      inverseOnSurface: Color(4294962661),
      inversePrimary: Color(4294948743),
      primaryFixed: Color(4294958279),
      onPrimaryFixed: Color(4281406208),
      primaryFixedDim: Color(4294948743),
      onPrimaryFixedVariant: Color(4285413646),
      secondaryFixed: Color(4294957041),
      onSecondaryFixed: Color(4281665583),
      secondaryFixedDim: Color(4294226658),
      onSecondaryFixedVariant: Color(4284953949),
      tertiaryFixed: Color(4293843967),
      onTertiaryFixed: Color(4280749379),
      tertiaryFixedDim: Color(4292459258),
      onTertiaryFixedVariant: Color(4283710322),
      surfaceDim: Color(4293384142),
      surfaceBright: Color(4294965493),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963690),
      surfaceContainer: Color(4294765538),
      surfaceContainerHigh: Color(4294370780),
      surfaceContainerHighest: Color(4293976023),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4285084938),
      surfaceTint: Color(4287319844),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289029431),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4284690777),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4288373389),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4283447149),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286867875),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294965493),
      onBackground: Color(4280424981),
      surface: Color(4294965493),
      onSurface: Color(4280424981),
      surfaceVariant: Color(4294237907),
      onSurfaceVariant: Color(4283318328),
      outline: Color(4285226067),
      outlineVariant: Color(4287133550),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281871913),
      inverseOnSurface: Color(4294962661),
      inversePrimary: Color(4294948743),
      primaryFixed: Color(4289029431),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4287122722),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4288373389),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4286532211),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286867875),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4285157513),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293384142),
      surfaceBright: Color(4294965493),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963690),
      surfaceContainer: Color(4294765538),
      surfaceContainerHigh: Color(4294370780),
      surfaceContainerHighest: Color(4293976023),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4282063104),
      surfaceTint: Color(4287319844),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4285084938),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282191670),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284690777),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281210186),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283447149),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965493),
      onBackground: Color(4280424981),
      surface: Color(4294965493),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4294237907),
      onSurfaceVariant: Color(4281147930),
      outline: Color(4283318328),
      outlineVariant: Color(4283318328),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281871913),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294961371),
      primaryFixed: Color(4285084938),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283113728),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284690777),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282981185),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283447149),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281933910),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293384142),
      surfaceBright: Color(4294965493),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963690),
      surfaceContainer: Color(4294765538),
      surfaceContainerHigh: Color(4294370780),
      surfaceContainerHighest: Color(4293976023),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294948743),
      surfaceTint: Color(4294948743),
      onPrimary: Color(4283442176),
      primaryContainer: Color(4285413646),
      onPrimaryContainer: Color(4294958279),
      secondary: Color(4294226658),
      onSecondary: Color(4283309637),
      secondaryContainer: Color(4284953949),
      onSecondaryContainer: Color(4294957041),
      tertiary: Color(4292459258),
      onTertiary: Color(4282197082),
      tertiaryContainer: Color(4283710322),
      onTertiaryContainer: Color(4293843967),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279833101),
      onBackground: Color(4293976023),
      surface: Color(4279833101),
      onSurface: Color(4293976023),
      surfaceVariant: Color(4283581500),
      onSurfaceVariant: Color(4292330424),
      outline: Color(4288646531),
      outlineVariant: Color(4283581500),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293976023),
      inverseOnSurface: Color(4281871913),
      inversePrimary: Color(4287319844),
      primaryFixed: Color(4294958279),
      onPrimaryFixed: Color(4281406208),
      primaryFixedDim: Color(4294948743),
      onPrimaryFixedVariant: Color(4285413646),
      secondaryFixed: Color(4294957041),
      onSecondaryFixed: Color(4281665583),
      secondaryFixedDim: Color(4294226658),
      onSecondaryFixedVariant: Color(4284953949),
      tertiaryFixed: Color(4293843967),
      onTertiaryFixed: Color(4280749379),
      tertiaryFixedDim: Color(4292459258),
      onTertiaryFixedVariant: Color(4283710322),
      surfaceDim: Color(4279833101),
      surfaceBright: Color(4282464049),
      surfaceContainerLowest: Color(4279504136),
      surfaceContainerLow: Color(4280424981),
      surfaceContainer: Color(4280688153),
      surfaceContainerHigh: Color(4281411619),
      surfaceContainerHighest: Color(4282200877),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294950033),
      surfaceTint: Color(4294948743),
      onPrimary: Color(4280880896),
      primaryContainer: Color(4291199056),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294555366),
      onSecondary: Color(4281205545),
      secondaryContainer: Color(4290412202),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4292722431),
      onTertiary: Color(4280354622),
      tertiaryContainer: Color(4288775617),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279833101),
      onBackground: Color(4293976023),
      surface: Color(4279833101),
      onSurface: Color(4294966008),
      surfaceVariant: Color(4283581500),
      onSurfaceVariant: Color(4292593596),
      outline: Color(4289896341),
      outlineVariant: Color(4287725686),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293976023),
      inverseOnSurface: Color(4281411619),
      inversePrimary: Color(4285479439),
      primaryFixed: Color(4294958279),
      onPrimaryFixed: Color(4280355584),
      primaryFixedDim: Color(4294948743),
      onPrimaryFixedVariant: Color(4284033280),
      secondaryFixed: Color(4294957041),
      onSecondaryFixed: Color(4280746019),
      secondaryFixedDim: Color(4294226658),
      onSecondaryFixedVariant: Color(4283704395),
      tertiaryFixed: Color(4293843967),
      onTertiaryFixed: Color(4280025401),
      tertiaryFixedDim: Color(4292459258),
      onTertiaryFixedVariant: Color(4282591840),
      surfaceDim: Color(4279833101),
      surfaceBright: Color(4282464049),
      surfaceContainerLowest: Color(4279504136),
      surfaceContainerLow: Color(4280424981),
      surfaceContainer: Color(4280688153),
      surfaceContainerHigh: Color(4281411619),
      surfaceContainerHighest: Color(4282200877),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294966008),
      surfaceTint: Color(4294948743),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294950033),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965753),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294555366),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965756),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4292722431),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279833101),
      onBackground: Color(4293976023),
      surface: Color(4279833101),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4283581500),
      onSurfaceVariant: Color(4294966008),
      outline: Color(4292593596),
      outlineVariant: Color(4292593596),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293976023),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4282851072),
      primaryFixed: Color(4294959568),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294950033),
      onPrimaryFixedVariant: Color(4280880896),
      secondaryFixed: Color(4294958578),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294555366),
      onSecondaryFixedVariant: Color(4281205545),
      tertiaryFixed: Color(4294107647),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4292722431),
      onTertiaryFixedVariant: Color(4280354622),
      surfaceDim: Color(4279833101),
      surfaceBright: Color(4282464049),
      surfaceContainerLowest: Color(4279504136),
      surfaceContainerLow: Color(4280424981),
      surfaceContainer: Color(4280688153),
      surfaceContainerHigh: Color(4281411619),
      surfaceContainerHighest: Color(4282200877),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
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

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
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
