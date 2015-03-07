Link = function(){
     this.listening = false;   
        
     function link(url){
         $("html").fadeOut(function () {
             // when the animation is complete, set the new location
             location = url;
         });
     }
     
     document.addEventListener("keydown", function ( event ) {
          event = event || window.event;
          key = event.keyCode;          
          
          if(key == 191){
               this.listening= !this.listening;
               event.preventDefault();
          }else if(this.listening){
               if(key==65){
                    link("/picture.html");
               }else if(key==83){
                    link("/input.html");
               }else if(key==68){
                    link("/vanguard.html");
               }else if(key==70){
                    link("/checklist.html");
               }
               
               this.listening= !this.listening;
               event.preventDefault();
          }
     });

}

new Link();
