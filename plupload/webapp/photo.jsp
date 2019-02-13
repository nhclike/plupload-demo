<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>plupload示例</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">

	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/print.css" />

</head>
<body>
<img src="img/sfz1.png" alt="" id="cardFrontImg"  />

<button id="uploader" class="btn btn-info">选择图片</button>
<button id="start_upload" class="btn btn-success">开始上传</button>
</body>
<script src="http://cdn.bootcss.com/jquery/1.9.0/jquery.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/plupload.full.min.js"></script>
<script type="text/javascript">
    var uploader = new plupload.Uploader({
        runtimes : 'html5,flash,silverlight',//设置运行环境，会按设置的顺序，可以选择的值有html5,gears,flash,silverlight,browserplus,html
        flash_swf_url : './js/Moxie.swf',
        silverlight_xap_url : './js/Moxie.xap',
        url : '${pageContext.request.contextPath}/uploadFile.do',//上传文件路径
        max_file_size : '10gb',//100b, 10kb, 10mb, 1gb
        chunk_size : '10mb',//分块大小，小于这个大小的不分块
        unique_names : true,//生成唯一文件名
        browse_button : 'uploader',
        filters: {
            mime_types : [ //只允许上传图片和zip文件
                { title : "Image files", extensions : "jpg,gif,png" }
            ],
            prevent_duplicates : true //不允许选取重复文件
        },
        multipart:true,//为true时将以multipart/form-data的形式来上传文件，为false时则以二进制的格式来上传文件
        multipart_params: {}, //文件上传附加参数
        init : {
            FilesAdded: function(up, files) {
                console.log('FilesAdded');
                console.log(up);
                console.log(files);
                //上传选择多张时，保存的永远的是最后一张
                if (up.files.length>=1) {
                    up.splice(0, up.files.length-1);
                    for (var i = up.files.length-1; i >0 ; i--) {
                        if (i!=up.files.length-1) {
                            up.removeFile( up.getFile(file[i].id));
                        }
                    }
                }
                plupload.each(files, function (file) {

                    //显示预览图片
                    previewImage(file, function(imgSrc) {
                        $("#cardFrontImg").attr("src", imgSrc);
                    });

                });
                return false;
            },
            FilesRemoved:function (up, files) {
                console.log('FilesRemoved');
                console.log(files);

            },
            FileUploaded : function(up, file, info) {//文件上传完毕触发
                console.log("单独文件上传完毕");
                var response = $.parseJSON(info.response);
                if (response.status) {
                    //$('#result').append( $('<div> "文件路径是："' + response.fileUrl + '"随机的文件名字为："' + file.name + '</div>') );
                }
            },
            UploadComplete : function( uploader,files ) {
                console.log("所有文件上传完毕");
            },
            UploadProgress : function( uploader,file ) {

            },
            Error:function (uploader,info) {
                console.log("error");
                console.log(uploader);
                console.log(info);

            }
        }
    });

    uploader.init();
    document.getElementById('start_upload').onclick = function(){
        uploader.start(); //调用实例对象的start()方法开始上传文件，当然你也可以在其他地方调用该方法
    }
    function previewImage(file, callback) {//file为plupload事件监听函数参数中的file对象,callback为预览图片准备完成的回调函数
        if (!file || !/image\//.test(file.type)) return; //确保文件是图片
        if (file.type == 'image/gif') {//gif使用FileReader进行预览,因为mOxie.Image只支持jpg和png
            var fr = new mOxie.FileReader();
            fr.onload = function () {
                callback(fr.result);
                fr.destroy();
                fr = null;
            }
            fr.readAsDataURL(file.getSource());
        } else {
            var preloader = new mOxie.Image();
            preloader.onload = function () {
                preloader.downsize(200, 300);//先压缩一下要预览的图片,宽300，高300
                var imgsrc = preloader.type == 'image/jpeg' ? preloader.getAsDataURL('image/jpeg', 80) : preloader.getAsDataURL(); //得到图片src,实质为一个base64编码的数据
                callback && callback(imgsrc); //callback传入的参数为预览图片的url
                preloader.destroy();
                preloader = null;
            };
            preloader.load(file.getSource());
        }
    }
</script>
</html>