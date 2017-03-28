#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) 
require "pry"
require "yaml"
require 'BanditAgent'


#
# == バンディットクラス
#
class NArmBanditProblem
  attr_accessor :arms, :conf    #書き込み、参照可能

  #
  # == armクラス
  #
  class Arm
    attr_accessor :ave, :var, :reward_pattern    #書き込み、参照可能
    #
    # === 確率分布の種類, 種類毎にconfに設定してあるデータで
    #
    def initialize(arm_conf)
     initialize_arm(arm_conf) 
    end
   
    #
    # === 各確率分布種類毎に分ける
    #
    def initialize_arm(conf)
      @reward_pattern = conf[:reward_pattern]
      case @reward_pattern
      when "exp" then
      when "random" then
        @value = rand()
        # p "lever value : "+@value.to_s
      end
    end

    def pull_lever()
      # return GenerateRand.exp(@ave) 
      case @reward_pattern
      when "exp" then
      when "random" then
        return @value
      end
    end
  end


  def initialize(conf=nil)
    if conf.nil?
      @conf = make_default_conf() 
    else
      @conf = conf 
    end
    initialize_arms()  #レバーの初期化
  end

  def make_default_conf()
    conf = {} 
    conf[:arm_num] = 6 
    conf[:reward_pattern] = "random"
    return conf 
  end

  #
  # === レバーの初期化
  #
  def initialize_arms()
    @arms = [] 
    @conf[:arm_num].times do 
      arm_conf = make_default_arm_conf() 
      @arms.push(Arm.new(arm_conf)) 
    end
  end

  def make_default_arm_conf(ave=0.5)
    arm_conf = {} 
    arm_conf[:reward_pattern] = "random" 
    # arm_conf[:ave] = ave 
    return arm_conf 
  end

  #
  # === レバーを引く
  # @param lever_num integer 選択したレバーのid
  # @return reward float 報酬
  #
  def pull_lever(lever_num)
    # output reward by a disttribution
    arm = @arms[lever_num] 
    return arm.pull_lever 
  end 

end

#
# 実行用
#
if($0 == __FILE__) then

  bandit_conf = {}
  bandit_conf[:arm_num] = 10
  bandit = NArmBanditProblem.new(bandit_conf)

  agent_list = [] 

  agent1_conf = {} 
  agent1_conf[:selection_method] = "e_greedy" 
  agent1_conf[:e] = 0.1 
  agent1_conf[:a] = 0.1 
  agent1 = BanditAgent.new(agent1_conf, bandit.arms.length) 
  agent_list.push(agent1) 

  agent2_conf = {} 
  agent2_conf[:selection_method] = "softmax" 
  agent2_conf[:t] = 0.1 
  agent2_conf[:a] = 0.1 
  agent2 = BanditAgent.new(agent2_conf, bandit.arms.length) 
  agent_list.push(agent2) 

  agent3_conf = {} 
  agent3_conf[:selection_method] = "ucb" 
  agent3_conf[:c] = 1 
  agent3_conf[:a] = 0.1 
  agent3 = BanditAgent.new(agent3_conf, bandit.arms.length) 
  agent_list.push(agent3) 
  exp_num = 10000 
  
  rewards_list = [] 

  exp_num.times do |num|
    agent_list.each_with_index do |agent, i|
      rewards_list[i] = [] if rewards_list[i].nil?
      agent_select = agent.select_action(num)
      reward = bandit.pull_lever(agent_select) 
      agent.calc_average_reward(reward,num) 
      agent.update_q(agent_select,reward) 
      rewards_list[i].push(agent.average_reward) 
    end
    # p "#{agent_select}, #{reward}"
  end
  
  p "=============[result]============="
  p "agent1's average reward (e_greedy): #{agent1.average_reward}"
  p "agent2's average reward (softmax) : #{agent2.average_reward}"
  p "agent3's average reward (ucb)     : #{agent3.average_reward}"

  YAML.dump(rewards_list, File.open("result.yml", "w"))
end



