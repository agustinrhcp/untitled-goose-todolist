const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const AutoprefixerPlugin = require('autoprefixer');

const HtmlWebpackPluginConfig = new HtmlWebpackPlugin({ template: 'src/index.html' });

const ExtractCssPluginConfig = new ExtractTextPlugin({
  filename: 'styles.[md5:contenthash:hex:20].css',
  allChunks: true,
  disable: process.env.NODE_ENV !== 'production',
});

module.exports = {
  entry: {
    bundle: './src/styles/main.scss',
  },
  module: {
    rules: [
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
