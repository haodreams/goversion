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
	buildTime string
	gitDate   string
	gitCommit string
	version   string
)

//Info 版本信息
func Info() (s string) {
	if buildDate != "" {
		if buildTime != "" {
			s += "Build date:" + buildDate + " " + buildTime + "\r\n"
		} else {
			s += "Build date:" + buildDate + " " + buildTime + "\r\n"
		}
	}
	if version != "" {
		s += "Version: " + version + "\r\n"
	}
	if gitDate != "" {
		s += "Git date:" + gitDate + "\r\n"
	}
	if gitCommit != "" {
		s += "Git version:" + gitCommit + "\r\n"
	}

	return
}

//GetBuildDate 编译日期和时间
func GetBuildDate() string {
	if buildTime == "" {
		return buildDate
	}
	return buildDate + " " + buildTime
}
