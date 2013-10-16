Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540Ab3JPSdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:33:05 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45010 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761114Ab3JPSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:33:03 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: s3c64xx: Select CPU_V6K instead of CPU_V6
Date: Wed, 16 Oct 2013 20:32:53 +0200
Message-ID: <3346618.t8I6lVv536@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1380390554-4400-1-git-send-email-tomasz.figa@gmail.com>
References: <1380390554-4400-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

On Saturday 28 of September 2013 19:49:14 Tomasz Figa wrote:
> All S3C64XX SoCs come with ARM1176JZF-s core, which fully supports
> ARMv6K extensions. This patch lets the kernel use them on S3C6410 by
> adding selection of CPU_V6K to ARCH_S3C64XX.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  arch/arm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What do you think about this patch?

Best regards,
Tomasz

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index b766dad..3a41bbb 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -728,7 +728,7 @@ config ARCH_S3C64XX
>  	select CLKDEV_LOOKUP
>  	select CLKSRC_SAMSUNG_PWM
>  	select COMMON_CLK
> -	select CPU_V6
> +	select CPU_V6K
>  	select GENERIC_CLOCKEVENTS
>  	select GPIO_SAMSUNG
>  	select HAVE_CLK

