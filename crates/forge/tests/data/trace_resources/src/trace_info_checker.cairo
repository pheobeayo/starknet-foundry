use starknet::ClassHash;


#[starknet::interface]
pub trait ITraceInfoChecker<T> {
    fn from_proxy(ref self: T, data: felt252, empty_hash: ClassHash, salt: felt252) -> felt252;
    fn panic(ref self: T, empty_hash: ClassHash, salt: felt252);
}

#[starknet::contract]
pub mod TraceInfoChecker {
    pub use super::ITraceInfoChecker;
    pub use trace_resources::trace_info_proxy::{
        ITraceInfoProxyDispatcher, ITraceInfoProxyDispatcherTrait
    };
    pub use starknet::{
        ContractAddress, get_contract_address, ClassHash, 
        SyscallResultTrait
    };
    pub use super::super::use_builtins_and_syscalls;

    #[storage]
    struct Storage {
        balance: u8
    }

    #[abi(embed_v0)]
   pub impl ITraceInfoChceckerImpl of ITraceInfoChecker<ContractState> {
        fn from_proxy(
            ref self: ContractState, data: felt252, empty_hash: ClassHash, salt: felt252
        ) -> felt252 {
            use_builtins_and_syscalls(empty_hash, salt);

            100 + data
        }

       fn panic(ref self: ContractState, empty_hash: ClassHash, salt: felt252) {
            use_builtins_and_syscalls(empty_hash, salt);

            
        }
    }

    #[l1_handler]
    pub fn handle_l1_message(
        ref self: ContractState,
        from_address: felt252,
        proxy_address: ContractAddress,
        empty_hash: ClassHash,
        salt: felt252
    ) -> felt252 {
        let my_address = use_builtins_and_syscalls(empty_hash, salt);

        ITraceInfoProxyDispatcher { contract_address: proxy_address }
            .regular_call(my_address, empty_hash, 10 * salt)
    }
}
