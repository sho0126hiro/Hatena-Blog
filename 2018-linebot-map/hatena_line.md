はじめに
学校の文化祭で技術系の開発をする団体ができたので、活動の一環としてHPとLINE@の製作に携わりました。
このページでは主にLINE@の自分が担当した箇所について書いています。  
文化祭の話については、3つのページに分けています。

1．実装した機能（HP/LINE@）全体の概要 （[こちら](https://sho0126hiro.hatenablog.com/?_ga=2.231328476.2103027269.1543835711-2109870035.1523712981)）  
2．LINE＠のmap機能について （今回）   
3．HPのmapページについて　（後日公開）  

# 目次
1．LINE＠ - map機能の概要  
2．imagemapオブジェクト  
3．flexメッセージ  

# LINE@ - map機能の概要
自分はフロントエンドを担当したので、サーバ側については書いていません。
主に、ユーザーからの入力の判定や、送信するメッセ―ジの指定等について書いています。
LINE＠のマップ機能では、直感的な操作で詳細マップ、模擬店の詳細を表示することで、エリアごとの遷移などを容易に行うシステムを実現しています。(詳細は[こちら](https://sho0126hiro.hatenablog.com/?_ga=2.231328476.2103027269.1543835711-2109870035.1523712981))

[f:id:sho0126hiro:20181106232409p:plain:w300]            [f:id:sho0126hiro:20181106232404p:plain:w300]  
[f:id:sho0126hiro:20181106232412p:plain:w300]            [f:id:sho0126hiro:20181106232414p:plain:w300]  

システムの概要

1．ユーザーがメッセージを送信すると、そのメッセージによって指定の画像やメッセージを返信することができます。
2．「○○のマップを表示」等のメッセージに対して、imagemapオブジェクトという、アクション等が決められた画像を返信します。
3．指定できるアクションには、**特定のメッセージをユーザーに送信させること**ができます。
4．送信させたメッセージに対して、imagemapオブジェクトを返信する。

以上のような流れで、画像の一部をタップした時に別の画像を表示させることができます。

また、Flex Messageを用いることで模擬店データ、研究室データをリッチに表示しています。

# imagemapオブジェクトについて
詳細はこちら - [LINE Messaging API リファレンス](https://developers.line.biz/ja/reference/messaging-api/#imagemap-message)
> イメージマップメッセージは、複数のタップ領域を設定した画像を送信できるメッセージです。
画像全体、画像を区切って複数のタップ領域を設定することもできます。  

実際に作成したイメージマップメッセージ(一部） 
```
{
        "type": "imagemap",
        "baseUrl": "https://URL/linebot_mapImg10/Top/map-OutsideTop",
        "altText": "[Top] 校外全体マップ",
        "baseSize": {
            "height": 469,
            "width": 1040
        },
        "actions": [
            {
                "type": "message",
                "text": "[Top] 校内全体マップへ",
                "area": {
                    "x": 731,
                    "y": 55,
                    "width": 256,
                    "height": 63
                }
            }
        ]
    }
```

プロパティ―と内容は以下の通りです。  
'actions'プロパティ―には、イメージマップメッセージアクションオブジェクトを指定しています。  
この例の場合`https://URL/linebot_mapImg10/Top/map-OutsideTop`の画像で  
画像の横幅を1040pxとした時に左上：(731,55)から、右下(731+256 , 55+63)を範囲とする領域をタップすると、”[Top] 校内全体マップへ”というメッセージが送信されます。

| プロパティ― | 内容 |
|:----------:|:-----------:|
| type | メッセージのタイプ | 
| baseUrl | 画像のurlです。細かな仕様は後程説明します。 | 
| altText | 代替テキスト |  
| baseSize.height | 画像のサイズです。横幅を1040pxとした時の高さ(px) | 
| baseSize.width | 1040(px)を指定します。（固定） | 
| actions | イメージマップアクションオブジェクト（詳細は[こちら](https://developers.line.biz/ja/reference/messaging-api/#imagemap-action-objects) )| 
| action.type | アクションのタイプ : message |  
| action.text | 送信するメッセ―ジ |
| action.area | イメージマップ領域オブジェクト（詳細は[こちら](https://developers.line.biz/ja/reference/messaging-api/#imagemap-area-object)) |
| action.text.x | イメージマップの左上角からの横方向相対位置 |
| action.text.y | イメージマップの左上角からの縦方向相対位置 |
| action.text.width | タップ領域の幅 |
| action.text.height | タップ領域の高さ |

イメージマップオブジェクトの注意点
画像形式・仕様が細かく定められています。  
1．httpsであること   
2．画像形式は png,jpeg  
3．ファイルサイズは1MB以下  
4．同じ画像で横幅を 240, 300, 460, 700, 1040px 日した5つを用意する。  
5．ディレクトリの構成は下の画像のようにすること 
<figure class="figure-image figure-image-fotolife" title="イメージマップ - ディレクトリ構成">[f:id:sho0126hiro:20181203211624p:plain]<figcaption>イメージマップ - ディレクトリ構成</figcaption></figure> 
6．ファイル名に拡張子は含めないこと  
7．baseURL二はフォルダまでのpathを書くこと  

baseURLが正しくない（または条件に合わない）とこのように表示されます。 

[f:id:sho0126hiro:20181203215646j:plain]

1. httpsで画像ファイルを置く場所の確保  
参考にしたサイトは[こちら](http://www.pre-practice.net/2017/10/line-botimagemap.html)  
無料でデータを置くサービスは
    Google Drive  
    Google photo  
    Drop Box  
    Microsoft One Drive  
    FC2  
    Github の issue 等がありますが、FC2サーバーを利用しました。  
(それ以外は、画像単体のURLが確保できない等の理由で実装できませんでした。)  
2.指定した画像形式への加工方法について

横幅指定の画像を多く使用する場合、一度に多くの画像を処理しなければなりません。
自分は、shellScriptでImageMagickというソフトウェアを用いて、指定した画像形式のフォルダを生成させました。
ImageMagickについての詳細は[こちら](http://imagemagick.rulez.jp/)が分かりやすいです。

ImageMagickのconvertコマンドを使うと画像サイズを変更できます。
convertコマンドはImageMagickの代表的なコマンドで、画像のサイズ変更、フォーマット変更、画像の編集、色加工など機能は多伎にわたります。

ここでは幅を指定した画像サイズ変更の方法について書いておきます。
`convert    [変換前の画像名]    -resize    (width)x    [変換後の画像名]`
例：'convert hoge.png -resize 240x 240'
のように使用すると、"hoge.png"を幅240xに指定してサイズ変更し、"240"というファイルを出力します。
実際に使用するには、ディレクトリ構造などを考えないといけません。
実際に使用したコードは[こちら](https://github.com/sho0126hiro/Hatena-Blog/blob/master/2018-linebot-map/makeImagemap.sh)を見てください。

また、画像サイズが1040だった時の高さも`size.height`プロパティ―に指定する必要があります。
下記のスクリプトを実行すると、親ディレクトリ内の全ての画像の1040pxだったときの縦幅を取得します。
ImageMagickのidentifyコマンドを使用すると、画像サイズを取得することが可能です。
identifyコマンドは画像のフォーマットや容量、幅・高さはもちろん、他にも様々な情報を取得する事ができます。
`identify -format "%w %h\n" [ファイル名]`
のように使用すると、%wの部分に幅、%hの部分に高さが出力されます。

実際に使用したコードは[こちら](https://github.com/sho0126hiro/Hatena-Blog/blob/master/2018-linebot-map/getImagemapSize.sh)



# Flex Messageについて   
研究室の表示は、リッチにするためにFlex Messageを使用しています。  
詳細はこちら - [LINE Messaging API > Flex Messageを使う](https://developers.line.biz/ja/docs/messaging-api/using-flex-messages/)
> Flex Messageは、複数の要素を組み合わせてレイアウトを自由にカスタマイズできるメッセージです。
Flex Messageはコンテナ、ブロック、コンポーネントの3層のデータ構造から構成されます。

[FlexSimulator](https://developers.line.biz/console/fx/)を使うとレイアウトを容易に作成できます。  
[f:id:sho0126hiro:20181203233742p:plain]

Flex Messageは、イメージマップオブジェクトと違い、メッセージの形式テンプレートを作成し、そこに値を入れています。
実際に作成したFlex Message のテンプレート（一部）は[こちら]()

