# vim:set ft= ts=4 sw=4 et fdm=marker:

use Test::Nginx::Socket::Lua;

#worker_connections(1014);
#master_process_enabled(1);
#log_level('warn');

log_level('debug');

repeat_each(2);

plan tests => repeat_each() * 94;

#no_diff();
#no_long_string();

run_tests();

__DATA__

=== TEST 1: set response content-type header
--- config
    location /read {
        echo "Hi";
        header_filter_by_lua '
            ngx.header.content_type = "text/my-plain";
        ';

    }
--- request
GET /read
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 2: server config
--- config
    header_filter_by_lua '
        ngx.header.content_type = "text/my-plain";
    ';

    location /read {
        echo "Hi";

    }
--- request
GET /read
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 3: set in http
--- http_config
    header_filter_by_lua '
        ngx.header.content_type = "text/my-plain";
    ';
--- config
    location /read {
        echo "Hi";
    }
--- request
GET /read
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 4: overriding config
--- config
    header_filter_by_lua '
        ngx.header.content_type = "text/my-plain";
    ';
    location /read {
        echo "Hi";
        header_filter_by_lua '
            ngx.header.content_type = "text/read-plain";
        ';
    }
--- request
GET /read
--- response_headers
Content-Type: text/read-plain
--- response_body
Hi



=== TEST 5: set response content-type header
--- config
    location /read {
        echo "Hi";
        header_filter_by_lua '
            ngx.header.content_type = "text/my-plain";
        ';

    }
--- request
GET /read
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 6: lua code run failed
--- config
    location /read {
        echo "Hi";
        header_filter_by_lua '
            ngx.header.content_length = "text/my-plain";
        ';
    }
--- request
GET /read
--- error_code
--- response_body



=== TEST 7: use variable generated by content phrase
--- config
   location /read {
        set $strvar '1';
        content_by_lua '
            ngx.var.strvar = "127.0.0.1:8080";
            ngx.say("Hi");
        ';
        header_filter_by_lua '
            ngx.header.uid = ngx.var.strvar;
        ';
    }
--- request
GET /read
--- response_headers
uid: 127.0.0.1:8080
--- response_body
Hi



=== TEST 8: use variable generated by content phrase for HEAD
--- config
   location /read {
        set $strvar '1';
        content_by_lua '
            ngx.var.strvar = "127.0.0.1:8080";
            ngx.say("Hi");
        ';
        header_filter_by_lua '
            ngx.header.uid = ngx.var.strvar;
        ';
    }
--- request
HEAD /read
--- response_headers
uid: 127.0.0.1:8080
--- response_body



=== TEST 9: use variable generated by content phrase for HTTP 1.0
--- config
   location /read {
        set $strvar '1';
        content_by_lua '
            ngx.var.strvar = "127.0.0.1:8080";
            ngx.say("Hi");
        ';
        header_filter_by_lua '
            ngx.header.uid = ngx.var.strvar;
        ';

    }
--- request
GET /read HTTP/1.0
--- response_headers
uid: 127.0.0.1:8080
--- response_body
Hi



=== TEST 10: use capture and header_filter_by
--- config
   location /sub {
        content_by_lua '
            ngx.say("Hi");
        ';
        header_filter_by_lua '
            ngx.header.uid = "sub";
        ';
    }

    location /parent {
        content_by_lua '
            local res = ngx.location.capture("/sub")
            if res.status == 200 then
                ngx.say(res.header.uid)
            else
                ngx.say("parent")
            end
        ';
        header_filter_by_lua '
            ngx.header.uid = "parent";
        ';
    }

--- request
GET /parent
--- response_headers
uid: parent
--- response_body
sub



=== TEST 11: overriding ctx
--- config
    location /lua {
        content_by_lua '
            ngx.ctx.foo = 32;
            ngx.say(ngx.ctx.foo)
        ';
        header_filter_by_lua '
            ngx.ctx.foo = ngx.ctx.foo + 1;
            ngx.header.uid = ngx.ctx.foo;
        ';
    }
--- request
GET /lua
--- response_headers
uid: 33
--- response_body
32



=== TEST 12: use req
--- config
    location /lua {
        content_by_lua '
            ngx.say("Hi");
        ';

        header_filter_by_lua '
            local str = "";
            local args = ngx.req.get_uri_args()
            local keys = {}
            for key, val in pairs(args) do
                table.insert(keys, key)
            end
            table.sort(keys)
            for i, key in ipairs(keys) do
                local val = args[key]
                if type(val) == "table" then
                    str = str .. table.concat(val, ", ")
                else
                    str = str .. ":" .. val
                end
            end

            ngx.header.uid = str;
        ';
    }
--- request
GET /lua?a=1&b=2
--- response_headers
uid: :1:2
--- response_body
Hi



=== TEST 13: use ngx md5 function
--- config
    location /lua {
        content_by_lua '
            ngx.say("Hi");
        ';
        header_filter_by_lua '
            ngx.header.uid = ngx.md5("Hi");
        ';
    }
--- request
GET /lua
--- response_headers
uid: c1a5298f939e87e8f962a5edfc206918
--- response_body
Hi



=== TEST 14: set response content-type header (by file)
--- config
    location /read {
        echo "Hi";
        header_filter_by_lua_file 'html/foo.lua';
    }
--- request
GET /read
--- user_files
>>> foo.lua
ngx.header.content_type = "text/my-plain";
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 15: by_lua_file server config
--- config
    header_filter_by_lua_file 'html/foo.lua';

    location /read {
        echo "Hi";
    }
--- request
GET /read
--- user_files
>>> foo.lua
ngx.header.content_type = "text/my-plain";
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 16: by_lua_file set in http
--- http_config
    header_filter_by_lua_file 'html/foo.lua';
--- config
    location /read {
        echo "Hi";
    }
--- request
GET /read
--- user_files
>>> foo.lua
ngx.header.content_type = "text/my-plain";
--- response_headers
Content-Type: text/my-plain
--- response_body
Hi



=== TEST 17: by_lua_file overriding config
--- config
    header_filter_by_lua 'html/foo.lua';
    location /read {
        echo "Hi";
        header_filter_by_lua_file 'html/bar.lua';
    }
--- request
GET /read
--- user_files
>>> foo.lua
ngx.header.content_type = "text/my-plain";
>>> bar.lua
ngx.header.content_type = "text/read-plain";
--- response_headers
Content-Type: text/read-plain
--- response_body
Hi



=== TEST 18: ngx.ctx available in header_filter_by_lua (already defined)
--- config
    location /lua {
        content_by_lua 'ngx.ctx.counter = 3 ngx.say(ngx.ctx.counter)';
        header_filter_by_lua 'ngx.log(ngx.ERR, "ngx.ctx.counter: ", ngx.ctx.counter)';
    }
--- request
GET /lua
--- response_body
3
--- error_log
ngx.ctx.counter: 3
lua release ngx.ctx



=== TEST 19: ngx.ctx available in header_filter_by_lua (not defined yet)
--- config
    location /lua {
        echo hello;
        header_filter_by_lua '
            ngx.log(ngx.ERR, "ngx.ctx.counter: ", ngx.ctx.counter)
            ngx.ctx.counter = "hello world"
        ';
    }
--- request
GET /lua
--- response_body
hello
--- error_log
ngx.ctx.counter: nil
lua release ngx.ctx



=== TEST 20: global got cleared for each single request
--- config
    location /lua {
        set $foo '';
        content_by_lua '
            ngx.send_headers()
            ngx.say(ngx.var.foo)
        ';
        header_filter_by_lua '
            if not foo then
                foo = 1
            else
                foo = foo + 1
            end
            ngx.var.foo = foo
        ';
    }
--- request
GET /lua
--- response_body
1
--- no_error_log
[error]



=== TEST 21: lua error (string)
--- config
    location /lua {
        set $foo '';
        content_by_lua '
            ngx.send_headers()
            ngx.say(ngx.var.foo)
        ';
        header_filter_by_lua '
            error("Something bad")
        ';
    }
--- request
GET /lua
--- ignore_response
--- error_log
failed to run header_filter_by_lua*: header_filter_by_lua:2: Something bad
--- no_error_log
[alert]



=== TEST 22: lua error (nil)
--- config
    location /lua {
        set $foo '';
        content_by_lua '
            ngx.send_headers()
            ngx.say(ngx.var.foo)
        ';
        header_filter_by_lua '
            error(nil)
        ';
    }
--- request
GET /lua
--- ignore_response
--- error_log
failed to run header_filter_by_lua*: unknown reason
--- no_error_log
[alert]



=== TEST 23: no ngx.print
--- config
    location /lua {
        header_filter_by_lua "ngx.print(32) return 1";
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 24: no ngx.say
--- config
    location /lua {
        header_filter_by_lua "ngx.say(32) return 1";
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 25: no ngx.flush
--- config
    location /lua {
        header_filter_by_lua "ngx.flush()";
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 26: no ngx.eof
--- config
    location /lua {
        header_filter_by_lua "ngx.eof()";
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 27: no ngx.send_headers
--- config
    location /lua {
        header_filter_by_lua "ngx.send_headers()";
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 28: no ngx.location.capture
--- config
    location /lua {
        header_filter_by_lua 'ngx.location.capture("/sub")';
        echo ok;
    }

    location /sub {
        echo sub;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 29: no ngx.location.capture_multi
--- config
    location /lua {
        header_filter_by_lua 'ngx.location.capture_multi{{"/sub"}}';
        echo ok;
    }

    location /sub {
        echo sub;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 30: no ngx.redirect
--- config
    location /lua {
        header_filter_by_lua 'ngx.redirect("/blah")';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 31: no ngx.exec
--- config
    location /lua {
        header_filter_by_lua 'ngx.exec("/blah")';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 32: no ngx.req.set_uri(uri, true)
--- config
    location /lua {
        header_filter_by_lua 'ngx.req.set_uri("/blah", true)';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 33: ngx.req.set_uri(uri) exists
--- config
    location /lua {
        header_filter_by_lua 'ngx.req.set_uri("/blah") return 1';
        content_by_lua '
            ngx.send_headers()
            ngx.say("uri: ", ngx.var.uri)
        ';
    }
--- request
GET /lua
--- response_body
uri: /blah
--- no_error_log
[error]



=== TEST 34: no ngx.req.read_body()
--- config
    location /lua {
        header_filter_by_lua 'ngx.req.read_body()';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 35: no ngx.req.socket()
--- config
    location /lua {
        header_filter_by_lua 'return ngx.req.socket()';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 36: no ngx.socket.tcp()
--- config
    location /lua {
        header_filter_by_lua 'return ngx.socket.tcp()';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 37: no ngx.socket.connect()
--- config
    location /lua {
        header_filter_by_lua 'return ngx.socket.connect("127.0.0.1", 80)';
        echo ok;
    }
--- request
GET /lua
--- ignore_response
--- error_log
API disabled in the context of header_filter_by_lua*



=== TEST 38: clear content-length
--- config
    location /lua {
        content_by_lua '
            ngx.header.content_length = 12
            ngx.say("hello world")
        ';
        header_filter_by_lua 'ngx.header.content_length = nil';
    }
--- request
GET /lua
--- response_headers
!content-length
--- response_body
hello world



=== TEST 39: backtrace
--- config
    location /t {
        header_filter_by_lua '
            function foo()
                bar()
            end

            function bar()
                error("something bad happened")
            end

            foo()
        ';
        echo ok;
    }
--- request
    GET /t
--- ignore_response
--- error_log
something bad happened
stack traceback:
in function 'error'
in function 'bar'
in function 'foo'



=== TEST 40: Lua file does not exist
--- config
    location /lua {
        echo ok;
        header_filter_by_lua_file html/test2.lua;
    }
--- user_files
>>> test.lua
v = ngx.var["request_uri"]
ngx.print("request_uri: ", v, "\n")
--- request
GET /lua?a=1&b=2
--- ignore_response
--- error_log eval
qr/failed to load external Lua file ".*?test2\.lua": cannot open .*? No such file or directory/



=== TEST 41: filter finalize
--- config
    error_page 582 = /bar;
    location = /t {
        echo ok;
        header_filter_by_lua '
            return ngx.exit(582)
        ';
    }

    location = /bar {
        echo hi;
        header_filter_by_lua '
            return ngx.exit(302)
        ';
    }
--- request
GET /t
--- response_body_like: 302 Found
--- error_code: 302
--- no_error_log
[error]

