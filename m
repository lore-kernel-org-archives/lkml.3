Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbbAUI0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:26:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33163 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUI02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:26:28 -0500
Date: Wed, 21 Jan 2015 09:26:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Flora Fu <flora.fu@mediatek.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 8/8] regulator: MT6397: Add support for MT6397 regulator
Message-ID: <20150121082622.GG18908@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:24:05 up 97 days, 19:37, 117 users,  load average: 0.19, 0.10,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:47:11AM +0100, Sascha Hauer wrote:
> From: Flora Fu <flora.fu@mediatek.com>
> 
> This adds support for the regulators on the MediaTek MT6397
> Multifunction device.
> 
> Signed-off-by: Flora Fu, MediaTek
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> ---
>  Documentation/devicetree/bindings/mfd/mt6397.txt   |  41 ++-
>  .../bindings/regulator/mt6397-regulator.txt        | 217 ++++++++++++++
>  drivers/regulator/Kconfig                          |   9 +
>  drivers/regulator/Makefile                         |   1 +
>  drivers/regulator/mt6397-regulator.c               | 332 +++++++++++++++++++++
>  include/linux/regulator/mt6397-regulator.h         |  49 +++
>  6 files changed, 626 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
>  create mode 100644 drivers/regulator/mt6397-regulator.c
>  create mode 100644 include/linux/regulator/mt6397-regulator.h
> 
> diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt

I'll move this documentation update to the patch adding the MFD driver
where it belongs to. I'll drop the reset of this patch since it's already
in Linux-next.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
