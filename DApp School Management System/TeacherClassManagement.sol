// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "DApp School Management System/TeacherManagement.sol";

contract TeacherClassManagement is TeacherManagement{
    function addClass(address _addr,uint _class) public onlyHeadMaster classCheck(_class){
        require(bytes(teacher_list[_addr].name).length!=0,"Teacher does not exist");
        teacher_list[_addr].class_list.push(class({class:_class}));
    }

    function removeClass(address _addr,uint _class) public onlyHeadMaster {
        require(bytes(teacher_list[_addr].name).length!=0,"Teacher does not exist");
        class[] storage classes = teacher_list[_addr].class_list;
        for(uint i=0;i<classes.length;i++)
            {
                if(classes[i].class==_class)
                    {
                        classes[i]=classes[classes.length-1];
                        classes.pop();
                        break;
                    }
            }
    }
}
