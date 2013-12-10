Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab3LJH2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:28:36 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34276 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3LJH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <1386373528-13045-2-git-send-email-tim.kryger@linaro.org>
References: <1386373528-13045-1-git-send-email-tim.kryger@linaro.org>
	<1386373528-13045-2-git-send-email-tim.kryger@linaro.org>
Date: Mon, 9 Dec 2013 23:28:31 -0800
Message-ID: <CAEPRUYpbHUsxOkG-VuVwVv7kakBJNnwTa-8+DNMbQ-xZNpPFnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: bcm281xx: Add i2c busses
From: Christian Daudt <bcm@fixthebug.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 3:45 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> Add the DTS nodes for all the i2c busses in the SoC.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  arch/arm/boot/dts/bcm11351.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index 1246885..4bfd7e3 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -146,6 +146,46 @@
>                 status = "disabled";
>         };
>
> +       i2c@3e016000 {
> +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> +               reg = <0x3e016000 0x80>;
> +               interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               clocks = <&bsc1_clk>;
> +               status = "disabled";
> +       };
> +
> +       i2c@3e017000 {
> +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> +               reg = <0x3e017000 0x80>;
> +               interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               clocks = <&bsc2_clk>;
> +               status = "disabled";
> +       };
> +
> +       i2c@3e018000 {
> +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> +               reg = <0x3e018000 0x80>;
> +               interrupts = <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               clocks = <&bsc3_clk>;
> +               status = "disabled";
> +       };
> +
> +       i2c@3500d000 {
> +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> +               reg = <0x3500d000 0x80>;
> +               interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               clocks = <&pmu_bsc_clk>;
> +               status = "disabled";
> +       };
> +
>         clocks {
>                 bsc1_clk: bsc1 {
>                         compatible = "fixed-clock";
> --
> 1.8.0.1
>
Applied to armsoc/for-3.14/dt
 thanks,
  csd
