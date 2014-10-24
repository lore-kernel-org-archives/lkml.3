Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbaJXQha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:37:30 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61190 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaJXQh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:37:29 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: m.szyprowski@samsung.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH] mm, cma: make parameters order consistent in func declaration and definition
In-Reply-To: <000201cfef6f$c5422b10$4fc68130$%yang@samsung.com>
Organization: http://mina86.com/
References: <000201cfef6f$c5422b10$4fc68130$%yang@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:weijie.yang@samsung.com::Tz3N/rflwScITGnt:000000000000000000000000000000000000000wCE
X-Hashcash: 1:20:141024:akpm@linux-foundation.org::J5Fja4FBQFQ7YCsn:000000000000000000000000000000000000107b
X-Hashcash: 1:20:141024:weijie.yang.kh@gmail.com::GmSWV134Il3F30Qj:00000000000000000000000000000000000001YUR
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::sIGtGWZEiuwP3VWU:00000000000000000000000000000000000001elS
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::NUDT0lAi6sgPxANq:0000000000000000000000000000000002Ndw
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::VEYsGikuSI0bWGCl:0000000000000000000000000000000000000005Ul5
X-Hashcash: 1:20:141024:aneesh.kumar@linux.vnet.ibm.com::pJz5jgrPQDH7v3LR:0000000000000000000000000000005M9G
X-Hashcash: 1:20:141024:linux-mm@kvack.org::FvInur1yUo1Wnq7v:00000000000000000000000000000000000000000005fSq
Date: Fri, 24 Oct 2014 18:37:23 +0200
Message-ID: <xa1td29h2zlo.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2014, Weijie Yang <weijie.yang@samsung.com> wrote:
> In the current code, the base and size parameters order is not consistent
> in functions declaration and definition. If someone calls these functions
> according to the declaration parameters order in cma.h, he will run into
> some bug and it's hard to find the reason.
>
> This patch makes the parameters order consistent in functions declaration
> and definition.
>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/cma.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 0430ed0..a93438b 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -18,12 +18,12 @@ struct cma;
>  extern phys_addr_t cma_get_base(struct cma *cma);
>  extern unsigned long cma_get_size(struct cma *cma);
>  
> -extern int __init cma_declare_contiguous(phys_addr_t size,
> -			phys_addr_t base, phys_addr_t limit,
> +extern int __init cma_declare_contiguous(phys_addr_t base,
> +			phys_addr_t size, phys_addr_t limit,
>  			phys_addr_t alignment, unsigned int order_per_bit,
>  			bool fixed, struct cma **res_cma);
> -extern int cma_init_reserved_mem(phys_addr_t size,
> -					phys_addr_t base, int order_per_bit,
> +extern int cma_init_reserved_mem(phys_addr_t base,
> +					phys_addr_t size, int order_per_bit,
>  					struct cma **res_cma);
>  extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
>  extern bool cma_release(struct cma *cma, struct page *pages, int count);
> -- 
> 1.7.0.4
>
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
