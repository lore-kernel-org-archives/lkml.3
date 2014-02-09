Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaBIWjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:39:16 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:65160 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbaBIWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:38:55 -0500
Message-ID: <1391985532.25855.88.camel@x220>
Subject: Re: [PATCH 26/28] Remove LOCAL_TIMERS
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/SHMOBILE ARM..." <linux-sh@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 23:38:52 +0100
In-Reply-To: <1391971686-9517-27-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-27-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 22:38:53.0038 (UTC) FILETIME=[B58948E0:01CF25E7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.

Orphaned a year ago, see commit 060f3043e5e ("ARM: smp: Remove local
timer API"). But this one got added after that, in the same relase
cycle.

> Signed-off-by: Richard Weinberger <richard@nod.at>

This gets my
    Acked-by: Paul Bolle <pebolle@tiscali.nl>

as it's correct (we're dropping a nop) but I'd appreciate it if you'd
resend with the above info added. That would easy review by others too.


Paul Bolle

>  arch/arm/mach-shmobile/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
> index 3386406..c055388 100644
> --- a/arch/arm/mach-shmobile/Kconfig
> +++ b/arch/arm/mach-shmobile/Kconfig
> @@ -8,7 +8,6 @@ config ARCH_SHMOBILE_MULTI
>  	select CPU_V7
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_ARM_SCU if SMP
> -	select HAVE_ARM_TWD if LOCAL_TIMERS
>  	select HAVE_SMP
>  	select ARM_GIC
>  	select MIGHT_HAVE_CACHE_L2X0


