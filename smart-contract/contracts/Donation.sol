// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Donation is ERC20, Ownable {
    address payable public donationReceiver;
    uint totalContribution;

    event DonationReceived(address sender, uint amount);
    event MyCurrentValue(address _msgSender,uint256 _value);
    event EtherReceived(address sender, uint256 amount);

  constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    donationReceiver = payable(0xadA2C5024608A5dD321b960c22CC297c31dF4422);
  }

  //Contract 자체 이더 조회
  function getContractBalance() public view returns (uint256) {
    return address(this).balance / 1 ether;
  }

   function getTotalContribution() public view returns (uint total) {
      return totalContribution;
   }

    //콘트렉트 자체에 이더 송금하면 자동으로 발동하는 함수 여러가지를 처리할 수 있음
    receive() external payable {
        emit EtherReceived(msg.sender, msg.value);
    }

     //콘트렉트 자체에 이더 송금
     function sendEtherToContract(address payable contractAddress) external payable {
        contractAddress.transfer(msg.value);
    }

    //기부
    function donate() public payable onlyOwner {
        require(msg.value > 0, "Donation: amount must be greater than 0");
        require(msg.sender.balance >= msg.value, "Donation: insufficient balance");

        //가스비 추측해서 기부금에서 제외시킴
        uint256 amount = msg.value - calculateGasFee();
        donationReceiver.transfer(amount);
        totalContribution+=amount / 1 ether;
        emit DonationReceived(msg.sender, amount);
    }

    function calculateGasFee() internal view returns (uint256) {
        // 가스비 계산 로직을 구현합니다.
        // 예시로 고정 가스비를 0.001 ether로 설정하였습니다.
        uint256 gasPrice = tx.gasprice;
        uint256 gasLimit = gasleft();
        uint256 gasFee = gasPrice * gasLimit;
        
        // 최소한의 가스비로 설정하기 위해 가스비를 조정합니다.
        gasFee = gasFee < 0.001 ether ? gasFee : 0.001 ether;
        
        return gasFee;
    }

    //잔고확인
    function checkValueNow() public view onlyOwner returns(uint balance){
        return msg.sender.balance / 1 ether;
    }
}