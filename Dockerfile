FROM ruby:2.5
#必要なパッケージをインストール。
#RubyイメージはDebianイメージをベースにしているため、apt-getを使う。
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

#作業用ディレクトリの作成。
RUN mkdir /myapp
#myappディレクトリをAPP_ROOTの変数に置き換える。
#myappディレクトリを変数に置き換える理由（メリット）はディレクトリ名の変更があった際の手間を削減するため。
#変数に置き換えるちょっとしたデメリットはdocoerfileの記述に慣れていない人がコードを見た際に読みづらいと感じるかも。
ENV APP_ROOT /myapp
#作業用ディレクトリに移動。
WORKDIR $APP_ROOT

#ローカル（自分のパソコン）にあるGemfileをコンテナ内にコピー（追加）する。
COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

#Gemfileのbundleをコンテナにインストールしローカルにコピー（追加）する。
#コンテナとローカルのフォルダ＆ファイルは共有することができる。
#（例）コンテナのファイルをローカルに共有。ローカルのファイルをコンテナに共有。どちらもできる。
RUN bundle install
COPY . $APP_ROOT

