// Main JS File

// Start Wrapper
$ = jQuery;
jQuery(document).ready(function ($) {
    $(window).load(function () {

// Mobile Nav Menu
        $(function htMenuToggle() {

            $("#ht-nav-toggle").click(function () {
                $("#nav-primary-menu").animate({
                    height: "toggle",
                    opacity: "toggle"
                }, 400);
            });

        });

// HT fade in #ht-to-top
        $(function () {
            $(window).scroll(function () {
                if ($(this).scrollTop() > 100) {
                    $('#ht-to-top').fadeIn('1000');
                } else {
                    $('#ht-to-top').fadeOut('1000');
                }
            });

            // scroll body to 0px on click
            $('#ht-to-top').click(function () {
                $('body,html').animate({
                    scrollTop: 0
                }, 800);
                return false;
            });
        });


// Responsive Images
        $(function(){
            $('picture').picture();
        });
    });

    /* Post Heading Tabas Start */
    function scrollToAnchor(aid,speed) {

        if (typeof(aid) != "undefined" && aid !== null) {

            var aTag = $(aid);

            if (aTag.length == 0) {
                return;
            }
            var scrollToPosition = aTag.offset().top;
            if (scrollToPosition < 0) { scrollToPosition = 0 } // make sure it is not negative

            $('html, body').animate({ scrollTop: scrollToPosition },speed);
        }
    }


    $(".tab_content").click(function () {
        var link_to = $(this).data("id");
        scrollToAnchor("#target_"+link_to,'fast');
        return false;

    });

    $(".support-btn").click(function () {
        var link_to = $(this).data("id");
        scrollToAnchor("#target_"+link_to,'slow');
        return false;

    });

    sticky('sidebar','footer','sticky-sidebar');

    $("#server_submit,.text_clear").click(function(){
        var that = $(this);

        that.attr("disabled", "disabled");
        var AjaxUrl= SITE_URL + '/wp-admin/admin-ajax.php';
        var searching_text;
        if($(this).hasClass('text_clear')){
            searching_text = '';
        }else{
            searching_text = $('#searching_text').val();
        }
        $("#loader").addClass("ajax");
        $.ajax({
            type: "POST",
            url: AjaxUrl,
            data: {
                action:'servers_searching',
                search:searching_text

            },
            success: function(res){

                $('#servers_data').html(res);
                $("#loader").removeClass("ajax");
                that.removeAttr("disabled", "disabled");
            }
        });
    });

    $(".sort_servers").click(function(){
        var that = $(this);
        var search_value = $('#searching_text').val();
        var sort_order = that.data("sort");
        var sort_type = that.data("sort_type");
        $("#loader").addClass("ajax");

        if(sort_order == 'desc') {
            that.data('sort', 'asc');
        }else {
            that.data('sort', 'desc');
        }

        $.ajax({
            url : SITE_URL + '/wp-admin/admin-ajax.php',
            type : 'POST',
            data : {
                action : 'server_sorting',

                order : sort_order,
                sort_type : sort_type,
                search_text : search_value

            },
            success : function(res){
                // console.log(data);
                $('#servers_data').html(res);
                $("#loader").removeClass("ajax");
            },
            error : function(d) {
                alert('error');
            }

        });

    });


    jQuery( "#searching_text" ).keypress(function() {

        /*delay(function(){
         jQuery("#server_submit").trigger( "click" );
         }, 1000 );*/

        jQuery('.searchclear').css({"display":"block"});
    });

    /**
     * Social icons
     * */
    $(function(){
        if(IS_SINGLE == 0) return false;

        var icon_btn = $( ".pb-fxd_icon-btn"),
            icons = $('.pb-fxd_icon'),
            social_ico = $('.social_o_ic'),
            scrol_top = $('.scroll-to-top'),

            post_entry = $('.entry-header').offset().top - 200,
            $window = $(window),
            footer = $('#footer').offset().top - 200;


        $(icon_btn).click(function() {
            icons.fadeToggle( "fast", "linear" );
            icon_btn.toggleClass('plus-btn_open');
            social_ico.toggleClass('fa-minus-circle');

        });


        scrol_top.click(function() {
            $("html, body").animate({ scrollTop: 0 }, "slow"); return false;
        });


        $window.scroll(function() {
            if ($window.scrollTop() >= post_entry && $window.scrollTop() <= footer ) {
                icons.fadeIn("fast", "linear" );
                icon_btn.addClass('plus-btn_open');
                social_ico.addClass('fa-minus-circle');
            }else {
                icons.fadeOut("fast", "linear" );
                icon_btn.removeClass('plus-btn_open');
                social_ico.removeClass('fa-minus-circle');
            }

            if ( $window.scrollTop() >= footer ) {
                icons.fadeOut("fast", "linear" );
                icon_btn.removeClass('plus-btn_open');
                social_ico.removeClass('fa-minus-circle');
            }
        });

    });

    /**
     * Votedown suggestion form
     * */
    $(function(){

        /*$(".ht-voting-upvote").click(function(){

         });*/

        $('#ht-kb-rate-article').delegate('.ht-voting-downvote', 'click', function() {
            var voting_container = $('#ht-kb-rate-article');
            suggestion_box = $('.vote_down_message');
            $(".vote_up_messgae").css("display", "none");
            if(voting_container.find('.ht-voting-up').length > 0 || voting_container.find('.ht-voting-none').length > 0) {
                suggestion_box.slideDown();
            }
        });

        $('#ht-kb-rate-article').delegate('.ht-voting-upvote', 'click', function() {
            $('.vote_down_message').slideUp();
            $(".vote_up_messgae").css("display", "block");
            setTimeout(function(){
                $(".vote_up_messgae").fadeOut();
            }, 5000);
        });

        $('.cancel_suggestion').click(function(){
            suggestion_box.slideUp();
            send_mail({
                action : 'vote_mail',
                post_id : $(this).data('post_id'),
                message : $('#vote_down_message').val()
            })
        });

        $('.vote_down_message form').submit(function () {
            var email = $(this.email).val();
            var feedback = $(this.feedback).val();

            var checkbox1 = $('#checkbox1');
                if(checkbox1.is(':checked')){
                    var checkbox1val = $(checkbox1).val();

                }
            var checkbox2 = $('#checkbox2');
                 if(checkbox2.is(':checked')){
                     var checkbox2val = $(checkbox2).val();

                 }
            var checkbox3 = $('#checkbox3');
                  if(checkbox3.is(':checked')){
                      var checkbox3val = $(checkbox3).val();

                  }
            var checkbox4 = $('#checkbox4');
            if(checkbox4.is(':checked')){
               var checkbox4val = $(checkbox4).val();

             }

            var other = $('#other');
            if(other.is(':checked')){
               var otherval = $(other).val();

             }

            if ($("#nothelpfull input:checkbox:checked").length <= 0)
            {
                suggestion_box.find('.field-valid-msg').html('<h3><span>Please select any one option !</span></h3>');
                return false;
            }

            var message = $(this.vote_down_message).val();
        var post_id = $(this.post_id).val();
            $.ajax({
                url : SITE_URL + '/wp-admin/admin-ajax.php',
                type : 'POST',
                data : {
                    action    : 'vote_down_message',
                    email     :  email,
                    option1   :  checkbox1val,
                    option2   :  checkbox2val,
                    option3   :  checkbox3val,
                    option4   :  checkbox4val,
                    other   :  otherval,
                    message   :    message,
                    post_id   :    post_id

                },
                success : function(res){
                    suggestion_box.html('<h3>Thank you for suggestion !</h3>');
                    send_mail({
                        action   : 'vote_mail',
                        email    :  email,
                        option1  :  checkbox1val,
                        option2  :  checkbox2val,
                        option3  :  checkbox3val,
                        option4  :  checkbox4val,
                        other  :  otherval,
                        post_id  :  post_id,
                        message  :  message
                    })
                },
                error : function(d) {
                    alert('error');
                }
            });
        })

    });

    show_hide('sticky-tr','endlist','sticky-server-list');


    var isMobile = window.matchMedia("only screen and (max-width: 1022px)");
    if(!isMobile.matches) {
        $('.sprt-cmpn-clos').click(function () {
            setCookie('hide_sale_cmpn', '1');
            $('.sprt-cmpn').hide();
        });
    }
    if(isMobile.matches){
        $('.sprt-cmpn').hide();
    }

    $('.wt-hlobar-toggle').click(function(){
        setCookie('birthday_promo', '1');
        $('.wt-hlobar-sec').slideUp('slow');
    });
});

function clear_field(){
    //jQuery("#server_submit").trigger('click');
    jQuery('#searching_text').val("");
    jQuery('.searchclear').css({"display":"none"});
}

function search_use(){

    jQuery("#use_serach").fadeToggle();
}
function sticky(fixedElementClass,endElementClass,stickyClass,MobileSize){

    MobileSize = MobileSize || '1022';
    /*
     * sticky side  panel
     */

    var fixedElement = jQuery('.'+fixedElementClass);
    var fixedElementOffset = fixedElement.offset();
    var endElement = jQuery('.'+endElementClass);
    var endElementOffset = endElement.offset();

    var isMobile = window.matchMedia("only screen and (max-width: "+MobileSize+"px)");

    if (typeof fixedElementOffset != 'undefined' && typeof endElementOffset != 'undefined') {

        // Position of fixed element from top of the document
        var fixedElementOffsetTop = fixedElementOffset.top;
        // Position of footer element from top of the document.
        // You can add extra distance from the bottom if needed,
        // must match with the bottom property in CSS
        var endElementOffsetTop = endElementOffset.top;

        var fixedElementHeight = fixedElement.height();

        // Check every time the user scrolls
        jQuery(window).scroll(function () {
            if (!isMobile.matches) {

                // again set offset if page has disqus plugin or lazyload
                endElementOffset = endElement.offset();
                endElementOffsetTop = endElementOffset.top;

                // Y position of the vertical scrollbar
                var y = jQuery(this).scrollTop();
                var bottom = y + jQuery(window).height();

                if (y >= fixedElementOffsetTop && ( bottom + fixedElementHeight ) < endElementOffsetTop) {
                    fixedElement.addClass(stickyClass);
                }
                else {
                    fixedElement.removeClass(stickyClass);
                }
            }
        });

        // Check on resizing
        jQuery(window).on('load resize', function () {
            if (fixedElement.hasClass(stickyClass)) {

                if (isMobile.matches) {
                    fixedElement.removeClass(stickyClass);
                }
                else {
                    fixedElement.addClass(stickyClass);
                }
            }
        });

    }
}
//  End Wrapper

function show_hide(fixedElementClass,endElementClass,show_div_class,MobileSize){

    MobileSize = MobileSize || '1022';
    /*
     * sticky side  panel
     */

    var fixedElement = jQuery('.'+fixedElementClass);
    var fixedElementOffset = fixedElement.offset();

    var endElement = jQuery('.'+endElementClass);
    var endElementOffset = endElement.offset();

    var showDivElement = jQuery('.'+show_div_class);
    var isMobile = window.matchMedia("only screen and (max-width: "+MobileSize+"px)");

    if (typeof fixedElementOffset != 'undefined' && typeof endElementOffset != 'undefined') {

        // Position of fixed element from top of the document
        var fixedElementOffsetTop = fixedElementOffset.top;
        // Position of footer element from top of the document.
        // You can add extra distance from the bottom if needed,
        // must match with the bottom property in CSS
        var endElementOffsetTop = endElementOffset.top;

        var fixedElementHeight = fixedElement.height();


        // Check every time the user scrolls
        jQuery(window).scroll(function () {
            if (!isMobile.matches) {
                // Y position of the vertical scrollbar
                var y = jQuery(this).scrollTop();
                var bottom = y + jQuery(window).height();

                if (y >= fixedElementOffsetTop && ( bottom + fixedElementHeight ) < endElementOffsetTop) {
                    showDivElement.show();
                }
                else {
                    showDivElement.hide();
                }
            }
        });

        // Check on resizing
        jQuery(window).on('load resize', function () {
            if (showDivElement.is(':visible')) {
                if (isMobile.matches) {
                    showDivElement.hide();
                }
                else {
                    showDivElement.show();
                }
            }
        });

    }
}

function popitup(url, height, width) {
    var newwindow = window.open(url, '', 'height=' + height+', width='+width+'');
    if (window.focus) {
        newwindow.focus()
    }
    return false;
}

function send_mail(obj){
    $.ajax({
        url : SITE_URL + '/wp-admin/admin-ajax.php',
        type : 'POST',
        data : obj,
        success : function(res){
            console.log('email was sent')
        },
        error : function(d) {
            alert('error');
        }
    });
}

function setCookie(key, value) {
    var expires = new Date();
    expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000));
    document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

$('.form-field-box #other,#checkbox1,#checkbox2,#checkbox3,#checkbox4').click(function(){
    if ($('#nothelpfull :checkbox:checked').length > 0){
        $('.form-field-box.textarea').css('display','block');
    }
    else
    {
        $('.form-field-box.textarea').css('display','none');
    }
}) ;


$(window).scroll(function() {
    var scroll = $(window).scrollTop();

    if (scroll >= 50) {
        $(".hellobar-strip").addClass("hellobar-strip-sticky");
    } else {
        $(".hellobar-strip").removeClass("hellobar-strip-sticky");
    }
});