Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaDRUsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:48:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25228 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaDRUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:47:59 -0400
Message-ID: <53518F77.6020609@atmel.com>
Date: Fri, 18 Apr 2014 22:47:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] ARM: at91: sama5d3: add DMA property for SSC devices
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/2014 10:45, Bo Shen :
> Add DMA property for SSC devices on SAMA5D3 SoC.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
>  arch/arm/boot/dts/sama5d3.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 3d5faf8..3e753e1 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -113,6 +113,9 @@
>  				compatible = "atmel,at91sam9g45-ssc";
>  				reg = <0xf0008000 0x4000>;
>  				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
> +				dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(13)>,
> +				       <&dma0 2 AT91_DMA_CFG_PER_ID(14)>;
> +				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
>  				clocks = <&ssc0_clk>;
> @@ -231,6 +234,9 @@
>  				compatible = "atmel,at91sam9g45-ssc";
>  				reg = <0xf800c000 0x4000>;
>  				interrupts = <39 IRQ_TYPE_LEVEL_HIGH 4>;
> +				dmas = <&dma1 2 AT91_DMA_CFG_PER_ID(3)>,
> +				       <&dma1 2 AT91_DMA_CFG_PER_ID(4)>;
> +				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
>  				clocks = <&ssc1_clk>;
> 


-- 
Nicolas Ferre
