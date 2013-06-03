Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab3FCIV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:21:27 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47857 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3FCIVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:21:23 -0400
Date: Mon, 3 Jun 2013 09:21:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
Message-ID: <20130603082117.GD3370@gmail.com>
References: <1370010272-25520-1-git-send-email-lee.jones@linaro.org>
 <38058740.G1EqTG95pA@wuerfel>
 <20130531151850.GC12488@gmail.com>
 <1902994.0Kq6C7Rx1R@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1902994.0Kq6C7Rx1R@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Arnd Bergmann wrote:

> On Friday 31 May 2013 16:18:50 Lee Jones wrote:
> > On Fri, 31 May 2013, Arnd Bergmann wrote:
> > 
> > > On Friday 31 May 2013 15:24:32 Lee Jones wrote:
> > > > In order to utilise all of the memory located on ux500 based devices
> > > > we have to enable HIGHMEM. Without it the kernel truncates memory down
> > > > to what's left after the PAGE_OFFSET has been applied, which doesn't
> > > > leave an awful lot, especially if we're running large rootfs' such
> > > > as full Linux desktop distributions or Android.
> > > > 
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > How much memory do those devices have? Enabling HIGHMEM is quite expensive.
> > 
> > Another 1GB.
> 
> You mean you have 2GB total or 1.75GB?  You could just use

We have 2GB in total.

> CONFIG_VMSPLIT_2G to an extra GB compared to the default, which
> is what vexpress, imx and s5p already do, but you still have to
> put the vmalloc area in the low 2GB then.

Isn't this for 4GB systems?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
