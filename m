Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaFMHOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:14:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43510 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaFMHOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:14:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18KchPhDkg3THkPfbqMI9DN
Date: Fri, 13 Jun 2014 00:13:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        kyungmin.park@samsung.com, pekon@ti.com,
        ezequiel.garcia@free-electrons.com, javier@dowhile0.org,
        nsekhar@ti.com, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/36] ARM: OMAP3: hwmod: Fix gpmc memory resource space
Message-ID: <20140613071357.GH17845@atomide.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
 <1402477001-31132-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402477001-31132-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140611 01:58]:

Missing description? Probably not an urgent fix or does
this fix something?

Regards,

Tony

> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 71ac7d5..f2848a8 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -3426,7 +3426,7 @@ static struct omap_hwmod_addr_space omap3xxx_counter_32k_addrs[] = {
>  static struct omap_hwmod_addr_space omap3xxx_gpmc_addrs[] = {
>  	{
>  		.pa_start	= 0x6e000000,
> -		.pa_end		= 0x6e000fff,
> +		.pa_end		= 0x6e0002d4,
>  		.flags		= ADDR_TYPE_RT
>  	},
>  	{ }
> -- 
> 1.8.3.2
> 
