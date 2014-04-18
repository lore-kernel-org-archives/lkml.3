Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaDRW0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:26:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26751 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaDRW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:26:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uZxaya7m2mU7gJXElU24T
Date: Fri, 18 Apr 2014 15:25:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH trivial 1/3] ARM: dts: Grammar /is uses/ is used/
Message-ID: <20140418222554.GE21823@atomide.com>
References: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396001499-17638-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Geert Uytterhoeven <geert@linux-m68k.org> [140328 03:16]:
> From: Geert Uytterhoeven <geert+renesas@glider.be>

Applying this into omap-for-v3.15/fixes thanks.

Tony
 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    2 +-
>  arch/arm/boot/dts/dra7.dtsi   |    2 +-
>  arch/arm/boot/dts/omap4.dtsi  |    2 +-
>  arch/arm/boot/dts/omap5.dtsi  |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 6d95d3df33c7..70f7f3eb5fb4 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -68,7 +68,7 @@
>  	};
>  
>  	/*
> -	 * The soc node represents the soc top level view. It is uses for IPs
> +	 * The soc node represents the soc top level view. It is used for IPs
>  	 * that are not memory mapped in the MPU view or for the MPU itself.
>  	 */
>  	soc {
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 1fd75aa4639d..c19e90ecf95e 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -75,7 +75,7 @@
>  	};
>  
>  	/*
> -	 * The soc node represents the soc top level view. It is uses for IPs
> +	 * The soc node represents the soc top level view. It is used for IPs
>  	 * that are not memory mapped in the MPU view or for the MPU itself.
>  	 */
>  	soc {
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index d3f8a6e8ca20..a07ea359ae20 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -67,7 +67,7 @@
>  	};
>  
>  	/*
> -	 * The soc node represents the soc top level view. It is uses for IPs
> +	 * The soc node represents the soc top level view. It is used for IPs
>  	 * that are not memory mapped in the MPU view or for the MPU itself.
>  	 */
>  	soc {
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index a72813a9663e..aa9878c0aaad 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -87,7 +87,7 @@
>  	};
>  
>  	/*
> -	 * The soc node represents the soc top level view. It is uses for IPs
> +	 * The soc node represents the soc top level view. It is used for IPs
>  	 * that are not memory mapped in the MPU view or for the MPU itself.
>  	 */
>  	soc {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
