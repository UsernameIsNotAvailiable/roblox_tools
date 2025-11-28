
type MaybeNil<T> = T | nil

local log4rblx = {
    enum = {
        Level = {
            Error = 1,
            Warn = 2,
            Info = 3,
            Debug = 4,
            Trace = 5
        },
    },
    record = {},
}
log4rblx.__index = log4rblx

local Record = {}
Record.__index = Record

export type Record = {
    __data: {
        file: string,
        func_name: string,
        line: number,
    },

    file: (
        self: Record
    ) -> string,

    func_name: (
        self: Record
    ) -> MaybeNil<string>,

    line: (
        self: Record
    ) -> number
}

function log4rblx.
