Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3GBOje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:39:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53795 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3GBOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:39:33 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 2 Jul 2013 07:39:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/13] 3.4.52-stable review
Message-ID: <20130702143932.GA24055@roeck-us.net>
References: <20130701200523.096669485@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701200523.096669485@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 01:10:19PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.52 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Jul  3 20:03:01 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.52-rc1.gz
> and the diffstat can be found below.
> 
Build results are as follows.

Guenter

---
Build reference: v3.4.51-13-g4384bdb

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
Build mips:nlm_xlp_defconfig passed
Build mips:ar7_defconfig passed
Build mips:fuloong2e_defconfig passed
Build mips:e55_defconfig passed
Build mips:powertv_defconfig passed
Build mips:malta_defconfig passed
Build powerpc:defconfig passed
Build powerpc:allyesconfig failed
Build powerpc:allmodconfig passed
Build powerpc:chroma_defconfig failed
Build powerpc:maple_defconfig passed
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
Build arm:u8500_defconfig passed
Build arm:at91sam9rl_defconfig passed
Build arm:ap4evb_defconfig passed
Build arm:bonito_defconfig passed
Build arm:pxa910_defconfig passed
Build m68k:defconfig passed
Build m68k:m5272c3_defconfig passed
Build m68k:m5307c3_defconfig passed
Build m68k:m5249evb_defconfig passed
Build m68k:m5407c3_defconfig passed
Build m68k:sun3_defconfig passed
Build sparc:defconfig passed
Build sparc:sparc64_defconfig passed
Build xtensa:defconfig failed
Build xtensa:iss_defconfig failed
Build microblaze:mmu_defconfig failed
Build microblaze:nommu_defconfig passed
Build blackfin:defconfig failed
Build parisc:defconfig passed

-----------------------
Total builds: 58 Total build errors: 8


