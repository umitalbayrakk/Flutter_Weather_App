import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/View/WeatherView/weather_viewmodel.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Hava Durumu",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            CustomDropDown(viewModel: viewModel),
            const SizedBox(height: 20),
            if (viewModel.isLoading)
              const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black))),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            if (viewModel.weather != null) ...[
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        viewModel.getWeatherIcon(viewModel.weather!.currentWeatherCode),
                        size: 50,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.weather!.cityName,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Text(
                              '${viewModel.weather!.currentTemperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            Text(
                              viewModel.weather!.currentDescription,
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              '7 Günlük Hava Durumu',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (viewModel.weather?.dailyForecasts.isNotEmpty ?? false)
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.weather?.dailyForecasts.length ?? 0,
                  itemBuilder: (context, index) {
                    final forecast = viewModel.weather!.dailyForecasts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  viewModel.formatDay(forecast.date),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(
                                viewModel.getWeatherIcon(forecast.weatherCode),
                                color: Theme.of(context).iconTheme.color,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${forecast.maxTemp.toStringAsFixed(1)}° / ${forecast.minTemp.toStringAsFixed(1)}°',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  forecast.description,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(child: Text('Günlük tahmin verisi bulunamadı.')),
          ],
        ),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final WeatherViewModel viewModel;
  const CustomDropDown({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, vm, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: vm.selectedCity,
            icon: const Icon(Icons.arrow_downward),
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                vm.fetchWeather(value);
              }
            },
            items: vm.cities.keys.map((city) => DropdownMenuItem<String>(value: city, child: Text(city))).toList(),
          ),
        );
      },
    );
  }
}
