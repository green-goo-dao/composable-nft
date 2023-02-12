import FungibleToken from "./FungibleToken.cdc"
import NonFungibleToken from "./NonFungibleToken.cdc"
import MetadataViews from "./MetadataViews.cdc"
import ComposableNFT from "./ComposableNFT.cdc"


pub contract interface ComposableNFT {


    // Core Slot struct that defines the containers of other NFTs within the parent NFT
    // Each Slot can accept different Types of NFTs and has a different index order
    //
    pub struct Slot {
        pub let id: UInt64
        pub let order: UInt64
        pub let name: String
        pub let acceptedTypes: [Type]
        pub let display: MetadataViews.Display?
        pub let externalURL: MetadataViews.ExternalURL?
        pub let edition: MetadataViews.Edition?
        pub let slots: [Slot]

        init(
            id : UInt64,
            order : UInt64,
            name : String,
            acceptedTypes: [Type],
            display : Display?,
            externalURL : ExternalURL?,
            edition: MetadataViews.Edition?,
            slots: [Slot]
        ) {
            self.id = id
            self.order = order
            self.name = name
            self.acceptedTypes = acceptedTypes
            self.display = display
            self.externalURL = externalURL
            self.edition = edition
            self.slots = slots
        }
    }

    pub struct Slots {
        pub let list: [Slot]

        init(list: [Slot]){
            self.list = list
        }
    }


    // Event that emitted when the NFT contract is initialized
    //
    pub event ContractInitialized()

    // Event that is emitted when an NFT has been equipped
    //
    pub event equippedNFT(owner:Address, parentID: UInt64, parentName;String, parentThumbnail:String, childID: UInt64, childType: String, slot: UInt64, slotName: String, childName: String, childThubmail: String)

    // Event that is emitted when an NFT has been equipped
    //
    pub event unequippedNFT(owner:Address, parentID: UInt64, parentName;String, parentThumbnail:String, childID: UInt64, childType: String, slot: UInt64, slotName: String, childName: String, childThubmail: String)


    // Interface that the NFTs have to conform to
    //
    pub resource interface IComposableNFT {
        pub fun equipNFT(nft: @NonFungibleToken.NFT, slot: UInt64): @NonFungibleToken.NFT?
        pub fun unequipNFT(slot: UInt64): @NonFungibleToken.NFT?
        pub fun borrowNFTFromSlot(slot: UInt64): &{NonFungibleToken.NFT}
        pub fun borrowComposableNFTFromSlot(slot: UInt64): &{ComposableNFT.IComposableNFT}
        pub fun slotAcceptedNFTs(slot: UInt64): [Type]
        pub fun getSlots(): [Slot]
        pub fun getSlot(slot: UInt64): Slot?
    }


    // Composable NFT View for MetadataView Resolver
    //
    pub struct ComposableNFTView {
        pub let id: UInt64
        pub let nftView: MetadataViews.NFTView
        pub let slots: [Slot]

        init(
            id : UInt64,
            nftView : MetadataViews.NFTView,
            slots : [Slot]
        ) {
            self.id = id
            self.nftView = nftView
            self.slots = slots
        }
    }

    pub fun getComposableNFTView(id: UInt64, viewResolver: &{MetadataViews.Resolver}) : ComposableNFTView {
        let composableNftView = viewResolver.resolveView(Type<ComposableNFTView>())
        if composableNftView != nil {
            return composableNftView! as! ComposableNFTView
        }

        return ComposableNFTView(
            id : id,
            nftView: MetadataViews.getNFTView(viewResolver),
            slots: []
        )
    }

}