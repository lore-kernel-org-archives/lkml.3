Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3LVUGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 15:06:49 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60690 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3LVUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 15:06:47 -0500
Date: Sun, 22 Dec 2013 12:04:39 -0800
From: Olof Johansson <olof@lixom.net>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Subject: Re: [PATCH v2] MAINTAINERS: take maintainership for Energy Micro
 efm32 SoCs
Message-ID: <20131222200439.GA11214@quad.lixom.net>
References: <1387569330.616105313@f421.i.mail.ru>
 <1387570919-13627-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387570919-13627-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 09:21:59PM +0100, Uwe Kleine-König wrote:
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> On Fri, Dec 20, 2013 at 11:55:30PM +0400, Alexander Shiyan wrote:
> > [...]
> > > +F: arch/arm/boot/dts/efm32*
> > > +F: arch/arm/configs/efm32_defconfig
> > > +F: arch/arm/include/debug/efm32.S
> > > +F: arch/arm/mach-efm32/
> > > +F: drivers/clk/clk-efm32gg.c
> > > +F: drivers/clocksource/time-efm32.c
> > > +F: drivers/spi/spi-efm32.c
> > > +F: drivers/tty/serial/efm32-uart.c
> > > +F: include/dt-bindings/clock/efm32-cmu.h
> > > +F: include/linux/platform_data/efm32-*
> > 
> > Maybe "N" keyword with "efm32" is better here?
> ah, didn't know about that. Nice.
> 
> So the changes since v1 are:
>  - use N: efm32
>  - add acks from Greg and Mark
>    I assume it's ok to keep them for v2 assuming they mean them being OK with
>    me maintaining the efm32 stuff and not the way to express that in
>    MAINTAINERS.

Applied, thanks.

-Olof
