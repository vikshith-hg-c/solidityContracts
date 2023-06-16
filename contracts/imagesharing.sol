// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
contract pDapp {

    string public name;
    uint public imageCount = 0;
    struct pixel {
        uint id;
        string hash;
        string imgdescription;
        uint tip;
        uint likeCount;
        address payable author;
    }
    mapping(uint => pixel) public images;
    
    event createPixel(
        uint id,
        string hash,
        string imageDescription
    );

    event tipPixel(
        uint id,
        string hash,
        string imagedescription,
        uint tipAmount,
        address payable author
    );

    event likePixel(
        uint id,
        string hash,
        string imgdescription,
        uint count
    );

    constructor() public {
        name = "pixelDapp";
    }

    function upload(string memory _imghash, string memory _imgdescription) public {
        require(bytes(_imghash).length>0);
        require(bytes(_imgdescription).length>0);
        require(msg.sender!=address(0));
        imageCount++;
        images[imageCount] = pixel(imageCount, _imghash,_imgdescription,0,0,payable(msg.sender));
        emit createPixel(imageCount, _imghash, _imgdescription); 
    }

    function tip(uint _id) public payable {
        require(_id >0 && _id <= imageCount);
        pixel memory _image = images[_id];
        address payable _author = _image.author;
        payable(_author).transfer(msg.value);
        _image.tip = _image.tip + msg.value;
        images[_id] = _image;
        emit tipPixel(_id, _image.hash,_image.imgdescription,_image.tip,_author);    
    }

    function like(uint _id) public payable{
        require(_id >0 && _id <= imageCount);
        pixel memory _image = images[_id];
        _image.likeCount += 1;
        images[_id] = _image;
        emit likePixel(_id, _image.hash,_image.imgdescription,_image.likeCount);
    }

}
