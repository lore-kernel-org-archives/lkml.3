Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3EaPTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:19:11 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55578 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3EaPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:18:55 -0400
Date: Fri, 31 May 2013 16:18:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Message-ID: <20130531151850.GC12488@gmail.com>
References: <1370010272-25520-1-git-send-email-lee.jones@linaro.org>
 <1370010272-25520-2-git-send-email-lee.jones@linaro.org>
 <38058740.G1EqTG95pA@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38058740.G1EqTG95pA@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Arnd Bergmann wrote:

> On Friday 31 May 2013 15:24:32 Lee Jones wrote:
> > In order to utilise all of the memory located on ux500 based devices
> > we have to enable HIGHMEM. Without it the kernel truncates memory down
> > to what's left after the PAGE_OFFSET has been applied, which doesn't
> > leave an awful lot, especially if we're running large rootfs' such
> > as full Linux desktop distributions or Android.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> How much memory do those devices have? Enabling HIGHMEM is quite expensive.

Another 1GB.

> > diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> > index 5439925..808be06 100644
> > --- a/drivers/of/fdt.c
> > +++ b/drivers/of/fdt.c
> 
> You should probably resend the patch without the second half that got
> in it by accident.

I did already, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
