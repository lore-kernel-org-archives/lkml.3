Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaK0Cwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:52:51 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:48024 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaK0Cwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:52:49 -0500
Date: Wed, 26 Nov 2014 18:52:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 26
Message-ID: <20141127025238.GA18150@roeck-us.net>
References: <20141126233827.3353c3f4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126233827.3353c3f4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.54769201.006E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Wed, Nov 26, 2014 at 11:38:27PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141125:
> 
> The i2c tree lost its build failure.
> 
> The block tree gained a conflict against the ext4 tree.
> 
> The omap_dss2 tree still had its build failure for which I applied a patch.
> 
> The devicetree tree gained conflicts against the i2c, pm, mfd and
> regulator trees.
> 
> The kvm-arm tree gained a conflict against the kvm tree.
> 
> The tty tree gained a conflict against the tty.current tree.
> 
> Non-merge commits (relative to Linus' tree): 8617
>  8299 files changed, 317805 insertions(+), 228360 deletions(-)
> 
Builds results:
	total: 133 pass: 126 fail: 7
Failed builds:
	alpha:allmodconfig
	arm:orion5x_defconfig
	arm:cm_x2xx_defconfig
	hexagon:defconfig
	sparc64:allmodconfig
	x86_64:allyesconfig
	xtensa:allmodconfig

Qemu tests:
	total: 30 pass: 22 fail: 8
Failed tests:
	arm:arm_versatile_defconfig
	mips:mips_malta_defconfig
	mips:mipsel_malta_defconfig
	mips:mipsel_malta_smp_defconfig
	powerpc:ppc_book3s_defconfig
	powerpc:ppc_book3s_smp_defconfig
	powerpc:ppc64_book3s_defconfig
	powerpc:ppc64_book3s_smp_defconfig

As far as I can see, qemu failures are all due to build failures
due to

ERROR: "nf_nat_redirect_ipv6" [net/netfilter/xt_REDIRECT.ko] undefined!

Details at http://server.roeck-us.net:8010/builders.

Guenter
