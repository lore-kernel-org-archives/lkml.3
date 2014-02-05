Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaBEBIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 20:08:46 -0500
Received: from outbound-mail01.westnet.com.au ([203.10.1.242]:26382 "EHLO
	outbound-mail01.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbaBEBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 20:08:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACKM8VKVhxBY/2dsb2JhbAANTMI6gR+DGQEBAQR4ARALGAkWDwkDAgECAUUGDQEFAgEBtAiiIxeOdQeEOAEDrgs
X-IronPort-AV: E=Sophos;i="4.95,783,1384272000"; 
   d="scan'208";a="391924263"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 391924263
X-WN-SMTPAUTHID: gregungerer
Message-ID: <52F18D07.8020301@uclinux.org>
Date: Wed, 05 Feb 2014 10:59:51 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] m68k: Switch to asm-generic/barrier.h
References: <1391544954-7422-1-git-send-email-geert@linux-m68k.org> <1391544954-7422-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1391544954-7422-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 06:15, Geert Uytterhoeven wrote:
> The generic nop() implementation is fine for m68k.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>  arch/m68k/include/asm/Kbuild    |    1 +
>  arch/m68k/include/asm/barrier.h |    8 --------
>  2 files changed, 1 insertion(+), 8 deletions(-)
>  delete mode 100644 arch/m68k/include/asm/barrier.h
> 
> diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
> index df4d46fc321b..6fb9e813a910 100644
> --- a/arch/m68k/include/asm/Kbuild
> +++ b/arch/m68k/include/asm/Kbuild
> @@ -1,3 +1,4 @@
> +generic-y += barrier.h
>  generic-y += bitsperlong.h
>  generic-y += clkdev.h
>  generic-y += cputime.h
> diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
> deleted file mode 100644
> index 15c5f77c1614..000000000000
> --- a/arch/m68k/include/asm/barrier.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#ifndef _M68K_BARRIER_H
> -#define _M68K_BARRIER_H
> -
> -#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
> -
> -#include <asm-generic/barrier.h>
> -
> -#endif /* _M68K_BARRIER_H */
> 

