<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Vanguard</title>
        <style>

        </style>
    </head>

    <body>
		<div class="panel" id="left">
			
		</div>

		<div class="panel" id="right">
		
		</div>

    </body>
    
	<script>
		link = "http://127.0.0.1:1555/";
		robot_one = null;
		robot_two = null;

		function loadRobots(bot1, bot2){
		        var request = new XMLHttpRequest();
                request.open("GET", link + "data/robot/" + bot1 , true);      
                request.send();
			    request.onreadystatechange = function() {
            		if (request.readyState == 4){
						var robot = JSON.parse(request.responseText);
						
                    }
                };
		}

            
    </script>

</html>
