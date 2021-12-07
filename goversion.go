/*
 * @Date: 2021-12-07 21:16:25
 * @LastEditors: Wangjun
 * @LastEditTime: 2021-12-07 21:26:51
 * @FilePath: \analysise:\go\go1.15.8\src\goversion\goversion.go
 * @Description:
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
