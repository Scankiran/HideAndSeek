

# Hide And Seek
```bash
This project developed by Said CANKIRAN 20170808018. 
```

In this project your message will hide inside an image. And there is no difference between the original image.

## Steganography

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

Steganography is the practice of concealing a file, message, image, or video within another file, message, image, or video. This iOS app allows the user to take a picture and hide a text message within the pixels before sharing it with a receiver. New version will support hiding images and using audio files as hiding support.


## Description

In this project, steganography application is carried out with the firstbit technique. Our user chooses an image in which the data will be stored. This picture can be any picture user wants. Then user writes the message he wants to hide inside. This message is encrypted with AES-256 technique and hidden inside the picture. Then, user write the password. This password will hash with SHA-256. Never keep with normal text. When get image also check with SHA-256 texts. Then, the id of the picture is shown to the user. So that he can then use the Picture he has hidden inside the picture. Or user can send it to the person it needs to be sent to and get him or her the message.

In addition, if he selects the deleteAfterShowed option and sends it, the image in which the encrypted message is stored will self-destruct once downloaded from anywhere.

So how do we ensure data security in the place stored here? We store our data in Google's Firebase Storage and Firebase Firestore modules, which provide the world's largest cloud services. Even the data exchange cannot be followed by anyone except the telephone companies. So it is not possible to access this data in any way. At the same time, since the message we send is an encrypted message, the security is increased a little more.




## How
I used this article to develop this project. You can get more information on there. 
[Steganography: Hiding an image inside another](https://towardsdatascience.com/steganography-hiding-an-image-inside-another-77ca66b2acb1)

## How to use?
* Select which process do you want?
* If you want to hide;
    * Select Image which will be use for data hidden
    * Write your message
    * Write password
    * Send image
    * Get image uid to get image when you need.
* If you want to get image;
    * Write given image uid and image password
    * Click get image button to check uid and get image
    * Click show data to see data

## Demo Video
[Youtube Demo Video](https://youtu.be/lAo0D50RLtc)


