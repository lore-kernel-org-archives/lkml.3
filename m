Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab3FRW6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:58:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64386 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3FRW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:58:40 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 18 Jun 2013 15:58:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/48] 3.9.7-stable review
Message-ID: <20130618225837.GA30881@roeck-us.net>
References: <20130618161725.912524266@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:17:26AM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 3.9.7 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Jun 20 16:15:42 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.7-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Test build results:

Build reference: v3.9.6-48-g72559a8

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
Build powerpc:defconfig passed
Build powerpc:allyesconfig failed
Build powerpc:allmodconfig passed
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
Build m68k:defconfig passed
Build m68k:apollo_defconfig passed
Build m68k:m5272c3_defconfig failed
Build m68k:m5307c3_defconfig passed
Build m68k:mac_defconfig passed
Build m68k:multi_defconfig passed
Build m68k:sun3_defconfig passed
Build m68k:sun3x_defconfig passed
Build m68k:mvme16x_defconfig passed
Build m68k:hp300_defconfig passed

-----------------------
Total builds: 46 Total build errors: 4

Results match the results for v3.9.6.

Guenter
