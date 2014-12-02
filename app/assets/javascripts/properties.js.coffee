# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ document
.ready ->
  researchEffortsInitPagse()

`
function researchEffortsInitPagse() {
    var default_dataTable_params = {
        "oLanguage": {
            "sEmptyTable": "There are no entries available at this time."
        },
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": true,
        "bRetrieve": true
    };

    var specific_dataTable_params = {
        "all_regs": {
            "aaSorting": [
                [1, 'desc']
            ],
            "aoColumns": [
                { "bSortable": true },
                { "bSortable": true },
                { "bSortable": true },
                { "bSortable": false },
                { "bSortable": false },
                { "bSortable": false },
                { "bSortable": false },
                { "bSortable": false },
                { "bSortable": false }
            ],
//            "aoColumnDefs": [
//                { "iDataSort": 8, "aTargets": [ 7 ] },
//                { "bVisible": false, "aTargets": [ 8 ] }
//            ],
            "bPaginate": true,
            "bLengthChange": true,
            "bFilter": true,
            "bInfo": true,
            "bProcessing": true,
            "bServerSide": true,
            "sAjaxSource": $(this).data('source')
        }
    };

    $('.datatable').each(function(){
        var specific_params = specific_dataTable_params[$(this).attr("id")];
        var combined_params = $.extend({}, default_dataTable_params, specific_params);
        $(this).dataTable(combined_params);
    });

    // DOM Elements are created in Javascript, so their styles needed to updated in it too.
    $('.dataTables_filter > label').each(function() {
        $(this).contents().filter(function() {
            return this.nodeType == 3;
        }).remove();
        $(this).css('width', '50%');

        var $input = $(this).children();
        $input.css('width', '100%');
        $input.addClass('form-control');
        $input.attr('placeholder', 'Search research effort/contact name');
    });

    $('.dataTables_length > label > select').each(function() {
        $(this).addClass('form-control');
    })
}
`