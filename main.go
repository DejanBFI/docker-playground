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

	output := base64.StdEncoding.EncodeToString(buf)
	os.WriteFile("output.txt", []byte(output), 0644)

	img, err := vips.NewImageFromBuffer(buf)
	if err != nil {
		panic(err)
	}

	err = img.Thumbnail(width, height, vips.InterestingAttention)
	if err != nil {
		panic(err)
	}

	ep := vips.NewDefaultJPEGExportParams()
	newImage, _, err := img.Export(ep)
	if err != nil {
		panic(err)
	}

	b := base64.StdEncoding.EncodeToString(newImage)
	fmt.Println(string(b))
}
