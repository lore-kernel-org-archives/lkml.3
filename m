Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaBQMdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:33:19 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:57675 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaBQMdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:33:17 -0500
Message-ID: <5302017F.40900@compulab.co.il>
Date: Mon, 17 Feb 2014 14:33:03 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: omap3: cm-t35: remove MACH_CM_T3730
References: <1392571560.28866.16.camel@x220>
In-Reply-To: <1392571560.28866.16.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 02/16/14 19:26, Paul Bolle wrote:
> The Kconfig symbol MACH_CM_T3730 was added in v3.1. It has never been
> used. Setting it has no effect. There are no calls for
> machine_is_cm_t3730(). This symbol can safely be removed.

Indeed...

Is it such a burden to keep it just until we switch OMAP3 to DT?
Because, it makes a bit harder to hack on the kernel.
Well, not too much as it can be reverted, but still one needs
to remember to do this...
I'd like to keep it just until we remove the board files, please.

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested only with "git grep".
> 
>  arch/arm/mach-omap2/Kconfig | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 66da3f5..7d4934e 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -292,7 +292,6 @@ config MACH_CM_T35
>  	bool "CompuLab CM-T35/CM-T3730 modules"
>  	depends on ARCH_OMAP3
>  	default y
> -	select MACH_CM_T3730
>  	select OMAP_PACKAGE_CUS
>  
>  config MACH_CM_T3517
> @@ -301,9 +300,6 @@ config MACH_CM_T3517
>  	default y
>  	select OMAP_PACKAGE_CBB
>  
> -config MACH_CM_T3730
> -       bool
> -
>  config MACH_SBC3530
>  	bool "OMAP3 SBC STALKER board"
>  	depends on ARCH_OMAP3
> 

-- 
Regards,
Igor.
