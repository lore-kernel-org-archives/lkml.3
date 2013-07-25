Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3GYDKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:10:52 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52160 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3GYDKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:10:49 -0400
Message-ID: <20130724221048.129254d7cfiyvoe0@67.228.131.205>
Date: Wed, 24 Jul 2013 22:10:48 -0500
From: linux@roeck-us.net
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/103] 3.10.3-stable review
References: <20130723220418.532514378@linuxfoundation.org>
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kroah-Hartman <gregkh@linuxfoundation.org>:

> This is the start of the stable review cycle for the 3.10.3 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 25 22:01:33 UTC 2013.
> Anything received after that time might be too late.
>
Build results below. Same as with previous release.

Guenter

----
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
Build m68k:m5272c3_defconfig passed
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
Build microblaze:nommu_defconfig passe
Build blackfin:defconfig passed
Build parisc:defconfig passed

-----------------------
Total builds: 64 Total build errors: 3

