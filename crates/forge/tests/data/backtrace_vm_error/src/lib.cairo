#[starknet::interface]
pub trait IOuterContract<TState> {
    fn outer(self: @TState, contract_address: starknet::ContractAddress);
}

#[starknet::contract]
pub mod OuterContract {
    use super::{IInnerContractDispatcher, IInnerContractDispatcherTrait};

    #[storage]
    pub struct Storage {}

    #[abi(embed_v0)]
    impl OuterContract of super::IOuterContract<ContractState> {
        fn outer(self: @ContractState, contract_address: starknet::ContractAddress) {
            let dispatcher = IInnerContractDispatcher { contract_address };
            dispatcher.inner();
        }
    }
}

#[starknet::interface]
pub trait IInnerContract<TState> {
    fn inner(self: @TState);
}

#[starknet::contract]
pub mod InnerContract {
    use starknet::SyscallResultTrait;
    use starknet::syscalls::call_contract_syscall;

    #[storage]
    pub struct Storage {}

    #[abi(embed_v0)]
    impl InnerContract of super::IInnerContract<ContractState> {
        fn inner(self: @ContractState) {
            inner_call()
        }
    }

    fn inner_call() {
        let this = starknet::get_contract_address();
        let selector = selector!("nonexistent");
        let calldata = array![].span();

        call_contract_syscall(this, selector, calldata).unwrap_syscall();
    }
}

