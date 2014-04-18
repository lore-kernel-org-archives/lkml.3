Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaDRWl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:41:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50161 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaDRWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:41:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UFipr6sApOzEQLuljN3sM
Date: Fri, 18 Apr 2014 15:41:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Jon Hunter <jon-hunter@ti.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: OMAP2+: remove uses of obsolete
 gpmc,device-nand
Message-ID: <20140418224115.GL21823@atomide.com>
References: <1396948817-29362-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396948817-29362-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Johan Hovold <jhovold@gmail.com> [140408 02:25]:
> Remove all remaining uses of gpmc,device-nand that have been added since
> the property was removed by commit f40739faba8e ("ARM: dts: OMAP2+:
> Simplify NAND support").

Thanks applying into omap-for-v3.15/fixes.

Tony
 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
>  arch/arm/boot/dts/am335x-igep0033.dtsi  | 1 -
>  arch/arm/boot/dts/omap3-devkit8000.dts  | 1 -
>  arch/arm/boot/dts/omap3-lilly-a83x.dtsi | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am335x-igep0033.dtsi b/arch/arm/boot/dts/am335x-igep0033.dtsi
> index 7063311a58d9..06c822a48b71 100644
> --- a/arch/arm/boot/dts/am335x-igep0033.dtsi
> +++ b/arch/arm/boot/dts/am335x-igep0033.dtsi
> @@ -118,7 +118,6 @@
>  		reg = <0 0 0>; /* CS0, offset 0 */
>  		nand-bus-width = <8>;
>  		ti,nand-ecc-opt = "bch8";
> -		gpmc,device-nand = "true";
>  		gpmc,device-width = <1>;
>  		gpmc,sync-clk-ps = <0>;
>  		gpmc,cs-on-ns = <0>;
> diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
> index bf5a515a3247..da402f0fdab4 100644
> --- a/arch/arm/boot/dts/omap3-devkit8000.dts
> +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
> @@ -112,7 +112,6 @@
>  		reg = <0 0 0>; /* CS0, offset 0 */
>  		nand-bus-width = <16>;
>  
> -		gpmc,device-nand;
>  		gpmc,sync-clk-ps = <0>;
>  		gpmc,cs-on-ns = <0>;
>  		gpmc,cs-rd-off-ns = <44>;
> diff --git a/arch/arm/boot/dts/omap3-lilly-a83x.dtsi b/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
> index 6369d9f43ca2..cc1dce6978f5 100644
> --- a/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
> +++ b/arch/arm/boot/dts/omap3-lilly-a83x.dtsi
> @@ -368,7 +368,6 @@
>  		/* no elm on omap3 */
>  
>  		gpmc,mux-add-data = <0>;
> -		gpmc,device-nand;
>  		gpmc,device-width = <2>;
>  		gpmc,wait-pin = <0>;
>  		gpmc,wait-monitoring-ns = <0>;
> -- 
> 1.8.3.2
> 
