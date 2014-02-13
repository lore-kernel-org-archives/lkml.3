Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBMXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:01:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33928 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaBMXBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:01:06 -0500
Message-ID: <52FD4EA4.2060402@samsung.com>
Date: Fri, 14 Feb 2014 08:00:52 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: s3c24xx: get rid of unneeded selects
References: <1391957465.25424.14.camel@x220>
In-Reply-To: <1391957465.25424.14.camel@x220>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/14 23:51, Paul Bolle wrote:
> Commit c67d0f29262b ("ARM: s3c24xx: get rid of custom<mach/gpio.h>")
> got rid of the Kconfig symbols S3C24XX_GPIO_EXTRA64 and
> S3C24XX_GPIO_EXTRA128. It missed one select of both of these symbols, so
> get rid of those now.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> Untested.
>
>   arch/arm/mach-s3c24xx/Kconfig | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index d876431..bb1fa603 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -521,7 +521,6 @@ config MACH_ANUBIS
>   	select HAVE_PATA_PLATFORM
>   	select S3C2440_XTAL_12000000
>   	select S3C24XX_DCLK
> -	select S3C24XX_GPIO_EXTRA64
>   	select S3C24XX_SIMTEC_PM if PM
>   	select S3C_DEV_USB_HOST
>   	help
> @@ -562,7 +561,6 @@ config MACH_OSIRIS
>   	select S3C2410_IOTIMING if ARM_S3C2440_CPUFREQ
>   	select S3C2440_XTAL_12000000
>   	select S3C24XX_DCLK
> -	select S3C24XX_GPIO_EXTRA128
>   	select S3C24XX_SIMTEC_PM if PM
>   	select S3C_DEV_NAND
>   	select S3C_DEV_USB_HOST

Applied, thanks.

- Kukjin
