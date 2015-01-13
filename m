Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbbAMCao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:30:44 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:32825 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbbAMCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:30:43 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 0/2] ARM: mediatek: Add watchdog driver
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <wim@iguana.be>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <heiko@sntech.de>,
        <yingjoe.chen@gmail.com>, <ibanezchen@gmail.com>,
        <greta.zhang@mediatek.com>, <wens@csie.org>, <linux@roeck-us.net>,
        <joe@perches.com>
In-Reply-To: <1421076884-15860-1-git-send-email-matthias.bgg@gmail.com>
References: <1421076884-15860-1-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jan 2015 10:30:38 +0800
Message-ID: <1421116238.22982.3.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On Mon, 2015-01-12 at 16:34 +0100, Matthias Brugger wrote:
> Mediatek SoCs have a watchdog driver. This patch set adds driver and DTS
> binding. The driver also implements a restart handler to reboot the SoC.
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

Test OK on mt8173 platform.

Tested-by: Eddie Huang <eddie.huang@mediatek.com>


