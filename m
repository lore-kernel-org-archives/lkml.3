Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbbATPFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:05:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33408 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbATPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:05:37 -0500
Date: Tue, 20 Jan 2015 16:05:12 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Flora Fu <flora.fu@mediatek.com>, Mark Rutland <mark.rutland@arm.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, arm@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        srv_heupstream@mediatek.com, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Chen Zhong <chen.zhong@mediatek.com>
Subject: Re: [PATCH v4 2/6] mfd: MT6397: Add support for PMIC MT6397 MFD
Message-ID: <20150120150512.GA12209@pengutronix.de>
References: <1419577768-12037-1-git-send-email-flora.fu@mediatek.com>
 <1419577768-12037-3-git-send-email-flora.fu@mediatek.com>
 <20150120144309.GT13701@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120144309.GT13701@x1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:58:50 up 97 days,  2:12, 127 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 20, 2015 at 02:43:09PM +0000, Lee Jones wrote:
> On Fri, 26 Dec 2014, Flora Fu wrote:
> 
> > Add core files for MT6397 MFD driver.
> > 
> > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > ---
> >  drivers/mfd/Kconfig                  |  10 +
> >  drivers/mfd/Makefile                 |   1 +
> >  drivers/mfd/mt6397-core.c            |  94 +++++++++
> >  include/linux/mfd/mt6397/core.h      |  23 +++
> >  include/linux/mfd/mt6397/registers.h | 362 +++++++++++++++++++++++++++++++++++
> >  5 files changed, 490 insertions(+)
> >  create mode 100644 drivers/mfd/mt6397-core.c
> >  create mode 100644 include/linux/mfd/mt6397/core.h
> >  create mode 100644 include/linux/mfd/mt6397/registers.h
> 
> Looks okay.
> 
> I assume there are dependancies on this patch.  What are they?
> 
> How would you like this set to be handled?

This patch is outdated, I sent an updated series today (you are on Cc).

There are no compile time dependencies to the PMIC wrapper, but without
it the mfd part is pretty useless. I prefer to keep the series together
and merge it through arm-soc, but I would be fine with merging it
through mfd aswell.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
