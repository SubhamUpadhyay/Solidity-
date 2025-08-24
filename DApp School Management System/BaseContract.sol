// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;
contract BaseContract{
    address public HeadMaster;
    constructor()
        {
            HeadMaster = msg.sender;
        }

    modifier onlyHeadMaster{
        require(msg.sender == HeadMaster,"You must be a Headmaster to access this function");
        _;
    }

    modifier NameLength(string memory _name)
        {
            require(bytes(_name).length >3 && bytes(_name).length<=20,"Name should be atleast 3 bit long and not more than 20 bit strictly !");
            _;
        }

    modifier classCheck(uint _class)
        {
            require(_class>=1 && _class<=10,"Class doesn't exist");
            _;
        }

    modifier check_studentAge(uint _age)
        {
            require(_age>=5 && _age<=25,"Age must be between 5 & 25 ");
            _;
        }

    modifier check_teacherAge(uint _age)
        {
            require(_age>=25 && _age<=60,"Not a valid age , must be between 25 & 60");
            _;
        }
    
}