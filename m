Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaCOTdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:33:00 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:33981 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754932AbaCOTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:32:59 -0400
Date: Sat, 15 Mar 2014 20:32:58 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: bcm281xx: Fix Kconfig dependency
Message-ID: <20140315193258.GA13884@spo001.leaseweb.com>
References: <1394017061-5481-1-git-send-email-markus.mayer@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394017061-5481-1-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

> Use more the applicable ARCH_BCM_MOBILE option instead of ARCH_BCM as
> dependency for bcm_kona_wdt.c.
> 
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  drivers/watchdog/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 79d2589..47a6f10 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1160,7 +1160,7 @@ config BCM2835_WDT
>  
>  config BCM_KONA_WDT
>  	tristate "BCM Kona Watchdog"
> -	depends on ARCH_BCM
> +	depends on ARCH_BCM_MOBILE
>  	select WATCHDOG_CORE
>  	help
>  	  Support for the watchdog timer on the following Broadcom BCM281xx

Patch has been added to linux-watchdog-next.

Kind regards,
Wim.

