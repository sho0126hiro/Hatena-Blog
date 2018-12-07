
# 親ディレクトリ内のすべての1040（png,jpeg)の画像の横幅を表示する。
# ディレクトリ構造
# 親ディレクトリ
#   - 子ディレクトリ
#       - 1040
#       - 700
#       - 460
#       - 300
#       - 240
# 1040（png)の画像の横幅を表示する。
# 

for dir in `\find . -maxdepth 1 -type d`;do
	if test $dir != "."; then
		cd $dir
		for file in `\find . -maxdepth 1 -type d`;do
			if test $file != "."; then
				if test $file != "./origin";then
					convert $file/1040 $file/1040.png
					echo -n $file : 
					identify -format "%w %h\n" $file/1040.png
					convert $file/1040.png $file/1040
					rm $file/1040.png
				fi
			fi
		done
		cd ..
	fi
done
