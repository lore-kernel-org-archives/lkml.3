Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3DGGTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 02:19:12 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:6973
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab3DGGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 02:19:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sun, 7 Apr 2013 14:19:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <jimwall@q.com>, <brian@crystalfontz.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: cfa10036: Add touchscreen support to the
 CFA-10049
Message-ID: <20130407061911.GB11898@S2101-09.ap.freescale.net>
References: <1365165182-29502-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1365165182-29502-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:33:02PM +0200, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks.

> ---
>  arch/arm/boot/dts/imx28-cfa10049.dts |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx28-cfa10049.dts b/arch/arm/boot/dts/imx28-cfa10049.dts
> index b9dad4e..f16c1e2 100644
> --- a/arch/arm/boot/dts/imx28-cfa10049.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10049.dts
> @@ -192,6 +192,11 @@
>  			usbphy1: usbphy@8007e000 {
>  				status = "okay";
>  			};
> +
> +			lradc@80050000 {
> +				status = "okay";
> +				fsl,lradc-touchscreen-wires = <4>;
> +			};
>  		};
>  	};
>  
> -- 
> 1.7.10.4
> 

