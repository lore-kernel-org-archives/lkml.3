Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbbATKyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:54:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbbATKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:54:40 -0500
Date: Tue, 20 Jan 2015 11:54:33 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 8/8] regulator: MT6397: Add support for MT6397 regulator
Message-ID: <20150120105433.GF18908@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
 <1421748424.9655.107.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421748424.9655.107.camel@x220>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:50:28 up 96 days, 22:04, 120 users,  load average: 0.00, 0.04,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:07:04AM +0100, Paul Bolle wrote:
> On Tue, 2015-01-20 at 10:47 +0100, Sascha Hauer wrote:
> > From: Flora Fu <flora.fu@mediatek.com>
> > 
> > This adds support for the regulators on the MediaTek MT6397
> > Multifunction device.
> > 
> > Signed-off-by: Flora Fu, MediaTek
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Liam Girdwood <lgirdwood@gmail.com>
> > Cc: Mark Brown <broonie@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/mfd/mt6397.txt   |  41 ++-
> 
> This looks new for linux-next ...
> 
> >  .../bindings/regulator/mt6397-regulator.txt        | 217 ++++++++++++++
> 
> but this is already in linux-next. See linux-next commit 269675757901
> ("regulator: Add document for MT6397 regulator"). And ...
> 
> >  drivers/regulator/Kconfig                          |   9 +
> >  drivers/regulator/Makefile                         |   1 +
> >  drivers/regulator/mt6397-regulator.c               | 332 +++++++++++++++++++++
> >  include/linux/regulator/mt6397-regulator.h         |  49 +++
> 
> these are too. See linux-next commit 0425e2420c0a ("egulator: mt6397:
> Add support for MT6397 regulator"). Unless there are difference that
> can't be spotted by looking at the diffstats of those commist, that is.

It seems Mark already merged the regulator part to his tree. Ok, in this
case you can ignore the regulator patch in this series. I think I haven't
made changes to the regulator part in this series.
The other patches are still needed though.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
