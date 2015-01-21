Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbbAUQXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:23:25 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:52374 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAUQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:23:17 -0500
Date: Wed, 21 Jan 2015 16:23:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com
Cc: kernel@stlinux.com, broonie@kernel.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ARM: sti: Provide DT nodes for SBC SSC[0..2]
Message-ID: <20150121162309.GH22024@x1>
References: <1417534844-25080-1-git-send-email-lee.jones@linaro.org>
 <1417534844-25080-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417534844-25080-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime,

Can you ping these up please?

> The Synchronous Serial Controller is used to provide SPI.
> 
> These are the ports which are located on the Stand-By Controller (SBC).
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/stih407.dtsi | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
> index 90bc090..80e2407 100644
> --- a/arch/arm/boot/dts/stih407.dtsi
> +++ b/arch/arm/boot/dts/stih407.dtsi
> @@ -329,5 +329,36 @@
>  
>  			status = "disabled";
>  		};
> +
> +		/* SBC SSC */
> +		spi@9540000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9540000 0x110>;
> +			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_sysin>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9541000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9541000 0x110>;
> +			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_sysin>;
> +			clock-names = "ssc";
> +
> +			status = "disabled";
> +		};
> +
> +		spi@9542000 {
> +			compatible = "st,comms-ssc4-spi";
> +			reg = <0x9542000 0x110>;
> +			interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&clk_sysin>;
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
