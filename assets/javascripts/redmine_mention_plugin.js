$(document).ready(function() {
    var values = [];
    var customItemTemplate = "<div><span />&nbsp;<small /></div>";

    function elementFactory(element, e) {
        var template = $(customItemTemplate).find('span')
                .text('@' + e.val).end()
                .find('small')
                .text("(" + (e.meta || e.val) + ")").end();
        element.append(template);
    };
    
    var projectId = $("#issue_project_id").val();
    if (projectId) {
        var watcherText = $("#watchers h3").text();

        $("body").parent().bind("DOMSubtreeModified", function() {
            var newProjectId = $("#issue_project_id").val();
            var newwatcherText = $("#watchers h3").text();
            if ((newProjectId && newProjectId != projectId)  || (newwatcherText && newwatcherText != watcherText)) {
                projectId = newProjectId;
                watcherText = newwatcherText;
                ajaxMentionUsers();
            }
        });
        ajaxMentionUsers();
        function ajaxMentionUsers() {
            var issue_id = '';
            var pathname = window.location.pathname;
            if (pathname.startsWith("/issues/")) {
                issue_id = "&issue_id=" + pathname.substring(pathname.lastIndexOf('/') + 1);
            }
            $.getJSON('/autocomplete/mention/user?project_id=' + projectId + issue_id, function(data) {
                values = [];
                $.each(data, function(user) {
                user = {
                    val: this.login,
                    meta: this.firstname + " " + this.lastname
                };
                values.push(user);
                });
            }).done(function() {
                $(window).trigger('feedLoaded', [{data: values}]);
                $("#issue_notes, #issue_description").sew({values: values, elementFactory: elementFactory, token: '@'});
            });
        }
    }
});
