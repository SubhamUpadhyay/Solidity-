// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;
import "DApp School Management System/BaseContract.sol";
contract StudentManagement is BaseContract{
    struct student{
        string name;
        uint age;
        uint class;
        bool exist;
    }

    mapping(address=>student) public student_list;
    address[] public studentAddresses; // track all the student addresses
    function addstudent(string memory _name , uint _age , uint _class ,address _addr) public onlyHeadMaster NameLength(_name) classCheck(_class)
        {   
            require(student_list[_addr].exist == false,"Student Already Registered");
            student_list[_addr] = student(_name,_age,_class,true) ;
            studentAddresses.push(_addr);
        }
    
    function getStudentName(address _addr)public view  returns (string memory){
        require(student_list[_addr].exist==true,"Student doesn't exist");
        return student_list[_addr].name;
    }


    function getAllStudentInfo() public view returns(student[] memory)
        {
            student[] memory studentInfo = new student[](studentAddresses.length);
            //creating an array to hold the studnetInfo and tha array is of type student
            //create a block of memory enough to hold the information 
            //memory array must have fixed size
            for(uint i=0;i<studentAddresses.length;i++)
            {
                studentInfo[i] = student_list[studentAddresses[i]];
            }
            return studentInfo;
        }


    function removeStudent(address _addr) public  onlyHeadMaster{
        require(student_list[_addr].exist==true,"Student don't exist");
        delete student_list[_addr];

        //remove an array of that deleted address from the studentAddress
        for(uint i=0;i<studentAddresses.length;i++)
            {
                if(studentAddresses[i]==_addr)
                    {
                        studentAddresses[i] = studentAddresses[studentAddresses.length-1];
                        studentAddresses.pop();
                        break;
                    }
            }
    }

    
        

}