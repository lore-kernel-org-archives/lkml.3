Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbaGDB3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:29:09 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:45467 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaGDB3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:29:07 -0400
Date: Fri, 4 Jul 2014 11:28:05 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Nicholas Krause <xerofoify@gmail.com>
cc: sammy@sammy.net, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Remove FIXME comment in file sun3_pgalloc.h
In-Reply-To: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
Message-ID: <alpine.LNX.2.00.1407041125060.15901@nippy.intranet>
References: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2 Jul 2014, Nicholas Krause wrote:

> Removes a FIXME comment in this file due to it not compiling as it now 
> compiles.

What got fixed?

It doesn't say "FIXME - this doesn't compile".

> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/m68k/include/asm/sun3_pgalloc.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
> index f868506..1798f25 100644
> --- a/arch/m68k/include/asm/sun3_pgalloc.h
> +++ b/arch/m68k/include/asm/sun3_pgalloc.h
> @@ -12,7 +12,6 @@
>  
>  #include <asm/tlb.h>
>  
> -/* FIXME - when we get this compiling */
>  /* erm, now that it's compiling, what do we do with it? */
>  #define _KERNPG_TABLE 0
>  
> 

-- 
