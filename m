Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaDWHFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:05:19 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:54304 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbaDWHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:05:16 -0400
Message-ID: <535765D7.5070007@st.com>
Date: Wed, 23 Apr 2014 09:03:51 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Cc: <kernel@stlinux.com>, Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        <linux-kernel@vger.kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [STLinux Kernel] [PATCH 3/4] ARM: dts: Typo s/interrupts-names/interrupt-names/g
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be> <1398192025-31523-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1398192025-31523-3-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-23_03:2014-04-22,2014-04-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by : Patrice Chotard <patrice.chotard@st.com>

Thanks

On 04/22/2014 08:40 PM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Cc: linux-omap@vger.kernel.org
> Cc: kernel@stlinux.com
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>   arch/arm/boot/dts/am33xx.dtsi          |    4 ++--
>   arch/arm/boot/dts/am4372.dtsi          |    4 ++--
>   arch/arm/boot/dts/stih415-pinctrl.dtsi |   10 +++++-----
>   arch/arm/boot/dts/stih416-pinctrl.dtsi |   10 +++++-----
>   4 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 07f283c20eb1..cb6811e5ae5a 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -802,7 +802,7 @@
>   			      <0x46000000 0x400000>;
>   			reg-names = "mpu", "dat";
>   			interrupts = <80>, <81>;
> -			interrupts-names = "tx", "rx";
> +			interrupt-names = "tx", "rx";
>   			status = "disabled";
>   			dmas = <&edma 8>,
>   				<&edma 9>;
> @@ -816,7 +816,7 @@
>   			      <0x46400000 0x400000>;
>   			reg-names = "mpu", "dat";
>   			interrupts = <82>, <83>;
> -			interrupts-names = "tx", "rx";
> +			interrupt-names = "tx", "rx";
>   			status = "disabled";
>   			dmas = <&edma 10>,
>   				<&edma 11>;
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 36d523a26831..d1f8707ff1df 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -691,7 +691,7 @@
>   			      <0x46000000 0x400000>;
>   			reg-names = "mpu", "dat";
>   			interrupts = <80>, <81>;
> -			interrupts-names = "tx", "rx";
> +			interrupt-names = "tx", "rx";
>   			status = "disabled";
>   			dmas = <&edma 8>,
>   			       <&edma 9>;
> @@ -705,7 +705,7 @@
>   			      <0x46400000 0x400000>;
>   			reg-names = "mpu", "dat";
>   			interrupts = <82>, <83>;
> -			interrupts-names = "tx", "rx";
> +			interrupt-names = "tx", "rx";
>   			status = "disabled";
>   			dmas = <&edma 10>,
>   			       <&edma 11>;
> diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
> index f09fb10a3791..81df870e5ee6 100644
> --- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
> @@ -49,7 +49,7 @@
>   			reg 		= <0xfe61f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges 		= <0 0xfe610000 0x5000>;
>   
>   			PIO0: gpio@fe610000 {
> @@ -187,7 +187,7 @@
>   			reg 		= <0xfee0f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 181 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfee00000 0x8000>;
>   
>   			PIO5: gpio@fee00000 {
> @@ -282,7 +282,7 @@
>   			reg 		= <0xfe82f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfe820000 0x8000>;
>   
>   			PIO13: gpio@fe820000 {
> @@ -423,7 +423,7 @@
>   			reg 		= <0xfd6bf080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfd6b0000 0x3000>;
>   
>   			PIO100: gpio@fd6b0000 {
> @@ -460,7 +460,7 @@
>   			reg 		= <0xfd33f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfd330000 0x5000>;
>   
>   			PIO103: gpio@fd330000 {
> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> index aeea304086eb..250d5ecc951e 100644
> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> @@ -53,7 +53,7 @@
>   			reg 		= <0xfe61f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 182 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfe610000 0x6000>;
>   
>   			PIO0: gpio@fe610000 {
> @@ -201,7 +201,7 @@
>   			reg 		= <0xfee0f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfee00000 0x10000>;
>   
>   			PIO5: gpio@fee00000 {
> @@ -333,7 +333,7 @@
>   			reg 		= <0xfe82f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges 		= <0 0xfe820000 0x6000>;
>   
>   			PIO13: gpio@fe820000 {
> @@ -461,7 +461,7 @@
>   			reg 		= <0xfd6bf080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges		= <0 0xfd6b0000 0x3000>;
>   
>   			PIO100: gpio@fd6b0000 {
> @@ -498,7 +498,7 @@
>   			reg 		= <0xfd33f080 0x4>;
>   			reg-names	= "irqmux";
>   			interrupts 	= <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
> -			interrupts-names = "irqmux";
> +			interrupt-names	= "irqmux";
>   			ranges			= <0 0xfd330000 0x5000>;
>   
>   			PIO103: gpio@fd330000 {

