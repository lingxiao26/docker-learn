1. auto-deployer.sh
  > source ssh-agent.sh
  > execute do_build function in do_build.sh
  ? REPO=git@code.myunsheji.com:sjy-mbuy/mbuy-order-service.git

2. do_build.sh
  > get branch (master)
  > cd /home/ecs-user/nebula-devops/apps
  ? REPO=sjy-mbuy/mbuy-order-service.git
  ? BRANCH=master => STAGE=alpha
  > source ./docker/mu/mbuy/mbuy-order-service/actions.sh
  	1. source common-k8s.sh
  		* source common.sh
  			1. source global.sh 
  				* 定义了一些全局变量
  			2. mkdir $BUILD_DIR
  				* mkdir -p /home/ecs-user/nebula-devops/apps/build/docker/mu/mbuy/mbuy-order-service
  		* mkdir $BUILD_DIR
  		* Dockerfile_REPO=/home/ecs-user/nebula-dockers
  	2. source common-all-k8s.sh # define some function
  > execute function build (in actions.sh) # build master alpha
  	1. source /home/ecs-user/nebula-devops/apps/docker/mu/mbuy/mbuy-order-service/alpha/nodes.sh
  		* 定义项目发布所在的目标主机
  	2. exec func hightlight "$NODES" # 高亮主机
  	3. exec func shell_lock # 创建锁文件
  	4. exec func sync_repo "$APP" "$REPO" "$BRANCH" # 同步代码
  		* mkdir build_dir(if not exist) ; cd build_dir
  		* git reset --hard HEAD; git clean -ff -d; git remote prune origin; git pull
  	5. exec func config "$APP" "$STAGE"; (func config in common-k8s.sh) # 更新配置
  		CONFIG_REPO="/home/ecs-user/gits/nebula-config-repo"
  		* cd $CONFIG_REPO ; git pull
  		* cp -a $CONFIG_REPO/common/$STACK/$STAGE/* $WORK_DIR/ # log4j.properties
  		* cd "$Dockerfile_REPO"; git pull # cd /home/ecs-user/nebula-dockers
  		








