luaunit = require('luaunit')

local function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

TestBSON = {}

    function TestBSON:setUp() 
      self.cbson = require("cbson")
      self.data = self.cbson.decode(readAll("input.bson"))
    end

    function TestBSON:test01_Decode()
        luaunit.assertNotNil(self.data)
    end

    function TestBSON:test02_Decode_string()
        luaunit.assertNotNil(self.data["foo"])
        luaunit.assertEquals(self.data["foo"], "bar")
    end

    function TestBSON:test03_Decode_int()
        luaunit.assertNotNil(self.data["bar"])
        luaunit.assertEquals(tostring(self.data["bar"]), "12341")
    end

    function TestBSON:test04_Decode_double()
        luaunit.assertNotNil(self.data["baz"])
        luaunit.assertEquals(self.data["baz"], 123.456)
    end

    function TestBSON:test05_Decode_map()
        luaunit.assertNotNil(self.data["map"])
        luaunit.assertNotNil(self.data["map"]["a"])
        luaunit.assertEquals(tostring(self.data["map"]["a"]), "1")
    end

    function TestBSON:test06_Decode_array()
        luaunit.assertNotNil(self.data["array"])
        luaunit.assertNotNil(self.data["array"][1])
        luaunit.assertNotNil(self.data["array"][2])
        luaunit.assertNotNil(self.data["array"][3])
        luaunit.assertNotNil(self.data["array"][4])
        luaunit.assertEquals(tostring(self.data["array"][1]), "1")
        luaunit.assertEquals(tostring(self.data["array"][2]), "2")
        luaunit.assertEquals(tostring(self.data["array"][3]), "3")
        luaunit.assertEquals(tostring(self.data["array"][4]), "4")
    end

    function TestBSON:test07_Decode_null()
        luaunit.assertNil(self.data["null"])
    end

    function TestBSON:test08_Decode_bool()
        luaunit.assertNotNil(self.data["boolean"])
        luaunit.assertTrue(self.data["boolean"])
    end

    function TestBSON:test09_Decode_oid()
        luaunit.assertNotNil(self.data["oid"])
        luaunit.assertIsUserdata(self.data["oid"])
        luaunit.assertEquals(tostring(self.data["oid"]), "000000000000000000000000")
    end

    function TestBSON:test10_Decode_binary()
        luaunit.assertNotNil(self.data["binary"])
        luaunit.assertEquals(self.data["binary"]:type(), 0)
        luaunit.assertEquals(self.data["binary"]:data(), "ZGVhZGJlZWY=")
        luaunit.assertEquals(self.data["binary"]:raw(), "deadbeef")
        luaunit.assertEquals(self.data["binary"]:data("aGVsbG8="), "aGVsbG8=")
        luaunit.assertEquals(self.data["binary"]:raw(), "hello")
    end

    function TestBSON:test11_Decode_regex()
        luaunit.assertNotNil(self.data["regex"])
        luaunit.assertIsUserdata(self.data["regex"])
        luaunit.assertEquals(tostring(self.data["regex"]), "/foo|bar/ism")
    end

    function TestBSON:test12_Decode_date()
        luaunit.assertNotNil(self.data["date"])
        luaunit.assertNotNil(self.data["date"])
        luaunit.assertEquals(tostring(self.data["date"]), "10000")
    end

    function TestBSON:test13_Decode_ref()
        luaunit.assertNotNil(self.data["ref"])
        luaunit.assertEquals(self.data["ref"]:ref(), "foo")
        luaunit.assertEquals(self.data["ref"]:id(), "000000000000000000000000")
    end

    function TestBSON:test14_Decode_undefined()
        luaunit.assertNotNil(self.data["undefined"])
        luaunit.assertEquals(tostring(self.data["undefined"]), "undefined")
    end

    function TestBSON:test15_Decode_minkey()
        luaunit.assertNotNil(self.data["minkey"])
        luaunit.assertEquals(tostring(self.data["minkey"]), "minkey")
    end

    function TestBSON:test16_Decode_maxkey()
        luaunit.assertNotNil(self.data["maxkey"])
        luaunit.assertEquals(tostring(self.data["maxkey"]), "maxkey")
    end

    function TestBSON:test17_Decode_timestamp()
        luaunit.assertNotNil(self.data["timestamp"])
        luaunit.assertEquals(self.data["timestamp"]:timestamp(),100)
        luaunit.assertEquals(self.data["timestamp"]:increment(),1000)
        luaunit.assertEquals(self.data["timestamp"]:increment(500),500)
        luaunit.assertEquals(self.data["timestamp"]:increment(),500)
    end

os.exit( luaunit.LuaUnit.run() )
