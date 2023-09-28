(function(){

    "use strict";

    const form = document.getElementById('convert')
    let convertType = 'kilometers';
    const heading = document.querySelector('h1');
    const intro = document.querySelector('p');
    const answerDiv = document.querySelector('#answer');
    const direction = document.getElementById('direction');


    document.addEventListener('keydown',function(event){

        let key = event.code;
        // alert(key)
       if (key === 'KeyM'){
        convertType = 'miles';
        heading.innerHTML=`Kilometers to miles converter`;
        intro.innerHTML='Type in the number of miles and click the button to convert the distance to kilometers'
        direction.innerHTML=`<h3>Press the "K" key to switch to miles to kilometers convertion</h3>`
       }
       else if (key === 'KeyK' )
       {
        convertType='kilometers';
        heading.innerHTML=`Miles to kilomters converter`;
        intro.innerHTML='Type in the number of kilometers and click the button to convert the distance to miles'
        direction.innerHTML=`<h3>Press the "M" key to switch to kilometers to miles convertion</h3>`

       }
    })

    form.addEventListener('submit', function (event) {
    event.preventDefault();    
    
    let distance = parseFloat(document.getElementById('distance').value);

    if (distance){
        if (convertType==='kilometers'){
            answerDiv.innerHTML=`<h2>${distance} miles converts to ${(1.60934*distance).toFixed(2)} kilometers</h2>`;
        }
        
        if(convertType==='miles'){
            answerDiv.innerHTML=`<h2>${distance} kilometer converts to ${(0.621371*distance).toFixed(2)} miles</h2>`;
        }
    }
    else{
            answerDiv.innerHTML=`<h2>Please provide a number!</h2>`;
    }
})
})();