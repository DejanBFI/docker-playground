package main

import (
	"encoding/base64"
	"fmt"
	"os"

	"github.com/davidbyttow/govips/v2/vips"
)

const (
	width  = 120
	height = 120
)

func main() {
	vips.Startup(nil)
	defer vips.Shutdown()

	buf, err := os.ReadFile("image.jpg")
	if err != nil {
		panic(err)
	}

	img, err := vips.NewThumbnailFromBuffer(buf, width, height, vips.InterestingAttention)
	if err != nil {
		panic(err)
	}

	newImage, _, err := img.ExportNative()
	if err != nil {
		panic(err)
	}

	b := base64.StdEncoding.EncodeToString(newImage)
	fmt.Println(string(b))
}
