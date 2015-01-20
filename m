Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbbATN16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:27:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43647 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbATN15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:27:57 -0500
Date: Tue, 20 Jan 2015 14:27:51 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] soc: Add MediaTek pericfg controller support
Message-ID: <20150120132751.GM18220@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
 <1421759910.11671.69.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421759910.11671.69.camel@mtksdaap41>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:27:27 up 97 days, 41 min, 121 users,  load average: 0.02, 0.09,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Jan 20, 2015 at 09:18:30PM +0800, Yingjoe Chen wrote:
> On Tue, 2015-01-20 at 10:47 +0100, Sascha Hauer wrote:
> <...>
> > diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
> > index b7ee902..aa9a7eb 100644
> > --- a/drivers/soc/mediatek/mtk-pericfg.c
> > +++ b/drivers/soc/mediatek/mtk-pericfg.c
> > @@ -1,6 +1,5 @@
> >  /*
> >   * Copyright (c) 2014 MediaTek Inc.
> > - * Author: Flora Fu <flora.fu@mediatek.com>
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License version 2 as
> 
> Hi Sascha,
> 
> I believe you want to add mtk-pericfg.c here instead of adding it in
> first patch and only change author here.

Indeed. Fixed for the next round.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
