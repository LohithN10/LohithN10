(function(){

    "use strict";

    const btn = document.querySelectorAll('button')[0];
    var pTag = document.querySelectorAll('p');
    const divt = document.querySelector('div');
    const Pb = document.querySelectorAll('button')[1];
    const Rbtn = document.querySelectorAll('button')[2];
    // btn.addEventListener('click',function(event){
    //     pTag.setAttribute('style','color:green');
    // })

    btn.onclick = function(){
        for (let i=0;i<pTag.length ; i++)
        pTag[i].style.color = 'green';
    }

    Pb.addEventListener('click', function(){
        var newP = document.createElement('p');
        var text = document.createTextNode('A new paragraph')
        newP.appendChild(text);
        divt.appendChild(newP);
    })

    Rbtn.addEventListener('click', function(){
        var allp = document.querySelectorAll('div p');
        // // var child = ];
        allp[allp.length-1].remove();
    })

})();