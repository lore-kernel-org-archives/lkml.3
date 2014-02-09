Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaBIWtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:49:39 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:51931 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbaBIWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:49:36 -0500
Message-ID: <1391986174.25855.95.camel@x220>
Subject: Re: [PATCH 28/28] Remove LOCAL_TIMERS
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 23:49:34 +0100
In-Reply-To: <1391971686-9517-29-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-29-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 22:49:35.0133 (UTC) FILETIME=[344134D0:01CF25E9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Merge with 26/28? Anyhow, my comments are basically identical to those
on that patch. So:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle 

>  arch/arm/mach-omap2/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 653b489..2817f1f 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -54,7 +54,6 @@ config SOC_OMAP5
>  	select ARM_GIC
>  	select CPU_V7
>  	select HAVE_ARM_SCU if SMP
> -	select HAVE_ARM_TWD if LOCAL_TIMERS
>  	select HAVE_SMP
>  	select HAVE_ARM_ARCH_TIMER
>  	select ARM_ERRATA_798181 if SMP


