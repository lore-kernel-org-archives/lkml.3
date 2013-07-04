Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3GDLrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:47:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20321 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756173Ab3GDLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:47:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/D15uNEYVXFQYSjznv+mtU
Date: Thu, 4 Jul 2013 04:47:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: Remove obsolete Makefile line
Message-ID: <20130704114744.GD5523@atomide.com>
References: <1369912823.23034.46.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369912823.23034.46.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130530 04:26]:
> The OMAP runtime PM implementation was removed in v3.0. But one Makefile
> line, which was used to tweak CFLAGS, was overlooked. Remove it too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. This cleans up after commit 638080c37a ("OMAP2+ / PM: move
> runtime PM implementation to use device power domains").

Thanks, applying into omap-for-v3.11/fixes.

Tony
 
>  arch/arm/mach-omap2/Makefile | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 55a9d67..7279fa8 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -93,10 +93,6 @@ obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)    += smartreflex-class3.o
>  AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
>  AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
>  
> -ifeq ($(CONFIG_PM_VERBOSE),y)
> -CFLAGS_pm_bus.o				+= -DDEBUG
> -endif
> -
>  endif
>  
>  ifeq ($(CONFIG_CPU_IDLE),y)
> -- 
> 1.7.11.7
> 
