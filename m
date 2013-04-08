Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936456Ab3DHWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:17:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42148 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934846Ab3DHWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:17:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187aUk8Rbg5d7XFfxB7oEqV
Date: Mon, 8 Apr 2013 15:17:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap2+: Remove useless Makefile line
Message-ID: <20130408221732.GD10155@atomide.com>
References: <1365156749.1830.60.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365156749.1830.60.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130405 03:17]:
> Commit f41caddbe73f52a42f529d668ce47b4d693fd2c0 ("omap2+: Use Kconfig
> symbol in Makefile instead of obj-y") reorganized this Makefile. But,
> for some reason, it also added references to CONFIG_MACH_ENCORE and
> board-omap3encore.o. But there's no Kconfig symbol MACH_ENCORE and
> there's no file board-omap3encore.c. This line can safely be removed.

Thanks applying into omap-for-v3.10/board.

Tony
 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  arch/arm/mach-omap2/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index b068b7f..3d0697c 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -229,7 +229,6 @@ obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o
>  obj-$(CONFIG_MACH_OMAP_LDP)		+= board-ldp.o
>  obj-$(CONFIG_MACH_OMAP3530_LV_SOM)      += board-omap3logic.o
>  obj-$(CONFIG_MACH_OMAP3_TORPEDO)        += board-omap3logic.o
> -obj-$(CONFIG_MACH_ENCORE)		+= board-omap3encore.o
>  obj-$(CONFIG_MACH_OVERO)		+= board-overo.o
>  obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o
>  obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o
> -- 
> 1.7.11.7
> 
> 
> 
