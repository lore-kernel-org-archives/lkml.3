Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab3GLWFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:05:06 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37861 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3GLWFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:05:04 -0400
Date: Fri, 12 Jul 2013 15:05:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/15] 3.9.10-stable review
Message-ID: <20130712220505.GA9787@roeck-us.net>
References: <20130711221255.925669600@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711221255.925669600@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:19:30PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.9.10 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Jul 13 22:11:24 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.10-rc1.gz
> and the diffstat can be found below.
> 
Cross build results are as follows. No change to previous release.

Guenter

---
Build reference: v3.9.9-15-gc79284a

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
Build mips:ath79_defconfig passed
Build mips:ar7_defconfig passed
Build mips:fuloong2e_defconfig passed
Build mips:e55_defconfig passed
Build mips:cavium_octeon_defconfig passed
Build mips:powertv_defconfig passed
Build mips:malta_defconfig passed
Build powerpc:defconfig passed
Build powerpc:allyesconfig failed
Build powerpc:allmodconfig passed
Build powerpc:chroma_defconfig passed
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
Build arm:multi_v7_defconfig passed
Build arm:kirkwood_defconfig passed
Build arm:omap2plus_defconfig passed
Build arm:tegra_defconfig passed
Build arm:u8500_defconfig passed
Build arm:at91sam9rl_defconfig passed
Build arm:ap4evb_defconfig passed
Build arm:bcm_defconfig passed
Build arm:bonito_defconfig passed
Build arm:pxa910_defconfig passed
Build arm:mvebu_defconfig passed
Build m68k:defconfig passed
Build m68k:m5272c3_defconfig failed
Build m68k:m5307c3_defconfig passed
Build m68k:m5249evb_defconfig passed
Build m68k:m5407c3_defconfig passed
Build m68k:sun3_defconfig passed
Build m68k:m5475evb_defconfig passed
Build sparc:defconfig passed
Build sparc:sparc64_defconfig passed
Build xtensa:defconfig passed
Build xtensa:iss_defconfig passed
Build microblaze:mmu_defconfig passed
Build microblaze:nommu_defconfig passed
Build blackfin:defconfig passed
Build parisc:defconfig passed

-----------------------
Total builds: 64 Total build errors: 4
