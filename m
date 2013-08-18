Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3HRUbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:31:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3HRU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:28:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/12] 3.0.92-stable review
Date: Sun, 18 Aug 2013 13:30:09 -0700
Message-Id: <20130818202949.875887601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.92 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Aug 20 20:29:24 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.92-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.92-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    vm: add no-mmu vm_iomap_memory() stub

Linus Walleij <linus.walleij@linaro.org>
    ARM: 7080/1: l2x0: make sure I&D are not locked down on init

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k/atari: ARAnyM - Fix NatFeat module support

Anton Blanchard <anton@samba.org>
    powerpc: Use -mtraceback=no

David S. Miller <davem@davemloft.net>
    sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

Sam Ravnborg <sam@ravnborg.org>
    sparc32: add ucmpdi2

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix broken control requests

Oliver Neukum <oneukum@suse.de>
    usb: add two quirky touchscreen

Johannes Berg <johannes.berg@intel.com>
    genetlink: fix family dump race

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    af_key: initialize satype in key_notify_policy_flush()

Jesper Nilsson <jesper.nilsson@axis.com>
    CRIS: Add _sdata to vmlinux.lds.S

Zhang Yi <wetpzy@gmail.com>
    futex: Take hugepages into account when generating futex_key


-------------

Diffstat:

 Makefile                                   |  4 ++--
 arch/arm/include/asm/hardware/cache-l2x0.h |  9 +++++++--
 arch/arm/mm/cache-l2x0.c                   | 21 +++++++++++++++++++++
 arch/cris/kernel/vmlinux.lds.S             |  1 +
 arch/m68k/emu/natfeat.c                    | 23 +++++++++++++++++++----
 arch/powerpc/Makefile                      |  2 +-
 arch/sparc/lib/Makefile                    |  2 +-
 arch/sparc/lib/ucmpdi2.c                   | 19 +++++++++++++++++++
 drivers/usb/core/quirks.c                  |  6 ++++++
 drivers/usb/serial/mos7720.c               | 21 ++++++++++++++-------
 include/linux/hugetlb.h                    | 16 ++++++++++++++++
 kernel/futex.c                             |  3 ++-
 mm/hugetlb.c                               | 17 +++++++++++++++++
 mm/nommu.c                                 | 10 ++++++++++
 net/key/af_key.c                           |  1 +
 net/netlink/genetlink.c                    |  7 +++++++
 16 files changed, 144 insertions(+), 18 deletions(-)


