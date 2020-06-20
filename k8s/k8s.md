# K8S

k8s集群节点类型：
  * master node
  * worker node

master节点的组件：
  * apiserver (接受客户端操作k8s的指令)
    > k8s API, 集群的统一入口，各组件协调者，以restful api提供接口服务，所有对象资源的
    > 增删改查和监听操作都交给APIServer处理后再提交给Etcd存储
  * schduler  (从多个workder node节点的组件中选举一个来启动服务)
    > 根据调度算法为新创建的Pod选择一个Node节点，可以任意部署，可以部署在同一个节点上，也可以部署在不同的节点上
  * controller manager (向worker节点的kubelet发送指令的)
    > 处理集群中常规后台任务，一个资源对应一个控制器，而Controller manager就是负责管理这些控制器

node节点的组件
  * kubelet (向docker发送指令管理docker容器)
    > 管理本机运行容器的生命周期，比如创建容器，Pod挂载数据卷，下载secret，获取容器和节点状态
    > kubelet将每个Pod转换成一组容器
  * kube-proxy (管理docker容器的网络)
    > 在node节点上实现Pod网络代理，维护网络规则和四层负载均衡工作

etcd：(k8s的数据存储)
  > 分布式键值存储系统，用于保存集群状态数据，比如Pod，Service等对象信息

# k8s核心概念

1. Pod
  * 最小部署单元
  * 一组容器的集合
  * 一个Pod中的容器共享网络命名空间
  * Pod是短暂的

2. Controller: 控制Pod启动，停止，删除
  * ReplicaSet：确保预期的Pod副本数量
  * Deployment：无状态应用部署
  * StatefulSet：有状态应用部署
  * DaemonSet：确保所有node运行同一个Pod
  * Job：一次性任务
  * Cronjob：定时任务

3. Service
  > 将一组Pod关联起来，提供一个统一的入口，即使Pod地址发生改变，不会影响service，可以保证用户的访问不会受到影响

4. Label
  > 一组Pod有一个统一的标签，service通过标签和一组Pod进行关联

5. Namespace
  > 

# 部署k8s测试环境

## 单master集群
### 集群规划
  * master
    hostname： k8s-master1
    IP：       192.168.56.200
  * worker1
    hostname： k8s-node1
    IP：       192.168.56.210
  * worker2
    hostname： k8s-node2
    IP：       192.168.56.211
  * k8s version 

### 初始化服务器
  1. 关闭防火墙
    systemctl stop firewalld
    systemctl disable firewalld
  2. 关闭selinux
  3. 配置主机名
  4. 配置名称解析
  5. 配置时间同步
    k8s-master作为时间服务器， worker节点把时间同步服务器地址设置为k8s-master
    * master
      - yum install chrony -y
      - vim /etc/chrony.conf
        > 去掉allow前面的注释
    * worker
      - yum install chrony -y
      - vim /etc/chrony.conf
        > 把server地址修改为master的ip或主机名

  6. 关闭交换分区
    swapoff -a
    delete end line in /etc/fstab




### 部署etcd
1. install etcd
  * yum install etcd -y
  * vim /etc/etcd/etcd.conf
    ```
    #[Member]
    ETCD_DATA_DIR="/var/lib/etcd/etcd-1.etcd"
    ETCD_LISTEN_PEER_URLS="http://192.168.56.200:2380"
    ETCD_LISTEN_CLIENT_URLS="http://192.168.56.200:2379"
    ETCD_NAME="etcd-1"
    #[Clustering]
    ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.56.200:2380"
    ETCD_ADVERTISE_CLIENT_URLS="http://192.168.56.200:2379"
    ETCD_INITIAL_CLUSTER="etcd-1=http://192.168.56.200:2380,etcd-2=http://192.168.56.210:2380,etcd-3=http://192.168.56.211:2380"
    ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
    ETCD_INITIAL_CLUSTER_STATE="new"
    ```

  * check cluster is health
    ```etcdctl --endpoints="http://192.168.56.200:2379,http://192.168.56.210:2379,http://192.168.56.211:2379" cluster-health```

  