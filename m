Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaK0JDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:03:09 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:42861 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaK0JDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:03:01 -0500
Date: Thu, 27 Nov 2014 09:02:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tglx@linutronix.de, kernel@stlinux.com,
        jason@lakedaemon.net
Subject: Re: [PATCH v2 2/8] irqchip: Supply new driver for STi based devices
Message-ID: <20141127090255.GD4628@x1>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
 <1416932705-16880-3-git-send-email-lee.jones@linaro.org>
 <2433040.4NqTrOMmEE@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2433040.4NqTrOMmEE@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Arnd Bergmann wrote:

> On Tuesday 25 November 2014 16:24:59 Lee Jones wrote:
> 
> > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > index b21f12f..e502f15 100644
> > --- a/drivers/irqchip/Kconfig
> > +++ b/drivers/irqchip/Kconfig
> > @@ -93,6 +93,13 @@ config RENESAS_IRQC
> >  	bool
> >  	select IRQ_DOMAIN
> >  
> > +config ST_IRQCHIP
> > +	bool
> > +	select REGMAP
> > +	select MFD_SYSCON
> > +	help
> > +	  Enables SysCfg Controlled IRQs on STi based platforms.
> > +
> 
> I'm confused by the purpose of this code. It's apparently a driver
> in drivers/irqchip, the Kconfig symbol contains the string IRQCHIP,
> yet it doesn't actually register an irq_chip.
> 
> Also, the name is a bit too generic, ST has lots of different irqchips,
> and this apparently isn't even one of them ;-)

Hmm... now you're going to ask me to remember who I had the
conversation with that alluded to this as the best location for this
driver.  Unfortunately, I cannot.  Can you think of a better place to
put it then?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
