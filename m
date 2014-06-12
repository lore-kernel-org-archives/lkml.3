Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaFLLiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:38:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60166 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaFLLiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:38:17 -0400
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
Subject: Re: [PATCH v2 09/10] mm, cma: move output param to the end of param list
In-Reply-To: <1402543307-29800-10-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-10-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::zENM3UGuVZmTWysu:0000000000000000000000000000000007Od
X-Hashcash: 1:20:140612:agraf@suse.de::pNTNc09kfaWsnAO1:00000J5e
X-Hashcash: 1:20:140612:pbonzini@redhat.com::wkKl9BM8hQ4CtDMo:0000000000000000000000000000000000000000000U9n
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::SazU3KTuMFBKtIl6:000000000000000000000000000000000000PTP
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::/3luuIzCCz+IKFah:0000000000000000000000000000001Zu/
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::gsv7iwkAtCAF5Lvv:0000000000000000000000000000000000002SHa
X-Hashcash: 1:20:140612:paulus@samba.org::gH5X7N0MVAumZrIh:02TZ6
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::W7YCESTNC2059Lli:0000000000000000000000000000000000000002VmW
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::iJkTGscpnQnH5uaw:0000000000000000000000000000000000000003672
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::GlquC4MESNMKBiD3:0000000000000000000000000000000003Z2Q
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::WnIBiwRI6h8cV31g:0000000000000000000000000000000000000000003SzA
X-Hashcash: 1:20:140612:gleb@kernel.org::R1O4H9dUGVvdTbsP:004CBB
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::2Yyl4EgBJNQW50Tf:000000000000000000000000000000000000057rd
X-Hashcash: 1:20:140612:minchan@kernel.org::gQv+LaRBSsVXs5hD:00000000000000000000000000000000000000000004ggb
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::21B5qFF5F5ftba3G:0000000000000000000000000000000000000004r2b
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::FOybtOCCyGFE+NAo:000000000000000000000000000000000000005k8o
X-Hashcash: 1:20:140612:linux-mm@kvack.org::iZb2Y5J/1k3qMLH6:00000000000000000000000000000000000000000008hQG
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::I2yquB4yOBh+NAJg:0000000000000000000000000000000000000BhOz
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::Tes9RPHAE2ZjInyF:0000000000000000000000000A+4P
Date: Thu, 12 Jun 2014 13:38:11 +0200
Message-ID: <xa1twqcmicik.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Conventionally, we put output param to the end of param list.
> cma_declare_contiguous() doesn't look like that, so change it.

Perhaps the function should be changed to return an error-pointer?

> Additionally, move down cma_areas reference code to the position
> where it is really needed.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

>
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 28ec226..97613ea 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -184,7 +184,7 @@ void __init kvm_cma_reserve(void)
>  
>  		align_size = max(kvm_rma_pages << PAGE_SHIFT, align_size);
>  		cma_declare_contiguous(selected_size, 0, 0, align_size,
> -			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, &kvm_cma, false);
> +			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, false, &kvm_cma);
>  	}
>  }
>  
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index f177f73..bfd4553 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -149,7 +149,7 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  {
>  	int ret;
>  
> -	ret = cma_declare_contiguous(size, base, limit, 0, 0, res_cma, fixed);
> +	ret = cma_declare_contiguous(size, base, limit, 0, 0, fixed, res_cma);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index e38efe9..e53eead 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -6,7 +6,7 @@ struct cma;
>  extern int __init cma_declare_contiguous(phys_addr_t size,
>  				phys_addr_t base, phys_addr_t limit,
>  				phys_addr_t alignment, int order_per_bit,
> -				struct cma **res_cma, bool fixed);
> +				bool fixed, struct cma **res_cma);
>  extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
>  extern bool cma_release(struct cma *cma, struct page *pages, int count);
>  #endif
> diff --git a/mm/cma.c b/mm/cma.c
> index 01a0713..22a5b23 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -142,8 +142,8 @@ core_initcall(cma_init_reserved_areas);
>   * @limit: End address of the reserved memory (optional, 0 for any).
>   * @alignment: Alignment for the contiguous memory area, should be power of 2
>   * @order_per_bit: Order of pages represented by one bit on bitmap.
> - * @res_cma: Pointer to store the created cma region.
>   * @fixed: hint about where to place the reserved area
> + * @res_cma: Pointer to store the created cma region.
>   *
>   * This function reserves memory from early allocator. It should be
>   * called by arch specific code once the early allocator (memblock or bootmem)
> @@ -156,9 +156,9 @@ core_initcall(cma_init_reserved_areas);
>  int __init cma_declare_contiguous(phys_addr_t size,
>  				phys_addr_t base, phys_addr_t limit,
>  				phys_addr_t alignment, int order_per_bit,
> -				struct cma **res_cma, bool fixed)
> +				bool fixed, struct cma **res_cma)
>  {
> -	struct cma *cma = &cma_areas[cma_area_count];
> +	struct cma *cma;
>  	int ret = 0;
>  
>  	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
> @@ -214,6 +214,7 @@ int __init cma_declare_contiguous(phys_addr_t size,
>  	 * Each reserved area must be initialised later, when more kernel
>  	 * subsystems (like slab allocator) are available.
>  	 */
> +	cma = &cma_areas[cma_area_count];
>  	cma->base_pfn = PFN_DOWN(base);
>  	cma->count = size >> PAGE_SHIFT;
>  	cma->order_per_bit = order_per_bit;
> -- 
> 1.7.9.5
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
