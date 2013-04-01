Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3DAPxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:53:54 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36433 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3DAPxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:53:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19guHqfblLmQXJoPOEqEgKC
Date: Mon, 1 Apr 2013 08:53:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP1: remove "config MACH_OMAP_HTCWIZARD"
Message-ID: <20130401155345.GD10155@atomide.com>
References: <1363901769.1390.159.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363901769.1390.159.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130321 14:40]:
> The Kconfig symbol MACH_OMAP_HTCWIZARD got added in v2.6.30. It has
> never been used. Its entry can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.

Thanks, applying into omap-for-v3.10/fixes-non-critical.

Regards,

Tony
 
>  arch/arm/mach-omap1/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
> index 903da8e..cdd05f2 100644
> --- a/arch/arm/mach-omap1/Kconfig
> +++ b/arch/arm/mach-omap1/Kconfig
> @@ -55,12 +55,6 @@ config MACH_OMAP_H3
>  	  TI OMAP 1710 H3 board support. Say Y here if you have such
>  	  a board.
>  
> -config MACH_OMAP_HTCWIZARD
> -	bool "HTC Wizard"
> -	depends on ARCH_OMAP850
> -	help
> -	  HTC Wizard smartphone support (AKA QTEK 9100, ...)
> -
>  config MACH_HERALD
>  	bool "HTC Herald"
>  	depends on ARCH_OMAP850
> -- 
> 1.7.11.7
> 
