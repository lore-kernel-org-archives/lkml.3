Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBMBf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:35:57 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34206 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaBMBf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:35:56 -0500
Message-ID: <52F999A1.1070709@samsung.com>
Date: Tue, 11 Feb 2014 12:31:45 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/28] Remove S3C24XX_GPIO_EXTRA128
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-23-git-send-email-richard@nod.at>
In-Reply-To: <1391971686-9517-23-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 03:48, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   arch/arm/mach-s3c24xx/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 1c67f04..bb1fa603 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -561,7 +561,6 @@ config MACH_OSIRIS
>   	select S3C2410_IOTIMING if ARM_S3C2440_CPUFREQ
>   	select S3C2440_XTAL_12000000
>   	select S3C24XX_DCLK
> -	select S3C24XX_GPIO_EXTRA128
>   	select S3C24XX_SIMTEC_PM if PM
>   	select S3C_DEV_NAND
>   	select S3C_DEV_USB_HOST

OK good, but I will squash this with 13th for mach-s3c24xx/Kconfig when 
I apply.

Thanks,
Kukjin
