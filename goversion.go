/*
 * @Author: Wangjun
 * @Date: 2022-11-04 14:49:05
 * @LastEditTime: 2023-02-13 18:16:34
 * @LastEditors: Wangjun
 * @Description:
 * @FilePath: \xdasd:\go\go1.19\src\goversion\goversion.go
 * hnxr
 */
package goversion

//使用说明
/*
使用脚本编译
goversion 放到go环境的src目录下

gobuild.sh 放到$PATH 目录

bash gobuild.sh


包必须在 %GOPATH%\src 目录下
*/

var (
	buildDate string
	buildTime string
	gitDate   string
	gitCommit string
	version   string
)

// Info 版本信息
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

// GetBuildDate 编译日期和时间
func GetBuildDateTime() string {
	if buildTime == "" {
		return buildDate
	}
	return buildDate + " " + buildTime
}

func GetBuildDate() string {
	return buildDate
}

// GetGitCommit 获取git提交信息
func GetGitCommit() string {
	return gitCommit
}
