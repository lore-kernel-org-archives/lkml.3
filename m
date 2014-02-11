Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaBMBd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:33:27 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46274 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaBMBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:33:25 -0500
Message-ID: <52F99907.6010604@samsung.com>
Date: Tue, 11 Feb 2014 12:29:11 +0900
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
Subject: Re: [PATCH 13/28] Remove S3C24XX_GPIO_EXTRA64
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-14-git-send-email-richard@nod.at>
In-Reply-To: <1391971686-9517-14-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/14 03:47, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   arch/arm/mach-s3c24xx/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index d876431..1c67f04 100644
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

OK, I will take this into samsung tree.

Thanks,
Kukjin
