Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3GYRfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:35:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48402 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3GYRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:35:29 -0400
Message-ID: <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 25 Jul 2013 19:34:53 +0200
In-Reply-To: <20130725080800.GC3403@laptop>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
	 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
	 <20130725080443.GB3403@laptop> <20130725080800.GC3403@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Am Donnerstag, den 25.07.2013, 09:08 +0100 schrieb Lee Jones:
> > > Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > ---
> > >  drivers/mfd/Kconfig                  |   12 +
> > >  drivers/mfd/Makefile                 |    3 +
> > >  drivers/mfd/da9063-core.c            |  177 ++++++
> > >  drivers/mfd/da9063-i2c.c             |  197 ++++++
> > >  drivers/mfd/da9063-irq.c             |  193 ++++++
> > >  include/linux/mfd/da9063/core.h      |  110 ++++
> > >  include/linux/mfd/da9063/pdata.h     |  114 ++++
> > >  include/linux/mfd/da9063/registers.h | 1090 ++++++++++++++++++++++++++++++++++
> > >  8 files changed, 1896 insertions(+)
> > 
> > Whoah!! Who's going to want to review a 2k line patch?

Well, most of those lines consist of the register and bit(field)
definitions and the assignment of those to regmap and regmap-irq.

I could split this into (core+i2c) and (irq) parts if you insist.

> > Any chance you can split this stuff up into more 'bite sized' patches?
> 
> You also missed Sam off the addressees list, which is not a good idea.

Oh right, thank you.

regards
Philipp

