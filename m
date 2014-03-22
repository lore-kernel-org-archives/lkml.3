Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaCVGsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:48:13 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35876 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbaCVGsK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:48:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh2a8h839h947hd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Date: Sat, 22 Mar 2014 14:47:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: dts: tx53: remove redundant regulator-boot-on
Message-ID: <20140322064747.GD5938@dragon>
References: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1395235721-13847-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 02:28:37PM +0100, Lothar Waﬂmann wrote:
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Please add something in the commit log, e.g. why regulator-boot-on is
redundant in this case.

Shawn

> ---
>  arch/arm/boot/dts/imx53-tx53-x13x.dts |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx53-tx53-x13x.dts b/arch/arm/boot/dts/imx53-tx53-x13x.dts
> index 6480471..c8a3473 100644
> --- a/arch/arm/boot/dts/imx53-tx53-x13x.dts
> +++ b/arch/arm/boot/dts/imx53-tx53-x13x.dts
> @@ -72,7 +72,6 @@
>  			regulator-max-microvolt = <3300000>;
>  			gpio = <&gpio3 29 GPIO_ACTIVE_HIGH>;
>  			enable-active-high;
> -			regulator-boot-on;
>  		};
>  
>  		reg_lcd_pwr1: regulator@6 {
> @@ -83,7 +82,6 @@
>  			regulator-max-microvolt = <3300000>;
>  			gpio = <&gpio2 31 GPIO_ACTIVE_HIGH>;
>  			enable-active-high;
> -			regulator-boot-on;
>  		};
>  	};
>  };
> -- 
> 1.7.10.4
> 
> 
> 

