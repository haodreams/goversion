package main

import (
	"goversion"
	"log"
)

var (
	buildDate string
	gitDate   string
	gitCommit string
)

func version() {
	if buildDate != "" {
		log.Println("Build date:", buildDate)
	}
	if gitDate != "" {
		log.Println("Git date:", gitDate)
	}
	if gitCommit != "" {
		log.Println("Git version:", gitCommit)
	}
}
func main() {
	version()
	log.Println(goversion.Info())
}
