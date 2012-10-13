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
  :bsb_vl => {
    :name => "Betriebssystembau Vorlesung",
    :xpath => "(//div[@class='wrapper']//table)[1]/tbody/tr/td[last()]/a/@href",
    :url => "http://ess.cs.tu-dortmund.de/Teaching/WS2012/BSB/Downloads/index.html",
    :repo => "u-felix-2012ws-bsb",
    :dir => "Vorlesung",
  },
  :bsb_ue => {
    :name => "Betriebssystembau Übung",
    :xpath => "(//div[@class='wrapper']//table)[2]/tbody/tr/td[last()]/a/@href",
    :url => "http://ess.cs.tu-dortmund.de/Teaching/WS2012/BSB/Downloads/index.html",
    :repo => "u-felix-2012ws-bsb",
    :dir => "Uebung",
  },
  :swk_ue => {
    :name => "Softwarekonstruktion Vorlesung",
    :xpatch => "//div[@class='wrapper']/h3[text()='Vorlesungsfolien:']/following-sibling::ul[not(preceding::h3[text()='Vorlesungstermine inkl. Wiederholungsfolien:'])]/li/a/@href",
    :url => "http://www-jj.cs.tu-dortmund.de/secse/pages/teaching/ws12-13/swk/index_de.shtml",
    :repo => "u-felix-2012ws-swk",
    :dir => "Vorlesung",
  },
  :uebau_vl => {
    :name => "Übersetzerbau Vorlesung",
    :url => "http://fldit-www.cs.tu-dortmund.de/ueb.html",
    :repo => "u-felix-2012ws-uebau",
    :dir => "Vorlesung",
    :xpath => "//a[text()='Übersetzerbau']/@href",
  },
  :uebau_ue => {
    :name => "Übersetzerbau Übung",
    :url => "https://ews.tu-dortmund.de/lecture/uezuebws1213/material/%C3%9Cbungszettel/",
    :repo => "u-felix-2012ws-uebau",
    :dir => "Uebung",
    :xpath => "//ul/li[position()>1]/a/@href",
  },
  :webtech1_vl => {
    :name => "Webtechnologien 1 Vorlesung",
    :url => "https://ews.tu-dortmund.de/lecture/lsf-117971/material/Vorlesungsfolien/",
    :repo => "u-felix-2012ws-webtech1",
    :dir => "Vorlesung",
    :xpath => "//ul/li[position()>1]/a/@href",
  },
  :webtech1_ue => {
    :name => "Webtechnologien 1 Übung",
    :url => "https://ews.tu-dortmund.de/lecture/lsf-117971/material/%C3%9Cbungsbl%C3%A4tter/",
    :repo => "u-felix-2012ws-webtech1",
    :dir => "Uebung",
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
