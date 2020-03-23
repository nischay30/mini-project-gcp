(function ($) {
    $(document).ready(function () {

        // The name of the product host. This is pulled from the Kubernetes service.
        var productHost = "http://35.197.233.56/";

        // The name of the ads host. This is pulled from the Compute Engine Load Balancer.
        var adHost = "http://34.98.80.83/";

        var app1 = new Vue({
            delimiters: ['[[', ']]'],
            el: '#items',
            data: {
                items: []
            },
            mounted() {

                var that = this;

                var request = $.ajax({
                    url: productHost,
                    method: "GET",
                    dataType: "json"
                });

                request.done(function (serviceJson) {
                    dataUrl = serviceJson.url;

                    var r = $.ajax({
                        url: dataUrl,
                        method: "GET",
                        dataType: "json",
                        crossDomain: true,
                    });

                    r.done(function (data) {
                        that.items = data;
                    });

                    r.fail(function (jqXHR, textStatus) {
                        console.log("Request failed: " + textStatus);
                    });

                });

                request.fail(function (jqXHR, textStatus) {
                    console.log("Request failed: " + textStatus);
                });
            }

        });

        var app2 = new Vue({
            delimiters: ['[[', ']]'],
            el: '#ads',
            data: {
                item: {}
            },
            mounted() {
                var that = this;

                var request = $.ajax({
                    url: adHost,
                    method: "GET",
                    dataType: "json"
                });

                request.done(function (data) {
                    that.item = data;
                });

                request.fail(function (jqXHR, textStatus) {
                    console.log("Request failed: " + textStatus);
                });
            }
        });
    });
})(jQuery);