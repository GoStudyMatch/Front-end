import 'package:flutter/material.dart';

class LocationSelector extends StatelessWidget {
  final String currentLocation;
  final Function(String) onLocationChanged;

  const LocationSelector({
    super.key,
    required this.currentLocation,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLocation,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => [
          '서울특별시',
          '부산광역시',
          '대구광역시',
          '인천광역시',
          '광주광역시',
          '대전광역시',
          '울산광역시',
          '세종특별자치시',
          '경기도',
          '강원도',
          '충청북도',
          '충청남도',
          '전라북도',
          '전라남도',
          '경상북도',
          '경상남도',
          '제주특별자치도',
        ].map((location) {
          return PopupMenuItem<String>(
            value: location,
            child: Row(
              children: [
                if (location == currentLocation)
                  const Icon(
                    Icons.check,
                    color: Colors.orange,
                    size: 20,
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 8),
                Text(location),
              ],
            ),
          );
        }).toList(),
        onSelected: onLocationChanged,
      ),
    );
  }
} 