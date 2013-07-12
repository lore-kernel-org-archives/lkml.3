Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab3GLDkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 23:40:10 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:49086 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3GLDkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 23:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <1373471889-18107-4-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de> <1373471889-18107-4-git-send-email-wsa@the-dreams.de>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 12 Jul 2013 11:39:46 +0800
Message-ID: <CAGsJ_4ygnSs_MLHOsoOo5VK=dLL4m0-o-mFR21oKwZ=LY35jXw@mail.gmail.com>
Subject: Re: [PATCH 04/12] drivers/mmc/host: don't use devm_pinctrl_get_select_default()
 in probe
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Marek Vasut <marex@denx.de>,
        Jingoo Han <jg1.han@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Balaji T K <balajitk@ti.com>, Nicolas Pitre <nico@fluxnic.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-mmc@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linux-omap@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Barry Song <baohua.song@csr.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/10 Wolfram Sang <wsa@the-dreams.de>:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/mmc/host/mvsdio.c          |    6 ------
>  drivers/mmc/host/mxs-mmc.c         |    8 --------
>  drivers/mmc/host/omap_hsmmc.c      |    7 -------
>  drivers/mmc/host/sdhci-esdhc-imx.c |    8 --------
>  drivers/mmc/host/sdhci-sirf.c      |    8 --------

Wolfram, this has been done for sirf, which version are you based on?

>  5 files changed, 37 deletions(-)

-barry
