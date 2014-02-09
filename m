Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaBIUfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:35:46 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53557 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaBIUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:35:45 -0500
Message-ID: <1391978143.25855.30.camel@x220>
Subject: Re: [PATCH 11/28] Remove ARCH_SUPPORTS_MSI
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "open list:MIPS" <linux-mips@linux-mips.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:35:43 +0100
In-Reply-To: <1391971686-9517-12-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-12-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:35:44.0383 (UTC) FILETIME=[818E00F0:01CF25D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/mips/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 792bd22..5b08fe9 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -782,7 +782,6 @@ config NLM_XLP_BOARD
>  	select CEVT_R4K
>  	select CSRC_R4K
>  	select IRQ_CPU
> -	select ARCH_SUPPORTS_MSI
>  	select ZONE_DMA32 if 64BIT
>  	select SYNC_R4K
>  	select SYS_HAS_EARLY_PRINTK

I sent an identical patch (with a more verbose explanation) yesterday.
But I'm fine with this one too.


Paul Bolle


