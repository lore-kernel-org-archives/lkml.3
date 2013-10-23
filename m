Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3JWH5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:57:35 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:35840
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab3JWHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 23 Oct 2013 15:39:21 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rostislav Lisovy <lisovy@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH 1/4] ARM: dts: i.MX53: Add alternate pinmux option for
 i2c_3
Message-ID: <20131023073918.GK2839@S2101-09.ap.freescale.net>
References: <1382461643-16790-1-git-send-email-lisovy@gmail.com>
 <1382461643-16790-2-git-send-email-lisovy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1382461643-16790-2-git-send-email-lisovy@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 07:07:20PM +0200, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> 

Applied #1 and #2, thanks.

Shawn

> diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> index 4307e80..55e83d1 100644
> --- a/arch/arm/boot/dts/imx53.dtsi
> +++ b/arch/arm/boot/dts/imx53.dtsi
> @@ -599,6 +599,13 @@
>  							MX53_PAD_GPIO_5__I2C3_SCL 0xc0000000
>  						>;
>  					};
> +
> +					pinctrl_i2c3_2: i2c3grp-2 {
> +						fsl,pins = <
> +							MX53_PAD_GPIO_3__I2C3_SCL	0xc0000000
> +							MX53_PAD_GPIO_6__I2C3_SDA	0xc0000000
> +						>;
> +					};
>  				};
>  
>  				ipu_disp0 {
> -- 
> 1.7.10.4
> 

