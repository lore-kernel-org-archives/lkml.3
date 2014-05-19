Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaESJWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:22:10 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36014 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaESJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:22:07 -0400
Date: Mon, 19 May 2014 10:21:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 3/7] mfd: add support for sun6i PRCM
 (Power/Reset/Clock Management) unit
Message-ID: <20140519092159.GE4978@lee--X1>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399633911-7094-4-git-send-email-boris.brezillon@free-electrons.com>
 <20140509135251.GY5767@lee--X1>
 <20140515151756.GX29258@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515151756.GX29258@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The PRCM (Power/Reset/Clock Management) block exposes several subdevices
> > > in different subsystems (clk, reset ...)
> > > 
> > > Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
> > > and reset controller subdevices.
> > > 
> > > Other subdevices might be added later (if needed).
> > > 
> > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >  drivers/mfd/Kconfig      |   8 +++
> > >  drivers/mfd/Makefile     |   1 +
> > >  drivers/mfd/sun6i-prcm.c | 134 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 143 insertions(+)
> > >  create mode 100644 drivers/mfd/sun6i-prcm.c
> > 
> > [...]
> > 
> > > +/*
> > > + * Copyright (C) 2014 Free Electrons
> > > + *
> > > + * License Terms: GNU General Public License v2
> > > + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > + *
> > > + * Allwinner PRCM (Power/Reset/Clock Management) driver
> > > + *
> > > + */
> > > +
> > > +#include <linux/mfd/core.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of.h>
> > 
> > Ah, now isn't that better?
> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> How do you want to merge this? Do you want me to take it through
> mach-sunxi tree, or do you want to take it in your tree?

If Boris can tell me what needs to go in with this patch (or if it
can go in on its own), I will create a(n immutable) branch from which
you can pull into your tree.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
