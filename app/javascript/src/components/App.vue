<template>
  <Suspense>
    <MapView />
  </Suspense>
</template>

<script setup>
import MapView from './MapView.vue'
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@500;900&display=swap');
@import "mapbox-gl/dist/mapbox-gl.css";
@import "v-mapbox/dist/v-mapbox.css";

html, body {
  margin: 0;
  font-family: 'Inter', Arial, sans-serif;
  font-weight: 500;
}
</style>