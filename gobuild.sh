#!/bin/bash -e


#$1 当前的工作目录，必须传递的参数

#这行代码兼容windows
#PATH="/d/Program Files/Git/bin":$PATH

#===========================以下代码勿动===============================



go env -w GOSUMDB="sum.golang.google.cn"
#go env -w GOPRIVATE=gitee.com
go env -w GONOPROXY=gitee.com
go env -w GONOSUMDB=gitee.com

DIR=$1

OS=$(uname -s)
BuildDate=$(date "+%Y-%m-%d")
BuildTime=$(date "+%H:%M:%S")
PluginDate=$(date "+%Y%m%d")
PluginOS="linux"


#结束调用此函数
end(){
	echo "======================== END ========================"
	#exit 
}

if [ $# -lt 1 ]; then
	#echo "  LOST PARAMTERS"
	DIR=$(pwd)
	echo $DIR
	#end
fi

#切换到工作目录
cd $DIR

set +e
output=$(git log -1 --pretty=format:'OK: %H %ci')
set -e
# array=(${output/// })
# IsOK=${array[0]}

# GitDate=
# GitCommit=
# if [ "$IsOK" == "OK:" ]; then
# 	GitCommit=${array[1]}
# 	GitDate=${array[2]}" "${array[3]}
# fi

# 直接通过管道和awk提取字段，不使用临时文件
IsOK=$(echo "$output" | awk '{print $1}')
GitCommit=$(echo "$output" | awk '{print $2}')
GitDate=$(echo "$output" | awk '{print $3, $4}')

# if [ "$IsOK" == "OK:" ]; then
# 	GitCommit=${array[1]}
# 	GitDate=${array[2]}" "${array[3]}
# fi

# echo $GitCommit $GitDate

PluginPath=$(basename $DIR)

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
        # -extldflags -static -buildvcs=false 
		go build -tags jsoniter -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit -X goversion.buildTime=$BuildTime -X gitee.com/haodreams/goversion.buildDate=$BuildDate -X 'gitee.com/haodreams/goversion.gitDate=$GitDate' -X gitee.com/haodreams/goversion.gitCommit=$GitCommit -X gitee.com/haodreams/goversion.buildTime=$BuildTime"
		# go build -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit -X goversion.buildTime=$BuildTime"
	else
		go build -tags jsoniter -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit -X goversion.buildTime=$BuildTime -X gitee.com/haodreams/goversion.buildDate=$BuildDate -X 'gitee.com/haodreams/goversion.gitDate=$GitDate' -X gitee.com/haodreams/goversion.gitCommit=$GitCommit -X gitee.com/haodreams/goversion.buildTime=$BuildTime"
		# go build -ldflags "-X goversion.buildDate=$BuildDate -X 'goversion.gitDate=$GitDate' -X goversion.gitCommit=$GitCommit -X goversion.buildTime=$BuildTime"
	fi
	
    # if [ -f "main.go" ]; then
        # swag init
        # rm -f docs/docs.go
    # fi
	end
}

#编译远程版本
build_remote(){
	if [ -f "build.sh" ]; then
		if [ -x "build.sh" ]; then
			chmod +x build.sh
		fi
		../build.sh
	else
		echo "Not found build.sh"
	fi
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

export CGO_ENABLED=0

case $# in
	0)
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
            "cgo")
                export GOARCH=
                export GOOS=
                export CC=
                export CXX=		
                export CGO_ENABLED=1	
                if [ "$OS" == "Linux" ]; then
                    echo "================ BUILD LINUX VERSION ================"
                else
                    echo "=============== BUILD WINDOWS VERSION ==============="
                fi
                build
                ;;
            "win32")
 				export GOARCH=386
				export CC=
				export CXX=		
                export CGO_ENABLED=1	
				build
                ;;           
            "win32Cgo")
 				export GOARCH=386
				export CC=i686-w64-mingw32-gcc
				export CXX=i686-w64-mingw32-g++		
				export CGO_ENABLED=1			
				build
                ;;           
			"remote")
				build_remote
				;;
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
			"linuxCgo")
				echo "============ BUILD LINUX WITH CGO VERSION ============="
				export GOARCH=
				export GOOS=linux
				export CC=
				export CXX=		
				export CGO_ENABLED=1			
				build
				;;
			"windowsCgo")
				echo "============ BUILD WINDOWS WITH CGO VERSION ============="
				export GOARCH=
				export GOOS=windows
				export CC=
				export CXX=		
				export CGO_ENABLED=1			
				build
				;;
			"windows")
				echo "============ BUILD WINDOWS WITH CGO VERSION ============="
				export GOARCH=
				export GOOS=windows
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
			"mac")
				echo "============ BUILD MAC VERSION ============="
				export GOARCH=
				export GOOS=darwin
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
				echo "================ BUILD ARM32 VERSION =================="
				build
				;;
			"arm32")
				export GOARCH=arm
				export GOARM=6
				export GOOS=linux
                export CGO_ENABLED=0	
				echo "================ BUILD ARM32 VERSION =================="
				build
				;;
			"arm32Cgo")
				export GOARCH=arm
				export GOARM=6
				export GOOS=linux
                export CGO_ENABLED=1	
				export CC=arm-linux-gnueabihf-gcc
				export CXX=arm-linux-gnueabihf-g++			
                export AR=aarch64-linux-gnu-ar		
				echo "================ BUILD ARM32 CGO VERSION =================="
				build
				;;
			"arm64")
				export GOARCH=arm64
				export GOOS=linux
                export CGO_ENABLED=0				
				echo "================ BUILD ARM64 VERSION =================="
				build
				;;
			"arm64Cgo")
				export GOARCH=arm64
				export GOOS=linux
                export CGO_ENABLED=1	
                export CC=aarch64-linux-gnu-gcc
				export CXX=aarch64-linux-gnu-g++
                export AR=aarch64-linux-gnu-ar		
				echo "================ BUILD ARM64 CGO VERSION =================="
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
				echo "ERROR PARAMTERS $2"
				echo "Usage: $0 dir [arm|arm32|arm32Cgo|arm64|arm64Cgo|arm5|plugin|plugin_arm|darwin]"
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






