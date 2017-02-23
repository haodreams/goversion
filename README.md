# goversion

1. 编译goversion
2. 改名 %GOROOT%\bin\go.exe ==> %GOROOT%\bin\goo.exe
3. 复制goversion.exe ==> %GOROOT%\bin\goversion.exe
4. 改名 %GOROOT%\bin\goversion.exe ==> %GOROOT%\bin\go.exe

5. 添加以下代码到项目包main


示例:

package main

import (
	"fmt"	
)

var (
	buildDate string	
	gitDate   string	
	gitCommit string	
)
func version() {
	if buildDate != "" {	
		fmt.Println("Build date:", buildDate)		
	}	
	if gitDate != "" {	
		fmt.Println("Git date:", gitDate)		
	}	
	if gitCommit != "" {	
		fmt.Println("Git version:", gitCommit)		
	}	
}

func main() {
	version()	
}
