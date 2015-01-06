Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbbAFQzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:55:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbAFQzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:55:12 -0500
Message-ID: <1420563279.3719.15.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-rockchip@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "padma.v@samsung.com" <padma.v@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "kgene@kernel.org" <kgene@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>
Date: Tue, 06 Jan 2015 17:54:39 +0100
In-Reply-To: <CAM4voa=xoM4AuGxwk0TpLnGz9jbZ02awFOrY_KgWCSzROJR6cA@mail.gmail.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
	 <1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
	 <1418292513.3188.4.camel@pengutronix.de> <20141211103919.GA6067@arm.com>
	 <1418298046.3188.10.camel@pengutronix.de>
	 <20141211145849.GH31456@e104818-lin.cambridge.arm.com>
	 <CAM4voakdfiTecW8YH0znnyB-dTnX_fsrRcH2McABwdk3T9drkQ@mail.gmail.com>
	 <20150105181823.GG4081@atomide.com>
	 <CAM4voa=xoM4AuGxwk0TpLnGz9jbZ02awFOrY_KgWCSzROJR6cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

Am Dienstag, den 06.01.2015, 19:57 +0530 schrieb Abhilash Kesavan:
> >> From the existing dts files, omap, imx, rockchip and exynos seem to be
> >> the only users of the sram allocator code. I have tested this on
> >> Exynos5420, Exynos5800 and Exynos7; there is no change in behavior
> >> seen on these boards. Tested-by for other SoCs would be appreciated.
> >
> > Sorry for the delay, these seems to boot OK on omap4, so from that
> > point of view:
> >
> > Tested-by: Tony Lindgren <tony@atomide.com>
> 
> Thanks a lot for testing this. If someone with imx and rockchip boards
> could help test this out, then we could look to get this in.

This shouldn't be a problem on i.MX, the coda driver doesn't access SRAM
from the CPU at all.

regards
Philipp

