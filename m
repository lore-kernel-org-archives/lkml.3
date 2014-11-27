Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaK0Uah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:30:37 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53123 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK0Uag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:30:36 -0500
Date: Thu, 27 Nov 2014 12:30:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 27
Message-ID: <20141127203027.GA13159@roeck-us.net>
References: <20141127230251.5273a72f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230251.5273a72f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.547789EB.01D6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Nov 27, 2014 at 11:02:51PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141126:
> 
> The block tree gained a conflict against the ext4 tree.
> 
> The omap_dss2 tree lost its build failure.
> 
> The irqchip tree gained a conflict against the mips tree.
> 
> The staging tree gained conflicts against the kbuild and vfs trees.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 9044
>  8635 files changed, 334054 insertions(+), 234320 deletions(-)
> 
> ----------------------------------------------------------------------------

Build results:
	total: 133 pass: 111 fail: 22
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	hexagon:defconfig
	mips:defconfig
	mips:allmodconfig
	mips:bcm47xx_defconfig
	mips:bcm63xx_defconfig
	mips:nlm_xlp_defconfig
	mips:ath79_defconfig
	mips:ar7_defconfig
	mips:fuloong2e_defconfig
	mips:e55_defconfig
	mips:cavium_octeon_defconfig
	mips:malta_defconfig
	parisc:defconfig
	parisc:generic-32bit_defconfig
	parisc:a500_defconfig
	parisc:generic-64bit_defconfig
	sparc64:allmodconfig
	x86_64:allyesconfig
	xtensa:defconfig
	xtensa:allmodconfig

Qemu test results:
	total: 30 pass: 17 fail: 13
Failed tests:
	alpha:alpha_defconfig
	arm:arm_versatile_defconfig
	mips:mips_malta_defconfig
	mips:mips_malta_smp_defconfig
	mips:mipsel_malta_defconfig
	mips:mipsel_malta_smp_defconfig
	mips64:mips_malta64_defconfig
	mips64:mips_malta64_smp_defconfig
	powerpc:ppc_book3s_defconfig
	powerpc:ppc_book3s_smp_defconfig
	powerpc:ppc64_book3s_defconfig
	powerpc:ppc64_book3s_smp_defconfig
	xtensa:xtensa_defconfig

Details are available at http://server.roeck-us.net:8010/builders.

Guenter
