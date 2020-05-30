package com.atguigu.myrule;

import com.netflix.loadbalancer.ILoadBalancer;
import com.netflix.loadbalancer.IRule;
import com.netflix.loadbalancer.RoundRobinRule;
import com.netflix.loadbalancer.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MySelfRule{
   @Bean
    public IRule myRule(){
//       return new RoundRobinRule();
       return new RoundRobinRule_ZDY();//自定义算法
   }
}
