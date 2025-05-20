import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  String? _selectedRegion;
  double _radius = 5000; // 5km

  final Map<String, LatLng> _regionCenters = {
    '서울': const LatLng(37.5665, 126.9780),
    '경기': const LatLng(37.4138, 127.5183),
    '인천': const LatLng(37.4563, 126.7052),
    '부산': const LatLng(35.1796, 129.0756),
    '대구': const LatLng(35.8714, 128.6014),
    '광주': const LatLng(35.1595, 126.8526),
    '대전': const LatLng(36.3504, 127.3845),
    '울산': const LatLng(35.5384, 129.3114),
    '세종': const LatLng(36.4801, 127.2892),
    '강원': const LatLng(37.8228, 128.1555),
    '충북': const LatLng(36.6357, 127.4915),
    '충남': const LatLng(36.6588, 126.6728),
    '전북': const LatLng(35.8242, 127.1480),
    '전남': const LatLng(34.8161, 126.4629),
    '경북': const LatLng(36.5760, 128.5059),
    '경남': const LatLng(35.2382, 128.6924),
    '제주': const LatLng(33.4996, 126.5312),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateMapRegion(String region) {
    if (_regionCenters.containsKey(region)) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_regionCenters[region]!, 12),
      );
      setState(() {
        _selectedRegion = region;
        _updateMarkers(region);
      });
    }
  }

  void _updateMarkers(String region) {
    _markers.clear();
    _circles.clear();

    // 임시 데이터: 선택된 지역에 스터디 그룹 마커 추가
    final center = _regionCenters[region]!;
    _circles.add(
      Circle(
        circleId: const CircleId('region'),
        center: center,
        radius: _radius,
        fillColor: Colors.blue.withOpacity(0.1),
        strokeColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 2,
      ),
    );

    // 임시 스터디 그룹 마커
    _markers.add(
      Marker(
        markerId: const MarkerId('study1'),
        position: LatLng(
          center.latitude + 0.01,
          center.longitude + 0.01,
        ),
        infoWindow: const InfoWindow(
          title: '프로그래밍 스터디',
          snippet: '매주 토요일 14:00',
        ),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('study2'),
        position: LatLng(
          center.latitude - 0.01,
          center.longitude - 0.01,
        ),
        infoWindow: const InfoWindow(
          title: '영어 회화 스터디',
          snippet: '매주 일요일 10:00',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지역별 스터디'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _regionCenters.keys.map((region) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(region),
                    selected: _selectedRegion == region,
                    onSelected: (selected) {
                      if (selected) {
                        _updateMapRegion(region);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _regionCenters['서울']!,
                zoom: 12,
              ),
              markers: _markers,
              circles: _circles,
            ),
          ),
        ],
      ),
    );
  }
} 