// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "./ConvertLib.sol";

contract PetAdoption {
    
    Adoption[16] public adopters;
    
    struct Adoption {
        address owner;
        uint256 date;
    }
    
    event AdoptionEvent(uint256 _petId, address _adopter);
      
    function adopt(uint256 _petId) public {
        require(_petId >= 0 && _petId <= 15); //between limits
        require(adopters[_petId].owner == address(0x0)); //is not adopted
        adopters[_petId].owner = msg.sender;
        adopters[_petId].date = block.timestamp;
        emit AdoptionEvent(_petId, msg.sender);
    }
    
    function returnToShelter(uint256 _petId) public {
        require(adopters[_petId].owner == msg.sender && block.timestamp < adopters[_petId].date + 30 seconds);
        adopters[_petId].owner = address(0x0);
        adopters[_petId].date = 0;
     }

}