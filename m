Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032Ab3GLNyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:54:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43586 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:54:42 -0400
Date: Fri, 12 Jul 2013 06:54:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/8] 3.0.86-stable review
Message-ID: <20130712135443.GA3439@roeck-us.net>
References: <20130711221931.216612791@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711221931.216612791@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:20:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.86 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Jul 13 22:18:05 UTC 2013.
> Anything received after that time might be too late.
> 
Build results are as follows. No changes from previous version.

Guenter

---

Build reference: v3.0.85-8-gfe7e43b

Build x86_64:defconfig passed
Build x86_64:allyesconfig passed
Build x86_64:allmodconfig passed
Build x86_64:allnoconfig passed
Build x86_64:alldefconfig passed
Build i386:defconfig passed
Build i386:allyesconfig passed
Build i386:allmodconfig passed
Build i386:allnoconfig passed
Build i386:alldefconfig passed
Build mips:defconfig passed
Build mips:bcm47xx_defconfig passed
Build mips:bcm63xx_defconfig passed
Build mips:ar7_defconfig passed
Build mips:fuloong2e_defconfig passed
Build mips:e55_defconfig passed
Build mips:powertv_defconfig passed
Build mips:malta_defconfig passed
Build powerpc:defconfig failed
Build powerpc:allyesconfig failed
Build powerpc:allmodconfig failed
Build powerpc:maple_defconfig failed
Build powerpc:ppc6xx_defconfig passed
Build powerpc:mpc83xx_defconfig passed
Build powerpc:mpc85xx_defconfig passed
Build powerpc:mpc85xx_smp_defconfig passed
Build powerpc:tqm8xx_defconfig passed
Build powerpc:85xx/sbc8548_defconfig passed
Build powerpc:83xx/mpc834x_mds_defconfig passed
Build powerpc:86xx/sbc8641d_defconfig passed
Build arm:defconfig passed
Build arm:allyesconfig failed
Build arm:allmodconfig failed
Build arm:exynos4_defconfig passed
Build arm:kirkwood_defconfig passed
Build arm:omap2plus_defconfig passed
Build arm:tegra_defconfig passed
Build arm:u8500_defconfig failed
Build arm:ap4evb_defconfig passed
Build arm:pxa910_defconfig passed
Build m68k:defconfig passed
Build m68k:m5272c3_defconfig failed
Build m68k:m5307c3_defconfig failed
Build m68k:m5249evb_defconfig failed
Build m68k:m5407c3_defconfig failed
Build m68k:sun3_defconfig passed
Build sparc:defconfig passed
Build sparc:sparc64_defconfig passed
Build xtensa:defconfig failed
Build xtensa:iss_defconfig failed
Build microblaze:mmu_defconfig failed
Build microblaze:nommu_defconfig failed
Build blackfin:defconfig failed
Build parisc:defconfig failed

-----------------------
Total builds: 54 Total build errors: 17
