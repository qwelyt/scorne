#include "Keyboard.h"
#include "Key.h"

const byte numCols = 12;
const byte numRows = 4;

const byte layers = 4; // Normal, lower, raise, lower+raise
const byte scanRounds = 2;
const byte msDelayBetweenScans = 10;


int cols[numCols] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 14, 15};
int rows[numRows] = {A3, A2, A1, A0};


typedef struct {
  byte row;
  byte col;
  byte val;
} ModPosition;

const ModPosition lower = {3, 4, 1};
const ModPosition raise = {3, 7, 2};
const byte numModifiers = 2;

ModPosition modifiers[numModifiers] = {lower, raise};

byte keys[layers][numRows][numCols] = {
  // 0 Normal
  {
    {   Key::TAB    , Key::Q      , Key::W         , Key::E     , Key::R     , Key::T      , Key::Y       , Key::U       , Key::I       , Key::O       , Key::P         , Key::OBRAKET   }
    , { Key::ESC    , Key::A      , Key::S         , Key::D     , Key::F     , Key::G      , Key::H       , Key::J       , Key::K       , Key::L       , Key::COLON     , Key::QUOTE     }
    , { Key::L_SHFT , Key::Z      , Key::X         , Key::C     , Key::V     , Key::B      , Key::N       , Key::M       , Key::COMMA   , Key::DOT     , Key::SLASH     , Key::BACKSPACE }
    , { Key::L_CTRL , Key::L_SUPR , Key::BS_N_PIPE , Key::L_ALT , MOD::Lower , Key::SPACE  , Key::RETURN  , MOD::Raise   , Key::R_ALT   , Key::MENU    , Key::NONE      , Key::R_CTRL    }
  }
  // 1 Lower
  , {
    {   Key::K1     , Key::K2     , Key::K3        , Key::K4    , Key::K5    , Key::K6     , Key::K7      , Key::K8      , Key::K9      , Key::K0      , Key::OBRAKET   , Key::CBRAKET   }
    , { Key::ESC    , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::ARROW_L , Key::ARROW_D , Key::ARROW_U , Key::ARROW_R , Key::TILDE     , Key::EQUAL     }
    , { Key::L_SHFT , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE      , Key::DELETE    }
    , { Key::L_CTRL , Key::L_SUPR , Key::GACC      , Key::L_ALT , MOD::Lower , Key::SPACE  , Key::RETURN  , MOD::Raise   , Key::R_ALT   , Key::MENU    , Key::NONE      , Key::R_CTRL    }
  }
  // 2 Raise
  , {
    {   Key::F1     , Key::F2     , Key::F3        , Key::F4    , Key::F5    , Key::F6     , Key::F7      , Key::F8      , Key::F9      , Key::F10     , Key::F11       , Key::F12       }
    , { Key::ESC    , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::INSERT , Key::HOME    , Key::PGDWN   , Key::PGUP    , Key::END     , Key::PRNT_SCRN , Key::DASH      }
    , { Key::L_SHFT , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE      , Key::DELETE    }
    , { Key::L_CTRL , Key::L_SUPR , Key::NONE      , Key::L_ALT , MOD::Lower , Key::SPACE  , Key::RETURN  , MOD::Raise   , Key::R_ALT   , Key::MENU    , Key::NONE      , Key::R_CTRL    }
  }
  // 3 Both
  , {
    {   Key::NONE   , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE    , Key::NONE      , Key::NONE      }
    , { Key::ESC    , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::MUTE    , Key::VOL_DN  , Key::VOL_UP  , Key::NONE    , Key::NONE      , Key::NONE      }
    , { Key::L_SHFT , Key::NONE   , Key::NONE      , Key::NONE  , Key::NONE  , Key::NONE   , Key::PLAY    , Key::PREV    , Key::NEXT    , Key::NONE    , Key::NONE      , Key::NONE      }
    , { Key::L_CTRL , Key::L_SUPR , Key::NONE      , Key::L_ALT , MOD::Lower , Key::SPACE  , Key::RETURN  , MOD::Raise   , Key::R_ALT   , Key::MENU    , Key::NONE      , Key::R_CTRL    }
  }
};


bool pressed[scanRounds][numRows][numCols] = {};
bool lastState[numRows][numCols] = {};
bool state[numRows][numCols] = {};

/*********************
****    BEGIN!    ****
*********************/

void setup() {
  for (byte b = 0; b < numRows; ++b) {
    setupRow(rows[b]);
  }

  for (byte b = 0; b < numCols; ++b) {
    setupCol(cols[b]);
  }
  initKeyboard();
}

void setupCol(byte pin) {
  pinMode(pin, INPUT_PULLUP);
}

void setupRow(byte pin) {
  pinMode(pin, OUTPUT);
  digitalWrite(pin, HIGH);
}

///////////////////////////


void loop() {
  scan(scanRounds, numRows, numCols, rows, pressed[0][0], msDelayBetweenScans);
  readCurrentState(scanRounds, numRows, numCols, pressed[0][0], state[0]);

  if (stateChanged(numRows, numCols, state[0], lastState[0])) {
    sendState(numRows, numCols, numModifiers, state[0], lastState[0], keys[0][0], modifiers);
    saveState(state[0], lastState[0], numRows, numCols);
  }
}

//////////
//  Scan
//////////

void scan(byte scanRounds, byte numRows, byte numCols, int *rows, bool *pressed, int msDelayBetweenScans) {
  for (byte scanRound = 0; scanRound < scanRounds; ++scanRound) {
    debounce(pressed, rows, scanRound, numRows, numCols);
    delay(msDelayBetweenScans);
  }
}

void debounce(bool *pressed, int *rows, byte scanRound, byte numRows, byte numCols) {
  for (byte row = 0; row < numRows; ++row) {
    digitalWrite(rows[row], LOW);
    for (byte col = 0; col < numCols; ++col) {
      pressed[(scanRound * numRows + row)*numCols + col] = readPin(cols[col]);
    }
    digitalWrite(rows[row], HIGH);
  }
}

bool readPin(byte pin) {
  if (!digitalRead(pin)) {
    return true;
  }
  return false;
}


//////////
// State
//////////

void readCurrentState(byte scanRounds, byte numRows, byte numCols, bool *pressed, bool *state) {
  for (byte row = 0; row < numRows; ++row) {
    for (byte col = 0; col < numCols; ++col) {
      bool isPressed = true;
      for (byte scanRound = 0; scanRound < scanRounds; ++scanRound) {
        isPressed = isPressed && pressed[(scanRound * numRows + row) * numCols + col];
      }
      state[row * numCols + col] = isPressed;
    }
  }
}

bool stateChanged(byte numRows, byte numCols, bool *currentState, bool *lastState) {
  for (byte row = 0; row < numRows; ++row) {
    for (byte col = 0; col < numCols; ++col) {
      if (lastState[row * numCols + col] != currentState[row * numCols + col]) {
        return true;
      }
    }
  }
  return false;
}

void saveState(bool *currentState, bool *lastState, byte numRows, byte numCols) {
  for (byte row = 0; row < numRows; ++row) {
    for (byte col = 0; col < numCols; ++col) {
      lastState[row * numCols + col] = currentState[row * numCols + col];
    }
  }
}


////////////
//// Key buffer
////////////

void sendState(byte numRows, byte numCols, byte numModifiers, bool *state, bool *lastState, byte *keys, ModPosition *modifiers ) {
  byte layer = checkLayer(state, modifiers, numModifiers, numRows, numCols);

  byte keyLimit = 6;
  byte keyBuf[keyLimit] = {0, 0, 0, 0, 0, 0};
  byte keyIndex = 0;
  byte meta = 0;

  //printState(state, numCols, numRows);

  for (byte row = 0; row < numRows; ++row) {
    for (byte col = 0; col < numCols; ++col) {
      if (state[row * numCols + col] == true) {
        if (isModifier(row, col, modifiers, numModifiers)) {
          continue;
        }
        byte key = 0;
        for (byte l = layer; l >= 0 && key == 0; --l) {
          key = keys[(l * numRows + row ) * numCols + col];
        }
        byte metaVal = metaValue(key);
        meta |= metaVal;
        if (metaVal == 0) {
          keyBuf[keyIndex++] = key;
        }
        if (keyIndex == keyLimit) {
          sendBuffer(meta, keyBuf, keyLimit);
          keyIndex = resetBuffer(keyBuf, keyLimit);
          meta = 0;
        }
      }
    }
  }
  if (keyIndex != 0 || stateChanged(numRows, numCols, state, lastState)) {
    sendBuffer(meta, keyBuf, keyLimit);
    keyIndex = resetBuffer(keyBuf, keyLimit);
    meta = 0;
  }
}

byte checkLayer(bool *state, ModPosition *modifiers, byte numModifiers, byte numRows, byte numCols) {
  byte layer = 0;
  for (byte modifier = 0; modifier < numModifiers; ++modifier) {
    ModPosition mod = modifiers[modifier];
    layer += state[mod.row * numCols + mod.col] == true ? mod.val : 0;
  }
  return layer;
}

bool isModifier(byte row, byte col, ModPosition *modifiers, byte numModifiers) {
  for (byte modifier = 0; modifier < numModifiers; ++modifier) {
    ModPosition mod = modifiers[modifier];
    if (mod.row == row && mod.col == col) {
      return true;
    }
  }
  return false;
}

bool isKeyWithValue(byte key) {
  return key != Key::NONE;
}


byte metaValue(byte key) {
  switch (key) {
    case Key::L_CTRL:
      return Mod::LCTRL;
    case Key::L_SHFT:
      return Mod::LSHFT;
    case Key::L_ALT:
      return Mod::LALT;
    case Key::L_SUPR:
      return Mod::LSUPR;
    case Key::R_CTRL:
      return Mod::RCTRL;
    case Key::R_SHFT:
      return Mod::RSHFT;
    case Key::R_ALT:
      return Mod::RALT;
    case Key::R_SUPR:
      return Mod::RSUPR;
    default:
      return 0;
  }
}

byte resetBuffer(byte *keyBuf, byte keyLimit) {
  for (byte b = 0; b < keyLimit; ++b) {
    keyBuf[b] = Key::NONE;
  }
  return 0;
}

void sendBuffer(byte meta, byte keyBuf[], byte keyLimit) {
  //printKeyBuf(keyBuf, keyLimit);
  sendKeyBuffer(meta, keyBuf, keyLimit);
}

////////////
//// Debug
////////////

void printState(bool *state, byte numCols, byte numRows) {
  Serial.println("State");
  Serial.print(" ");
  for (int j = 0; j < numCols; ++j) {
    Serial.print(" ");
    Serial.print(j);
  }
  for (int row = 0; row < numRows ; ++row) {
    Serial.println();
    Serial.print(row);
    for (int col = 0; col < numCols; ++col) {
      Serial.print(" ");
      Serial.print(state[row * numCols + col]);
    }
  }
  Serial.println();
}

void printKeyBuf(byte keyBuf[], byte keyLimit) {
  Serial.println();
  Serial.println("keyBuf");
  for (byte b = 0; b < keyLimit; ++b) {
    Serial.print(" ");
    Serial.print(keyBuf[b]);
  }
  Serial.println();
}
