// test project main.go
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
