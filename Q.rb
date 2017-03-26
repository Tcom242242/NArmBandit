#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"
# require 'rubyOkn/BasicTool'
# require 'rubyOkn/StringTool'

# include BasicTool
# include StringTool;

#
# === Q値
#
class Q
  attr_accessor :r, :id #書き込み、参照可能
  # attr_writer :test #書き込み可能
  # attr_reader :test #参照可能
  def initialize(id=nil,r=0.0)
    @id = id ;
    @r = r ;
  end
end

#
# 実行用
#
if($0 == __FILE__) then
  
end


