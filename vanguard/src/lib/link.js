Link = function() {
    this.listening = false;

    function link(url) {
        $("html").fadeOut(function() {
            // when the animation is complete, set the new location
            location = url;
        });
    }

    document.addEventListener("keydown", function(event) {
        event = event || window.event;
        key = event.keyCode;

        if (key == 191) {
            this.listening = !this.listening;
            event.preventDefault();
        } else if (this.listening) {
            this.listening = !this.listening;
            event.preventDefault();
        
            if (key == 65) {
                link("/picture.html");
            } else if (key == 83) {
                link("/input.html");
            } else if (key == 68) {
                link("/vanguard.html");
            } else if (key == 70) {
                link("/checklist.html");
            } else {
               command(key);
            }
            
        }
    });
    container = document.createElement('div');
    container.className = "github_container";
    
    github = document.createElement('div');
    github.innerHTML = '<a href="https://github.com/cougarTech2228/Vanguard" target="_blank">Fork me on GitHub</a>';
    github.className = "github";
    
    container.appendChild(github);
    document.querySelector("body").appendChild(container);
}

new Link();
