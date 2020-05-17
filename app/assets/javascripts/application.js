// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require cable
//= require datatable
//= require_tree .


$(document).ready(function() {
	$("p.alert, p.notice").click(function(event) {
		$(this).hide();
	});
});

$( document ).on('turbolinks:load', function() {
	// Initilize the table and save any state changes.
	var table = $('[id$="table"]').DataTable({
		stateSave: true
	});

	// Check if filter needs to be applied
	if ((window._search != undefined) && (window._search.length > 0 )) {
		// Apply the filter param to the filter box.
		table.search(window._search);
		table.draw();

		// Clear the filter in the URL when the search param is updated.
		table.on( 'search.dt', function () {
			if ((table.search() != window._search) && (window._search.length > 0 )) {
				var url = window.location.href;
				var tail = url.substring(url.lastIndexOf('/') + 1);
				var clean_tail = tail.substring(0, tail.lastIndexOf('?'));
				var clean_title = document.title.replace(/#(.*?)\s/, '');

				history.replaceState({}, clean_title, clean_tail);
				document.title = clean_title;
			}
		});
	}
});
