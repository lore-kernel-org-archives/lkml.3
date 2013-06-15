Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3FOHOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 03:14:31 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:46463 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3FOHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 03:14:30 -0400
MIME-Version: 1.0
Date: Sat, 15 Jun 2013 15:14:29 +0800
Message-ID: <CAHnt0GUrw+XznoUaJ31YO9yoB7JZmpbo+oAXUPud3HK-LiEiAA@mail.gmail.com>
Subject: PPC440GX (taishan config) compilation errors
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling the latest linus-git image for PPC440GX (taishan config) I
got the following errors:

git describe
v3.10-rc5-219-ga2648eb

Issuing "make V=1 ARCH=powerpc CROSS_COMPILE=ppc_4xx- oldconfig" where
the config file ".config" is from powerpc/configs/44x gives:

make -f scripts/Makefile.build obj=net/wireless
make -f scripts/Makefile.build obj=lib
make -f scripts/Makefile.build obj=lib/zlib_inflate
make ARCH=ppc64 -f scripts/Makefile.build obj=arch/powerpc/boot
arch/powerpc/boot/uImage
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
mkdir -p arch/powerpc/boot/
  ppc_4xx-gcc -m32 -Wp,-MD,arch/powerpc/boot/.treeboot-currituck.o.d
-Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
-Os -msoft-float -pipe -fomit-frame-pointer -fno-builtin -fPIC
-nostdinc -isystem
/opt/eldk-4.2/usr/bin/../lib/gcc/powerpc-linux/4.2.2/include
-fno-stack-protector -Iarch/powerpc/boot
-I/media/d4fdcf1c-c7f1-419a-8418-3d0e7b1ad883/linux_latest/arch/powerpc/boot
-mcpu=405 -c -o arch/powerpc/boot/treeboot-currituck.o
arch/powerpc/boot/treeboot-currituck.c
{standard input}: Assembler messages:
{standard input}:82: Error: Unrecognized opcode: `mfdcrx'
make[1]: *** [arch/powerpc/boot/treeboot-currituck.o] Error 1
make: *** [uImage] Error 2

Question:

a.   why is the "mkdir -p arch/powerpc/boot/" repeated so many times?
b.   what is the cause of error "mfdcrx"?

Any idea what is the cause of error?


--
Regards,
Peter Teoh
