#!/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'open-uri'

BASE_DIR = File.expand_path(File.dirname(__FILE__))
REPOS_DIR = File.join(BASE_DIR, "gits")

CONFIG = {
  :ra_vl => {
    :name => "Rechnerarchitektur Vorlesung",
    :xpath => "//div[@id='page']/table[2]/tbody/tr/td[last()]/a[text()='PDF']/@href|//div[@id='page']/h2[text()='Materialien']/following-sibling::ul[1]/li/a/@href",
    :url => "http://ls12-www.cs.tu-dortmund.de/daes/de/lehre/lehrveranstaltungen/sommersemester-2012/rechnerarchitektur.html",
    :repo => "u-felix-2012ss-ra",
    :dir => "Vorlesung",
  },
  :ra_ue => {
    :name => "Rechnerarchitektur Übung",
    :xpath => "//div[@id='page']/table[4]/tbody/tr/td[1 or 3]/a/@href",
    :url => "http://ls12-www.cs.tu-dortmund.de/daes/de/lehre/lehrveranstaltungen/sommersemester-2012/rechnerarchitektur.html",
    :repo => "u-felix-2012ss-ra",
    :dir => "Uebung",
  },
  :sus_vl => {
    :name => "Software ubiquitärer Systeme",
    :xpath => "(//div[@id='inhalt']//table)[1]/tbody/tr/td[last()]/a/@href",
    :url => "http://ess.cs.uni-dortmund.de/DE/Teaching/SS2012/SuS/Downloads/index.html",
    :repo => "u-felix-2012ss-sus",
    :dir => "Vorlesung",
  },
  :egp_vl => {
    :name => "Elektronische Geschäftsprozesse Vorlesung",
    :url => "http://ls14-www.cs.uni-dortmund.de/index.php/ElektrGP-SS-2012",
    :repo => "u-felix-2012ss-egp",
    :dir => "Vorlesung",
    :xpath => "//h2[span[@id='Vorlesungsfolien']]/following-sibling::ul[1]/li/a/@href",
  },
  :egp_ue => {
    :name => "Elektronische Geschäftsprozesse Übung",
    :url => "http://ls14-www.cs.uni-dortmund.de/index.php/ElektrGP-SS-2012",
    :repo => "u-felix-2012ss-egp",
    :dir => "Uebung",
    :xpath => "//h3[span[@id='.C3.9Cbungsbl.C3.A4tter']]/following-sibling::ol[1]/li/a/@href",
  },
}


CONFIG.each do |key, options|
  puts "*** #{options[:name]}"
  links = Nokogiri::HTML(open options[:url]).xpath(options[:xpath]).map(&:to_s)

  target_dir = File.join(REPOS_DIR, options[:repo], options[:dir])
  puts %x{cd #{target_dir} && git pull}
  puts %x{echo '#{links.join("\n")}' | wget -q -i - -N -P #{target_dir} -B '#{options[:url]}'}
  puts %x{cd #{target_dir} && git add . && git commit -m "Automatically added/updated files" && git push}
  puts
end
