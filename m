Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDPGNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:13:51 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:40427
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655AbaDPGNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:13:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Wed, 16 Apr 2014 14:13:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: imx6q-gk802: Enable HDMI
Message-ID: <20140416061334.GE2523@dragon>
References: <1397499353-6116-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1397499353-6116-1-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:15:53PM +0200, Philipp Zabel wrote:
> This patch enables HDMI output on GK802 HDMI dongles.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  arch/arm/boot/dts/imx6q-gk802.dts | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6q-gk802.dts b/arch/arm/boot/dts/imx6q-gk802.dts
> index 4a9b4dc..16d3491 100644
> --- a/arch/arm/boot/dts/imx6q-gk802.dts
> +++ b/arch/arm/boot/dts/imx6q-gk802.dts
> @@ -48,6 +48,11 @@
>  	};
>  };
>  
> +&hdmi {
> +	status = "okay";

I prefer to put 'status' at the bottom of the property list.

Shawn

> +	ddc-i2c-bus = <&i2c3>;
> +};
> +
>  /* Internal I2C */
>  &i2c2 {
>  	pinctrl-names = "default";
> -- 
> 1.9.1
> 
> 
> 

