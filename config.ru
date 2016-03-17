$:.unshift File.expand_path("../", __FILE__)
require 'rubygems'
require 'sinatra'
require 'pry'
require './app'

run Sinatra::Application