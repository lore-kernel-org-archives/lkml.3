Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab3GVTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:25:43 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:54517 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3GVTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:25:41 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 07/22] ARM: exynos: Remove '0x's from Exynos4110 DTSI file
Date: Mon, 22 Jul 2013 21:25:35 +0200
Message-ID: <2350088.9z671SCjFz@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org> <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Monday 22 of July 2013 11:52:26 Lee Jones wrote:
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/exynos4210.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -72,7 +72,7 @@
>  		};
>  	};
> 
> -	clock: clock-controller@0x10030000 {
> +	clock: clock-controller@10030000 {
>  		compatible = "samsung,exynos4210-clock";
>  		reg = <0x10030000 0x20000>;
>  		#clock-cells = <1>;

This looks fine, but please fix commit message - it should be Exynos4210. 
Also some explanation why this change is needed would be good, even if 
it's obvious.

Best regards,
Tomasz

