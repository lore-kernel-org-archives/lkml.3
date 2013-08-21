Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3HUHu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:50:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53081 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3HUHu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:50:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ZhVX/9de6o5e91oGXde2H
Date: Wed, 21 Aug 2013 00:50:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Cousson <bcousson@baylibre.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: am33xx: Correct gpio #interrupt-cells
 property
Message-ID: <20130821075016.GW7656@atomide.com>
References: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375873592-26881-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

Care to take a look at this too?

* Lars Poeschel <larsi@wh2.tu-dresden.de> [130807 04:14]:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> Following commit ff5c9059 and therefore other omap platforms using
> the gpio-omap driver correct the #interrupt-cells property on am33xx
> too. The omap gpio binding documentaion also states that
> the #interrupt-cells property should be 2.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 38b446b..033c5dd 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -102,7 +102,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  			reg = <0x44e07000 0x1000>;
>  			interrupts = <96>;
>  		};
> @@ -113,7 +113,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  			reg = <0x4804c000 0x1000>;
>  			interrupts = <98>;
>  		};
> @@ -124,7 +124,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  			reg = <0x481ac000 0x1000>;
>  			interrupts = <32>;
>  		};
> @@ -135,7 +135,7 @@
>  			gpio-controller;
>  			#gpio-cells = <2>;
>  			interrupt-controller;
> -			#interrupt-cells = <1>;
> +			#interrupt-cells = <2>;
>  			reg = <0x481ae000 0x1000>;
>  			interrupts = <62>;
>  		};
> -- 
> 1.7.10.4
> 
