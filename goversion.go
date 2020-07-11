package goversion

//使用说明
/*
1. 编译goversion
2. 改名 %GOROOT%\bin\go.exe ==> %GOROOT%\bin\goo.exe
3. 复制goversion.exe ==> %GOROOT%\bin\goversion.exe
4. 改名 %GOROOT%\bin\goversion.exe ==> %GOROOT%\bin\go.exe

包必须在 %GOPATH%\src 目录下
*/

var (
	buildDate string
	gitDate   string
	gitCommit string
)

func Info() (s string) {
	if buildDate != "" {
		s += "Build date:" + buildDate + "\r\n"
	}
	if gitDate != "" {
		s += "Git date:" + gitDate + "\r\n"
	}
	if gitCommit != "" {
		s += "Git version:" + gitCommit + "\r\n"
	}
	return
}

func GetBuildDate() string {
	return buildDate
}
