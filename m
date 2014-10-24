Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaJXWHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:07:44 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56239 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbaJXWHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:07:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru M Stan <amstan@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add SPI DMA into rk3288.dtsi
Date: Sat, 25 Oct 2014 00:10:16 +0200
Message-ID: <1433094.iLN0prRLzJ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414186926-25986-1-git-send-email-dianders@chromium.org>
References: <1414186926-25986-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 24. Oktober 2014, 14:42:06 schrieb Doug Anderson:
> Now that SPI DMA has been fixed on rk3288 we can enable it.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Alexandru M Stan <amstan@chromium.org>

applied into my v3.19-armsoc/dts branch

I've taken the liberty of changing the subject to
	ARM: dts: rockchip: Add SPI DMA into rk3288.dtsi


Heiko

> ---
>  arch/arm/boot/dts/rk3288.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 874e66d..e0b99f7 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -177,6 +177,8 @@
>  		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
>  		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
>  		clock-names = "spiclk", "apb_pclk";
> +		dmas = <&dmac_peri 11>, <&dmac_peri 12>;
> +		dma-names = "tx", "rx";
>  		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&spi0_clk &spi0_tx &spi0_rx &spi0_cs0>;
> @@ -190,6 +192,8 @@
>  		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
>  		clocks = <&cru SCLK_SPI1>, <&cru PCLK_SPI1>;
>  		clock-names = "spiclk", "apb_pclk";
> +		dmas = <&dmac_peri 13>, <&dmac_peri 14>;
> +		dma-names = "tx", "rx";
>  		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&spi1_clk &spi1_tx &spi1_rx &spi1_cs0>;
> @@ -203,6 +207,8 @@
>  		compatible = "rockchip,rk3288-spi", "rockchip,rk3066-spi";
>  		clocks = <&cru SCLK_SPI2>, <&cru PCLK_SPI2>;
>  		clock-names = "spiclk", "apb_pclk";
> +		dmas = <&dmac_peri 15>, <&dmac_peri 16>;
> +		dma-names = "tx", "rx";
>  		interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&spi2_clk &spi2_tx &spi2_rx &spi2_cs0>;

