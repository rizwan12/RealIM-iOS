# RealIM-iOS
Real Time Chat Messenger Using Parse and Push Messages
Instant Messaging App for iOS

Implementing real time messaging with the help of Parse library, (utilizing the power of push mesasges)

Login Screen: First screen is to login to the chat room. You simply write a nick name and press 'Confirm' to enter the chat room.

Chat Screen: Once you have entered the chat screen, previous chats will load as well as you can also chat with the users. You can also send images as chat.

Implementation Details:

There are many online solutions available that can be used to implement Instant messaging with Parse, for e.g. PubNub provide easiest way to implement Instant Chatting. But here challenge taken was to explore the power of Push Messages.
Parse provide their own Push Mesages mechanism which works same like Google Cloud Messaging (GCM) and also works with iOS. So decided to explore parse to its fullest.
This app is implemented using Objective-C Language and Parse as Backend.
Life Cycle of app: When a user sends a message, A Chat Object is saved with details:

User Name
User Message
User Image
isImage (boolean value for ease of use)
Image Url
Image
After saving the object in Parse, relavant information is sent to the people who are connected to that chat room as Push Message. Parse provide App to App push messages mechanism which we can limit to certain people called "Channels" in Parse. So a Push notification is sent and on all the devices which are connected to the room receives a message by a custom Broadcast Receiver and transfer data to the UI where it adds that Chat Object and displays right there.

If the app is in background then a Push Notification is generated that whenever the user will open the app, he/she can see the messages.

Once user have logged in, user will remain in the chat room with the same name.

There is still no logout mechanism.

Timeline I followed while Implementing:

IT CAN WORK WITH ANDROID TOO. So Android to iOS and iOS to Android messaging app working now.

UI can be enhanced.
More functionality can be added like different rooms. User can join any room to chat.
