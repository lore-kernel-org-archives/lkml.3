Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3BCNgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:36:18 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31376 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268Ab3BCNgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:36:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 3 Feb 2013 21:36:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Brian Lilly <brian@crystalfontz.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: mxs: dts: Add gpio-keys for the rotary to the
 CFA-10049
Message-ID: <20130203133620.GA24081@S2101-09.ap.freescale.net>
References: <1359626424-22546-1-git-send-email-maxime.ripard@free-electrons.com>
 <1359626424-22546-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359626424-22546-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:00:23AM +0100, Maxime Ripard wrote:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied both, thanks.

> ---
>  arch/arm/boot/dts/imx28-cfa10049.dts |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
> index cabc33a..5db3789 100644
> --- a/arch/arm/boot/dts/imx28-cfa10049.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10049.dts
> @@ -45,6 +45,7 @@
>  					reg = <0>;
>  					fsl,pinmux-ids = <
>  						0x2133 /* MX28_PAD_SSP2_D3__GPIO_2_19 */
> +						0x31a3 /* MX28_PAD_SAIF_SDATA0__GPIO_3_26 */
>  						0x31e3 /* MX28_PAD_LCD_RESET__GPIO_3_30 */
>  					>;
>  					fsl,drive-strength = <0>;
> @@ -276,6 +277,19 @@
>  		};
>  	};
>  
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		rotary_button {
> +			label = "rotary_button";
> +			gpios = <&gpio3 26 1>;
> +			debounce-interval = <10>;
> +			linux,code = <28>;
> +		};
> +	};
> +
>  	backlight {
>  		compatible = "pwm-backlight";
>  		pwms = <&pwm 3 5000000>;
> -- 
> 1.7.10.4
> 

