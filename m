Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3G2P5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:57:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:1780 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab3G2P5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="378375737"
Date: Mon, 29 Jul 2013 17:57:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
Message-ID: <20130729155727.GA11830@zurbaran>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
 <20130725080443.GB3403@laptop>
 <20130725080800.GC3403@laptop>
 <1374773693.4382.17.camel@pizza.hi.pengutronix.de>
 <20130729154614.GA7704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729154614.GA7704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jul 29, 2013 at 04:46:14PM +0100, Lee Jones wrote:
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
> I won't insist on it, 
I would. Smaller patches are easier to review, track and bisect.
So if you can logically split this patch into smaller pieces,, then
please do so.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
