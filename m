Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaDRW0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:26:23 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27272 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaDRW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:26:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX198H+7nEARhvsbUC5/yp2BF
Date: Fri, 18 Apr 2014 15:26:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH trivial 3/3] ARM: dts: Grammar /that will/it will/
Message-ID: <20140418222612.GF21823@atomide.com>
References: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
 <1396001499-17638-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396001499-17638-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Geert Uytterhoeven <geert@linux-m68k.org> [140328 03:16]:
> From: Geert Uytterhoeven <geert+renesas@glider.be>

Applying this too into omap-for-v3.15/fixes thanks.

Tony
 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    4 ++--
>  arch/arm/boot/dts/dra7.dtsi   |    2 +-
>  arch/arm/boot/dts/omap3.dtsi  |    2 +-
>  arch/arm/boot/dts/omap4.dtsi  |    2 +-
>  arch/arm/boot/dts/omap5.dtsi  |    2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 70f7f3eb5fb4..2a66fd484284 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -90,8 +90,8 @@
>  
>  	/*
>  	 * XXX: Use a flat representation of the AM33XX interconnect.
> -	 * The real AM33XX interconnect network is quite complex.Since
> -	 * that will not bring real advantage to represent that in DT
> +	 * The real AM33XX interconnect network is quite complex. Since
> +	 * it will not bring real advantage to represent that in DT
>  	 * for the moment, just use a fake OCP bus entry to represent
>  	 * the whole bus hierarchy.
>  	 */
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index c19e90ecf95e..9daab63fe457 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -89,7 +89,7 @@
>  	/*
>  	 * XXX: Use a flat representation of the SOC interconnect.
>  	 * The real OMAP interconnect network is quite complex.
> -	 * Since that will not bring real advantage to represent that in DT for
> +	 * Since it will not bring real advantage to represent that in DT for
>  	 * the moment, just use a fake OCP bus entry to represent the whole bus
>  	 * hierarchy.
>  	 */
> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> index a5fc83b9c835..5ae8141d3713 100644
> --- a/arch/arm/boot/dts/omap3.dtsi
> +++ b/arch/arm/boot/dts/omap3.dtsi
> @@ -69,7 +69,7 @@
>  	/*
>  	 * XXX: Use a flat representation of the OMAP3 interconnect.
>  	 * The real OMAP interconnect network is quite complex.
> -	 * Since that will not bring real advantage to represent that in DT for
> +	 * Since it will not bring real advantage to represent that in DT for
>  	 * the moment, just use a fake OCP bus entry to represent the whole bus
>  	 * hierarchy.
>  	 */
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index a07ea359ae20..c95adadb0bbf 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -91,7 +91,7 @@
>  	/*
>  	 * XXX: Use a flat representation of the OMAP4 interconnect.
>  	 * The real OMAP interconnect network is quite complex.
> -	 * Since that will not bring real advantage to represent that in DT for
> +	 * Since it will not bring real advantage to represent that in DT for
>  	 * the moment, just use a fake OCP bus entry to represent the whole bus
>  	 * hierarchy.
>  	 */
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index aa9878c0aaad..0d875ba32fa9 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -101,7 +101,7 @@
>  	/*
>  	 * XXX: Use a flat representation of the OMAP3 interconnect.
>  	 * The real OMAP interconnect network is quite complex.
> -	 * Since that will not bring real advantage to represent that in DT for
> +	 * Since it will not bring real advantage to represent that in DT for
>  	 * the moment, just use a fake OCP bus entry to represent the whole bus
>  	 * hierarchy.
>  	 */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
