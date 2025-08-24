// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "DApp School Management System/BaseContract.sol";

contract TeacherManagement is BaseContract{
    struct subject{
        string subject;
    }    
    struct class{
        uint class;
    }

    struct Teacher{
        string name;
        uint age;
        subject[] subject_list;
        class[] class_list;
    }

    mapping (address=>Teacher) public teacher_list;
    address[] public teacherAddresses;

    function addTeacher(string memory _name,uint _age,address _addr,subject[] memory _subject_list,class[] memory _class_list) public onlyHeadMaster NameLength(_name) check_teacherAge(_age){
        for(uint i=0;i<_subject_list.length;i++)
            {
                bool found = false;
                string[8] memory validSubjects = ["English","History","Maths","Science","Geography","Computer","Optional Math","Sports"];
                for(uint j=0;j<validSubjects.length;j++)
                    {
                        if(keccak256(abi.encodePacked(validSubjects[j]))==keccak256(abi.encodePacked(_subject_list[i].subject)))
                            {
                                found = true;
                                break;
                            }
                    }
                require(found==true,"Subject not found !");
            }

        for (uint i=0;i<_class_list.length;i++)
            {
                require(_class_list[i].class>=1 && _class_list[i].class<=12,"Not a valid class ! ");
            }

        Teacher storage t = teacher_list[_addr];
        t.name = _name;
        t.age = _age;

        delete t.subject_list;
        delete t.class_list;

        for(uint i=0;i<_subject_list.length;i++)
            {
                t.subject_list.push(subject({subject:_subject_list[i].subject}));
            }

        for(uint i=0;i<_class_list.length;i++)
            {
                t.class_list.push(class({class:_class_list[i].class}));
            }

        bool exists = false;
        for(uint i=0;i<teacherAddresses.length;i++)
            {
                if(teacherAddresses[i]==_addr)
                    {
                        exists = true;
                        break;
                    }
            }
        if(!exists)
            {
                teacherAddresses.push(_addr);
            }
    }
}
