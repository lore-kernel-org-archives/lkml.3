Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaELEvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 00:51:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50654 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaELEvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 00:51:17 -0400
Date: Mon, 12 May 2014 06:51:13 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] pinctrl: Add i.MX1 pincontrol driver
Message-ID: <20140512045113.GY5858@pengutronix.de>
References: <1399652193-17827-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399652193-17827-1-git-send-email-shc_work@mail.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:46:24 up 18 days, 22:17, 31 users,  load average: 0.17, 0.13,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:16:33PM +0400, Alexander Shiyan wrote:
> This patch adds pincontrol driver for Freescale i.MX1 SOCs.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/pinctrl/Kconfig        |   7 ++
>  drivers/pinctrl/Makefile       |   1 +
>  drivers/pinctrl/pinctrl-imx1.c | 279 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+)
>  create mode 100644 drivers/pinctrl/pinctrl-imx1.c

Nice. I thought about adding devicetree support for i.MX1 aswell.

Don't we need a imx1-pinfunc.h file to make use of this patch?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
