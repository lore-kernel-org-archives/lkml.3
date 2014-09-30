Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaI3Q0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:26:44 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48564 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaI3Q0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:26:40 -0400
Date: Tue, 30 Sep 2014 09:26:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>
Subject: Re: linux-next: Tree for Sep 30
Message-ID: <20140930162635.GA7135@roeck-us.net>
References: <20140930201244.0a4596ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930201244.0a4596ec@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 08:12:44PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140926:
> 
> The arm-soc tree still had its build failure for which I reverted
> 5 commits.
> 
> The asm-generic tree lost its build failure.
> 
> The net-next tree gained conflicts against the net tree and a build
> failure so I used the version from next-20140926.
> 
> The battery tree gained a conflict against the arm-soc tree.
> 
> The watchdog tree lost its build failure.
> 
> The tty tree gained a conflict against the slave-dma tree and a build
> failure so I used the version from next-20140926.
> 
> The staging tree gained a build failure for which I reverted a commit.
> 
> The scsi tree lost its build failure.
> 
> The akpm tree gained a conflict against the clk tree and lost a few
> patches that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 8618
>  7372 files changed, 318777 insertions(+), 223023 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
arc:defconfig
xtensa:defconfig

[and possibly others]

drivers/clk/clk-gpio-gate.c: In function 'clk_gpio_gate_enable':
drivers/clk/clk-gpio-gate.c:36: error: implicit declaration of function 'gpiod_set_value'
drivers/clk/clk-gpio-gate.c: In function 'clk_gpio_gate_is_enabled':
drivers/clk/clk-gpio-gate.c:52: error: implicit declaration of function 'gpiod_get_value'
drivers/clk/clk-gpio-gate.c: In function 'clk_register_gpio_gate':
drivers/clk/clk-gpio-gate.c:79: error: implicit declaration of function 'gpiod_is_active_low'
drivers/clk/clk-gpio-gate.c:85: error: implicit declaration of function 'desc_to_gpio'
drivers/clk/clk-gpio-gate.c:125: error: implicit declaration of function 'gpiod_put'
drivers/clk/clk-gpio-gate.c: In function 'of_clk_gpio_gate_delayed_register_get':
drivers/clk/clk-gpio-gate.c:169: error: implicit declaration of function 'gpio_to_desc'
drivers/clk/clk-gpio-gate.c:169: warning: assignment makes pointer from integer without a cast
make[2]: *** [drivers/clk/clk-gpio-gate.o] Error 1

Looks like a missing include file.

Guenter
