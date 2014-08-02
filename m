Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaHBNCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:02:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35379 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaHBNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:02:07 -0400
Message-ID: <53DCE14A.3020108@gmail.com>
Date: Sat, 02 Aug 2014 15:02:02 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/10] ARM: dts: Clean up exynos5250-arndale
References: <1406940750-15880-1-git-send-email-afaerber@suse.de> <1406940750-15880-8-git-send-email-afaerber@suse.de>
In-Reply-To: <1406940750-15880-8-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.2014 02:52, Andreas Färber wrote:
> Use the new style of referencing inherited nodes, use symbolic names,
> tidy indentation and reorder includes.
> 
> Goal is the alignment of all exynos5250 based device trees for comparison.
> 
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v5 -> v6:
>  * Updated for mfc node label
>  
>  v5: New
>  Aligns with SMDK.
> 
>  arch/arm/boot/dts/exynos5250-arndale.dts | 929 ++++++++++++++++---------------
>  1 file changed, 466 insertions(+), 463 deletions(-)
> 

Diff in resulting dtb:

> --- exynos5250-arndale.dtb.dts	2014-08-02 14:54:15.102905920 +0200
> +++ ../dtbs.post/exynos5250-arndale.dtb.dts	2014-08-02 14:54:15.104905920 +0200
> @@ -1977,7 +1977,7 @@
>  		clocks = <0x2 0x158 0x2 0x88 0x2 0x89 0x2 0x9f 0x2 0x400>;
>  		clock-names = "hdmi", "sclk_hdmi", "sclk_pixel", "sclk_hdmiphy", "mout_hdmi";
>  		samsung,syscon-phandle = <0x7>;
> -		hpd-gpio = <0xc 0x7 0x2>;
> +		hpd-gpio = <0xc 0x7 0x1>;
>  		vdd_osc-supply = <0x31>;
>  		vdd_pll-supply = <0x32>;
>  		vdd-supply = <0x32>;
> @@ -2104,15 +2104,9 @@
>  		};
>  	};
>  
> -	usb_hub_bus {
> -		compatible = "simple-bus";
> -		#address-cells = <0x1>;
> -		#size-cells = <0x0>;
> -
> -		usb_hub {
> -			compatible = "smsc,usb3503a";
> -			reset-gpios = <0xc 0x5 0x1>;
> -			connect-gpios = <0x10 0x7 0x1>;
> -		};
> +	usb-hub {
> +		compatible = "smsc,usb3503a";
> +		reset-gpios = <0xc 0x5 0x1>;
> +		connect-gpios = <0x10 0x7 0x1>;
>  	};
>  };

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
