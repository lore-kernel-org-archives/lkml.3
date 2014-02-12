Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaBLPpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:45:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaBLPpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:45:51 -0500
Subject: [PATCH 0/4] Final asm/system.h cleanups
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Date: Wed, 12 Feb 2014 15:45:44 +0000
Message-ID: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some patches to clean up the last bits of the asm/system.h
disintegration.  They comprise:

 (*) Some doc changes.

 (*) Some comment changes.

 (*) Final removal of ARM's asm/system.h and fixing up all remaining
     users thereof.

David
---
David Howells (4):
      Clean asm/system.h from docs
      Sparc: sparc_cpu_model isn't in asm/system.h any more
      UM: arch_align_stack() moved to asm/exec.h
      ARM: Delete asm/system.h


 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 Documentation/irqflags-tracing.txt        |    7 -------
 Documentation/scheduler/sched-arch.txt    |    2 +-
 arch/arm/include/asm/jump_label.h         |    1 -
 arch/arm/include/asm/sync_bitops.h        |    1 -
 arch/arm/include/asm/system.h             |    7 -------
 arch/arm/mach-gemini/idle.c               |    2 +-
 arch/arm/mach-omap2/am35xx-emac.c         |    1 -
 arch/um/kernel/process.c                  |    2 +-
 drivers/sbus/char/jsflash.c               |    4 +---
 drivers/usb/gadget/lpc32xx_udc.c          |    1 -
 11 files changed, 5 insertions(+), 25 deletions(-)
 delete mode 100644 arch/arm/include/asm/system.h

