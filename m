Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaJPFKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:10:39 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34767 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaJPFKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:10:36 -0400
Date: Thu, 16 Oct 2014 07:10:31 +0200
From: Simon Horman <horms@verge.net.au>
To: Rolf Evers-Fischer <embedded24@evers-fischer.de>
Cc: magnus.damm@gmail.com, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-shmobile: Remove ARCH_HAS_OPP completely
Message-ID: <20141016051031.GA1265@verge.net.au>
References: <1413379785-14468-1-git-send-email-embedded24@evers-fischer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413379785-14468-1-git-send-email-embedded24@evers-fischer.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 03:29:45PM +0200, Rolf Evers-Fischer wrote:
> The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
> 049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
> removed the only dependency that used it. Setting it had no effect
> anymore.
> 
> So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
> some reason that commit did not remove all select statements for that
> symbol. These statements are now useless.
> 
> Commit adad5621f3e1 ("PM / devfreq: Remove ARCH_HAS_OPP completely")
> removed it for devfreq. Remove one from mach-shmobile too.
> 
> Signed-off-by: Rolf Evers-Fischer <embedded24@evers-fischer.de>

Thanks, I have queued this up.

> ---
>  arch/arm/mach-shmobile/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> index 21f457b..f59019d 100644
> --- a/arch/arm/mach-shmobile/Kconfig
> +++ b/arch/arm/mach-shmobile/Kconfig
> @@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
>  	select NO_IOPORT_MAP
>  	select PINCTRL
>  	select ARCH_REQUIRE_GPIOLIB
> -	select ARCH_HAS_OPP
>  
>  if ARCH_SHMOBILE_MULTI
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
