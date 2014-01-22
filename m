Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaAVT7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:59:48 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:53644 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753786AbaAVT7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:59:47 -0500
Date: Wed, 22 Jan 2014 20:59:40 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: naresh.bhat@linaro.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] watchdog: Add sp805_wdt depends on ARM64
Message-ID: <20140122195940.GW5647@spo001.leaseweb.com>
References: <1390394643-25443-1-git-send-email-naresh.bhat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390394643-25443-1-git-send-email-naresh.bhat@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naresh,

> From: Naresh Bhat <naresh.bhat@linaro.org>
> 
> Add sp805_wdt depends on ARM64.
> 
> Signed-off-by: Naresh Bhat <naresh.bhat@linaro.org>
> ---
>  drivers/watchdog/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 5be6e91..2385124 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -109,7 +109,7 @@ config WM8350_WATCHDOG
>  
>  config ARM_SP805_WATCHDOG
>  	tristate "ARM SP805 Watchdog"
> -	depends on ARM && ARM_AMBA
> +	depends on (ARM || ARM64) && ARM_AMBA
>  	select WATCHDOG_CORE
>  	help
>  	  ARM Primecell SP805 Watchdog timer. This will reboot your system when

Added to linux-watchdog-next.

Kind regards,
Wim.

