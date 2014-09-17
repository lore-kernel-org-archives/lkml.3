Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbaIQSMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:12:43 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58328 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbaIQSMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:12:41 -0400
Date: Wed, 17 Sep 2014 11:12:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 16
Message-ID: <20140917181235.GA5486@roeck-us.net>
References: <20140916175612.3a348b9c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916175612.3a348b9c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 05:56:12PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140912:
> 
> The net tree gained a build failure so I used the version from
> next-20140915.
> 
> The nfs tree lost its build failure.
> 
> The v4l-dvb tree still had its build failure so I used the version from
> next-20140908.
> 
> The slave-dma tree gained a build faiure so I used the version from
> next-20140911.
> 
> The drm tree still had its build failure for which I applied a merge
> fix patch.
> 
> The llvmlinux tree gained a conflict against the kbuild tree.
> 
> The rd-docs tree gained a build failure for which I reverted a commit.
> 
> Non-merge commits (relative to Linus' tree): 5279
>  4805 files changed, 176345 insertions(+), 114250 deletions(-)
> 

Build results:
	total: 133 pass: 107 fail: 26
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
		drivers/tty/serial/8250/8250_core.c: error: 'TIOCSRS485' undeclared
	arc:defconfig
	arc:tb10x_defconfig
	avr32:defconfig
	avr32:merisc_defconfig
	avr32:atngw100mkii_evklcd101_defconfig
	metag:defconfig
	metag:meta1_defconfig
	metag:meta2_defconfig
	metag:meta2_smp_defconfig
	openrisc:defconfig
	unicore32:defconfig
		fs/namei.c:1778: error: unknown field 'hash_len' specified in initializer
	i386:allyesconfig
		fs/built-in.o: In function `bl_map_stripe':
		dev.c:(.text+0x348783): undefined reference to `__udivdi3'
		dev.c:(.text+0x3487a2): undefined reference to `__umoddi3'
		dev.c:(.text+0x34885b): undefined reference to `__udivdi3'
	i386:allmodconfig
		ERROR: "__udivdi3" [fs/nfs/blocklayout/blocklayoutdriver.ko] undefined!
		ERROR: "__umoddi3" [fs/nfs/blocklayout/blocklayoutdriver.ko] undefined!
	m68k:allmodconfig
		drivers/tty/serial/st-asc.c:154:2: error: implicit declaration of function 'readl_relaxed'
	m68k:m5272c3_defconfig
		drivers/net/ethernet/freescale/fec_main.c:580:2: error:
		'FEC_X_DES_ACTIVE_1' undeclared
		[and many other similar errors]
	mips:defconfig
	mips:allmodconfig
	mips:bcm47xx_defconfig
	mips:bcm63xx_defconfig
	mips:ath79_defconfig
	mips:ar7_defconfig
	mips:fuloong2e_defconfig
	mips:e55_defconfig
		drivers/base/topology.c:87:1: error: 'cpu_sibling_map' undeclared
		drivers/base/topology.c:91:1: error: 'cpu_core_map' undeclared
		block/blk-mq-cpumap.c:27:22: error: 'cpu_sibling_map' undeclared
	sparc64:allmodconfig
		include/uapi/asm-generic/termios.h:22:8: error: redefinition of 'struct termio'
		./arch/sparc/include/uapi/asm/termbits.h:16:8: note: originally defined here

Qemu test results:
	total: 24 pass: 16 fail: 8
Failed tests:
	alpha:alpha_defconfig
		[same build error as above]
	metag:metag_defconfig
		[same build error as above]
	mips:mips_malta_defconfig
		[same build error as above]
	mips:mips_malta_smp_defconfig
		[crashes]
	mips64:mips_malta64_defconfig
		[same build error as above]
	mips64:mips_malta64_smp_defconfig
		[crashes]
	sparc64:sparc_smp_defconfig
		[crashes]
	sparc64:sparc_nosmp_defconfig
		[crashes]

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
