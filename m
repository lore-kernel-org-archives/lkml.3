Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaHVRcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:32:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:32:53 -0400
Message-ID: <53F77EC1.6080604@suse.de>
Date: Fri, 22 Aug 2014 19:32:49 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ARM: dts: remove old USB2 PHY node hook for Arndale
References: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com> <1408726745-31135-2-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1408726745-31135-2-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.08.2014 18:59, schrieb Bartlomiej Zolnierkiewicz:
> drivers/usb/phy/phy-samsung-usb2 driver got replaced by
> drivers/phy/phy-samsung-usb2 one.  Remove the leftover hook
> from Arndale dts file.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Mark Brown <broonie@linaro.org>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250-arndale.dts | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
> index d0de1f5..dad8f9b 100644
> --- a/arch/arm/boot/dts/exynos5250-arndale.dts
> +++ b/arch/arm/boot/dts/exynos5250-arndale.dts
> @@ -570,8 +570,4 @@
>  			connect-gpios = <&gpd1 7 1>;
>  		};
>  	};
> -
> -	usb@12110000 {
> -		usb-phy = <&usb2_phy>;
> -	};
>  };

This will trivially conflict with my exynos5250 cleanups in the Spring
series: &ehci {...} there.

https://patchwork.kernel.org/patch/4664751/

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
