Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3GJT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:57:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35285 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3GJT5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:57:23 -0400
X-Auth-Info: zAigTkTyNAihuDl8bWf14J3he5GE6Tm9WqIFa/ANTe4=
From: Marek Vasut <marex@denx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 04/12] drivers/mmc/host: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 21:57:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, Balaji T K <balajitk@ti.com>,
        Barry Song <baohua.song@csr.com>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jingoo Han <jg1.han@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de> <1373471889-18107-4-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1373471889-18107-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307102157.16419.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wolfram Sang,

> Since commit ab78029 (drivers/pinctrl: grab default handles from device
> core), we can rely on device core for setting the default pins. Compile
> tested only.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Something like that is already in -next:

    mmc: mxs-mmc: Let device core handle pinctrl

Otherwise

Tested-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
