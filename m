Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaKJWSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:18:01 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35493 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaKJWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:17:59 -0500
Date: Mon, 10 Nov 2014 14:17:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 10
Message-ID: <20141110221748.GA25100@roeck-us.net>
References: <20141110205945.51af32a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110205945.51af32a6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54613997.00A5,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:59:45PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141106:
> 
> New tree: nios2
> 
> The slave-dma tree gained a build failure so I used the version from
> next-20141106.
> 
> The mmc-uh tree gained a conflict against the arm-soc tree.
> 
> The tiny tree gained conflicts against Linus' and the net-next trees.
> 
> The driver-core tree gained conflicts against the pm, mfd, l2-mtd,
> sound-asoc and wireless-next trees.
> 
> The tty tree gained conflicts against the tip and tty.current trees.
> 
> The usb-gadget tree gained a conflict against the driver-core tree.
> 
> The char-misc tree gained a conflict agsinst the staging tree.
> 
> The scsi tree gained a build failure so I used teh version from
> next-20141106.
> 
> The pinctrl tree gained conflicts against the arm-soc and driver-core
> trees.
> 
> The tiny tree gained a build failure for which I reverted a commit.
> 
> The akpm-current tree gained conflicts against the driver-core and tiny
> trees and still had its build failures for which I applied two patches.
> 
> Non-merge commits (relative to Linus' tree): 5350
>  5611 files changed, 164785 insertions(+), 151258 deletions(-)
> 
Build results:
	total: 133 pass: 129 fail: 4
Failed builds:
	arm:davinci_all_defconfig
	arm:orion5x_defconfig
	hexagon:defconfig
	sparc64:allmodconfig

Qemu tests:
	total: 30 pass: 29 fail: 1
Failed tests:
	x86:x86_pc_nosmp_defconfig

---

hexagon:defconfig:

In file included from ./arch/hexagon/include/asm/io.h:33:0,
                 from include/linux/io.h:22,
                 from include/linux/irq.h:23,
                 from include/asm-generic/hardirq.h:12,
                 from arch/hexagon/include/generated/asm/hardirq.h:1,
                 from include/linux/hardirq.h:8,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from ./arch/hexagon/include/asm/pgtable.h:27,
                 from include/linux/mm.h:52,
                 from arch/hexagon/kernel/asm-offsets.c:28:
./arch/hexagon/include/asm/cacheflush.h: In function 'copy_to_user_page':
./arch/hexagon/include/asm/cacheflush.h:89:22: error: 'VM_EXEC' undeclared (first use in this function)
./arch/hexagon/include/asm/cacheflush.h:89:22: note: each undeclared identifier is reported only once for each function it appears in
make[1]: *** [arch/hexagon/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

---
sparc64:allmodconfig:

In file included from ./arch/sparc/include/asm/pgtable.h:4:0,
                 from include/linux/mm.h:52,
                 from include/linux/pid_namespace.h:6,
                 from include/linux/ptrace.h:8,
                 from include/linux/ftrace.h:13,
                 from include/linux/init_task.h:8,
                 from init/init_task.c:1:
./arch/sparc/include/asm/pgtable_64.h: In function 'pmd_dirty':
./arch/sparc/include/asm/pgtable_64.h:674:2: error: incompatible types when returning type 'long unsigned int' but 'pmd_t' was expected

---
arm:davinci_all_defconfig:

drivers/tty/vt/vt.c: In function 'tioclinux':
drivers/tty/vt/vt.c:2703:4: error: implicit declaration of function
'vt_get_kmsg_redirect' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/tty/vt/vt.o] Error 1

---
arm:orion5x_defconfig:

arch/arm/plat-orion/gpio.c: In function 'orion_gpio_unmask_irq':
arch/arm/plat-orion/gpio.c:509:2: error: too few arguments to function
'irq_reg_readl'

and many similar follow-up errors.

---
x86:qemu_x86_pc_nosmp_defconfig:

Stalls until killed. There are several messages such as
	Driver 'serial' needs an owner
in the log.

---

Details at http://server.roeck-us.net:8010/builders.

Guenter
