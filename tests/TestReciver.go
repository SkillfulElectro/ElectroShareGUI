package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func main() {
	var reciver string
	fmt.Println("Insert reciver IPv4 of Reciver !")
	fmt.Scanln(&reciver)

	reciver = fmt.Sprintf("http://%s:9090/", reciver)

	result, err := http.Post(reciver, "app.exe", strings.NewReader("hi"))
	if err != nil {
		fmt.Println(err)
	}

	b, _ := io.ReadAll(result.Body)
	fmt.Println(string(b))
}
