local coroutine = require("coroutine")
local table = require("table")
local table_remove = table.remove
local co_create = coroutine.create
local co_running = coroutine.running
local co_resume = coroutine.resume
local co_yield = coroutine.yield

local co_pool = setmetatable({}, {__mode = "kv"})

local M = {}

local waitallco = {}

local function check_wait_all( ... )
    local co = co_running()
    local waitco = waitallco[co]
    if waitco then
        if -1 ~= waitco.ctx.count then
            waitco.ctx.results[waitco.idx] = {...}
            waitco.ctx.count= waitco.ctx.count-1
            if 0==waitco.ctx.count then
                waitco.ctx.count = -1
                co_resume(waitco.ctx.cur,waitco.ctx.results)
            end
        end
    end
    return co
end

local function routine(func)
    while true do
        local co = check_wait_all(func())
        co_pool[#co_pool + 1] = co
        func = co_yield()
    end
end

function M.start_coroutine(func)
    local co = table_remove(co_pool)
    if not co then
        co = co_create(routine)
    end
    co_resume(co, func)
    return co
end

function M.wait_all( ... )
    local currentco = co_running()
    local cos = {...}
    local ctx = {count = #cos,results={},cur=currentco}
    for k,co in pairs(cos) do
        ctx.results[k]=""
        waitallco[co]={ctx=ctx,idx=k}
    end
    return co_yield()
end

return M




