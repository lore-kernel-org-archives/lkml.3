Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3LIFNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:13:11 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:37160
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab3LIFNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:13:07 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 00:13:06 EST
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 9 Dec 2013 12:57:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, <jimwall@q.com>,
        <brian@crystalfontz.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: mxs: Add iio-hwmon to crystalfontz boards
Message-ID: <20131209045702.GH825@S2101-09.ap.freescale.net>
References: <1386362843-20798-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386362843-20798-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 09:47:23PM +0100, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> 
> This won't work until those patches are applied:
>  https://lkml.org/lkml/2013/12/6/676

I won't have this patch in my tree until next cycle.  But if this DTS
change does not cause any regression on my tree, I can still apply it,
and the feature will work when it gets merged into linux-next together
with the driver changes.

>  and http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/216963.html
> 
> However, I'm wondering if it wouldn't make sense to add it directly in
> imx28.dtsi

Since it sounds like a SoC configuration rather than board one, having
the change in imx28.dtsi makes sense to me. 

Shawn

> 
>  arch/arm/boot/dts/imx28-cfa10036.dts | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
> index cabb6171a19d..51ebf36dd7b9 100644
> --- a/arch/arm/boot/dts/imx28-cfa10036.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10036.dts
> @@ -114,4 +114,9 @@
>  			default-state = "on";
>  		};
>  	};
> +
> +	iio_hwmon {
> +		compatible = "iio-hwmon";
> +		io-channels = <&lradc 8>;
> +	};
>  };
> -- 
> 1.8.3.2
> 

