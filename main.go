// goversion project main.go
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

func git() string {
	args := []string{"log", "-1", "--pretty=format:'OK: %H %ci'"}
	cmd := exec.Command("git", args...)
	data, err := cmd.Output()
	s := strings.Trim(string(data), "'")
	if strings.HasPrefix(s, "OK: ") && err == nil {
		s = strings.TrimPrefix(s, "OK: ")
		ss := strings.Split(s, " ")
		if len(ss) > 1 {
			return fmt.Sprintf("-X main.gitCommit=%s -X main.gitDate=%s", ss[0], ss[1])
		}
	}
	return ""
}

func main() {
	var args []string
	isAdd := false
	isBuild := false
	ver := ""
	for i := 1; i < len(os.Args); i++ {
		if os.Args[i] == "build" {
			isBuild = true
			ver = git()
			if ver != "" {
				ver += fmt.Sprintf(" -X main.buildDate=%s", time.Now().Format("2006-01-02_15:04:05"))
			} else {
				ver += fmt.Sprintf("-X main.buildDate=%s", time.Now().Format("2006-01-02_15:04:05"))
			}
			break
		}
	}
	for i := 1; i < len(os.Args); i++ {
		if isBuild {
			if os.Args[i] == "-ldflags" {
				args = append(args, os.Args[i])
				i++
				if i < len(os.Args) {
					args = append(args, os.Args[i]+" "+ver)
					isAdd = true
				}
				continue
			}
			if os.Args[i] == "clean" {
				args = append(args, os.Args[i])
				isAdd = true
				continue
			}
		}
		args = append(args, os.Args[i])
	}
	if isBuild && !isAdd {
		args = append(args, "-ldflags", ver)
	}

	cmd := exec.Command("goo", args...)
	data, err := cmd.CombinedOutput()
	fmt.Print(string(data))
	if err != nil {
		fmt.Println(err)
		return
	}
}
