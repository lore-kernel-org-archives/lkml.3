Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBITvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:51:20 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:48224 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaBITvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:51:19 -0500
Date: Sun, 9 Feb 2014 21:50:21 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: Remove MACH_NOKIA_N800
Message-ID: <20140209195021.GE573@drone.musicnaut.iki.fi>
References: <1391958088.25424.17.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391958088.25424.17.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 09, 2014 at 04:01:28PM +0100, Paul Bolle wrote:
> The last caller of machine_is_nokia_n800() was removed in commit
> 5a87cde490e1 ("ARM: OMAP2+: Remove legacy booting support for n8x0").
> That means that the Kconfig symbol MACH_NOKIA_N800 is now unused. It can
> safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>

A.

> ---
> Untested.
> 
>  arch/arm/mach-omap2/Kconfig | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 653b489..66da3f5 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -268,9 +268,6 @@ config MACH_OMAP_3430SDP
>  	default y
>  	select OMAP_PACKAGE_CBB
>  
> -config MACH_NOKIA_N800
> -       bool
> -
>  config MACH_NOKIA_N810
>         bool
>  
> @@ -281,7 +278,6 @@ config MACH_NOKIA_N8X0
>  	bool "Nokia N800/N810"
>  	depends on SOC_OMAP2420
>  	default y
> -	select MACH_NOKIA_N800
>  	select MACH_NOKIA_N810
>  	select MACH_NOKIA_N810_WIMAX
>  	select OMAP_PACKAGE_ZAC
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
