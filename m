Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaAOF5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:57:09 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:58902
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbaAOF5G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:57:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 15 Jan 2014 13:58:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: =?iso-8859-1?Q?S=E9bastien?= Szymanski 
	<sebastien.szymanski@armadeus.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Julien Boibessot <julien.boibessot@armadeus.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ARM: dts: imx28-apf28dev: add user button
Message-ID: <20140115055830.GF1896@S2101-09.ap.freescale.net>
References: <1389709287-25742-1-git-send-email-sebastien.szymanski@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1389709287-25742-1-git-send-email-sebastien.szymanski@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 03:21:27PM +0100, Sébastien Szymanski wrote:
> Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
> ---
>  arch/arm/boot/dts/imx28-apf28dev.dts | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Applied, thanks.

Shawn

> 
> diff --git a/arch/arm/boot/dts/imx28-apf28dev.dts b/arch/arm/boot/dts/imx28-apf28dev.dts
> index 334dea5..221cac4 100644
> --- a/arch/arm/boot/dts/imx28-apf28dev.dts
> +++ b/arch/arm/boot/dts/imx28-apf28dev.dts
> @@ -48,6 +48,7 @@
>  						MX28_PAD_LCD_D20__GPIO_1_20
>  						MX28_PAD_LCD_D21__GPIO_1_21
>  						MX28_PAD_LCD_D22__GPIO_1_22
> +						MX28_PAD_GPMI_CE1N__GPIO_0_17
>  					>;
>  					fsl,drive-strength = <MXS_DRIVE_4mA>;
>  					fsl,voltage = <MXS_VOLTAGE_HIGH>;
> @@ -193,4 +194,14 @@
>  		brightness-levels = <0 4 8 16 32 64 128 255>;
>  		default-brightness-level = <6>;
>  	};
> +
> +	gpio-keys {
> +		compatible = "gpio-keys";
> +
> +		user-button {
> +			label = "User button";
> +			gpios = <&gpio0 17 0>;
> +			linux,code = <0x100>;
> +		};
> +	};
>  };
> -- 
> 1.8.3.2
> 

