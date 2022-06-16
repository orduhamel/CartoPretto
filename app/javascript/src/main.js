import { createApp } from "vue";
import App from "./components/App.vue";

export default () => {
  document.addEventListener("DOMContentLoaded", () => {
    // Add root component
    const app = createApp(App);
    app.mount("#vue-app");
  });
};
