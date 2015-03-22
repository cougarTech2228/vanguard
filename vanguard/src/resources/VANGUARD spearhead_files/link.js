Link = function() {
    this.listening = false;
    this.info_bar = document.createElement('div');
    this.info_bar.id="info_bar"
    document.body.appendChild(this.info_bar);

    function link(url) {
        $("html").fadeOut(function() {
            // when the animation is complete, set the new location
            location = url;
        });
    }
    
    container = document.createElement('div');
    container.className = "github_container";

    github = document.createElement('div');
    github.innerHTML = '<a href="https://github.com/cougarTech2228/Vanguard" target="_blank">Fork me on GitHub</a>';
    github.className = "github";

    container.appendChild(github);
    document.querySelector("body").appendChild(container);
    
        document.addEventListener("keydown", function(event) {
        event = event || window.event;
        key = event.keyCode;

        if (key == 191) {
            this.listening = !this.listening;
            linker.info_open();
            linker.info_text("?");
            event.preventDefault();
            
        } else if (this.listening) {
            this.listening = !this.listening;
            event.preventDefault();

            if (key == 65) {
                 linker.info_text("switching to laserscope");
                link("/picture.html");
            } else if (key == 83) {
                 linker.info_text("switching to spearhead");
                link("/input.html");
            } else if (key == 68) {
                 linker.info_text("switching to datacrystal");
                link("/vanguard.html");
            } else if (key == 70) {
                 linker.info_text("switching to aquapipe");
                link("/checklist.html");
            } else {
                try{
                  command(key);
                }catch(e){
                  linker.info_say("unknown command")
                }
            }

        }
    });
}

Link.prototype.info_say = function (text){
  delay = 1000;
  this.info_open();
  this.info_text(text);
  setTimeout(this.info_close,delay);
}

Link.prototype.info_open = function (text){
  this.info_bar.style.opacity=.8;
}

Link.prototype.info_text = function (text){
  this.info_bar.innerHTML = text;
}

Link.prototype.info_close = function (text){
  this.info_bar.style.opacity=0;
}
    

function queryParameter(name){
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
    results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

linker = new Link();
