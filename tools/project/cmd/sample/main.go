package main

import (
	"fmt"
	"os"
	"text/template"
)

func main() {
	// ファイル作成
	fw, err := os.OpenFile("sample", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
	}
	defer fw.Close()

	t, err := template.ParseFiles("./configs/sample")
	if err != nil {
		fmt.Println(err)
	}

	t.Execute(fw, struct {
		Name string
		URL  string
	}{Name: "TEST-USER", URL: "https://qiita.com"})

}
