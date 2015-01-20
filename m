Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbbATORw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:17:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:42181 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbATORt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:17:49 -0500
Date: Tue, 20 Jan 2015 06:16:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 20
Message-ID: <20150120141644.GA21491@roeck-us.net>
References: <20150120185308.53f4af4e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120185308.53f4af4e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54BE6389.0396,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Tue, Jan 20, 2015 at 06:53:08PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150119:
> 
> The omap tree gained a conflict against the arm-soc tree.
> 
> The net-next tree lost its build failure.
> 
> The mmc-uh tree gained a conflict against the sunxi tree.
> 
> The audit tree gained conflicts against Linus' tree.
> 
> Non-merge commits (relative to Linus' tree): 3975
>  3828 files changed, 141642 insertions(+), 68217 deletions(-)
> 
What difference a few days can make ... from zero failures to:

Build results:
	total: 133 pass: 123 fail: 10
Failed builds:
	i386:allyesconfig
	mips:allmodconfig
	powerpc:cell_defconfig (binutils 2.23)
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:cell_defconfig (binutils 2.24)
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	sparc64:allmodconfig
	x86_64:allyesconfig

Qemu tests:
	total: 30 pass: 19 fail: 11
Failed tests:
	microblaze:microblaze_defconfig
	microblaze:microblazeel_defconfig
	mips:mips_malta_smp_defconfig
	mips64:mips_malta64_smp_defconfig
	powerpc:ppc_book3s_smp_defconfig
	powerpc:ppc64_book3s_smp_defconfig
	sh:sh_defconfig
	sparc32:sparc_defconfig
	sparc32:sparc_smp_defconfig
	x86:x86_pc_defconfig
	x86_64:x86_64_pc_defconfig

Most of it mm related problems inherited from mmotm, but there are
a few others (sparc64, x86_64, and i386 don't fail to build on mmotm,
and the microblaze qemu test fails differently, for example).

Guenter
