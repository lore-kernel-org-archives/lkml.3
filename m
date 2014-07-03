Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaGCMf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:35:29 -0400
Received: from anhedonia.sammy.net ([174.143.180.86]:38322 "EHLO sammy.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaGCMf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:35:27 -0400
X-Greylist: delayed 2316 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 08:35:27 EDT
Date: Thu, 3 Jul 2014 07:56:45 -0400
From: Sam Creasey <sammy@sammy.net>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: sammy@sammy.net, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: Remove FIXME comment in file sun3_pgalloc.h
Message-ID: <20140703115645.GB21346@anhedonia>
References: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404351693-5588-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sam Creasey <sammy@sammy.net>   

On Wed, Jul 02, 2014 at 09:41:33PM -0400, Nicholas Krause wrote:
> Removes a FIXME comment in this file due to it not compiling
> as it now compiles.
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
