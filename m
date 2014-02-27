Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaB0AQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:16:30 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40083 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaB0AQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:16:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1393392247-6247-4-git-send-email-pankaj.dubey@samsung.com>
Cc: "Pankaj Dubey" <pankaj.dubey@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Ben Dooks" <ben-linux@fluff.org>
References: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
 <1393392247-6247-4-git-send-email-pankaj.dubey@samsung.com>
Message-ID: <20140227001620.12081.28601@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 3/3] ARM: S3C24XX: select COMMON_CLK_SAMSUNG for S3C24XX
Date: Wed, 26 Feb 2014 16:16:20 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pankaj Dubey (2014-02-25 21:24:07)
> CC: Ben Dooks <ben-linux@fluff.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-s3c24xx/Kconfig |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
> index 80373da..5cf82a1 100644
> --- a/arch/arm/mach-s3c24xx/Kconfig
> +++ b/arch/arm/mach-s3c24xx/Kconfig
> @@ -40,6 +40,7 @@ config CPU_S3C2410
>  config CPU_S3C2412
>         bool "SAMSUNG S3C2412"
>         select COMMON_CLK
> +       select COMMON_CLK_SAMSUNG

I guess this depends on Heiko's "[PATCH 00/12] ARM: S3C24XX: convert
s3c2410, s3c2440 s3c2442 to common clock framework" series?

Regards,
Mike

>         select CPU_ARM926T
>         select CPU_LLSERIAL_S3C2440
>         select S3C2412_COMMON_CLK
> @@ -51,6 +52,7 @@ config CPU_S3C2412
>  config CPU_S3C2416
>         bool "SAMSUNG S3C2416/S3C2450"
>         select COMMON_CLK
> +       select COMMON_CLK_SAMSUNG
>         select CPU_ARM926T
>         select CPU_LLSERIAL_S3C2440
>         select S3C2416_PM if PM
> @@ -89,6 +91,7 @@ config CPU_S3C244X
>  config CPU_S3C2443
>         bool "SAMSUNG S3C2443"
>         select COMMON_CLK
> +       select COMMON_CLK_SAMSUNG
>         select CPU_ARM920T
>         select CPU_LLSERIAL_S3C2440
>         select S3C2443_COMMON_CLK
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
