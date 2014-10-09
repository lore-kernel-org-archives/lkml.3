Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaJIHRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:17:55 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:45447 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaJIHRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:17:46 -0400
Date: Thu, 9 Oct 2014 08:17:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141009071740.GK20647@lee--X1>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
 <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
 <20141008155756.GA17676@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141008155756.GA17676@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2014, Guenter Roeck wrote:

> On Wed, Oct 08, 2014 at 10:33:30AM +0100, Lee Jones wrote:
> > Signed-off-by: David Paris <david.paris@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/watchdog/Kconfig  |  16 +++
> >  drivers/watchdog/Makefile |   1 +
> >  drivers/watchdog/st_wdt.c | 317 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 334 insertions(+)
> >  create mode 100644 drivers/watchdog/st_wdt.c
> > 
> 
> Unfortunately (built with W=1):
> 
> drivers/watchdog/st_wdt.c: In function 'st_wdog_load_timer':
> drivers/watchdog/st_wdt.c:114:14: warning: comparison between signed and
> unsigned integer expressions [-Wsign-compare]
> drivers/watchdog/st_wdt.c: In function 'st_wdog_remove':
> drivers/watchdog/st_wdt.c:273:24: error: 'clk' undeclared (first use in this
> function)
> 
> and checkpatch complains a bit: 
> 
> WARNING: please, no space before tabs
> #303: FILE: drivers/watchdog/st_wdt.c:236:
> +^Ist_wdog->dev ^I^I= &pdev->dev;$
> 
> WARNING: please, no space before tabs
> #304: FILE: drivers/watchdog/st_wdt.c:237:
> +^Ist_wdog->base ^I^I= base;$
> 
> WARNING: please, no space before tabs
> #306: FILE: drivers/watchdog/st_wdt.c:239:
> +^Ist_wdog->warm_reset ^I= of_property_read_bool(np, "st,warm_reset");$

Thanks for taking the time to build this Guenter.  I must profess, the
recent submissions were delivered hastily, due to other pressing tasks
and a mountain of email to peruse.  The next submission will be
subject extensive; build, static analysis and execution testing.
Sorry to waste your time.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
