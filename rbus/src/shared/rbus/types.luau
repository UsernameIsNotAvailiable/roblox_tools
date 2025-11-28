
export type maybe_nil<T> = T?
export type map<T, U> = {[T]: U}
export type rbus_method<TRet,TArgs...> = (self: any, TArgs...) -> TRet

-- in ./signal.luau
export type rbus_signal_connection = {
    disconnect: () -> ()
}

-- in ./signal.luau
export type rbus_signal = {
    connect: (
        self: rbus_signal,
        fn: (...any) -> ()
    ) -> rbus_signal_connection,

    fire: (
        self: rbus_signal,
        ...any
    ) -> ()
}

export type rbus_property<T> = {
    get: (
        self: rbus_property<T>
    ) -> any,

    set: (
        self: rbus_property<T>,
        v: T
    ) -> (),
    
    changed: rbus_signal
}

export type rbus_interface = {
    name: string,
    methods: map<string, rbus_method<any,any>>,
    signals: map<string, rbus_signal>,
    properties: map<string, rbus_property<any>>
}

export type rbus_wrapper = {
    interface: rbus_interface,

    call: (
        self: rbus_wrapper,
        name: string,
        ...any
    ) -> any,

    get_property: (
        self: rbus_wrapper,
        name: string
    ) -> rbus_property<any>,

    get_signal: (
        self: rbus_wrapper,
        name: string
    ) -> rbus_signal
}

export type rbus_object_path = map<string, rbus_interface>

export type rbus_interface_builder = {
    name: string,
    methods: map<string, rbus_method<any, ...any>>,
    signals: map<string, rbus_signal>,
    properties: map<string, rbus_property<any>>,

    method: <TRet,TArgs...>(
        self: rbus_interface_builder,
        name: string,
        fn: rbus_method<TRet, TArgs...>
    ) -> rbus_interface_builder,

    signal: (
        self: rbus_interface_builder,
        name: string,
        sig: rbus_signal
    ) -> rbus_interface_builder,

    property: <T>(
        self: rbus_interface_builder,
        name: string,
        prop: rbus_property<T>
    ) -> rbus_interface_builder,

    interface: (
        self: rbus_interface,
        name: string,
        interface: rbus_interface_builder
    ) -> rbus_interface_builder,

    build: (
        self: rbus_interface_builder
    ) -> rbus_interface
}

return {}
