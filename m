Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3G2P6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:58:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36581 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3G2P6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:58:23 -0400
Message-ID: <1375113464.4223.31.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Mon, 29 Jul 2013 17:57:44 +0200
In-Reply-To: <20130729154614.GA7704@gmail.com>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
	 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
	 <20130725080443.GB3403@laptop> <20130725080800.GC3403@laptop>
	 <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
	 <20130729154614.GA7704@gmail.com>
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

Am Montag, den 29.07.2013, 16:46 +0100 schrieb Lee Jones:
> > > > > Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
> > > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > > ---
> > > > >  drivers/mfd/Kconfig                  |   12 +
> > > > >  drivers/mfd/Makefile                 |    3 +
> > > > >  drivers/mfd/da9063-core.c            |  177 ++++++
> > > > >  drivers/mfd/da9063-i2c.c             |  197 ++++++
> > > > >  drivers/mfd/da9063-irq.c             |  193 ++++++
> > > > >  include/linux/mfd/da9063/core.h      |  110 ++++
> > > > >  include/linux/mfd/da9063/pdata.h     |  114 ++++
> > > > >  include/linux/mfd/da9063/registers.h | 1090 ++++++++++++++++++++++++++++++++++
> > > > >  8 files changed, 1896 insertions(+)
> > > > 
> > > > Whoah!! Who's going to want to review a 2k line patch?
> > 
> > Well, most of those lines consist of the register and bit(field)
> > definitions and the assignment of those to regmap and regmap-irq.
> > 
> > I could split this into (core+i2c) and (irq) parts if you insist.
>
> I won't insist on it, but bear in mind it might take me longer to set
> aside enough time to review the patch than if it were broken up. In
> the latter case I could pick at it throughout the working day.

Alright. I'll split it up a bit, then.

regards
Philipp

