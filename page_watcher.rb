#!/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'uri'
require 'open-uri'
require 'netrc'

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
    :name => "Software ubiquitärer Systeme Vorlesung",
    :xpath => "(//div[@id='inhalt']//table)[1]/tbody/tr/td[last()]/a/@href",
    :url => "http://ess.cs.uni-dortmund.de/DE/Teaching/SS2012/SuS/Downloads/index.html",
    :repo => "u-felix-2012ss-sus",
    :dir => "Vorlesung",
  },
  :sus_ue_blaetter => {
    :name => "Software ubiquitärer Systeme Übungsblätter",
    :xpath => "(//div[@id='inhalt']//table)[1]/tbody/tr/td[2]/a/@href",
    :url => "http://ess.cs.uni-dortmund.de/DE/Teaching/SS2012/SuS/Exercises/",
    :repo => "u-felix-2012ss-sus",
    :dir => "Uebung",
  },
  :sus_ue_folien => {
    :name => "Software ubiquitärer Systeme Übungsfolien",
    :xpath => "(//div[@id='inhalt']//table)[2]/tbody/tr/td[last()]/a/@href",
    :url => "http://ess.cs.uni-dortmund.de/DE/Teaching/SS2012/SuS/Downloads/index.html",
    :repo => "u-felix-2012ss-sus",
    :dir => "Uebung",
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
  :webtech2_vl => {
    :name => "Webtechnologien 2",
    :url => "https://ews.tu-dortmund.de/lecture/lsf-110720/material/Folien/",
    :repo => "u-felix-2012ss-webtech2",
    :dir => "Vorlesung",
    :xpath => "//ul/li[position()>1]/a/@href",
  },
}


CONFIG.each do |key, options|
  #puts "*** #{options[:name]}"
  netrc = Netrc.read
  links = Nokogiri::HTML(open(options[:url], :http_basic_authentication => netrc[URI(options[:url]).host])).xpath(options[:xpath]).map(&:to_s)

  target_dir = File.join(REPOS_DIR, options[:repo], options[:dir])
  puts %x{cd #{target_dir} && git pull -q}
  puts %x{echo '#{links.join("\n")}' | wget -q -i - -N -P #{target_dir} -B '#{options[:url]}'}
  puts %x{cd #{target_dir} && git add . && git diff --quiet --staged || (git commit -m "Automatically added/updated files" && git push)}
  puts
end
