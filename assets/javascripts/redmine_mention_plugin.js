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
    
    $.getJSON('/autocomplete/mention/user', function(data) {
        $.each(data, function(user) {
          user = {
              val: this.login,
              meta: this.firstname + " " + this.lastname
          };
          values.push(user);
        });
    }).done(function() {
        $("#issue_notes, #issue_description").sew({values: values, elementFactory: elementFactory, token: '@'});
    });
});
