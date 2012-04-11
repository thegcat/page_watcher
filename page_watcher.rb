#!/bin/env ruby

require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'open-uri'

XPATH = "//div[@id='page']/table[2]/tbody/tr/td[last()]/a[text()='PDF']/@href"
URL = "http://ls12-www.cs.tu-dortmund.de/daes/de/lehre/lehrveranstaltungen/sommersemester-2012/rechnerarchitektur.html"

res = Nokogiri::HTML(open(URL)).xpath(XPATH).map(&:to_s)

puts res.inspect
