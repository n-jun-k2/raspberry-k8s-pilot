package main

import (
	"os"
	"fmt"
	"bufio"
	"text/template"
)

func main() {

	// パラメタを入力する
	scanner := bufio.NewScanner(os.Stdin)

	fmt.Print("SubNetMask >>")
	scanner.Scan()
	subnetmask := scanner.Text()

	fmt.Print("Addresses >>")
	scanner.Scan()
	address := scanner.Text()

	fmt.Print("RouterIP >>")
	scanner.Scan()
	routerIP := scanner.Text()

	// ファイル作成
	fw, err := os.OpenFile("network-config", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println(err)
	}
	defer fw.Close()

	// テンプレートファイル指定
	t, err := template.ParseFiles("./configs/network")
	if err != nil {
		fmt.Println(err)
	}

	//　テンプレートに書き込み
	t.Execute(fw, struct {
		Dhcp4 bool
		Dhcp6 bool
		Addresses string
		RouterIP string
	}{
		Dhcp4: false,
		Dhcp6: false,
		Addresses: address  + "/" + subnetmask,
		RouterIP: routerIP})

}
