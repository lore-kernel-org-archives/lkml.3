Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaI2AKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:10:47 -0400
Received: from icp-osb-irony-out6.external.iinet.net.au ([203.59.1.222]:23147
	"EHLO icp-osb-irony-out6.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbaI2AKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:10:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApUBACajKFSVhxBY/2dsb2JhbAANU4c5zmgCgRIBhH4BAQEDASNVAQULCw0BCgICBRYLAgIJAwIBAgFFBgEMAQUCAQGIJQEMqHR4lTEBF4Esjg5kB4J4gVMBBKUjhEEEjRJagQaBRAEBAQ
X-IronPort-AV: E=Sophos;i="5.04,616,1406563200"; 
   d="scan'208";a="76470861"
Message-ID: <5428A380.9030408@westnet.com.au>
Date: Mon, 29 Sep 2014 10:10:40 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <trivial@kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] m68k: Fix typo 'COFNIG_MBAR'
References: <1411753216.7866.65.camel@x220>
In-Reply-To: <1411753216.7866.65.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 27/09/14 03:40, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested!

Thanks. I have applied this to the m68knommu git tree (since
that is where we tend to keep all ColdFire fixes).


> Geert, PASR is obviously unused. Is it needed?

Not at the moment. It will be if/when we implement better error
handling for external master errors.

Regards
Greg

 
>  arch/m68k/include/asm/m54xxpci.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/m68k/include/asm/m54xxpci.h b/arch/m68k/include/asm/m54xxpci.h
> index 6fbf54f72f2e..4687f5aa3741 100644
> --- a/arch/m68k/include/asm/m54xxpci.h
> +++ b/arch/m68k/include/asm/m54xxpci.h
> @@ -72,7 +72,7 @@
>  #define	PCIRFWPR	(CONFIG_MBAR + 0x84d4)	/* RX FIFO write pointer */
>  
>  #define	PACR		(CONFIG_MBAR + 0xc00)	/* PCI arbiter control */
> -#define	PASR		(COFNIG_MBAR + 0xc04)	/* PCI arbiter status */
> +#define	PASR		(CONFIG_MBAR + 0xc04)	/* PCI arbiter status */
>  
>  /*
>   *	Definitions for the Global status and control register.
> 

