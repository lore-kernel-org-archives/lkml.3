Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3KGNYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:24:09 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:48970 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KGNYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:24:06 -0500
MIME-Version: 1.0
In-Reply-To: <1383830523-1767-1-git-send-email-ch.naveen@samsung.com>
References: <1383830523-1767-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 7 Nov 2013 18:53:44 +0530
Message-ID: <CAHfPSqBpPoLqF+8+qjtL_zRA2+tdeqt=+zA+VfTOcvv2kq+5bg@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Exynos5420: Add device nodes for HSI2C blocks
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2013 18:52, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> Exynos5420 SoC has 7 High speed I2C channels, This patch adds
> the device tree nodes to the DT device list.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |   98 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 6ffefd1..12f612d 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -34,6 +34,13 @@
>                 i2c1 = &i2c_1;
>                 i2c2 = &i2c_2;
>                 i2c3 = &i2c_3;
> +               i2c4 = &hsi2c_4;
> +               i2c5 = &hsi2c_5;
> +               i2c6 = &hsi2c_6;
> +               i2c7 = &hsi2c_7;
> +               i2c8 = &hsi2c_8;
> +               i2c9 = &hsi2c_9;
> +               i2c10 = &hsi2c_10;
>                 gsc0 = &gsc_0;
>                 gsc1 = &gsc_1;
>         };
> @@ -333,6 +340,97 @@
>                 status = "disabled";
>         };
>
> +       hsi2c_4: hsi2c@12CA0000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12CA0000 0x1000>;
> +               interrupts = <0 60 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c4_hs_bus>;
> +               clocks = <&clock 265>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_5: hsi2c@12CB0000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12CB0000 0x1000>;
> +               interrupts = <0 61 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c5_hs_bus>;
> +               clocks = <&clock 266>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_6: hsi2c@12CC0000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12CC0000 0x1000>;
> +               interrupts = <0 62 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c6_hs_bus>;
> +               clocks = <&clock 267>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_7: hsi2c@12CD0000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12CD0000 0x1000>;
> +               interrupts = <0 63 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c7_hs_bus>;
> +               clocks = <&clock 268>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_8: hsi2c@12E00000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12E00000 0x1000>;
> +               interrupts = <0 87 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c8_hs_bus>;
> +               clocks = <&clock 281>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_9: hsi2c@12E10000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12E10000 0x1000>;
> +               interrupts = <0 88 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c9_hs_bus>;
> +               clocks = <&clock 282>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
> +       hsi2c_10: hsi2c@12E20000 {
> +               compatible = "samsung,exynos5-hsi2c";
> +               reg = <0x12E20000 0x1000>;
> +               interrupts = <0 203 0>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&i2c10_hs_bus>;
> +               clocks = <&clock 283>;
> +               clock-names = "hsi2c";
> +               status = "disabled";
> +       };
> +
>         hdmi@14530000 {
>                 compatible = "samsung,exynos4212-hdmi";
>                 reg = <0x14530000 0x70000>;
> --
> 1.7.10.4
>
Just found that Sachin Kamat already tried to post a similar patch.
http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/24581

I was actually waiting for the High speed I2C driver to get merged
before adding the device tree nodes.

The High speed I2C driver was accepted only a couple of days ago.

-- 
Shine bright,
(: Nav :)
