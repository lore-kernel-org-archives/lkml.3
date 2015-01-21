Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbbAUQXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:23:00 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:41357 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbAUQWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:22:50 -0500
Date: Wed, 21 Jan 2015 16:22:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com
Cc: kernel@stlinux.com, broonie@kernel.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ARM: sti: Provide DT nodes for SSC[0..4]
Message-ID: <20150121162243.GG22024@x1>
References: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
 <1417534844-25080-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417534844-25080-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime,

Can you ping these up please?

> The Synchronous Serial Controller is used to provide SPI.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/stih407.dtsi | 54 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
> index 50637f5..90bc090 100644
> --- a/arch/arm/boot/dts/stih407.dtsi
> +++ b/arch/arm/boot/dts/stih407.dtsi
> @@ -275,5 +275,59 @@
>  
>  			status = "disabled";
>  		};
> +
> +		spi@9840000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9840000 0x110>;
> +			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
> +			clock-names = "ssc";
> +			pinctrl-0 = <&pinctrl_spi0_default>;
> +			pinctrl-names = "default";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9841000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9841000 0x110>;
> +			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9842000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9842000 0x110>;
> +			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9843000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9843000 0x110>;
> +			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9844000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9844000 0x110>;
> +			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
