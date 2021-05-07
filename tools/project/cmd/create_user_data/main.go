package main

import (
	"os"
	"fmt"
	"bufio"
	"text/template"
)

func main() {

	// ファイル作成
	fw, err := os.OpenFile("user-data", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
	}
	defer fw.Close()

	// テンプレートファイル指定
	t, err := template.ParseFiles("./configs/user-data")
	if err != nil {
		fmt.Println(err)
	}

	// パラメタを入力する
	scanner := bufio.NewScanner(os.Stdin)

	fmt.Print("Hostname >>")
	scanner.Scan()
	hostname := scanner.Text()

	fmt.Print("Username >>")
	scanner.Scan()
	username := scanner.Text()

	fmt.Print("Password >>")
	scanner.Scan()
	password := scanner.Text()

	fmt.Print("ssh_pwauth is [y/n] >>")
	scanner.Scan()
	issshpwauth := scanner.Text() == "y"

	fmt.Print("public key >>")
	scanner.Scan()
	sshkey := scanner.Text()

	//　テンプレートに書き込み
	t.Execute(fw, struct {
		Hostname string
		Username string
		Password string
		Issshpwauth bool
		Keys []string
	}{
		Hostname: hostname,
		Username: username,
		Password: password,
		Issshpwauth: issshpwauth,
		Keys: []string{sshkey}})

}
