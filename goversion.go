package goversion

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
