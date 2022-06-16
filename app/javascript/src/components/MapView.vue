<template>
  <section class="page">
    <header class="page-header">
      <img src="/mapWithHouse.svg" class="header-logo" />

      <div>
        <h1 class="header-title">
          <span>Carto</span>
          <span>Pretto</span>
        </h1>
  
        <p class="header-subtitle">Les derniers taux obtenus par Pretto pour nos clients ! </p>
      </div>
    </header>

    <div class="map-container">
      <VMap
        class="map-component"
        :options="mapOptions"
        @loaded="handleMapLoad"
      />
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
  })

  map.on('mouseenter', 'unclustered-point', (e) => {
    map.getCanvas().style.cursor = 'pointer';
    const coordinates = e.features[0].geometry.coordinates.slice();
    const rate = e.features[0].properties.rate;
    
    // Ensure that if the map is zoomed out such that
    // multiple copies of the feature are visible, the
    // popup appears over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
      coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }
    
    popup.setLngLat(coordinates)
      .setHTML(`taux: ${rate}`)
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

<style scoped>
.page {
  position: relative;
}

.page-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1;
  background-color: white;
  padding: 0.5rem 1rem;
  display: flex;
}

.header-logo {
  max-width: 100%;
  width: 150px;
  height: auto;
  margin-right: 1rem;
}

.header-title {
  font-size: 60px;
  font-family: 'Inter', Arial, sans-serif;
  font-weight: 900;
  display: flex;
  flex-direction: column;
}

.header-title > span {
  line-height: 0.8;
}

.header-title > span:last-of-type {
  color: #006855;
}

.header-subtitle {
  color: #006855;
  font-style: italic;
}

.map-container {
  width: 100vw;
  height: 100vh;
}

.map-component {
  width: 100%;
  height: 100%;
}
</style>
