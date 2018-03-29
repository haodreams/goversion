package main

import (
	"goversion"
	"log"
	"magus/logs"
)

var (
	buildDate string
	gitDate   string
	gitCommit string
)

func version() {
	if buildDate != "" {
		logs.Info("Build date:", buildDate)
	}
	if gitDate != "" {
		logs.Info("Git date:", gitDate)
	}
	if gitCommit != "" {
		logs.Info("Git version:", gitCommit)
	}
}
func main() {
	version()
	log.Println(goversion.Info())
}
