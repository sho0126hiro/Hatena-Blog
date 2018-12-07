# imagemapの読み込み用画像を生成する
# ディレクトリ内のすべての.pngファイルに適用される。
# 元画像はoriginディレクトリにコピーされ、
# 元画像の拡張子を外した名前のディレクトリに、それぞれのサイズのファイルが生成される。

mkdir origin
for file in *.png; do
	filename=( `echo $file | tr -s '.' ' '` )
	mkdir ${filename[0]}
	convert $file -resize 240x ${filename[0]}/240
	convert $file -resize 300x ${filename[0]}/300
	convert $file -resize 460x ${filename[0]}/460
	convert $file -resize 700x ${filename[0]}/700
	convert $file -resize 1040x ${filename[0]}/1040
	mv ${filename[0]}.${filename[1]} origin
done
