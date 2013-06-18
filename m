Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3FRX1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:27:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3FRX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:27:01 -0400
Date: Tue, 18 Jun 2013 16:26:59 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/48] 3.9.7-stable review
Message-ID: <20130618232659.GA7716@kroah.com>
References: <20130618161725.912524266@linuxfoundation.org>
 <20130618225837.GA30881@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618225837.GA30881@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 03:58:37PM -0700, Guenter Roeck wrote:
> On Tue, Jun 18, 2013 at 09:17:26AM -0700, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 3.9.7 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Jun 20 16:15:42 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.7-rc1.gz
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Test build results:
> 
> Build reference: v3.9.6-48-g72559a8
> 
> Build x86_64:defconfig passed
> Build x86_64:allyesconfig passed
> Build x86_64:allmodconfig passed
> Build x86_64:allnoconfig passed
> Build x86_64:alldefconfig passed
> Build i386:defconfig passed
> Build i386:allyesconfig passed
> Build i386:allmodconfig passed
> Build i386:allnoconfig passed
> Build i386:alldefconfig passed
> Build mips:defconfig passed
> Build mips:bcm47xx_defconfig passed
> Build mips:bcm63xx_defconfig passed
> Build mips:nlm_xlp_defconfig passed
> Build mips:ath79_defconfig passed
> Build mips:ar7_defconfig passed
> Build mips:fuloong2e_defconfig passed
> Build mips:e55_defconfig passed
> Build mips:cavium_octeon_defconfig passed
> Build powerpc:defconfig passed
> Build powerpc:allyesconfig failed
> Build powerpc:allmodconfig passed
> Build powerpc:mpc85xx_defconfig passed
> Build powerpc:mpc85xx_smp_defconfig passed
> Build powerpc:tqm8xx_defconfig passed
> Build powerpc:85xx/sbc8548_defconfig passed
> Build powerpc:83xx/mpc834x_mds_defconfig passed
> Build powerpc:86xx/sbc8641d_defconfig passed
> Build arm:defconfig passed
> Build arm:allyesconfig failed
> Build arm:allmodconfig failed
> Build arm:exynos4_defconfig passed
> Build arm:kirkwood_defconfig passed
> Build arm:omap2plus_defconfig passed
> Build arm:tegra_defconfig passed
> Build arm:u8500_defconfig passed
> Build m68k:defconfig passed
> Build m68k:apollo_defconfig passed
> Build m68k:m5272c3_defconfig failed
> Build m68k:m5307c3_defconfig passed
> Build m68k:mac_defconfig passed
> Build m68k:multi_defconfig passed
> Build m68k:sun3_defconfig passed
> Build m68k:sun3x_defconfig passed
> Build m68k:mvme16x_defconfig passed
> Build m68k:hp300_defconfig passed
> 
> -----------------------
> Total builds: 46 Total build errors: 4
> 
> Results match the results for v3.9.6.

Thanks for testing and letting me know.

greg k-h
