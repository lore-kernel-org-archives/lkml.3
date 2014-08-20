Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaHTPVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:21:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48503 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaHTPVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:21:02 -0400
Message-ID: <53F4BCBF.1030204@ti.com>
Date: Wed, 20 Aug 2014 20:50:31 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ARM: dts: remove old USB2 PHY node for Exynos5250
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com> <1408026327-31437-3-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1408026327-31437-3-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 14 August 2014 07:55 PM, Bartlomiej Zolnierkiewicz wrote:
> drivers/usb/phy/phy-samsung-usb2 driver got replaced by
> drivers/phy/phy-samsung-usb2 one.  Remove the leftover
> USB2 PHY node (EHCI/OHCI USB nodes are using the new one
> already) from Exynos5250 dtsi file.
> 
> Cc: Mark Brown <broonie@linaro.org>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Vivek Gautam <gautam.vivek@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi | 15 ---------------
>  1 file changed, 15 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 492e1ef..f21b9aa 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -603,21 +603,6 @@
>  		};
>  	};
>  
> -	usb2_phy: usbphy@12130000 {
> -		compatible = "samsung,exynos5250-usb2phy";
> -		reg = <0x12130000 0x100>;
> -		clocks = <&clock CLK_FIN_PLL>, <&clock CLK_USB2>;
> -		clock-names = "ext_xtal", "usbhost";
> -		#address-cells = <1>;
> -		#size-cells = <1>;
> -		ranges;
> -
> -		usbphy-sys {
> -			reg = <0x10040704 0x8>,
> -			      <0x10050230 0x4>;
> -		};
> -	};
> -
>  	usb2_phy_gen: phy@12130000 {
>  		compatible = "samsung,exynos5250-usb2-phy";
>  		reg = <0x12130000 0x100>;
> 
