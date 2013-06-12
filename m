Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab3FLRMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:12:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40077 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757685Ab3FLRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:12:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+IlA/g/42dMVvHrCYRHPcQ
Date: Wed, 12 Jun 2013 10:12:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 02/14] ARM: OMAP2+: AM43x: Kconfig
Message-ID: <20130612171200.GL8164@atomide.com>
References: <cover.1369658705.git.afzal@ti.com>
 <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Afzal Mohammed <afzal@ti.com> [130527 07:41]:
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -149,6 +149,16 @@ config SOC_AM33XX
>  	select MULTI_IRQ_HANDLER
>  	select COMMON_CLK
>  
> +config SOC_AM43XX
> +	bool "TI AM43x"
> +	depends on ARCH_OMAP2PLUS
> +	default y
> +	select CPU_V7
> +	select MULTI_IRQ_HANDLER
> +	select ARM_GIC
> +	select COMMON_CLK
> +	select MACH_OMAP_GENERIC
> +
>  config OMAP_PACKAGE_ZAF
>         bool

I've updated this patch to remove the "default y" and
"depends on ARCH_OMAP2PLUS" entries for the usual reasons
and applied the first ten patches into omap-for-v3.11/soc.

Regards,

Tony
