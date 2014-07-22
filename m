Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbaGVTqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:46:53 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:37122 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541AbaGVTqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:46:51 -0400
Date: Tue, 22 Jul 2014 21:46:47 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Marek Belisko <marek@goldelico.com>
cc: bcousson@baylibre.com, tony@atomide.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, hns@goldelico.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, galak@codeaurora.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] arm: dts: omap3-gta04: Fix magnetometer model
In-Reply-To: <1406057420-22269-3-git-send-email-marek@goldelico.com>
Message-ID: <alpine.DEB.2.01.1407222145360.27558@pmeerw.net>
References: <1406057420-22269-1-git-send-email-marek@goldelico.com> <1406057420-22269-3-git-send-email-marek@goldelico.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> gta04 is using hmc5843l not hmc5843 so fix wrong compatible
> entry.

I guess you mean hmc5883l
 
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
> index 7d7ddd7..6d1a8d8 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dts
> +++ b/arch/arm/boot/dts/omap3-gta04.dts
> @@ -220,7 +220,7 @@
>  
>  	/* compass aka magnetometer */
>  	hmc5843@1e {
> -		compatible = "honeywell,hmc5843";
> +		compatible = "honeywell,hmc5843l";
>  		reg = <0x1e>;
>  	};
>  
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
