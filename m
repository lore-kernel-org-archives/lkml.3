Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaICFWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:22:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33179 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbaICFWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:22:53 -0400
Message-ID: <5406A590.7050703@ti.com>
Date: Wed, 3 Sep 2014 10:52:24 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/5] PHY: Fixes for 3.17 -rc cycle
References: <1409221506-6262-1-git-send-email-kishon@ti.com>
In-Reply-To: <1409221506-6262-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thursday 28 August 2014 03:55 PM, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> Please find the pull request for this -rc cycle. It consistes of a regression
> fix to runtime PM on OMAP (cc'ed stable) and few other minor fixes.
> 
> Please consider merging it in this -rc cycle.
> Let me know If I have to make any changes.

Can we have this merged in this -rc cycle?

Thanks
Kishon

> 
> Cheers
> Kishon
> 
> The following changes since commit 451fd72219dd6f3355e2d036c598544c760ee532:
> 
>   Merge tag 'pwm/for-3.17-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm (2014-08-22 14:50:21 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git tags/for-3.17-rc
> 
> for you to fetch changes up to fbb1a770039d3900f5130bab949b757f6f7fb373:
> 
>   phy: miphy365x: Select GENERIC_PHY instead of depending on it (2014-08-28 11:17:43 +0530)
> 
> ----------------------------------------------------------------
> for_3.17-rc
> 
> Fix regressions to runtime PM on OMAP and other minor fixes.
> 
> ----------------------------------------------------------------
> Kamil Debski (1):
>       MAINTAINERS: add entry for the Samsung USB2 PHY driver
> 
> Lee Jones (1):
>       phy: miphy365x: Select GENERIC_PHY instead of depending on it
> 
> Sjoerd Simons (1):
>       phy: exynos5-usbdrd: Add MODULE_DEVICE_TABLE entry
> 
> Tony Lindgren (2):
>       usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps
>       usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
> 
>  MAINTAINERS                      |   13 ++++
>  drivers/phy/Kconfig              |    2 +-
>  drivers/phy/phy-exynos5-usbdrd.c |    1 +
>  drivers/phy/phy-twl4030-usb.c    |  121 +++++++++++++++++++++++---------------
>  4 files changed, 88 insertions(+), 49 deletions(-)
> 
