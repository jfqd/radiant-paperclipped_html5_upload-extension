jQuery.noConflict();
jQuery(document).ready(function($){
  'use strict';
  
  $(document).bind('drop dragover', function (e) {
      e.preventDefault();
  });

  function getTimestamp() {
    return Math.round((new Date()).getTime() / 1000);
  }
  
  function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
  
  // Make Rails happy
  $("body").bind("ajaxSend", function(elm, xhr, s){
    if (s.type == "POST" || s.type == "PUT") {
      xhr.setRequestHeader('X-CSRF-Token', window._authenticity_token);
    }
  });
  
  // Storing the file name in the queue
  var fileQueue = {};
  var fileName = "";
  var fileId = "";

  // On file add assigning the name of that file to the variable to pass to the web service
  $('#fileupload').bind('fileuploadadd', function (e, data) {
    $.each(data.files, function (index, file) {
      fileName = file.name;
      fileId = getTimestamp()+getRandomInt(1,100);
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
    formAcceptCharset: 'utf-8',
    singleFileUploads: true,
    add: function (e, data) {
      // add key+value to queue
      fileQueue[fileName]=fileId;
      data.context = $('<p/>')
                       .attr("id",fileId)
                       .css('width','0')
                       .text(fileName)
                       .appendTo("#files");
      data.submit();
    },
    progress: function (v, data) {
      try {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        var dataFile = data.files[0]['name'];
        $( '#' + fileQueue[dataFile]).css('width',progress + '%' );
      }
      catch (e) { console.log(e); }
    },
    done: function (e, data) {
      try {
        //console.log(data.result.asset_id);
        var asset_id = data.result.asset_id;
        var dataFile = data.files[0]['name'];
        $form = $('<form id="asset_form_' + asset_id + '" action="/admin/assets/' + asset_id + '/describe" method="put"></form>');
        $form.append('<label><span>Title</span><input id="asset_title_' + asset_id + '" name="asset[title]" type="text" value="' + dataFile + '" /></label>');
        $form.append('<label><span>Caption</span><input id="asset_caption_' + asset_id + '" name="asset[caption]" type="text" value="" /></label>');
        $form.append('<input name="commit" type="submit" id="submit_' + asset_id + '" value="Speichern" />');
        $form.append('<a id="cancel_' + asset_id + '" href="#">Abbrechen</a>');
        $('#'+fileQueue[dataFile]).html($form).append('<a href="/admin/assets/' + asset_id + '/edit" id="filename_' + asset_id + '" style="display:none;">' + dataFile + '</a>');
        // setup vars
        var my_form = $( '#asset_form_' + asset_id );
        var my_filename = $( '#filename_' + asset_id );
        var my_cancel = $( '#cancel_' + asset_id );
        var my_submit = $( '#submit_' +  asset_id );
        // Prevent form submission with return key!
        my_form.keypress(function(event) {
          var code = event.keyCode || event.which;
          if (code == 13) {
            event.preventDefault();
            return false;
          }
        });
        //delete fileQueue[dataFile];
        my_cancel.click(function() {
          my_filename.show();
          my_form.hide();
        });
        my_submit.click(function() {
          var title = $('#asset_title_' + asset_id);
          var caption = $('#asset_caption_' + asset_id);
          // simple validation
          if (title.val()=='') {
            title.addClass('validation-error');
            return false;
          } else {
            title.removeClass('validation-error');
          }
          // disable input fields
          my_submit.attr('disabled','disabled');
          title.attr('disabled','true');
          caption.attr('disabled','true');
          my_cancel.hide();
          // construct data
          var data = 'asset[title]=' + encodeURIComponent(title.val()) + 
                     '&asset[caption]=' + encodeURIComponent(caption.val());
          $.ajax({
            url: '/admin/assets/' + asset_id + '/describe',
            type: 'PUT',
            data: data,
            cache: false,
            success: function (response) {
              my_filename.show();
              my_form.hide();
              console.log("done!");
            }
          }).fail(function() {
            title.attr('disabled','false');
            caption.attr('disabled','false');
            my_submit.attr('disabled', 'false');
            title.addClass('validation-error');
            caption.addClass('validation-error');
            my_cancel.show();
          });
          return false;
        });
      }
      catch (e) { console.log(e); }
    },
    fail:function(e, data){
      data.context.addClass('error').css('width','100%');
    }
  }).prop('disabled', !$.support.fileInput)
      .parent().addClass($.support.fileInput ? undefined : 'disabled');
});