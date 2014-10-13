Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaJMQag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:30:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18224 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbaJMQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:30:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 162.217.72.251
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Ix0iGAXPoG7UIws2XK5Si
Date: Mon, 13 Oct 2014 09:29:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Marek Belisko <marek@goldelico.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk,
        dmitry.torokhov@gmail.com, hns@goldelico.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] arm: dts: omap3-gta04: Extend touchscreen configs
Message-ID: <20141013162905.GC5192@atomide.com>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com>
 <1412108254-19234-4-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412108254-19234-4-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marek Belisko <marek@goldelico.com> [140930 13:19]:
> Adding min/max values for various touschscreen properties.

Assuming no other comments on this patch series, this should be
safe to merge along with the other patches in this series without
causing merge conflicts:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
> index fd34f91..2dafac3b 100644
> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> @@ -284,6 +284,12 @@
>  		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
>  		gpios = <&gpio6 0 GPIO_ACTIVE_LOW>;
>  		ti,x-plate-ohms = <600>;
> +		ti,min-x = <0x100>;
> +		ti,max-x = <0xf00>;
> +		ti,min-y = <0xf00>;
> +		ti,max-y = <0x100>;
> +		ti,min-rt = <0xfff>;
> +		ti,max-rt = <0>;
>  	};
>  };
>  
> -- 
> 1.9.3
> 
