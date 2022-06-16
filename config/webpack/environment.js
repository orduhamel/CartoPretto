const { environment } = require('@rails/webpacker')

// Set Vue properties
const { DefinePlugin } = require("webpack");

// Set Vue loader
const { VueLoaderPlugin } = require("vue-loader");
const vue = require("./loaders/vue");

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin());
environment.plugins.prepend(
  "Define",
  new DefinePlugin({
    __VUE_OPTIONS_API__: false,
    // or __VUE_OPTIONS_API__: true,
    __VUE_PROD_DEVTOOLS__: false,
  })
);

environment.loaders.prepend("vue", vue);

// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');
module.exports = environment
