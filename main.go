package main

import (
	"encoding/base64"
	"fmt"
	"os"

	"github.com/h2non/bimg"
)

const (
	width  = 120
	height = 120
)

func main() {
	buffer, err := bimg.Read("image.jpg")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	newImage, err := bimg.NewImage(buffer).SmartCrop(width, height)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
	}

	size, err := bimg.NewImage(newImage).Size()
	if size.Width != width || size.Height != height {
		fmt.Println("The image size is invalid")
		os.Exit(1)
	}

	b := base64.StdEncoding.EncodeToString(newImage)
	fmt.Println(string(b))
}
