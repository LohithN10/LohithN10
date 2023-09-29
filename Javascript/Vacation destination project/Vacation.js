(function(){
"use strict";

const detailsForm = document.getElementById('destination_details_form');

detailsForm.addEventListener('submit',handleFormSubmit);

function handleFormSubmit(event){
event.preventDefault();

    let destName = event.target.elements["name"].value;
    let destLocation = event.target.elements["location"].value;
    let destPhoto = event.target.elements["photo"].value;
    let destDesc = event.target.elements["description"].value;

    for(var i=0; i<detailsForm.length;i++){
        detailsForm.elements[i].value="";
    }
    
    let destCard = createDestinationCard(destName,destLocation,destPhoto,destDesc);
    
    const wishlistContainer = document.getElementById('destination_container')

    if(wishlistContainer.children.length === 0){
        document.getElementById('title').innerHTML=`My Wish List`
    }

    document.querySelector('#destination_container').appendChild(destCard)
    //5. add the card
}

function createDestinationCard(name, location, photoURL, descrip){

    let card = document.createElement('div');
    card.className='card';

    let img = document.createElement('img');

    card.appendChild(img);

    const constImage = 'images/default.jpg';

    if (photoURL.length === 0){
        img.setAttribute('src',constImage);
    }
    else{
        img.setAttribute('src',photoURL);
    }

    let card_body = document.createElement('div');
    card_body.className = 'card-body';

    let cardTitle = document.createElement('h3');
    cardTitle.innerText=name;
    card_body.appendChild(cardTitle);

    let cardLocation = document.createElement('h4');
    cardLocation.innerText=location;
    card_body.appendChild(cardLocation)

    if(descrip){
    let cardDescription = document.createElement('p');
    cardDescription.className='card-text';
    Desc.innerText=descrip;
    card_body.appendChild(cardDescription);

    }

    let btn = document.createElement('button');
    btn.innerHTML='Remove';
    
    btn.addEventListener('click', removeDestination);
    card_body.appendChild(btn);

    card.appendChild(card_body);

    return card;
}

function removeDestination(event){
    let card = event.target.parentElement.parentElement;
    card.remove();
}
})();