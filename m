Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaB1Xih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:38:37 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64353 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaB1Xig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:38:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/B6A7tqCqpUdGFOuLmuxU4
Date: Fri, 28 Feb 2014 15:38:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: omap: remove OMAP_PACKAGE_ZAC and OMAP_PACKAGE_ZAF
Message-ID: <20140228233817.GZ13624@atomide.com>
References: <1392576697.28866.27.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392576697.28866.27.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [140216 10:54]:
> The Kconfig symbols OMAP_PACKAGE_ZAC and OMAP_PACKAGE_ZAF were added in
> v2.6.36. They have never been used. Setting them has no effect. These
> symbols can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep".

Thanks applying into omap-for-v3.15/soc with the related entries also
removed from arch/arm/mach-omap2/mux.h.

Regards,

Tony
 
> A sort of related cleanup would be removing the preprocessoer defines of
> OMAP_PACKAGE_ZAC and OMAP_PACKAGE_ZAF that are unused since v3.14-rc1.
> 
>  arch/arm/mach-omap2/Kconfig | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 7d4934e..bb51eeb 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -165,12 +165,6 @@ config SOC_TI81XX
>  	depends on ARCH_OMAP3
>  	default y
>  
> -config OMAP_PACKAGE_ZAF
> -       bool
> -
> -config OMAP_PACKAGE_ZAC
> -       bool
> -
>  config OMAP_PACKAGE_CBC
>         bool
>  
> @@ -280,7 +274,6 @@ config MACH_NOKIA_N8X0
>  	default y
>  	select MACH_NOKIA_N810
>  	select MACH_NOKIA_N810_WIMAX
> -	select OMAP_PACKAGE_ZAC
>  
>  config MACH_NOKIA_RX51
>  	bool "Nokia N900 (RX-51) phone"
> -- 
> 1.8.5.3
> 
