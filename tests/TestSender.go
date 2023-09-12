package main

import (
	"fmt"
	"io"
	"net"
	"net/http"
)

func main() {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		fmt.Println(err)
		return
	}

	localAddress := conn.LocalAddr().(*net.UDPAddr)

	fmt.Println("your IP is : ", localAddress.IP.String())
	conn.Close()

	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		b, err := io.ReadAll(r.Body)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println(string(b))
		fmt.Fprint(w, "done")
	})
	err = http.ListenAndServe(":9090", mux)
	if err != nil {
		fmt.Println(err)
		return
	}
}
