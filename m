Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3GHMD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:03:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10161 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3GHMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:03:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+p18f8hB8FIM7B04m4cLaf
Date: Mon, 8 Jul 2013 05:03:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@infradead.org,
        arm@kernel.org
Subject: Re: [PATCH 2/8] ARM: omap5: omap5 has SCU and TWD
Message-ID: <20130708120325.GY5523@atomide.com>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
 <1373041417-217728-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373041417-217728-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130705 09:28]:
> These are selected by omap4 but used in common omap4/5
> SMP code, so building an omap5-only kernel is actually
> broken without this patch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Tony Lindgren <tony@atomide.com>

>  arch/arm/mach-omap2/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 1fdb462..1f8127a 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -110,6 +110,8 @@ config SOC_OMAP5
>  	select ARM_CPU_SUSPEND if PM
>  	select ARM_GIC
>  	select CPU_V7
> +	select HAVE_ARM_SCU if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>  	select HAVE_SMP
>  	select COMMON_CLK
>  	select HAVE_ARM_ARCH_TIMER
> -- 
> 1.8.3.1
> 
