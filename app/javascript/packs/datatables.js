const $  = require( 'jquery' );
const dt = require('datatables.net-dt');
require('datatables.net-dt/css/jquery.dataTables.css');

$(document).ready( function () {
    const element = $('.table').first();
    const table = element.DataTable();

    document.addEventListener("turbolinks:before-cache", function() {
        if (table !== null) {
            table.destroy();
        }
    });

    element.find('tfoot th').each((footerIndex, footerElement) => {
        let searchElement = $(footerElement).find('input, select').first();
        if (searchElement === null) return;
        searchElement = searchElement[0];

        const column = table.columns(footerIndex);
        $(searchElement).on('keyup change clear', function() {
            if (searchElement.nodeName === "SELECT") {
                const searchText = searchElement.options[searchElement.selectedIndex].text;
                column.search(searchText).draw();
            } else {
                column.search(searchElement.value).draw();
            }
        });
    });
});