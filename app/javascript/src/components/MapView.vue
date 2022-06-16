<template>
  <section class="page">
    <header class="page-header">
      <div class="header-logo">
        <h1 class="header-title">
          <span>Carto</span>
          <img src="/logo.svg" class="logo" />
          <span>Pretto</span>
        </h1>
      </div>
  
      <p class="header-subtitle">Les derniers taux obtenus par Pretto pour nos clients ! </p>

      <div class="header-rates">
        <div class="rate-block">
          <p>Taux &lt; 15 ans</p>
          <p>{{ averageRates[0] }} %</p>
        </div>

        <div class="rate-block">
          <p>Taux 15 ans</p>
          <p>{{ averageRates[1] }} %</p>
        </div>

        <div class="rate-block">
          <p>Taux 20 ans</p>
          <p>{{ averageRates[2] }} %</p>
        </div>

        <div class="rate-block">
          <p>Taux 25 ans</p>
          <p>{{ averageRates[3] }} %</p>
        </div>

        <p class="rate-disclaimer">NB : Taux moyens obtenus </p>
      </div>
    </header>

    <div class="map-container">
      <VMap
        class="map-component"
        :options="mapOptions"
        @loaded="handleMapLoad"
      />

      <!-- <div class="filters-container">
        <div class="filter-duration">
          <label>Filtrer par durée</label>
          <input type="range" step="5" min="0" max="25" />
        </div>
      </div> -->
    </div>
  </section>
</template>

<script setup>
import { reactive, readonly, ref } from 'vue'
import { VMap } from 'v-mapbox'
import mapboxgl from 'mapbox-gl'

const accessToken = 'pk.eyJ1Ijoia21vcnBhaW4iLCJhIjoiY2w0Z3Bkd2YxMGZjcTNncjFod3ZrZjJoaCJ9.3aRdefgr1DrE4xcxWlgHBA'

const mapOptions = reactive({
  accessToken,
  style: 'mapbox://styles/mapbox/light-v10',
  container: 'map',
  center: [2.21, 46.23], // center of France
  zoom: 5.3,
  minZoom: 5.3,
  maxZoom: 15,
});

const data = ref([])
const averageRates = ref([
  1.04,
  1.15,
  1.59,
  1.39,
])

const response = await fetch('/map_results')
data.value = await response.json()

let map = readonly({})
const handleMapLoad = ($map) => {
  map = $map

  map.addSource('projects', {
    type: 'geojson',
    data: {
      type: "FeatureCollection",
      features: data.value.map((point, index) => ({
        type: "Feature",
        properties: {
          id: index,
          ...point,
        },
        geometry: {
          type: "Point",
          coordinates: [ point.lng, point.lat]
        }
      })),
    },
    cluster: true,
    clusterMaxZoom: 14, // Max zoom to cluster points on
    clusterRadius: 50, // Radius of each cluster when clustering points (defaults to 50)
  });
  
  map.addLayer({
    id: 'clusters',
    type: 'circle',
    source: 'projects',
    filter: ['has', 'point_count'],
    paint: {
      // Use step expressions (https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions-step)
      // with three steps to implement three types of circles:
      //   * Blue, 20px circles when point count is less than 100
      //   * Yellow, 30px circles when point count is between 100 and 750
      //   * Pink, 40px circles when point count is greater than or equal to 750
      'circle-color': [
        'step',
        ['get', 'point_count'],
        '#B3D8B6',
        10, // limit
        '#FFAA98',
        50, // limit
        '#FC5C63',
      ],
      'circle-radius': [
        'step',
        ['get', 'point_count'],
        20, // radius before limite
        10, // limit
        30, // radius between limits
        50, // limit
        40, // radius after limit
      ],
    },
  });

  map.addLayer({
    id: 'cluster-count',
    type: 'symbol',
    source: 'projects',
    filter: ['has', 'point_count'],
    layout: {
      'text-field': '{point_count_abbreviated}',
      'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
      'text-size': 12,
    },
  });

  map.addLayer({
    id: 'unclustered-point',
    type: 'circle',
    source: 'projects',
    filter: ['!', ['has', 'point_count']],
    paint: {
      'circle-color': '#B3D8B6',
      'circle-radius': 10,
      'circle-stroke-width': 1,
      'circle-stroke-color': '#fff',
    },
  });
  
  map.on('click', 'clusters', (e) => {
    const features = map.queryRenderedFeatures(e.point, {
      layers: ['clusters'],
    });
    const clusterId = features[0].properties.cluster_id;
    map.getSource('projects').getClusterExpansionZoom(
      clusterId,
      (err, zoom) => {
        if (err) return;
        
        map.easeTo({
          center: features[0].geometry.coordinates,
          zoom: zoom,
        });
      },
    );
  });
 
  // When a click event occurs on a feature in
  // the unclustered-point layer, open a popup at
  // the location of the feature, with
  // description HTML from its properties.
  const popup = new mapboxgl.Popup({
    closeOnClick: false,
    closeButton: false,
    maxWidth: 'none',
  })

  map.on('mouseenter', 'unclustered-point', (e) => {
    map.getCanvas().style.cursor = 'pointer';
    const coordinates = e.features[0].geometry.coordinates.slice();
    const point = e.features[0].properties;
    
    // Ensure that if the map is zoomed out such that
    // multiple copies of the feature are visible, the
    // popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
      coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    
    popup.setLngLat(coordinates)
      .setHTML(`
        <div class="tooltip-block">
          <img src="/house.svg" />
          <div>
            <p>${point.address}</p>
          </div>
        </div>
        <div class="tooltip-block">
          <img src="/loan.svg" />
          <div>
            <p>${point.loan_amount}€ empruntés</p>
          </div>
        </div>
        <div class="tooltip-block">
          <img src="/mortgagors.svg" />
          <div>
            <p>Emprunt ${point.nb_mortgagors > 1 ? 'à deux' : 'seul'}</p>
            <p>${point.total_income}€ de revenus bruts annuels</p>
            <p>${point.age} ans d'âge moyen</p>
          </div>
        </div>
        <p class="tooltip-rate"><img src="/bulb.svg" /> ${point.rate} % sur ${point.duration}</p>
      `)
      .addTo(map);
  });

  map.on('mouseleave', 'unclustered-point', () => {
    map.getCanvas().style.cursor = '';
    popup.remove()
  })
  
  map.on('mouseenter', 'clusters', () => {
    map.getCanvas().style.cursor = 'pointer';
  });
  map.on('mouseleave', 'clusters', () => {
    map.getCanvas().style.cursor = '';
  });
}
</script>
