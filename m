Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632Ab3LIVTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:19:48 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54444 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761564Ab3LIVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:19:45 -0500
Message-ID: <52A633EB.4070503@samsung.com>
Date: Tue, 10 Dec 2013 06:19:39 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: SAMSUNG: remove unused SAMSUNG_GPIOLIB_4BIT Kconfig
 parameter
References: <000001ced94433863209a92960$%han@samsung.com> <1386563907-18808-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1386563907-18808-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 13:38, Michael Opdenacker wrote:
> This removes the SAMSUNG_GPIOLIB_4BIT Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker<michael.opdenacker@free-electrons.com>
> Reviewed-by: Jingoo Han<jg1.han@samsung.com>
> ---
>   arch/arm/Kconfig              | 1 -
>   arch/arm/plat-samsung/Kconfig | 8 --------
>   2 files changed, 9 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c1f1a7eee953..5e227a371401 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -740,7 +740,6 @@ config ARCH_S3C64XX
>   	select S3C_DEV_NAND
>   	select S3C_GPIO_TRACK
>   	select SAMSUNG_ATAGS
> -	select SAMSUNG_GPIOLIB_4BIT
>   	select SAMSUNG_WAKEMASK
>   	select SAMSUNG_WDT_RESET
>   	select USB_ARCH_HAS_OHCI
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index 6d95d60276d6..58645a58d0d8 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -24,7 +24,6 @@ config PLAT_S5P
>   	select S3C_GPIO_TRACK
>   	select S5P_GPIO_DRVSTR
>   	select SAMSUNG_CLKSRC if !COMMON_CLK
> -	select SAMSUNG_GPIOLIB_4BIT
>   	help
>   	  Base platform code for Samsung's S5P series SoC.
>
> @@ -115,13 +114,6 @@ config S5P_GPIO_INT
>
>   # options for gpio configuration support
>
> -config SAMSUNG_GPIOLIB_4BIT
> -	bool
> -	help
> -	  GPIOlib file contains the 4 bit modification functions for gpio
> -	  configuration. GPIOlib shall be compiled only for S3C64XX and S5P
> -	  series of processors.
> -
>   config S5P_GPIO_DRVSTR
>   	bool
>   	help

OK, applied.

Thanks
Kukjin
