#ifndef Q_KEYBOARD_H
#define Q_KEYBOARD_H

void initKeyboard();
void sendKeyBuffer(byte meta, byte keys[], byte keyLimit);

#endif
