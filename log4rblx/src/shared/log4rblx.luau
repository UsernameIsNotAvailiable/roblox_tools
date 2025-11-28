

local logger = {
    enum = {
        level = {
            ERROR = 1,
            WARN = 2,
            INFO = 3,
            DEBUG = 4,
            TRACE = 5
        },
    },
}
local multiple_loggers = false
local enum = logger.enum
logger.__index = logger



local SourceInformation = {}
SourceInformation.__index = SourceInformation

export type SourceInformation = {
    line: number,
    file: string,
    func: string
}

function SourceInformation.new(line: number,file: string, func: string) : SourceInformation
    return {
        line = line,
        file = file,
        func = func
    } :: SourceInformation
end


-------
local LogMetadata = {}
LogMetadata.__index = LogMetadata

export type LogMetadata = {
    level: number, -- logger.enum.level
    source: SourceInformation
}

function LogMetadata.new(level: number, source: SourceInformation) : LogMetadata
    return {
        level = level,
        source = source
    } :: LogMetadata
end

-------
local LogRecord = {}
LogRecord.__index = LogRecord

export type LogRecord = {
    metadata: (
        self: LogRecord
    ) -> LogMetadata,

    level_str: (
        self: LogRecord
    ) -> string,

    message: string
}

function LogRecord.new(message: string, metadata: LogMetadata) : LogRecord
    return {
        message = message,

        ["level_str"] = function (self: LogRecord) : string
            local level = self:metadata().level

            if level == enum.level.WARN then return "WARN" end
            if level == enum.level.ERROR then return "ERROR" end
            if level == enum.level.DEBUG then return "DEBUG" end
            if level == enum.level.INFO then return "INFO" end
            if level == enum.level.TRACE then return "TRACE" end

            return "<UNKNOWN>"
        end,

        ["metadata"] = function (self: LogRecord) : LogMetadata
            return metadata
        end
    }
end

-------

export type Log = {
    enabled: (
        self: Log,
        metadata: LogMetadata
    ) -> boolean,

    log: (
        self: Log,
        record: LogRecord
    ) -> (),
}
local loggers: {Log} = nil
local gmaxll: number = enum.level.TRACE

function logger.set_max_log_level(max: number)
    gmaxll = max
end

function logger.register(log: Log)
    if log["enabled"] == nil or log["log"] == nil then
        error("[logger.register] cannot register - logger is invalid, messing enabled() or log()")
    end
    table.insert(loggers,log)
    return logger
end

function get_source() : SourceInformation
    local n = debug.info(3,"n")
    local s = debug.info(3,"s")
    local l = debug.info(3,"l")

    if n == "" then
        n = s
    end
    
    return SourceInformation.new(l,s,n)
end

function dispatch_loggers(record: LogRecord)
    if record:metadata().level >= gmaxll then return end
    -- fallback
    if loggers == nil then
        if record:metadata().level == enum.level.ERROR then
            error(record.message)
        end
        if record:metadata().level == enum.level.WARN then
            warn(record.message)
        end
        print(record.message)
        return
    end

    for logger in loggers do
        logger:log(record)
    end

    return
end

function logger.info(msg: string)
    dispatch_loggers(
        LogRecord.new(
            msg, 
            LogMetadata.new(
                enum.level.INFO, 
                get_source()
            )
        )
    )
end

function logger.warn(msg: string)
    dispatch_loggers(
        LogRecord.new(
            msg, 
            LogMetadata.new(
                enum.level.WARN, 
                get_source()
            )
        )
    )
end

function logger.error(msg: string)
    dispatch_loggers(
        LogRecord.new(
            msg, 
            LogMetadata.new(
                enum.level.ERROR, 
                get_source()
            )
        )
    )
end


function logger.debug(msg: string)
    dispatch_loggers(
        LogRecord.new(
            msg, 
            LogMetadata.new(
                enum.level.DEBUG, 
                get_source()
            )
        )
    )
end

function logger.trace(msg: string)
    dispatch_loggers(
        LogRecord.new(
            msg, 
            LogMetadata.new(
                enum.level.TRACE, 
                get_source()
            )
        )
    )
end

function logger.format(format: string, ...)
    local args = {...}
    local index = 1

    local result = format:gsub("{}", function()
        local v = args[index]
        index += 1

        if v == nil then
            error("[logger.format] not enough arguments for format string",2)
            return "{}"
        end

        return tostring(v)
    end)

    return result
end

return logger
