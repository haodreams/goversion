#!/bin/bash -e


#$1 当前的工作目录，必须传递的参数

#这行代码兼容windows
PATH="/d/Program Files/Git/bin":$PATH

#===========================以下代码勿动===============================

DIR=$1

OS=$(uname -s)
BuildDate=$(date "+%Y-%m-%d")
PluginDate=$(date "+%Y%m%d")
PluginOS="linux"
set +e
output=$(git log -1 --pretty=format:'OK: %H %ci')
set -e
array=(${output/// })
IsOK=${array[0]}

GitDate=
GitCommit=
if [ "$IsOK" == "OK:" ]; then
	GitCommit=${array[1]}
	GitDate=${array[2]}" "${array[3]}
fi



if [ $# -lt 1 ]; then
	echo "  LOST PARAMTERS"
	end
fi

PluginPath=$(basename $1)

#结束调用此函数
end(){
	echo "======================== END ========================"
	#exit 
}

#运行程序
test(){
	#切换到工作目录
	echo go test -v  $DIR
	go test -v $DIR
	end
}

#运行程序
run(){
	#切换到工作目录
	cd $DIR

	echo $DIR
	#echo $(basename $1)
	#binName=$(basename($1))
	#echo $binName
	./$(basename $DIR)
	end
}

#编译程序
build(){
	if [ -n "$GitCommit" ]; then
		#echo go build -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit"
		go build -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit"
	else
		go build -ldflags "-X goversion.buildDate=$BuildDate"
	fi
	
	end
}

#编译插件
buildPlugin(){
	go build -buildmode=plugin -ldflags "-X main.buildDate=$BuildDate"
	echo $PluginPath
	
	if [ ! -d "$PluginPath" ]; then
		mkdir $PluginPath
	fi

	mv "${PluginPath}.so" $PluginPath
	
	tar zcvf "${PluginPath}.${PluginDate}.${PluginOS}.tar.gz" $PluginPath

	end
}
#切换到工作目录
cd $1

export CGO_ENABLED=1

case $# in
	1)
		export GOARCH=
		export GOOS=
		export CC=
		export CXX=			
		if [ "$OS" == "Linux" ]; then
			echo "================ BUILD LINUX VERSION ================"
		else
			echo "=============== BUILD WINDOWS VERSION ==============="
		fi
		build
	;;
	2)
		case $2 in
			"buildRun")
				set +e
				echo "================ BUILD ================"
				build
				echo "================  RUN  ================"
				run
				;;
			"linuxNoCgo")
				echo "============ BUILD LINUX WITHOUT CGO VERSION ============="
				export GOARCH=
				export GOOS=linux
				export CC=
				export CXX=		
				export CGO_ENABLED=0				
				build
				;;

			"linux")
				echo "============ BUILD LINUX VERSION ============="
				export GOARCH=
				export GOOS=linux
				export CC=
				export CXX=			
				build
				;;

			"run")
				echo "======================== RUN ========================"
				run
				;;
			"test")
				echo "======================== TEST ======================="
				test
				;;				
			"arm")
				export GOARCH=arm
				export GOARM=6
				export GOOS=linux
				export CC=arm-linux-gnueabihf-gcc
				export CXX=arm-linux-gnueabihf-g++			
				echo "================ BUILD ARM VERSION =================="
				build
				;;
			"plugin")
				echo "============ BUILD LINUX PLUGIN VERSION ============="
				export GOARCH=
				export GOOS=
				export CC=
				export CXX=			
				buildPlugin
				;;
			"plugin_arm")
				echo "============= BUILD ARM PLUGIN VERSION =============="
				export GOARCH=arm
				export GOARM=6
				export GOOS=linux
				export CC=arm-linux-gnueabihf-gcc
				export CXX=arm-linux-gnueabihf-g++	
				PluginOS="arm"		
				buildPlugin
				;;
			"arm5")
				export GOARCH=arm
				export GOARM=5
				export GOOS=linux
				export CC=
				export CXX=	
				export CGO_ENABLED=		
				echo "=============== BUILD ARM 5 VERSION ================="
				build
				;;
			*)
				echo "ERROR PARAMTERS"
				echo "Usage: $0 dir [arm|plugin|plugin_arm]"
				end
				;;
		esac
	;;
	*)
		echo "ERROR PARAMTERS"
		echo "Usage: $0 dir [arm]"
		end
	;;
esac






