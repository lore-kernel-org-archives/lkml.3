Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaEOHvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:51:46 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:52967 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaEOHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:51:44 -0400
Date: Thu, 15 May 2014 09:51:37 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel@axis.com
Subject: Re: [PATCH 09/27] cris: Use common bits from generic tlb.h
Message-ID: <20140515075137.GR23150@axis.com>
References: <1400093999-18703-1-git-send-email-richard@nod.at>
 <1400093999-18703-10-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400093999-18703-10-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 08:59:41PM +0200, Richard Weinberger wrote:
> It is no longer needed to define them on our own.

Looks good!

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: linux-cris-kernel@axis.com
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/cris/include/asm/tlb.h | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/arch/cris/include/asm/tlb.h b/arch/cris/include/asm/tlb.h
> index 77384ea..4cc840f 100644
> --- a/arch/cris/include/asm/tlb.h
> +++ b/arch/cris/include/asm/tlb.h
> @@ -2,18 +2,7 @@
>  #define _CRIS_TLB_H
>  
>  #include <linux/pagemap.h>
> -
>  #include <arch/tlb.h>
> -
> -/*
> - * cris doesn't need any special per-pte or
> - * per-vma handling..
> - */
> -#define tlb_start_vma(tlb, vma) do { } while (0)
> -#define tlb_end_vma(tlb, vma) do { } while (0)
> -#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
> -
> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
>  #include <asm-generic/tlb.h>
>  
>  #endif
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
