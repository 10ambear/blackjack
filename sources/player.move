module blackjack::player {

    use std::string::{Self, String};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::package;
    use sui::event;

    /// otw
    public struct PLAYER has drop {}

    public struct Player has key, store{ 
    	id: UID, 
        username: String,
        balance: Balance<SUI>,
    }

    /// Event - player card created
    public struct PlayerCreated has copy, drop {
        id: ID, 
        owner: address,
    }

    fun init(otw: PLAYER, ctx: &mut TxContext) { 
        /* @todo we don't really need this atm, we'll come back to this*/
        let publisher = package::claim(otw, ctx); 
        transfer::public_transfer(publisher, tx_context::sender(ctx)); // transfers the publisher object to the sender
    }

    
    /// Build a player card
    entry fun create_player_card(username: vector<u8>, coin: Coin<SUI>, ctx: &mut TxContext) {
        // @todo check if username exists
        // @todo check min amount of coin to create a player card

		let obj_id = object::new(ctx); 
		
		
		// new castle object.
		let player = Player { 
            id: obj_id, 
            username: string::utf8(username), 
            balance: coin.into_balance(),
        };

        let player_id = object::uid_to_inner(&player.id);
        let owner = tx_context::sender(ctx); 


        event::emit(PlayerCreated{id: player_id, owner: owner}); 
		transfer::public_transfer(player, owner);
        
	}


}