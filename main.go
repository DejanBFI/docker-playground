package main

import (
	"encoding/base64"
	"fmt"
	"os"

	"github.com/h2non/bimg"
)

func main() {
	buffer, err := bimg.Read("image.jpg")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	newImage, err := bimg.NewImage(buffer).SmartCrop(120, 120)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	size, err := bimg.NewImage(newImage).Size()
	if size.Width == 120 && size.Height == 120 {
		fmt.Println("The image size is invalid")
	}

	b := base64.StdEncoding.EncodeToString(newImage)
	fmt.Println(string(b))
}
