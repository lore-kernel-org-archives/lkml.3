Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaKEKrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:47:45 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51829 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaKEKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:47:44 -0500
Date: Wed, 5 Nov 2014 02:47:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 5
Message-ID: <20141105104727.GA27329@roeck-us.net>
References: <20141105175330.3aa16982@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105175330.3aa16982@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.545A004F.00E1,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Wed, Nov 05, 2014 at 05:53:30PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Due to a move of office, there will not be a linux-next release on
> Friday (and maybe Monday).
> 
> Changes since 20141104:
> 
> The f2fs tree gained a build failure so I used the version from
> next-20141104.
> 
> The mfd tree lost its build failure.
> 
> The iommu tree gained a build failure so I used the version from
> next-20141104.
> 
> The usb tree gained a conflict against the usb.current tree.
> 
> The staging tree gained conflicts against the v4l-dvb tree.
> 
> The scsi tree still had its its build failure, so I applied a supplied
> patch.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 3680
>  3064 files changed, 103787 insertions(+), 114924 deletions(-)
> 
Build results:
	total: 133 pass: 117 fail: 16
Failed builds:
	arm:omap2plus_defconfig
	arm:axm55xx_defconfig
	arm64:defconfig
	avr32:defconfig
	m68k:allmodconfig
	microblaze:mmu_defconfig
	microblaze:nommu_defconfig
	mips:allmodconfig
	mips:nlm_xlp_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	s390:defconfig
	tile:tilegx_defconfig

Qemu test results:
	total: 30 pass: 28 fail: 2
Failed tests:
	arm64:arm64_smp_defconfig
	arm64:arm64_nosmp_defconfig

Browsing through the failures, they all seem to be due to the missing
declaration of 'audit_file'. A patch for that problem is pending with
https://lkml.org/lkml/2014/11/4/528.

Guenter
