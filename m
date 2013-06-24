Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3FXNMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:12:17 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:41602
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab3FXNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:11:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 24 Jun 2013 21:11:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philippe Reynes <tremyfr@yahoo.fr>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <gwenhael.goavec-merou@armadeus.com>, <linux@arm.linux.org.uk>
Subject: Re: [PATCH] apf27dev: add rtc ds1374 to the device tree
Message-ID: <20130624131130.GD30747@S2101-09.ap.freescale.net>
References: <1371831853-24754-1-git-send-email-tremyfr@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1371831853-24754-1-git-send-email-tremyfr@yahoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 06:24:13PM +0200, Philippe Reynes wrote:
> 
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>

Applied, thanks.

Shawn

> ---
>  arch/arm/boot/dts/imx27-apf27dev.dts |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
> index 66b8e1c..2a377ca 100644
> --- a/arch/arm/boot/dts/imx27-apf27dev.dts
> +++ b/arch/arm/boot/dts/imx27-apf27dev.dts
> @@ -53,6 +53,11 @@
>  &i2c1 {
>  	clock-frequency = <400000>;
>  	status = "okay";
> +
> +	rtc@68 {
> +		compatible = "dallas,ds1374";
> +		reg = <0x68>;
> +	};
>  };
>  
>  &i2c2 {
> -- 
> 1.7.4.4
> 

