Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3D2A4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 20:56:32 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60140 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3D2A4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 20:56:30 -0400
MIME-Version: 1.0
Date: Sun, 28 Apr 2013 17:56:29 -0700
X-Google-Sender-Auth: Puhqy8tH_W0W43A37RKZNh-ZBbs
Message-ID: <CA+55aFxcqR+5wK0QoGBA_jYP1epH2NCbVTRaE51rLK3mdRjN6Q@mail.gmail.com>
Subject: Linux 3.9 released
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the last week was much quieter than the preceding ones, which makes
me suspect that one reason -rc7 was bigger than I liked was that
people were gaming the system and had timed some of their pull
requests for just before the release, explaining why -rc7 was big
enough that I didn't actually want to do a final release last week.
Please don't do that.

Anyway. Whatever the reason, this week has been very quiet, which
makes me much more comfortable doing the final 3.9 release, so I guess
the last -rc8 ended up working. Because not only aren't there very
many commits here, even the ones that made it really are tiny and not
pretty obscure and not very interesting.

Also, this obviously means that the merge window is open. I won't be
merging anything today, but if you start sending me your pull requests
(Konrad already sent in his Xen pull request for the 3.10 merge window
a week ago), tomorrow the flood gates start opening..

                    Linus

---
Borislav Petkov (1):
      x86, efi: Fix a build warning

David S. Miller (1):
      sparc64: Fix missing put_cpu_var() in tlb_batch_add_one() when
not batching.

Hans Verkuil (1):
      [media] cx25821: do not expose broken video output streams

Helge Deller (1):
      parisc: disable -mlong-calls compiler option for kernel modules

Jiri Slaby (1):
      TTY: fix atime/mtime regression

John David Anglin (3):
      parisc: Provide __ucmpdi2 to resolve undefined references in 32
bit builds.
      parisc: Change kunmap macro to static inline function
      parisc: use spin_lock_irqsave/spin_unlock_irqrestore for PTE updates

Josh Boyer (1):
      efi: Check EFI revision in setup_efi_vars

Kishon Vijay Abraham I (1):
      ARM: OMAP4: hwmod data: make 'ocp2scp_usb_phy_phy_48m" as the main clock

Linus Torvalds (2):
      vm: add no-mmu vm_iomap_memory() stub
      Linux 3.9

Linus Walleij (1):
      Revert "gpio: pxa: set initcall level to module init"

Mathias Krause (1):
      crypto: algif - suppress sending source address information in recvmsg

Matt Fleming (1):
      efivars: only check for duplicates on the registered list

Mauro Carvalho Chehab (1):
      [media] mb86a20s: Fix estimate_rate setting

Paul E. McKenney (1):
      events: Protect access via task_subsys_state_check()

Ralf Baechle (1):
      Revert "MIPS: page.h: Provide more readable definition for PAGE_MASK."

Rusty Russell (1):
      kernel/hz.bc: ignore.

Will Deacon (1):
      parisc: uaccess: fix compiler warnings caused by __put_user casting

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled
