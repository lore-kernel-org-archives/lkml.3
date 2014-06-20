Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaFTOV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:21:59 -0400
Received: from icp-osb-irony-out8.external.iinet.net.au ([203.59.1.225]:61919
	"EHLO icp-osb-irony-out8.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbaFTOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:21:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEBADZCpFN8q1qV/2dsb2JhbAANTK5YAQEBAQEBBpkqAYEchHgBAQEEOEABEAsNAQoJFg8JAwIBAgFFBg0BBQIBAbQTnzMXhWKJFAeEQwEDoWeQCw
X-IronPort-AV: E=Sophos;i="5.01,514,1399996800"; 
   d="scan'208";a="829186096"
Message-ID: <53A4437E.1030107@uclinux.org>
Date: Sat, 21 Jun 2014 00:21:50 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: Remove unnecessary prototype for kobjsize()
References: <1403249376-27739-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1403249376-27739-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

On 20/06/14 17:29, Tobias Klauser wrote:
> The prototype for kobjsize() is already defined in linux/mm.h which is
> included where kobjsize() is used.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Thanks. I have added this to the m68knommu git tree, for-next branch.

Regards
Greg


> ---
>   arch/m68k/include/asm/pgtable_no.h |    5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/arch/m68k/include/asm/pgtable_no.h b/arch/m68k/include/asm/pgtable_no.h
> index c527fc2..11859b8 100644
> --- a/arch/m68k/include/asm/pgtable_no.h
> +++ b/arch/m68k/include/asm/pgtable_no.h
> @@ -46,11 +46,6 @@ static inline int pte_file(pte_t pte) { return 0; }
>   #define ZERO_PAGE(vaddr)	(virt_to_page(0))
>
>   /*
> - * These would be in other places but having them here reduces the diffs.
> - */
> -extern unsigned int kobjsize(const void *objp);
> -
> -/*
>    * No page table caches to initialise.
>    */
>   #define pgtable_cache_init()	do { } while (0)
>

