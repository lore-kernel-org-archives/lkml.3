Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaIQBfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:35:08 -0400
Received: from icp-osb-irony-out8.external.iinet.net.au ([203.59.1.225]:14160
	"EHLO icp-osb-irony-out8.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbaIQBfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:35:05 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 21:35:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqABAPXhGFSVhxBY/2dsb2JhbAANU4Q30EQBgSoBhH0BAQR4ARALDQEKCRYPCQMCAQIBRQYBDAEFAgEBiCUBph+WagEXjmdkB4RLAQSke49vgVVagQaBRAEBAQ
X-IronPort-AV: E=Sophos;i="5.04,537,1406563200"; 
   d="scan'208";a="853663009"
Message-ID: <5418E31B.9020103@westnet.com.au>
Date: Wed, 17 Sep 2014 11:25:47 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] m68k/coldfire: remove second asm/mcfclk.h
 inclusion in m54xx.c
References: <1410893014-32665-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1410893014-32665-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

On 17/09/14 04:43, Fabian Frederick wrote:
> asm/mcfclk.h was included twice.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Looks good, thanks. I have added it to the for-next branch
of the m68knommu git tree.

Regards
Greg


> ---
>  arch/m68k/coldfire/m54xx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/m68k/coldfire/m54xx.c b/arch/m68k/coldfire/m54xx.c
> index eec7f71..075aaab 100644
> --- a/arch/m68k/coldfire/m54xx.c
> +++ b/arch/m68k/coldfire/m54xx.c
> @@ -23,7 +23,6 @@
>  #include <asm/mcfuart.h>
>  #include <asm/mcfclk.h>
>  #include <asm/m54xxgpt.h>
> -#include <asm/mcfclk.h>
>  #ifdef CONFIG_MMU
>  #include <asm/mmu_context.h>
>  #endif
> 

