import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  lagos,
  abuja,
  enugu,
  akure,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getCityWeather(City city) async {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.abuja: "🌧",
      City.lagos: "🌤",
      City.enugu: "🌧",
    }[city]!,
  );
}

final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = "🤷🏽‍♂️";

final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getCityWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

class ThreeApp extends ConsumerWidget {
  const ThreeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          currentWeather.when(
              data: ((data) => Text(
                    data,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  )),
              error: (_, __) => const Text(
                    "Ouch 😬",
                  ),
              loading: (() => const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ))),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city ==
                    ref.watch(
                      currentCityProvider,
                    );
                return ListTile(
                  title: Text(
                    city.name,
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                        )
                      : null,
                  onTap: (() => ref
                      .read(
                        currentCityProvider.notifier,
                      )
                      .state = city),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
