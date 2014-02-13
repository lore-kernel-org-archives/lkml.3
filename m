Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBMXkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:40:47 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56835 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaBMXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:40:44 -0500
Message-ID: <52FD57F2.8@samsung.com>
Date: Fri, 14 Feb 2014 08:40:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        kgene.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
        w.sang@pengutronix.de, balbi@ti.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, taeggyun.ko@samsung.com, cpgs@samsung.com,
        naveenkrishna.ch@gmail.com, t.figa@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: DTS: exynos5420: Rename hsi2c compatible to exynos5250-hsi2c
References: <1391688477-8124-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1391688477-8124-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/14 21:07, Naveen Krishna Chatradhi wrote:
> As per the changes submitted for the i2c-exynos5.c driver with the
> compatible string being named after the first SoC it is observed on.
> This patch modifes the existing hsi2c compatible strings in
> arch/arm/boot/dts.
>
> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> ---
>   arch/arm/boot/dts/exynos5420.dtsi |   14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 11dd202..c5187d1 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -486,7 +486,7 @@
>   	};
>
>   	hsi2c_4: i2c@12CA0000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12CA0000 0x1000>;
>   		interrupts =<0 60 0>;
>   		#address-cells =<1>;
> @@ -499,7 +499,7 @@
>   	};
>
>   	hsi2c_5: i2c@12CB0000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12CB0000 0x1000>;
>   		interrupts =<0 61 0>;
>   		#address-cells =<1>;
> @@ -512,7 +512,7 @@
>   	};
>
>   	hsi2c_6: i2c@12CC0000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12CC0000 0x1000>;
>   		interrupts =<0 62 0>;
>   		#address-cells =<1>;
> @@ -525,7 +525,7 @@
>   	};
>
>   	hsi2c_7: i2c@12CD0000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12CD0000 0x1000>;
>   		interrupts =<0 63 0>;
>   		#address-cells =<1>;
> @@ -538,7 +538,7 @@
>   	};
>
>   	hsi2c_8: i2c@12E00000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12E00000 0x1000>;
>   		interrupts =<0 87 0>;
>   		#address-cells =<1>;
> @@ -551,7 +551,7 @@
>   	};
>
>   	hsi2c_9: i2c@12E10000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12E10000 0x1000>;
>   		interrupts =<0 88 0>;
>   		#address-cells =<1>;
> @@ -564,7 +564,7 @@
>   	};
>
>   	hsi2c_10: i2c@12E20000 {
> -		compatible = "samsung,exynos5-hsi2c";
> +		compatible = "samsung,exynos5250-hsi2c";
>   		reg =<0x12E20000 0x1000>;
>   		interrupts =<0 203 0>;
>   		#address-cells =<1>;

Naveen,

Please don't post separately for one series. It's hard to find to look 
at regarding patches.

And please post regarding binding doc together. Additionally if you run 
checkpatch, you can see see below complaining.

"WARNING: DT compatible string "samsung,exynos5250-hsi2c" appears 
un-documented -- check ./Documentation/devicetree/bindings/"

- Kukjin
