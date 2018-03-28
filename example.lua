local waitall = require("waitall")
local coroutine = require("coroutine")
local table = require("table")
local co_resume = coroutine.resume
local co_yield = coroutine.yield

do
    local co1 =
        waitall.start_coroutine(
        function(...)
            co_yield()
            co_yield()
            co_yield()
            print("co1 done")
            return 1
        end
    )

    local co2 =
        waitall.start_coroutine(
        function()
            co_yield()
            print("co2 done")
            return false, "err msg"
        end
    )

    local co3 =
        waitall.start_coroutine(
        function()
            co_yield()
            co_yield()
            print("co3 done")
            return 3
        end
    )

    waitall.start_coroutine(
        function()
            local ret = waitall.wait_all(co1, co2, co3)
            for _, v in pairs(ret) do
                print(table.unpack(v))
            end
        end
    )

    co_resume(co2)

    co_resume(co1)
    co_resume(co3)
    co_resume(co1)
    co_resume(co3)
    co_resume(co1)
end

print("--------------------------")

-- reuse  coroutine
do
    local co1 =
        waitall.start_coroutine(
        function(...)
            co_yield()
            co_yield()
            co_yield()
            print("co1 done")
            return 1
        end
    )

    local co2 =
        waitall.start_coroutine(
        function()
            co_yield()
            print("co2 done")
            return false, "err msg"
        end
    )

    local co3 =
        waitall.start_coroutine(
        function()
            co_yield()
            co_yield()
            print("co3 done")
            return 3
        end
    )

    waitall.start_coroutine(
        function()
            local ret = waitall.wait_all(co1, co2, co3)
            for _, v in pairs(ret) do
                print(table.unpack(v))
            end
        end
    )

    co_resume(co2)

    co_resume(co1)
    co_resume(co3)
    co_resume(co1)
    co_resume(co3)
    co_resume(co1)
end