Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaJBD7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:59:38 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42089 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaJBD73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:59:29 -0400
Date: Wed, 1 Oct 2014 20:59:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 1
Message-ID: <20141002035924.GA18144@roeck-us.net>
References: <20141001175411.00be9683@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001175411.00be9683@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 05:54:11PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140930:
> 
> The arm-soc tree still had its build failure for which I reverted
> 5 commits.
> 
> The net-next tree gained a conflict against the berlin tree, lost
> its build failure but gained another for which I applied a patch.
> 
> The vfio tree gained a conflict against the pci tree.
> 
> The tty tree lost its build failure.
> 
> The staging tree still had its build failure for which I reverted
> a commit.
> 
> The gpio tree gained conflicts against Linus' tree and the pinctrl tree.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 8953
>  7726 files changed, 354879 insertions(+), 267353 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
Building arm:cm_x2xx_defconfig ... failed

drivers/built-in.o: In function `clk_set_rate':
:(.text+0xdef44): multiple definition of `clk_set_rate'
arch/arm/mach-pxa/built-in.o::(.text+0xf78): first defined here
drivers/built-in.o:(___ksymtab_gpl+clk_disable+0x0): multiple definition of
`__ksymtab_clk_disable'
arch/arm/mach-pxa/built-in.o:(___ksymtab+clk_disable+0x0): first defined here
drivers/built-in.o: In function `clk_disable':
:(.text+0xddf30): multiple definition of `clk_disable'
arch/arm/mach-pxa/built-in.o::(.text+0xfbc): first defined here

[and more]

---
Building m68k:allmodconfig ... failed

drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
drivers/media/rc/ir-hix5hd2.c:100:2: error: implicit declaration of function 'readl_relaxed'

---
Building mn10300:asb2303_defconfig ... failed
Building um:defconfig ... failed

In file included from drivers/base/platform.c:24:0:
include/linux/pm_domain.h:74:23: error: expected identifier or '(' before '&' token
make[2]: *** [drivers/base/platform.o] Error 1

---
Building sparc64:allmodconfig ... failed

drivers/bcma/main.c: In function 'bcma_of_find_child_device':
drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'

---

Guenter
