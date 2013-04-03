Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878Ab3DCKf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:35:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32989 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762611Ab3DCKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:35:25 -0400
Date: Wed, 3 Apr 2013 12:35:14 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 8/8] ARM: dts: add pinctrl property for spi node for
 atmel SoC
Message-ID: <20130403103512.GB4633@lnx-rg>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364969032-24281-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364969032-24281-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [mer., 03.04.2013 14:03:52], Wenyou Yang wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: linux@arm.linux.org.uk
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/at91sam9260.dtsi |   22 ++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9263.dtsi |   22 ++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9g45.dtsi |   22 ++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9n12.dtsi |   22 ++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9x5.dtsi  |   22 ++++++++++++++++++++++
>  5 files changed, 110 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
> index 6e31dc8..39253b9 100644
> --- a/arch/arm/boot/dts/at91sam9260.dtsi
> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
> @@ -322,6 +322,24 @@
>  					};
>  				};
>  
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<0 0 0x1 0x0	/* PA0 periph A SPI0_MISO pin */
> +							 0 1 0x1 0x0	/* PA1 periph A SPI0_MOSI pin */
> +							 0 2 0x1 0x0>;	/* PA2 periph A SPI0_SPCK pin */
> +					};
> +				};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<1 0 0x1 0x0	/* PB0 periph A SPI1_MISO pin */
> +							 1 1 0x1 0x0	/* PB1 periph A SPI1_MOSI pin */
> +							 1 2 0x1 0x0>;	/* PB2 periph A SPI1_SPCK pin */
> +					};
> +				};
> +
>  				pioA: gpio@fffff400 {
>  					compatible = "atmel,at91rm9200-gpio";
>  					reg = <0xfffff400 0x200>;
> @@ -477,6 +495,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffc8000 0x200>;
>  				interrupts = <12 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
>  			};
>  
> @@ -486,6 +506,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffcc000 0x200>;
>  				interrupts = <13 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
>  			};
>  
> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
> index 6c6d9ae..94b58ab 100644
> --- a/arch/arm/boot/dts/at91sam9263.dtsi
> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
> @@ -303,6 +303,24 @@
>  					};
>  				};
>  
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<0 0 0x2 0x0	/* PA0 periph B SPI0_MISO pin */
> +							 0 1 0x2 0x0	/* PA1 periph B SPI0_MOSI pin */
> +							 0 2 0x2 0x0>;	/* PA2 periph B SPI0_SPCK pin */
> +					};
> +				};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<1 12 0x1 0x0	/* PB12 periph A SPI1_MISO pin */
> +							 1 13 0x1 0x0	/* PB13 periph A SPI1_MOSI pin */
> +							 1 14 0x1 0x0>;	/* PB14 periph A SPI1_SPCK pin */
> +					};
> +				};
> +
>  				pioA: gpio@fffff200 {
>  					compatible = "atmel,at91rm9200-gpio";
>  					reg = <0xfffff200 0x200>;
> @@ -469,6 +487,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffa4000 0x200>;
>  				interrupts = <14 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
>  			};
>  
> @@ -478,6 +498,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffa8000 0x200>;
>  				interrupts = <15 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
> index e085b8a..cfdf429 100644
> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
> @@ -322,6 +322,24 @@
>  					};
>  				};
>  
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<1 0 0x1 0x0	/* PB0 periph A SPI0_MISO pin */
> +							 1 1 0x1 0x0	/* PB1 periph A SPI0_MOSI pin */
> +							 1 2 0x1 0x0>;	/* PB2 periph A SPI0_SPCK pin */
> +					};
> +				};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<1 14 0x1 0x0	/* PB14 periph A SPI1_MISO pin */
> +							 1 15 0x1 0x0	/* PB15 periph A SPI1_MOSI pin */
> +							 1 16 0x1 0x0>;	/* PB16 periph A SPI1_SPCK pin */
> +					};
> +				};
> +
>  				pioA: gpio@fffff200 {
>  					compatible = "atmel,at91rm9200-gpio";
>  					reg = <0xfffff200 0x200>;
> @@ -538,6 +556,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffa4000 0x200>;
>  				interrupts = <14 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
>  			};
>  
> @@ -547,6 +567,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xfffa8000 0x200>;
>  				interrupts = <15 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> index f3f87ef3..b2961f1 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -261,6 +261,24 @@
>  					};
>  				};
>  
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO pin */
> +							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI pin */
> +							 0 13 0x1 0x0>;	/* PA13 periph A SPI0_SPCK pin */
> +					};
> +				};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO pin */
> +							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI pin */
> +							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
> +					};
> +				};
> +
>  				pioA: gpio@fffff400 {
>  					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
>  					reg = <0xfffff400 0x200>;
> @@ -380,6 +398,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xf0000000 0x100>;
>  				interrupts = <13 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
>  			};
>  
> @@ -389,6 +409,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xf0004000 0x100>;
>  				interrupts = <14 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index 77ce2e1..347b438 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -343,6 +343,24 @@
>  					};
>  				};
>  
> +				spi0 {
> +					pinctrl_spi0: spi0-0 {
> +						atmel,pins =
> +							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO pin */
> +							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI pin */
> +							 0 13 0x1 0x0>;	/* PA13 periph A SPI0_SPCK pin */
> +					};
> +				};
> +
> +				spi1 {
> +					pinctrl_spi1: spi1-0 {
> +						atmel,pins =
> +							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO pin */
> +							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI pin */
> +							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
> +					};
> +				};
> +
>  				pioA: gpio@fffff400 {
>  					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
>  					reg = <0xfffff400 0x200>;
> @@ -536,6 +554,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xf0000000 0x100>;
>  				interrupts = <13 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi0>;
>  				status = "disabled";
>  			};
>  
> @@ -545,6 +565,8 @@
>  				compatible = "atmel,at91rm9200-spi";
>  				reg = <0xf0004000 0x100>;
>  				interrupts = <14 4 3>;
> +				pinctrl-names = "default";
> +				pinctrl-0 = <&pinctrl_spi1>;
>  				status = "disabled";
>  			};
>  		};
> -- 
> 1.7.9.5
> 
On sam9g35 with DMA and PIO (3.9-rc5 + device tree patches)
Tested-by: Richard Genoud <richard.genoud@gmail.com>
