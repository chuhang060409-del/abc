import 'package:flutter/foundation.dart';

/// Real-time Sensor Data Model for Climate-Controlled Cabin
@immutable
class CabinSensorData {
  final String cabinId;
  final String cabinName;
  final String cabinCode;
  final String lotNumber;
  final String blockHeight;
  final bool isOnline;
  final bool isDoorLocked;
  final bool isSteadyState;

  // Temperature & Humidity Metrics
  final double currentTemp;
  final double targetTempMin;
  final double targetTempMax;
  final String tempSystemStatus;

  final double currentHumidity;
  final double targetHumidityMin;
  final double targetHumidityMax;
  final String humiditySystemStatus;

  // Controlled Atmosphere (CA) Gases
  final double oxygenPercentage;
  final double nitrogenPercentage;
  final int microPositivePressurePa;

  // Inventory & Quality
  final double totalWeightKg;
  final int storageDays;
  final double freshActiveIndex;

  const CabinSensorData({
    this.cabinId = 'NODE-A03',
    this.cabinName = 'A区01号气调保鲜仓',
    this.cabinCode = 'TCM-A892',
    this.lotNumber = 'LOT-CBS-202608-89240',
    this.blockHeight = '#18,492,031',
    this.isOnline = true,
    this.isDoorLocked = true,
    this.isSteadyState = true,
    this.currentTemp = 3.8,
    this.targetTempMin = 2.0,
    this.targetTempMax = 6.0,
    this.tempSystemStatus = '恒速制冷 · 压缩机组#1运行',
    this.currentHumidity = 64.5,
    this.targetHumidityMin = 60.0,
    this.targetHumidityMax = 70.0,
    this.humiditySystemStatus = '微湿平衡 · 超声波雾化泵待机',
    this.oxygenPercentage = 3.2,
    this.nitrogenPercentage = 96.0,
    this.microPositivePressurePa = 12,
    this.totalWeightKg = 1450.0,
    this.storageDays = 14,
    this.freshActiveIndex = 98.4,
  });

  CabinSensorData copyWith({
    String? cabinId,
    String? cabinName,
    String? cabinCode,
    String? lotNumber,
    String? blockHeight,
    bool? isOnline,
    bool? isDoorLocked,
    bool? isSteadyState,
    double? currentTemp,
    double? targetTempMin,
    double? targetTempMax,
    String? tempSystemStatus,
    double? currentHumidity,
    double? targetHumidityMin,
    double? targetHumidityMax,
    String? humiditySystemStatus,
    double? oxygenPercentage,
    double? nitrogenPercentage,
    int? microPositivePressurePa,
    double? totalWeightKg,
    int? storageDays,
    double? freshActiveIndex,
  }) {
    return CabinSensorData(
      cabinId: cabinId ?? this.cabinId,
      cabinName: cabinName ?? this.cabinName,
      cabinCode: cabinCode ?? this.cabinCode,
      lotNumber: lotNumber ?? this.lotNumber,
      blockHeight: blockHeight ?? this.blockHeight,
      isOnline: isOnline ?? this.isOnline,
      isDoorLocked: isDoorLocked ?? this.isDoorLocked,
      isSteadyState: isSteadyState ?? this.isSteadyState,
      currentTemp: currentTemp ?? this.currentTemp,
      targetTempMin: targetTempMin ?? this.targetTempMin,
      targetTempMax: targetTempMax ?? this.targetTempMax,
      tempSystemStatus: tempSystemStatus ?? this.tempSystemStatus,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      targetHumidityMin: targetHumidityMin ?? this.targetHumidityMin,
      targetHumidityMax: targetHumidityMax ?? this.targetHumidityMax,
      humiditySystemStatus: humiditySystemStatus ?? this.humiditySystemStatus,
      oxygenPercentage: oxygenPercentage ?? this.oxygenPercentage,
      nitrogenPercentage: nitrogenPercentage ?? this.nitrogenPercentage,
      microPositivePressurePa:
          microPositivePressurePa ?? this.microPositivePressurePa,
      totalWeightKg: totalWeightKg ?? this.totalWeightKg,
      storageDays: storageDays ?? this.storageDays,
      freshActiveIndex: freshActiveIndex ?? this.freshActiveIndex,
    );
  }
}
