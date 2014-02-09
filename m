Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaBIU7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:59:51 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58509 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbaBIU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:59:50 -0500
Message-ID: <1391979588.25855.41.camel@x220>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:59:48 +0100
In-Reply-To: <1391971686-9517-17-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-17-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:59:49.0050 (UTC) FILETIME=[DEA4B1A0:01CF25D9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/score/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> index c75d06a..c7a7b65 100644
> --- a/arch/score/Kconfig
> +++ b/arch/score/Kconfig
> @@ -23,19 +23,16 @@ config ARCH_SCORE7
>  	bool "SCORE7 processor"
>  	select SYS_SUPPORTS_32BIT_KERNEL
>  	select CPU_SCORE7
> -	select GENERIC_HAS_IOMAP
>  
>  config MACH_SPCT6600
>  	bool "SPCT6600 series based machines"
>  	select SYS_SUPPORTS_32BIT_KERNEL
>  	select CPU_SCORE7
> -	select GENERIC_HAS_IOMAP
>  
>  config SCORE_SIM
>  	bool "Score simulator"
>  	select SYS_SUPPORTS_32BIT_KERNEL
>  	select CPU_SCORE7
> -	select GENERIC_HAS_IOMAP
>  endchoice
>  
>  endmenu

Actually, all these select statements can be dropped. I sent a patch to
do that about a year ago (but the link to that patch on lkml.org seems
empty: https://lkml.org/lkml/2013/3/6/167 ).

Good luck in getting a reply from the score maintainers. I never got
one.


Paul Bolle

