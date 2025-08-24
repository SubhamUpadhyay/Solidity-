// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./TeacherManagement.sol";

contract TeacherRemoval is TeacherManagement{
    function removeTeacher(address _addr) public onlyHeadMaster {
        require(bytes(teacher_list[_addr].name).length!=0,"Teacher does not exist");
        delete teacher_list[_addr];
        for(uint i=0;i<teacherAddresses.length;i++)
            {
                if(teacherAddresses[i]==_addr)
                    {
                        teacherAddresses[i]=teacherAddresses[teacherAddresses.length-1];
                        teacherAddresses.pop();
                        break;
                    }
            }
    }
}
