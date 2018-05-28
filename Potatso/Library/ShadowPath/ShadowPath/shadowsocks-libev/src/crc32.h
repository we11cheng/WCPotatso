//
//  crc32.h
//  ShadowPath
//
//  Created by LEI on 7/7/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#ifndef crc32_h
#define crc32_h

void init_crc32_table(void);

void fillcrc32to(unsigned char *buffer, unsigned int size, unsigned char *outbuffer);

void fillcrc32(unsigned char *buffer, unsigned int size);

uint32_t crc32(unsigned char *buffer, unsigned int size);

void filladler32(unsigned char *buffer, unsigned int size);

int checkadler32(unsigned char *buffer, unsigned int size);

#endif /* crc32_h */
