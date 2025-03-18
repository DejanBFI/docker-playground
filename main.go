package main

import (
	"encoding/base64"
	"fmt"

	"github.com/davidbyttow/govips/v2/vips"
)

const (
	width  = 120
	height = 120
)

func main() {
	vips.Startup(nil)
	defer vips.Shutdown()

	img, err := vips.NewImageFromFile("image.jpg")
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
