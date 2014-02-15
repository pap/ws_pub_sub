var websocket;
      var connected = false;

      //qs = generateGuid();
      //qs = "xpto";
      qs = "00721b2a-046c-4ecc-a5df-5f808cc6c58f";
      $(document).ready(init);

      function init() {
          document.getElementsByName("open")[0].disabled = true;
          document.getElementsByName("close")[0].disabled = true;
          if(!("WebSocket" in window)){
              $('#status').append('<p><span style="color: red;">websockets not supported </span></p>');
              $("#navigation").hide();
          } else {
              $('#status').append('<p><span style="color: green;">websockets supported </span></p>');
              connect();
          };
      };

      function connect()
      {
          //Digital Ocean Droplet
          wsHost = "ws://188.226.147.202/websocket";
          //wsHost = "ws://realtime.pknoa.com/websocket";
          // Localhost
          //wsHost = "ws://127.0.0.1/websocket";
          wsHost = wsHost+'?'+qs;
          $('#connection').text('Connecting');
          $('#footer-info').text('GUID: ' + qs );
          websocket = $.bullet(wsHost);
          websocket.onopen = function(evt) { onOpen(evt) };
          websocket.onclose = function(evt) { onClose(evt) };
          websocket.onmessage = function(evt) { onMessage(evt) };
          websocket.onerror = function(evt) { onError(evt) };
          websocket.onheartbeat = function(evt) { onHeartbeat(evt) };
      };

      function disconnect() {
          websocket.close();
      };

      function sendTxt() {
          if(websocket.readyState == websocket.OPEN){
              txt = $("#send_txt").val();
              websocket.send(txt);
              showScreen('sending: ' + txt);
          } else {
               showScreen('websocket is not connected');
          };
      };

      function onOpen(evt) {
          $('#connection').text('Connected');
          connected = true;
          document.getElementsByName("open")[0].disabled = true;
          document.getElementsByName("close")[0].disabled = false;
      };

      function onClose(evt) {
          $('#connection').text('Disconnected');
          connected = false;
          document.getElementsByName("open")[0].disabled = false;
          document.getElementsByName("close")[0].disabled = true;
      };

      function onMessage(evt) {
          //if (evt.data == "heartbeat message"){
          if (evt.data == "status checked"){
            showHeartbeat();
          } else {
            //var obj = jQuery.parseJSON(evt.data);
            //showMessage(obj);
            showMessage(evt.data);
          }
      };

      function onHeartbeat(evt) {
        //websocket.send("ping");
        websocket.send("status");
      };



      function showHeartbeat() {
          $("#heartbeat").text(getTimeStamp());
      };

      function getTimeStamp() {
       var now = new Date();
       return ((now.getDate()) + '/' + (now.getMonth() + 1) + '/' + now.getFullYear() + " " + now.getHours() + ':'
                     + ((now.getMinutes() < 10) ? ("0" + now.getMinutes()) : (now.getMinutes())) + ':' + ((now.getSeconds() < 10) ? ("0" + now
                     .getSeconds()) : (now.getSeconds())));
      }

      function showMessage(txt) {
          var now = getTimeStamp();
          $("#msgs_last").text(now);
          $("#msgs").text(txt);
      };

      function showScreen(txt) {
          $('#output').prepend('<p>' + txt + '</p>');
      };

      function clearScreen()
      {
          $('#output').html("");
      };

      function inputChanged(Text){
        if (connected){
          sendTxt();
        }
      }

      function clearInput(){
        inputBox = document.getElementById('send_txt');
        inputBox.value = "";
        $("#msgs").text("");
        inputBox.focus();
      }

      function generateGuid() {
        var result, i, j;
        result = '';
        for(j=0; j<32; j++) {
          if( j == 8 || j == 12|| j == 16|| j == 20)
          result = result + '-';
          i = Math.floor(Math.random()*16).toString(16).toUpperCase();
          result = result + i;
        }
        return result;
      };
