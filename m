Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3KTJBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:01:12 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:36666 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTJBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:01:08 -0500
Date: Wed, 20 Nov 2013 10:01:03 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com
Subject: [GIT PULL] AVR32 updates for 3.13
Message-ID: <20131120090103.GA27023@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

please pull

git://git.kernel.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32.git for-linus

to receive the following AVR32 updates for 3.13

Andreas Bieﬂmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Chen Gang (1):
      avr32: uapi: be sure of "_UAPI" prefix for all guard macros

Eirik Aanonsen (1):
      avr32: add kprobe_ctlblk memory struct

 arch/avr32/boot/u-boot/head.S             | 35 +++++++++++++++++++++++++++++------
 arch/avr32/include/asm/kprobes.h          | 14 ++++++++++++++
 arch/avr32/include/uapi/asm/Kbuild        | 24 ++++++++++++------------
 arch/avr32/include/uapi/asm/auxvec.h      |  6 +++---
 arch/avr32/include/uapi/asm/bitsperlong.h |  1 -
 arch/avr32/include/uapi/asm/byteorder.h   |  6 +++---
 arch/avr32/include/uapi/asm/cachectl.h    |  6 +++---
 arch/avr32/include/uapi/asm/errno.h       |  6 ------
 arch/avr32/include/uapi/asm/fcntl.h       |  6 ------
 arch/avr32/include/uapi/asm/ioctl.h       |  6 ------
 arch/avr32/include/uapi/asm/ioctls.h      |  6 ------
 arch/avr32/include/uapi/asm/ipcbuf.h      |  1 -
 arch/avr32/include/uapi/asm/kvm_para.h    |  1 -
 arch/avr32/include/uapi/asm/mman.h        |  1 -
 arch/avr32/include/uapi/asm/msgbuf.h      |  6 +++---
 arch/avr32/include/uapi/asm/poll.h        |  1 -
 arch/avr32/include/uapi/asm/posix_types.h |  6 +++---
 arch/avr32/include/uapi/asm/resource.h    |  6 ------
 arch/avr32/include/uapi/asm/sembuf.h      |  6 +++---
 arch/avr32/include/uapi/asm/setup.h       |  1 -
 arch/avr32/include/uapi/asm/shmbuf.h      |  6 +++---
 arch/avr32/include/uapi/asm/sigcontext.h  |  6 +++---
 arch/avr32/include/uapi/asm/siginfo.h     |  6 ------
 arch/avr32/include/uapi/asm/signal.h      |  1 -
 arch/avr32/include/uapi/asm/socket.h      |  6 +++---
 arch/avr32/include/uapi/asm/sockios.h     |  6 +++---
 arch/avr32/include/uapi/asm/stat.h        |  6 +++---
 arch/avr32/include/uapi/asm/statfs.h      |  6 ------
 arch/avr32/include/uapi/asm/swab.h        |  6 +++---
 arch/avr32/include/uapi/asm/termbits.h    |  6 +++---
 arch/avr32/include/uapi/asm/termios.h     |  1 -
 arch/avr32/include/uapi/asm/types.h       |  5 +++++
 arch/avr32/include/uapi/asm/unistd.h      |  1 -
 arch/avr32/kernel/entry-avr32b.S          |  3 ++-
 arch/avr32/kernel/head.S                  | 20 --------------------
 35 files changed, 101 insertions(+), 129 deletions(-)
 delete mode 100644 arch/avr32/include/uapi/asm/bitsperlong.h
 delete mode 100644 arch/avr32/include/uapi/asm/errno.h
 delete mode 100644 arch/avr32/include/uapi/asm/fcntl.h
 delete mode 100644 arch/avr32/include/uapi/asm/ioctl.h
 delete mode 100644 arch/avr32/include/uapi/asm/ioctls.h
 delete mode 100644 arch/avr32/include/uapi/asm/ipcbuf.h
 delete mode 100644 arch/avr32/include/uapi/asm/kvm_para.h
 delete mode 100644 arch/avr32/include/uapi/asm/mman.h
 delete mode 100644 arch/avr32/include/uapi/asm/poll.h
 delete mode 100644 arch/avr32/include/uapi/asm/resource.h
 delete mode 100644 arch/avr32/include/uapi/asm/siginfo.h
 delete mode 100644 arch/avr32/include/uapi/asm/statfs.h

-- 
mvh
Hans-Christian Egtvedt
