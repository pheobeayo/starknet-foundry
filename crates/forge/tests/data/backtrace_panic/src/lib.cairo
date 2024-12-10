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
    #[storage]
    pub struct Storage {}

    #[abi(embed_v0)]
    impl InnerContract of super::IInnerContract<ContractState> {
        fn inner(self: @ContractState) {
            inner_call()
        }
    }

    fn inner_call() {
        assert(1 != 1, 'aaaa');
    }
}

