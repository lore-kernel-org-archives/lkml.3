Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3KTQMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:12:41 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52366 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KTQMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:12:40 -0500
MIME-Version: 1.0
In-Reply-To: <1384888074-19696-2-git-send-email-markus.mayer@linaro.org>
References: <1384888074-19696-1-git-send-email-markus.mayer@linaro.org>
	<1384888074-19696-2-git-send-email-markus.mayer@linaro.org>
Date: Wed, 20 Nov 2013 08:12:37 -0800
Message-ID: <CAPdLdqmxFnJ9HZa04buh8NecMszEAp11VRU4Q159vZ+=NG9p3A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Linaro Patches <patches@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2013 11:07, Markus Mayer <markus.mayer@linaro.org> wrote:
> This commit adds support for the watchdog timer used on the BCM281xx
> family of SoCs.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/Kconfig        |   22 +++
>  drivers/watchdog/Makefile       |    1 +
>  drivers/watchdog/bcm_kona_wdt.c |  365 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 388 insertions(+)
>  create mode 100644 drivers/watchdog/bcm_kona_wdt.c
>

[...]

> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 6c5bb27..7c860ca 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
>  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
>  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
> +obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>
>  # AVR32 Architecture
>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o

Just to let everyone know, due to the watchdog -> mainline merge a few
days ago, there's a trivial merge conflict now in the makefile. I'll
send out a re-based v5 of this patch once 3.13-rc1 has been tagged
(unless you would like a rebased-to-tip version before then).

Regards,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
