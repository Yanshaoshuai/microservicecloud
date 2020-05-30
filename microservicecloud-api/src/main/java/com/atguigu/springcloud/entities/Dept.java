package com.atguigu.springcloud.entities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.Serializable;

/**
 * @author 14469
 */
@AllArgsConstructor
@NoArgsConstructor
@Data
//set方法返回当前对象
@Accessors(chain = true)
public class Dept implements Serializable {
    /**
     * 主键
     */
    private Long 	deptno;
    /**
     * 部门名称
     */
    private String 	dname;
    /**
     * 来自那个数据库，因为微服务架构可以一个服务对应一个数据库，同一个信息被存储到不同数据库
     */
    private String 	db_source;

    public Dept(String dname)
    {
        super();
        this.dname = dname;
    }
}
