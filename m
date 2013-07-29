Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3G2PqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:46:22 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54652 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3G2PqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:46:20 -0400
Date: Mon, 29 Jul 2013 16:46:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
Message-ID: <20130729154614.GA7704@gmail.com>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
 <20130725080443.GB3403@laptop>
 <20130725080800.GC3403@laptop>
 <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
> > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > ---
> > > >  drivers/mfd/Kconfig                  |   12 +
> > > >  drivers/mfd/Makefile                 |    3 +
> > > >  drivers/mfd/da9063-core.c            |  177 ++++++
> > > >  drivers/mfd/da9063-i2c.c             |  197 ++++++
> > > >  drivers/mfd/da9063-irq.c             |  193 ++++++
> > > >  include/linux/mfd/da9063/core.h      |  110 ++++
> > > >  include/linux/mfd/da9063/pdata.h     |  114 ++++
> > > >  include/linux/mfd/da9063/registers.h | 1090 ++++++++++++++++++++++++++++++++++
> > > >  8 files changed, 1896 insertions(+)
> > > 
> > > Whoah!! Who's going to want to review a 2k line patch?
> 
> Well, most of those lines consist of the register and bit(field)
> definitions and the assignment of those to regmap and regmap-irq.
> 
> I could split this into (core+i2c) and (irq) parts if you insist.

I won't insist on it, but bear in mind it might take me longer to set
aside enough time to review the patch than if it were broken up. In
the latter case I could pick at it throughout the working day.

> > > Any chance you can split this stuff up into more 'bite sized' patches?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
