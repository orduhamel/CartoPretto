import { createApp } from "vue";
import HelloWorld from "./components/HelloWorld.vue";

export default () => {
  document.addEventListener("DOMContentLoaded", () => {
    // Add root component
    const app = createApp(HelloWorld);
    app.mount("#vue-app");
  });
};
