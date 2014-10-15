jQuery.noConflict();
jQuery(document).ready(function($){
  'use strict';
  
  function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
  
  $("body").bind("ajaxSend", function(elm, xhr, s){
     if (s.type == "POST") {
        xhr.setRequestHeader('X-CSRF-Token', window._authenticity_token);
     }
  });
  
  // Storing the file name in the queue
  var fileName = "";
  var fileId = "";

  // On file add assigning the name of that file to the variable to pass to the web service
  $('#fileupload').bind('fileuploadadd', function (e, data) {
    $.each(data.files, function (index, file) {
      var ts = Math.round((new Date()).getTime() / 1000);
      fileName = file.name;
      fileId = ts+getRandomInt(1,100);
    });
  });

  // On file upload submit - assigning the file name value to the form data
  $('#fileupload').bind('fileuploadsubmit', function (e, data) {
    data.formData = {
      "asset[title]": fileName,
      "asset[caption]": "",
      "file_id": fileId
    };
  });

  $('#fileupload').fileupload({
      dropZone: $('#multi-fileupload'),
      dataType: 'json',
      add: function (e, data) {
        data.context = $('<p/>')
                         .attr("id",fileId)
                         .css('width','0')
                         .text(fileName)
                         .appendTo("#files");
        data.submit();
      },
      progressall: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        $('#'+fileId).css('width',progress + '%');
      },
      //done: function (e, data) {
        //data.context.text('Upload finished.');
      //},
      fail:function(e, data){
        data.context.addClass('error').css('width','100%');
      }
  }).prop('disabled', !$.support.fileInput)
      .parent().addClass($.support.fileInput ? undefined : 'disabled');
});