Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbAUCyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 21:54:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUCy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 21:54:29 -0500
X-AuditID: cbfee68e-f79b46d000002b74-0d-54bf14e2f1cc
Message-id: <54BF14FB.8050300@samsung.com>
Date: Wed, 21 Jan 2015 11:54:51 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Kevin Hilman <khilman@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: exynos5422-odroidxu3: add on-board INA231
 sensors
References: <1421284089-421-1-git-send-email-khilman@kernel.org>
In-reply-to: <1421284089-421-1-git-send-email-khilman@kernel.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWyRsSkQPeRyP4Qg0X91hbzj5xjteh/s5DV
	4tyrlYwWR38XWPQuuMpm0f/4NbPF082PmSzeH3rGbLHp8TVWi8u75rBZzDi/j8ni9mVei6XX
	LzJZTJi+lsWide8Rdovpx9+yOgh4rJm3htGjpbmHzeNyXy+Tx9/n11k8Vi7/wuaxaVUnm8fm
	JfUet/89Zvbo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujMd3+1gKdgtX3HgyhaWB8TZfFyMn
	h4SAicT1lbvYIGwxiQv31oPZQgJLGSVutHvA1Mw/vQEozgUUn84o0XvkEztE0WtGieUPHUFs
	XgEtid7t/8GaWQRUJVa+OcYMYrMJ6Enc2XacCcQWFQiTmHjzMStEvaDEj8n3WLoYOThEBPIk
	pk9mAZnPLHCaReL8t99gvcICoRLz//WxQOxykNh+ZCOYzSngKPFy2WZ2kF5moPn3L2qBhJkF
	5CU2r3nLDDJHQmAHh8TmQz9ZIO4RkPg2+RDYLgkBWYlNB5gh/pKUOLjiBssERrFZSC6ahTB1
	FpKpCxiZVzGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIExv3pf8/6djDePGB9iFGAg1GJh/fl
	qr0hQqyJZcWVuYcYTYGOmMgsJZqcD0wueSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MM7IrhWpuOhjIvE/cD77ossqvnNDGPyrZj9W8jzr/z46SmZ/
	0Ls5OZ68pr9EGZZqvzwv837yV07HlP3unCVWYqW3e5ky3K5u2TOp5V3Od8vKvXN7X2V9nPdG
	5N/3fnnOiBMuGnwKNXMWbeAXLp00a4tDe8bjVU8dwnlk2fZ1WZQt/yzgIf9qihJLcUaioRZz
	UXEiAM5obAD2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd1HIvtDDDqvGlrMP3KO1aL/zUJW
	i3OvVjJaHP1dYNG74CqbRf/j18wWTzc/ZrJ4f+gZs8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZe
	v8hkMWH6WhaL1r1H2C2mH3/L6iDgsWbeGkaPluYeNo/Lfb1MHn+fX2fxWLn8C5vHplWdbB6b
	l9R73P73mNmjb8sqRo/Pm+QCuKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgF5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGY8vtvHUrBbuOLGkyksDYy3+boYOTkkBEwk5p/ewAZhi0lcuLceyObiEBKYzijRe+QTO0hC
	SOA1o8Tyh44gNq+AlkTv9v9gDSwCqhIr3xxjBrHZBPQk7mw7zgRiiwqESUy8+ZgVol5Q4sfk
	eyxdjBwcIgJ5EtMns4DMZxY4zSJx/ttvsF5hgVCJ+f/6WCB2OUhsP7IRzOYUcJR4uWwzO0gv
	M9D8+xe1QMLMAvISm9e8ZZ7AKDALyYZZCFWzkFQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iRGcVp5J7WBc2WBxiFGAg1GJh9dh7d4QIdbEsuLK3EOMEhzMSiK8fR/2hQjxpiRWVqUW
	5ccXleakFh9iNAX6fyKzlGhyPjDl5ZXEGxqbmBlZGpkbWhgZmyuJ8yrZt4UICaQnlqRmp6YW
	pBbB9DFxcEo1MHooPYnk7138bcUjVhO+XXUPomeXBz94MktG2JT9+asHHVJ7VKJ6rkZ/uCzo
	sU9X8vLU/hThtSI/eHY/5d0bxxxtLjz7uUVXWblA/qsT3bdPH0wX6P7/U3rC7A/y+gs9r5zq
	PZEwbcc2/yLWu06yvze+fb6CY/X8qZvuuYlzPveuuvOihX37IhklluKMREMt5qLiRACTXv24
	QQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On 01/15/2015 10:08 AM, Kevin Hilman wrote:
> From: Kevin Hilman <khilman@linaro.org>
> 
> The odroid-xu3 has 4 INA231 current sensors on board which can be
> accessed from the Linux via the hwmon interface.
> 
> There is one sensor for each of these power rails:
> 
> - A15 cluster: VDD_ARM
> - A7 cluster: VDD_KFC
> - GPU: VDD_G3D
> - memory: VDD_MEM
> 
> In addition to adding the sensors, LDO26 from the PMIC needs to be
> enabled because it's powering these sensor.
> 
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
> v2: use "ti,ina231" as compatible string.
> 
> Applies on top of "ARM: dts: Add dts file for odroid XU3 board" from Sjoerd Simons.
> 
>  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 39 ++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> index c29123c0734d..50353d023225 100644
> --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
> @@ -174,6 +174,13 @@
>  					regulator-always-on;
>  				};
>  
> +				ldo26_reg: LDO26 {
> +					regulator-name = "vdd_ldo26";
> +					regulator-min-microvolt = <3000000>;
> +					regulator-max-microvolt = <3000000>;
> +					regulator-always-on;
> +				};
> +
>  				buck1_reg: BUCK1 {
>  					regulator-name = "vdd_mif";
>  					regulator-min-microvolt = <800000>;
> @@ -257,6 +264,38 @@
>  		};
>  	};
>  
> +	i2c_0: i2c@12C60000 {

It's ok but IMHO it can split using label reference, e.g. 

&i2c_0 {
	...
};

Thanks.

> +		status = "okay";
> +
> +		/* A15 cluster: VDD_ARM */
> +		ina231@40 {
> +			compatible = "ti,ina231";
> +			reg = <0x40>;
> +			shunt-resistor = <10000>;
> +		};
> +
> +		/* memory: VDD_MEM */
> +		ina231@41 {
> +			compatible = "ti,ina231";
> +			reg = <0x41>;
> +			shunt-resistor = <10000>;
> +		};
> +
> +		/* GPU: VDD_G3D */
> +		ina231@44 {
> +			compatible = "ti,ina231";
> +			reg = <0x44>;
> +			shunt-resistor = <10000>;
> +		};
> +
> +		/* A7 cluster: VDD_KFC */
> +		ina231@45 {
> +			compatible = "ti,ina231";
> +			reg = <0x45>;
> +			shunt-resistor = <10000>;
> +		};
> +	};
> +
>  	i2c_2: i2c@12C80000 {
>  		samsung,i2c-sda-delay = <100>;
>  		samsung,i2c-max-bus-freq = <66000>;
> 

