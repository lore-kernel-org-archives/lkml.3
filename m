Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaHKRFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:05:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34995 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaHKRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:05:16 -0400
Date: Mon, 11 Aug 2014 10:05:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 11
Message-ID: <20140811170510.GA19750@roeck-us.net>
References: <20140811155213.0aa083ce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811155213.0aa083ce@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 03:52:13PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add code intended for v3.18 until after v3.17-rc1 is
> released.
> 
> Changes since 20140808:
> 
> The ext3 tree lost its build failure.
> 
> The pm tree gained conflicts against Linus' tree and a build failure for
> which I applied a merge fix patch.
> 
> The mmc-uh tree still had its build failure so I used the version from
> next-20140725.
> 
> The akpm tree lost several patches that turned up in Linus' tree.
> 
> Non-merge commits (relative to Linus' tree): 1547
>  1041 files changed, 31446 insertions(+), 15956 deletions(-)
> 

New build failures:

Building arm:s5pv210_defconfig ... failed
--------------
Error log:
arch/arm/mach-s5pv210/pm.c:150:12: error: 'suspend_valid_only_mem' undeclared
here (not in a function)
make[1]: *** [arch/arm/mach-s5pv210/pm.o] Error 1

Building arm:pxa910_defconfig ... failed
--------------
Error log:
arch/arm/mach-mmp/pm-pxa910.c: In function 'pxa910_pm_valid':
arch/arm/mach-mmp/pm-pxa910.c:243:65: error: expected ')' before ';' token
arch/arm/mach-mmp/pm-pxa910.c:244:1: error: expected ';' before '}' token
make[1]: *** [arch/arm/mach-mmp/pm-pxa910.o] Error 1

Guenter
