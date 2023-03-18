# beautify

beautify data

开发、问题排查时经常需要数据美化（格式化），常见的 JSON 字符串的格式化，时间戳的处理等。目前没有找到好的美化工具，通常是搜索并使用 WEB 网站工具，需要美化的数据可能包含敏感信息，容易造成信息泄漏，为了方便使用以及信息安全，决定开发一个本地美化工具。美化数据包括以下数据类型：
* JSON 字符串
    * JSON 字符串转为可折叠查看的方式展示
    * 格式化输入的 JSON 字符串
    * 实时更新输入的 JSON 字符串
    * 多 TAB JSON 字符串美化
    * 可定义 TAB 名称
* 时间
    * yyyy-MM-dd HH:mm:ss 转毫秒
    * 毫秒 转 yyyy-MM-dd HH:mm:ss
* 存储
    * 单位转换，在一个单位中录入数据，可展示出其他单位对应的值
* Base64
    * Decode Base64 字符串
    * Encode Base64 字符串
* JSON Excel 转换
    * JSON 转 Excel 文件
    * Excel 文件 转 JSON