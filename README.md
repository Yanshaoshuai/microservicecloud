### Spring Cloud（Dalston.SR1版）

#### Eureka

##### 集群搭建

**microservicecloud-eureka-7001**

application.yml

```yml
server: 
  port: 7001
 
eureka:
  server:
#    enable-self-preservation: false #取消自我我保护机制
  instance:
    hostname: eureka7001.com #eureka服务端的实例名称
  client: 
    register-with-eureka: false     #false表示不向注册中心注册自己。
    fetch-registry: false     #false表示自己端就是注册中心，我的职责就是维护服务实例，并不需要去检索服务
    service-url: 
#      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/       # 单机 设置与Eureka Server交互的地址查询服务和注册服务都需要依赖这个地址（单机）。
       defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
      
```

主启动类:

```java
@SpringBootApplication
//表明是EurekaServer 接受其他服务注册
@EnableEurekaServer
public class EurekaServer7001_App {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServer7001_App.class,args);
    }
}
```

依赖:

```xml
 <!--eureka-server服务端 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka-server</artifactId>
        </dependency>
```

**microservicecloud-eureka-7002**

application.yml

```yml
server:
  port: 7002

eureka:
  server:
  #    enable-self-preservation: false #取消自我我保护机制
  instance:
    hostname: eureka7002.com #eureka服务端的实例名称
  client:
    register-with-eureka: false     #false表示不向注册中心注册自己。
    fetch-registry: false     #false表示自己端就是注册中心，我的职责就是维护服务实例，并不需要去检索服务
    service-url:
      #      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/       # 单机 设置与Eureka Server交互的地址查询服务和注册服务都需要依赖这个地址（单机）。
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7003.com:7003/eureka/
```

主启动类:

```java
@SpringBootApplication
//表明是EurekaServer 接受其他服务注册
@EnableEurekaServer
public class EurekaServer7002_App {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServer7002_App.class,args);
    }
}
```

依赖同上

**microservicecloud-eureka-7003**

application.yml

```yml
server:
  port: 7003

eureka:
  server:
  #    enable-self-preservation: false #取消自我我保护机制
  instance:
    hostname: eureka7003.com #eureka服务端的实例名称
  client:
    register-with-eureka: false     #false表示不向注册中心注册自己。
    fetch-registry: false     #false表示自己端就是注册中心，我的职责就是维护服务实例，并不需要去检索服务
    service-url:
      #      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/       # 单机 设置与Eureka Server交互的地址查询服务和注册服务都需要依赖这个地址（单机）。
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/
```

主启动类:

```java
@SpringBootApplication
//表明是EurekaServer 接受其他服务注册
@EnableEurekaServer
public class EurekaServer7003_App {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServer7003_App.class,args);
    }
}
```

依赖同上

启动项目:microservicecloud-eureka-7001,microservicecloud-eureka-7002,microservicecloud-eureka-7003

**访问任意eureka的host:端口号都能看到eureka面板**

##### Eureka客户端

Eureka客户端是要注册到Eureka上的服务

**microservicecloud-provider-dept-8001**

application.yml

```yml
server:
  port: 8001

mybatis:
  config-location: classpath:mybatis/mybatis.cfg.xml        # mybatis配置文件所在路径
  type-aliases-package: com.atguigu.springcloud.entities   # 所有Entity别名类所在包
  mapper-locations:
    - classpath:mybatis/mapper/**/*.xml                       # mapper映射文件

spring:
  application:
    name: microservicecloud-dept
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource            # 当前数据源操作类型
    driver-class-name: org.gjt.mm.mysql.Driver              # mysql驱动包
    url: jdbc:mysql://localhost:3306/cloudDB01              # 数据库名称
    username: root
    password: 123456
    dbcp2:
      min-idle: 5                                           # 数据库连接池的最小维持连接数
      initial-size: 5                                       # 初始化连接数
      max-total: 5                                          # 最大连接数
#      max-wait-millis: 200                                  # 等待连接获取的最大超时时间
# spring-cloud部分
eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
#      defaultZone: http://localhost:7001/eureka
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
  #自定义instance信息
  instance:
    instance-id: microservicecloud-dept8001
    prefer-ip-address: true     #访问路径可以显示IP地址
# /info监控信息
info:
  app.name: atguigu-microservicecloud
  company.name: www.atguigu.com
  build.artifactId: $project.artifactId$
  build.version: $project.version$

```

主启动类:

```java
@SpringBootApplication
//开启EurekaClient功能 自动注册到EurekaServer
@EnableEurekaClient
//开启服务发现功能
@EnableDiscoveryClient
public class DeptProvider8001_App {
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider8001_App.class,args);
    }
}
```

@EnableDiscoveryClient是非必须的,但是添加了@EnableDiscoveryClient注解可以使用客户端的服务发现功能,容器中会实例化一个DiscoveryClient的实现类,在客户端注入后可以通过此类完成服务发现操作

依赖:

```xml
 		
    <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
		<dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
```

启动项目

microservicecloud-eureka-7001,microservicecloud-eureka-7002,microservicecloud-eureka-7003，microservicecloud-provider-dept-8001

后会在Eureka面板上看见有一个新的实例,实例名是spring.application.name全转成大写，服务名一致代表同一种服务,显示在同一行

#### Ribbon

Ribbon是一个客户端负载均衡工具,是一个Eureka客户端

**microservicecloud-consumer-dept-80**

application.yml

```yml
server:
  port: 80

eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
      #      defaultZone: http://localhost:7001/eureka
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
    register-with-eureka: false
```

主启动类:

```java
@SpringBootApplication
@EnableEurekaClient
//在启动该微服务的时候就能去加载我们的自定义Ribbon配置类，从而使配置生效
@RibbonClient(name="MICROSERVICECLOUD-DEPT",configuration= MySelfRule.class)
public class DeptConsumer80_App
{
	public static void main(String[] args)
	{
		SpringApplication.run(DeptConsumer80_App.class, args);
	}
}
```

依赖:

```xml
<!-- Ribbon相关 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-ribbon</artifactId>
        </dependency>
		<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
```

配置类:

```java
@Configuration
public class ConfigBean //boot -->spring   applicationContext.xml --- @Configuration配置   ConfigBean = applicationContext.xml
{
    @Bean
    @LoadBalanced//开启Ribbon负载均衡
    public RestTemplate getRestTemplate()
    {
        return new RestTemplate();
    }

    /**
     * 选择负载均衡算法
     * @return
     */
    @Bean
    public IRule myRule()
    {
        //return new RoundRobinRule();
        return new RandomRule();//达到的目的，用我们重新选择的随机算法替代默认的轮询。
//        return new RetryRule();
    }
}
```

这里配置类主要配置了一个RestTemplate,可以利用它通过服务名调用注册到Eureka的服务

调用方式如下:

DeptController_Consumer.java

```java
@RestController
public class DeptController_Consumer
{

//	private static final String REST_URL_PREFIX = "http://localhost:8001";//直接调用
	private static final String REST_URL_PREFIX = "http://MICROSERVICECLOUD-DEPT";//通过Eureka调用

	/**
	 * 使用 使用restTemplate访问restful接口非常的简单粗暴无脑。 (url, requestMap,
	 * ResponseBean.class)这三个参数分别代表 REST请求地址、请求参数、HTTP响应转换被转换成的对象类型。
	 */
	@Autowired
	private RestTemplate restTemplate;

	@RequestMapping(value = "/consumer/dept/add")
	public boolean add(Dept dept)
	{
		return restTemplate.postForObject(REST_URL_PREFIX + "/dept/add", dept, Boolean.class);
	}

	@RequestMapping(value = "/consumer/dept/get/{id}")
	public Dept get(@PathVariable("id") Long id)
	{
		return restTemplate.getForObject(REST_URL_PREFIX + "/dept/get/" + id, Dept.class);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/consumer/dept/list")
	public List<Dept> list()
	{
		return restTemplate.getForObject(REST_URL_PREFIX + "/dept/list", List.class);
	}

	// 测试@EnableDiscoveryClient,消费端可以调用服务发现
	@RequestMapping(value = "/consumer/dept/discovery")
	public Object discovery()
	{
		return restTemplate.getForObject(REST_URL_PREFIX + "/dept/discovery", Object.class);
	}

}
```

主启动类中@RibbonClient注解属性configuration= MySelfRule.class表明使用自己的负载均衡算法配置类

MySelfRule.java不要和主启动类同包或在其子包下,否则会被识别为全局负载均衡算法配置

MySelfRule.java:

```java
@Configuration
public class MySelfRule{
   @Bean
    public IRule myRule(){
//       return new RoundRobinRule();
       return new RoundRobinRule_ZDY();//自定义算法
   }
}
```

RoundRobinRule_ZDY.java

```java
/**
 * 轮询 每个被轮询到的访问五次 接着向下轮询
 */
public class RoundRobinRule_ZDY extends AbstractLoadBalancerRule
{

	// total = 0 // 当total==5以后，我们指针才能往下走，
	// index = 0 // 当前对外提供服务的服务器地址，
	// total需要重新置为零，但是已经达到过一个5次，我们的index = 1
	// 分析：我们5次，但是微服务只有8001 8002 8003 三台，OK？
	// 
	
	
	private int total = 0; 			// 总共被调用的次数，目前要求每台被调用5次
	private int currentIndex = 0;	// 当前提供服务的机器号

	public Server choose(ILoadBalancer lb, Object key)
	{
		if (lb == null) {
			return null;
		}
		Server server = null;

		while (server == null) {
			if (Thread.interrupted()) {
				return null;
			}
			List<Server> upList = lb.getReachableServers();
			List<Server> allList = lb.getAllServers();

			int serverCount = allList.size();
			if (serverCount == 0) {
				/*
				 * No servers. End regardless of pass, because subsequent passes only get more
				 * restrictive.
				 */
				return null;
			}

//			int index = rand.nextInt(serverCount);// java.util.Random().nextInt(3);
//			server = upList.get(index);

			
//			private int total = 0; 			// 总共被调用的次数，目前要求每台被调用5次
//			private int currentIndex = 0;	// 当前提供服务的机器号
            if(total < 5)
            {
	            server = upList.get(currentIndex);
	            total++;
            }else {
	            total = 0;
	            currentIndex++;
	            if(currentIndex >= upList.size())
	            {
	              currentIndex = 0;
	            }
            }			
			
			
			if (server == null) {
				/*
				 * The only time this should happen is if the server list were somehow trimmed.
				 * This is a transient condition. Retry after yielding.
				 */
				Thread.yield();
				continue;
			}

			if (server.isAlive()) {
				return (server);
			}

			// Shouldn't actually happen.. but must be transient or a bug.
			server = null;
			Thread.yield();
		}

		return server;

	}

	@Override
	public Server choose(Object key)
	{
		return choose(getLoadBalancer(), key);
	}

	@Override
	public void initWithNiwsConfig(IClientConfig clientConfig)
	{
		// TODO Auto-generated method stub

	}

}
```

再启动一个**microservicecloud-provider-dept-8002**多次访问即可看见负载均衡起作用

#### Feign

**microservicecloud-consumer-dept-feign**

feign支持以接口的方式调用服务

接口:

```java
@FeignClient(value = "MICROSERVICECLOUD-DEPT")
public interface DeptClientService
{
    @RequestMapping(value = "/dept/get/{id}", method = RequestMethod.GET)
    public Dept get(@PathVariable("id") long id);

    @RequestMapping(value = "/dept/list", method = RequestMethod.GET)
    public List<Dept> list();

    @RequestMapping(value = "/dept/add", method = RequestMethod.POST)
    public boolean add(Dept dept);
}
```

application.yml

```yml
server:
  port: 80
eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
      #      defaultZone: http://localhost:7001/eureka
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
    register-with-eureka: false
feign:
  hystrix:
    enabled: true
```

主启动类

```java
@SpringBootApplication
@EnableEurekaClient
@EnableFeignClients
public class DeptConsumer80_Feign_App
{
	public static void main(String[] args)
	{
		SpringApplication.run(DeptConsumer80_Feign_App.class, args);
	}
}
```

配置类:

```java
@Configuration
public class ConfigBean //boot -->spring   applicationContext.xml --- @Configuration配置   ConfigBean = applicationContext.xml
{
    @Bean
    @LoadBalanced//开启Ribbon负载均衡
    public RestTemplate getRestTemplate()
    {
        return new RestTemplate();
    }

    /**
     * 自定义负载均衡算法
     * @return
     */
    @Bean
    public IRule myRule()
    {
        //return new RoundRobinRule();
        return new RandomRule();//达到的目的，用我们重新选择的随机算法替代默认的轮询。
//        return new RetryRule();
    }
}
```

通过接口调用:

```java
@RestController
@ResponseBody
public class DeptController_Consumer
{
	@Autowired
	private DeptClientService service;

	@RequestMapping(value = "/consumer/dept/get/{id}")
	public Dept get(@PathVariable("id") Long id)
	{
		return this.service.get(id);
	}

	@RequestMapping(value = "/consumer/dept/list")
	public List<Dept> list()
	{
		return this.service.list();
	}

	@RequestMapping(value = "/consumer/dept/add")
	public Object add(Dept dept)
	{
		return this.service.add(dept);
	}
}
```

依赖:

```xml

		<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
        <!-- feign-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-feign</artifactId>
        </dependency>
```

启动项目

microservicecloud-eureka-7001,microservicecloud-eureka-7002,microservicecloud-eureka-7003，microservicecloud-provider-dept-8001,microservicecloud-consumer-dept-feign

进行测试

#### Hystrix

**熔断**
是应对雪崩效应的一种微服务链路保护机制
服务发生异常时向调用方返回一个符合预期的,可备选响应(fallback),而不是长时间没有响应或者抛出调用方无法处理的异常

application.yml

```yml
server:
  port: 8001

mybatis:
  config-location: classpath:mybatis/mybatis.cfg.xml        # mybatis配置文件所在路径
  type-aliases-package: com.atguigu.springcloud.entities   # 所有Entity别名类所在包
  mapper-locations:
    - classpath:mybatis/mapper/**/*.xml                       # mapper映射文件

spring:
  application:
    name: microservicecloud-dept
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource            # 当前数据源操作类型
    driver-class-name: org.gjt.mm.mysql.Driver              # mysql驱动包
    url: jdbc:mysql://localhost:3306/cloudDB01              # 数据库名称
    username: root
    password: 123456
    dbcp2:
      min-idle: 5                                           # 数据库连接池的最小维持连接数
      initial-size: 5                                       # 初始化连接数
      max-total: 5                                          # 最大连接数
      max-wait-millis: 200                                  # 等待连接获取的最大超时时间
# spring-cloud部分
eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
#      defaultZone: http://localhost:7001/eureka
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
  #自定义instance信息
  instance:
    instance-id: microservicecloud-dept8001-hystrix
    prefer-ip-address: true     #访问路径可以显示IP地址
# /info监控信息
info:
  app.name: atguigu-microservicecloud
  company.name: www.atguigu.com
  build.artifactId: $project.artifactId$
  build.version: $project.version$

```

主启动类

```java
@SpringBootApplication
//开启EurekaClient功能 自动注册到EurekaServer
@EnableEurekaClient
//开启服务发现功能
@EnableDiscoveryClient
//开启Hystrix熔断机制
@EnableCircuitBreaker
public class DeptProvider8001_Hystrix_App {
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider8001_Hystrix_App.class,args);
    }
}
```

添加熔断配置

```java
@RestController
public class DeptController
{
	@Autowired
	private DeptService service;
	@RequestMapping(value = "/dept/get/{id}", method = RequestMethod.GET)
	@HystrixCommand(fallbackMethod = "processHystrix_Get")
	public Dept get(@PathVariable("id") Long id)
	{
		Dept dept = service.get(id);
		if(dept==null){
			throw new RuntimeException("没有id为"+id+"的dept记录");
		}
		return dept;
	}
	public Dept processHystrix_Get(@PathVariable("id") Long id)
	{
		return new Dept().setDeptno(id).setDname("该ID：" + id + "没有没有对应的信息,null--@HystrixCommand")
				.setDb_source("no this database in MySQL");
	}

}
```

依赖:

```xml
 <!-- hystrix -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix</artifactId>
        </dependency>
        <!-- 将微服务provider侧注册进eureka -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
 		<dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
        </dependency>
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
```

请求为id不存在的dept会返回自定义的响应

启动项目

microservicecloud-eureka-7001,microservicecloud-eureka-7002,microservicecloud-eureka-7003，microservicecloud-provider-dept-hystrix-8001,microservicecloud-consumer-dept-80

进行测试

**通过fign来做熔断**

接口

```java
@FeignClient(value = "MICROSERVICECLOUD-DEPT",fallbackFactory=DeptClientServiceFallbackFactory.class)
public interface DeptClientService
{
    @RequestMapping(value = "/dept/get/{id}", method = RequestMethod.GET)
    public Dept get(@PathVariable("id") long id);

    @RequestMapping(value = "/dept/list", method = RequestMethod.GET)
    public List<Dept> list();

    @RequestMapping(value = "/dept/add", method = RequestMethod.POST)
    public boolean add(Dept dept);
}
```

熔断处理类

```java
@Component
public class DeptClientServiceFallbackFactory implements FallbackFactory<DeptClientService> {

    @Override
    public DeptClientService create(Throwable throwable) {
        return new DeptClientService(){

            @Override
            public Dept get(long id) {
                return new Dept().setDeptno(id).setDname("该ID：" + id + "没有没有对应的信息,null--@HystrixCommand")
                        .setDb_source("no this database in MySQL");
            }

            @Override
            public List<Dept> list() {
                return null;
            }

            @Override
            public boolean add(Dept dept) {
                return false;
            }
        };
    }
}
```

(重新install microservicecloud-api模块)配合Feign消费端即可生效

启动项目

microservicecloud-eureka-7001,microservicecloud-eureka-7002,microservicecloud-eureka-7003，microservicecloud-config-dept-client-8001,microservicecloud-consumer-dept-feign

进行测试

#### HystrixDashboard  

HystrixDashboard提供了对配置类Hystrix微服务的监控面板,被监控端要添加监控信息依赖

```xml
 <!-- actuator监控信息完善 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
```

application.yml

```yml
server:
  port: 9001
```

主启动类

```java
@SpringBootApplication
@EnableHystrixDashboard
public class DeptConsumer_DashBoard_App {
    public static void main(String[] args) {
        SpringApplication.run(DeptConsumer_DashBoard_App.class,args);
    }
}
```

依赖:

```xml
	<!-- hystrix dashboard-->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
        </dependency>
```

访问http://localhost:9001/hystrix按照提示填入要监控的hystrix服务 即可看到监控信息

#### Zuul网关

一般微服务都不直接对外提供访问,外部通过访问同一的网关,由网关代为访问内部的具体服务 

application.yml

```yml
server:
  port: 9527
 
spring: 
  application:
    name: microservicecloud-zuul-gateway

eureka: 
  client: 
    service-url: 
      defaultZone: http://eureka7001.com:7001/eureka,http://eureka7002.com:7002/eureka,http://eureka7003.com:7003/eureka  
  instance:
    instance-id: gateway-9527.com
    prefer-ip-address: true 
 
 
zuul:
  #ignored-services: microservicecloud-dept # 忽略真实服务名microservicecloud-dept
  prefix: /atguigu  #设置公共前缀
  ignored-services: "*"
  routes:
    mydept.serviceId: microservicecloud-dept
    mydept.path: /mydept/**

info:
  app.name: atguigu-microcloud
  company.name: www.atguigu.com
  build.artifactId: $project.artifactId$
  build.version: $project.version$
```

主启动类

```java
@SpringBootApplication
@EnableZuulProxy
public class Zuul_9527_App {
    public static void main(String[] args) {
        SpringApplication.run(Zuul_9527_App.class,args);
    }
}
```

依赖

```xml
<!-- zuul路由网关 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-zuul</artifactId>
        </dependency>
 		<dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-eureka</artifactId>
        </dependency>
```

Zuul通过Eureka上的服务名和自己配置文件中对应的路由来转发相应的请求

启动

microservicecloud-config-dept-client-8001,microservicecloud-zuul-gateway-9527

Eureka集群

访问http://localhost:9527/atguigu/mydept/dept/get/1

进行测试

#### SpringCloudConfig 分布式配置中心

通过SpringCloudConfig配置中心的功能,可以把配置文件统一放在Git仓库中管理

##### SpringCloudConfig服务端

application.yml

```yml
server:
  port: 3344

spring:
  application:
    name:  microservicecloud-config
  cloud:
    config:
      server:
        git:
          skipSslValidation: true
          uri: git@github.com:Yanshaoshuai/microservicecloud-config.git #GitHub上面的git仓库名字
```

主启动类

```java
@SpringBootApplication
@EnableConfigServer
public class Config_3344_StartSpringCloudApp
{
	public static void main(String[] args)
	{
		SpringApplication.run(Config_3344_StartSpringCloudApp.class, args);
	}
}
```

依赖

```xml
 <!-- springCloud Config -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
        </dependency>
        <!-- 避免Config的Git插件报错：org/eclipse/jgit/api/TransportConfigCallback -->
        <dependency>
            <groupId>org.eclipse.jgit</groupId>
            <artifactId>org.eclipse.jgit</artifactId>
            <version>4.10.0.201712302008-r</version>
        </dependency>
```

git仓库地址: git@github.com:Yanshaoshuai/microservicecloud-config.git

文件内容如下:

microservicecloud-config-client.yml

```yaml
spring:
  profiles:
    active:
      - dev
---
server:
  port: 8201
spring:
  profiles: dev
  application:
    name: microservicecloud-config-client

eureka:
  client:
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka/
---
server:
  port: 8202
spring:
  profiles: test
  application:
    name: microservicecloud-config-client

# spring-cloud部分
eureka:
  client: #客户端注册进eureka服务列表内
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka/
```

检查服务端是否可以正确获取配置文件:

访问http://config-3344.com:3344/master/microservicecloud-config-client-dev.yml会返回dev配置内容

##### SpringCloudConfig客户端

其他从SpringCloudConfig上获取配置文件的服务都是SpringCloudConfig客户端

application.yml(非必须)

```yml
spring:
  application:
    name: microservicecloud-config-client
```

bootstrap.yml

```yml
spring:
  cloud:
    config:
      name: microservicecloud-config-client #需要从github上读取的资源名称，注意没有yml后缀名
      profile: dev   #本次访问的配置项
      label: master   
      uri: http://config-3344.com:3344  #本微服务启动后先去找3344号服务，通过SpringCloudConfig获取GitHub的服务地址
```

客户端查看配置是否正确获取:

```java
@RestController
public class ConfigClientRest
{

	@Value("${spring.application.name}")
	private String applicationName;

	@Value("${eureka.client.service-url.defaultZone}")
	private String eurekaServers;

	@Value("${server.port}")
	private String port;

	@RequestMapping("/config")
	public String getConfig()
	{
		String str = "applicationName: " + applicationName + "\t eurekaServers:" + eurekaServers + "\t port: " + port;
		System.out.println("******str: " + str);
		return "applicationName: " + applicationName + "\t eurekaServers:" + eurekaServers + "\t port: " + port;
	}
}
```

启动客户端访问localhost:8201/config可以看到相关配置信息



