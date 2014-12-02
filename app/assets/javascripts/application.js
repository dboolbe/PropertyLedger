// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require jquery.ui.all
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function() {
    // Get the <datalist> and <input> elements.
    var dataList = document.getElementById('account-datalist');
    var textField = document.getElementById('transaction_account');

    var input = $('#transaction_account');

    input.keyup(function() {
        console.log("Working: " + input.val());
        clearChildren('account-datalist');

        // Create a new XMLHttpRequest.
        var request = new XMLHttpRequest();

        // Handle state changes for the request.
        request.onreadystatechange = function(response) {
            if(request.readyState === 4) {
                if(request.status === 200) {
                    // Parse the JSON
                    var jsonOptions = JSON.parse(request.responseText);
                    console.log(jsonOptions);
                    // Loop over the JSON array.
                    jsonOptions.forEach(function(item) {
                        // Create a new <option> element.
                        var option = document.createElement('option');
                        // Set the value using the item in the JSON array.
                        option.value = item.account;
                        // Add the <option> element to the <datalist>.
                        dataList.appendChild(option);
                    });

                    // Update the placeholder text.
                    textField.placeholder = "Search for an account ... or type in a new one";
                } else {
                    // An error occurred :(
                    textField.placeholder = "Couldn't load account options :(";
                }
            }
        };

        // Update the placeholder text.
        textField.placeholder = "Loading options...";

        // Set up and make the request.
        request.open('GET', '/ajax/accounts?term=' + input.val(), true);
        request.send();
    });

    $(function() {
        var $j = jQuery.noConflict();
        $j("#transaction_date").datepicker();
    });
});

function clearChildren(parentId) {
    var childArray = document.getElementById(parentId).children;
    if(childArray.length > 0) {
        document.getElementById(parentId).removeChild(childArray[0]);
        clearChildren(parentId);
    }
}
