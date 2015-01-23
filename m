Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbbAWOUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:20:50 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53605 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbAWOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:20:47 -0500
MIME-Version: 1.0
In-Reply-To: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
References: <1421152136-5007-1-git-send-email-matthias.bgg@gmail.com>
Date: Fri, 23 Jan 2015 15:20:45 +0100
Message-ID: <CABuKBeKWU=wGuyT2u1Ndori1e8B7vAzFAmCafwLDPfAyLHkYBQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] ARM: mediatek: Add watchdog driver
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Howard Chen <ibanezchen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, greta.zhang@mediatek.com,
        huang eddie <eddie.huang@mediatek.com>, Chen-Yu Tsai <wens@csie.org>,
        Guenter Roeck <linux@roeck-us.net>, joe@perches.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

2015-01-13 13:28 GMT+01:00 Matthias Brugger <matthias.bgg@gmail.com>:
> Mediatek SoCs have a watchdog driver. This patch set adds driver and DTS
> binding. The driver also implements a restart handler to reboot the SoC.

Any comments on this patch set?

>
> Changes for v5:
> - add newline in dev_info message
> - add tested-by and reviewed-by
>
> Changes for v4:
> - fix indentation errors
> - delete unused include
> - reorganize while loop to eliminate code duplication
> - eliminate indirection to watchdog_device structure
> - delete unnecessary brackets
>
> Changes for v3:
> - fix based on file name
> - fix style problems
> - fix error return value and warning message
> - delete unnecessary watchdog_set_drvdata
> - delete unused variable
>
> Changes for v2:
> - we don't need to have the watchdog enabled to do a software reset
> - disable dual mode and irq mode when starting the watchdog
> - update commit message to name the SoCs the driver supports
>
>
> Matthias Brugger (2):
>   watchdog: Add driver for Mediatek watchdog
>   ARM: mediatek: dts: Add bindings for watchdog
>
>  .../devicetree/bindings/watchdog/mtk-wdt.txt       |  13 ++
>  drivers/watchdog/Kconfig                           |  10 +
>  drivers/watchdog/Makefile                          |   1 +
>  drivers/watchdog/mtk_wdt.c                         | 252 +++++++++++++++++++++
>  4 files changed, 276 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
>  create mode 100644 drivers/watchdog/mtk_wdt.c
>
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
