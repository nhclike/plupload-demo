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
<div id="filelist">
	<ul id="ul-file">

	</ul>
</div>
<button id="uploader" class="btn btn-info">选择文件</button>
<button id="start_upload" class="btn btn-success">开始上传</button>
<div id="result"></div>
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
        { title: "files", extensions: "jpg,png,gif,mp4,docx,doc,ppt,pptx,mkv,pdf" }
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

          var li = '';
          plupload.each(files, function(file) { //遍历文件
              li += "<li id='" + file['id'] + "'>" +

                  "<span class='name' title='"+file.name+"'>"+file.name+"</span>" +
                  "<div class='progressContainer'>" +
                  "<div class='progress progress-striped'>" +
                  "<div class='progress-bar progress-bar-success' role='progressbar'"+
                  "aria-valuenow='60' aria-valuemin='0' aria-valuemax='100'"+
                  "style='width: 0%'>"+
                  "<span class='percent'>0% 完成（警告）</span>"+
                  "</div>"+
                  "</div>" +
                  "</div>"+

                  "<span class='deleteFile' data-id='" + file['id'] + "'>删除</span>" +
                  "<span class='finish'  style='display: none'>完成</span>" +
                  "</li>";
              //alert(fileType)
          });
          $("#ul-file").append(li);

        return false;
      },
      FilesRemoved:function (up, files) {
        console.log('FilesRemoved');
        console.log(files);
        $('#'+files[0].id).remove();
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
          var percent = file.percent;
          if(percent===100){
              $("#" + file.id).find(".finish").show();
              $("#" + file.id).find(".deleteFile").hide();
          }
          $("#" + file.id).find('.progress-bar').css({ "width": percent + "%" });
          $("#" + file.id).find(".percent").text(percent + "%");
      },
        Error:function (uploader,info) {
          console.log("error");
          console.log(uploader);
          console.log(info);
			if(info.code==-602){
				var errFileName=info.file.name
              alert(errFileName+"已经存在");
            }
        }
    }
  });
		$("#filelist").on('click','.deleteFile',function () {
			var id=$(this).attr('data-id');
      console.log(id);
			var file=uploader.getFile(id);
      uploader.removeFile(file);
    })
  uploader.init();
  document.getElementById('start_upload').onclick = function(){
    uploader.start(); //调用实例对象的start()方法开始上传文件，当然你也可以在其他地方调用该方法
  }
</script>
</html>