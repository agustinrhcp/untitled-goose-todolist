const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const AutoprefixerPlugin = require('autoprefixer');

const HtmlWebpackPluginConfig = new HtmlWebpackPlugin({
  template: 'src/index.html',
  filename: 'index.html',
  inject: 'body',
  publicPath: '/',
});

const ExtractCssPluginConfig = new ExtractTextPlugin({
  filename: 'styles.[md5:contenthash:hex:20].css',
  allChunks: true,
  disable: process.env.NODE_ENV !== 'production',
});

module.exports = {
  mode: 'development',
  entry: {
    bundle: './src/index.js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: 'babel-loader',
        exclude: [/node_modules/],
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/],
        use: {
          loader: 'elm-webpack-loader',
        }
      },
      {
        test: /\.scss$/,
        use: ExtractCssPluginConfig.extract({
          fallback: 'style-loader',
          use: [
            { loader: 'css-loader' },
            {
              loader: 'postcss-loader',
              options: {
                plugins: () => [new AutoprefixerPlugin()],
              },
            },
            { loader: 'sass-loader' },
          ],
        }),
      },
    ]
  },
  devServer: {
    port: 8080,
    contentBase: './dist',
  },
  plugins: [
    ExtractCssPluginConfig,
    HtmlWebpackPluginConfig,
  ],
};
