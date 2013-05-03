Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3ECIBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:01:33 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46124 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3ECIBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:01:31 -0400
Date: Fri, 3 May 2013 09:01:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 0/5] various ab8500 fixes
Message-ID: <20130503080125.GC24153@gmail.com>
References: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366978638-967-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Fabio Baltieri wrote:

> Hi Samuel,
> 
> this series contains various fixes I found on the current -next ab8500
> driver(s).
> 
> Patches 1 and 2 are just sparse warning, patch 3 drops reference to a
> superseeded driver and last two makes ab8500-sysctrl works again without
> an explicit ab8500->sysctrl defined, as it is in current kernel.
> 
> Thanks,
> Fabio
> 
> 
> Fabio Baltieri (5):
>   mfd: abx500-core: fix sparse warning
>   mfd: ab8500-sysctrl: fix sparse warning
>   mfd: ab8500: drop references to ab8500-leds
>   mfd: ab8500-sysctrl: set sysctrl_dev during probe
>   mfd: ab8500-sysctrl: let sysctrl driver work without pdata

I have a really petty point:

Try and keep to the $SUBJECT line conventions which are preferred by
each subsystem maintainer. Linus Walleij tends to prefer the scheme
you've used above, but Sam likes the description to start with an
uppercase character. No biggy, I'll just fix that up for you.

>  drivers/mfd/ab8500-core.c    | 13 -------------
>  drivers/mfd/ab8500-sysctrl.c |  9 +++++----
>  drivers/mfd/abx500-core.c    |  2 +-
>  3 files changed, 6 insertions(+), 18 deletions(-)

All patches applied. Thanks Fabio.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
