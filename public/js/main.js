(function($,window,document,_,Backbone){
    var App = {
        Views: {},
        Routers: {}
    };

    App.Routers.Main = Backbone.Router.extend({
        routes: {
          '': 'defaultAction',
          '_=_': 'defaultAction',
          '!/where': 'whereAction'

        },
        initialize: function() {
            $('#layout').height(window.innerHeight+70);
            setTimeout(function() {
                window.scrollTo(0, 1);
            },300);

            this.mainView = new App.Views.Main();
            this.whereView = new App.Views.Where();
        },
        defaultAction: function() {
            this.mainView.render();
            if(this.whereView)
                this.whereView.exit();
        },
        whereAction: function() {
            if(this.whereView)
                this.whereView.render();
        }
    });

    App.Views.Main = Backbone.View.extend({
        el:'.login,.logged',
        initialize: function() {
        },
        render: function() {
          this.$el.addClass('active');
        },
        exit: function() {
          this.$el.removeClass('active');
        }
    });

    App.Views.Where = Backbone.View.extend({
        el: '.where',
        initialize: function() {
            if(!this.$el.size())
                return false;

        },
        render: function() {
            this.$el.addClass('active');
            window.scrollTo(0, 1);
        },
        exit: function() {
            this.$el.removeClass('active');
        }
    });

    new App.Routers.Main();
    Backbone.history.start();
    

    

}(jQuery,window,document,_,Backbone));
