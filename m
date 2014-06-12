Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbaFLI4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:56:45 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42725 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbaFLI4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:56:42 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 01/10] DMA, CMA: clean-up log message
In-Reply-To: <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:pbonzini@redhat.com::sVucMY2jI/H3+9Jr:00000000000000000000000000000000000000000006QG
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::eYDRO9QuLysvbpm2:0000000000000000000000000000000000000000000VNf
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::x8RKyIYgpwaUbNfX:0000000000000000000000000000000000000000a5D
X-Hashcash: 1:20:140612:linux-mm@kvack.org::EGagoqdhu/1m21NI:00000000000000000000000000000000000000000000qWo
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::YjnNTqemvw5uuFVW:00000000000000000000000000000000000000013bG
X-Hashcash: 1:20:140612:agraf@suse.de::s6vOJKzMBpEjBxkP:00001Zf5
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::eTJw30wEOfG6MTJ1:0000000000000000000000000000000000001uT7
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::jIVU26KHkgTkteeT:00000000000000000000000001/jJ
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::EBZi9hlARwKqfgw8:00000000000000000000000000000000000002QNe
X-Hashcash: 1:20:140612:minchan@kernel.org::I+9KcXS1I9UdbTX+:00000000000000000000000000000000000000000002Ku1
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::b27/1xm+ElDaQ+WT:00000000000000000000000000000000000002jhe
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::sLVgNdCvsRvRZkY6:000000000000000000000000000000000003Al5
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::HISTAG/vW9If0dNR:0000000000000000000000000000000004D/M
X-Hashcash: 1:20:140612:paulus@samba.org::C0RYKhOkcLm1cCAq:03vUl
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::EMH4hWKuacDRu78W:0000000000000000000000000000006NhY
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::tnjXLR4HKlsqvsIb:000000000000000000000000000000006gB0
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::6XKG9KAYYH+Bfe07:000000000000000000000000000000000000000AfNS
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::7I0UOvZS4sE0vWYM:00000000000000000000000000000000000000NAN9
X-Hashcash: 1:20:140612:gleb@kernel.org::01gH3W9X86y28DYQ:00QR+G
Date: Thu, 12 Jun 2014 10:56:37 +0200
Message-ID: <xa1tlht2jyka.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> We don't need explicit 'CMA:' prefix, since we already define prefix
> 'cma:' in pr_fmt. So remove it.
>
> And, some logs print function name and others doesn't. This looks
> bad to me, so I unify log format to print function name consistently.
>
> Lastly, I add one more debug log on cma_activate_area().

I don't particularly care what format of logs you choose, so:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

even though I'd go without empty “()”.

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 83969f8..bd0bb81 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -144,7 +144,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>  	}
>  
>  	if (selected_size && !dma_contiguous_default_area) {
> -		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
> +		pr_debug("%s(): reserving %ld MiB for global area\n", __func__,
>  			 (unsigned long)selected_size / SZ_1M);
>  
>  		dma_contiguous_reserve_area(selected_size, selected_base,
> @@ -163,8 +163,9 @@ static int __init cma_activate_area(struct cma *cma)
>  	unsigned i = cma->count >> pageblock_order;
>  	struct zone *zone;
>  
> -	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +	pr_debug("%s()\n", __func__);
>  
> +	cma->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
>  	if (!cma->bitmap)
>  		return -ENOMEM;
>  
> @@ -234,7 +235,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  
>  	/* Sanity checks */
>  	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
> -		pr_err("Not enough slots for CMA reserved regions!\n");
> +		pr_err("%s(): Not enough slots for CMA reserved regions!\n",
> +			__func__);
>  		return -ENOSPC;
>  	}
>  
> @@ -274,14 +276,15 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  	*res_cma = cma;
>  	cma_area_count++;
>  
> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -		(unsigned long)base);
> +	pr_info("%s(): reserved %ld MiB at %08lx\n",
> +		__func__, (unsigned long)size / SZ_1M, (unsigned long)base);
>  
>  	/* Architecture specific contiguous memory fixup. */
>  	dma_contiguous_early_fixup(base, size);
>  	return 0;
>  err:
> -	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
> +	pr_err("%s(): failed to reserve %ld MiB\n",
> +		__func__, (unsigned long)size / SZ_1M);
>  	return ret;
>  }

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
