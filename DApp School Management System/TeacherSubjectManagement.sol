// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "DApp School Management System/TeacherManagement.sol";
contract TeacherSubjectManagement is TeacherManagement{
    function addSubject(address _addr,string memory _subject) public onlyHeadMaster {
        require(bytes(teacher_list[_addr].name).length!=0,"Teacher does not exist");

        bool found = false;
        string[8] memory validSubjects = ["English","History","Maths","Science","Geography","Computer","Optional Math","Sports"];
        for(uint i=0;i<validSubjects.length;i++)
            {
                if(keccak256(abi.encodePacked(validSubjects[i]))==keccak256(abi.encodePacked(_subject)))
                    {
                        found = true;
                        break;
                    }
            }
        require(found==true,"Subject not found !");

        teacher_list[_addr].subject_list.push(subject({subject:_subject}));
    }

    function removeSubject(address _addr,string memory _subject) public onlyHeadMaster {
        require(bytes(teacher_list[_addr].name).length!=0,"Teacher does not exist");
        subject[] storage subs = teacher_list[_addr].subject_list;
        for(uint i=0;i<subs.length;i++)
            {
                if(keccak256(abi.encodePacked(subs[i].subject))==keccak256(abi.encodePacked(_subject)))
                    {
                        subs[i]=subs[subs.length-1];
                        subs.pop();
                        break;
                    }
            }
    }
}
