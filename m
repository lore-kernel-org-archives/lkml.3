Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaJTJfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:35:45 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:40956 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaJTJfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:35:42 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Pintu Kumar <pintu.k@samsung.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, riel@redhat.com, mgorman@suse.de,
        vdavydov@parallels.com, nasa4836@gmail.com, ddstreet@ieee.org,
        m.szyprowski@samsung.com, pintu.k@samsung.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, lauraa@codeaurora.org,
        gioh.kim@lge.com, rientjes@google.com, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: cpgs@samsung.com, pintu_agarwal@yahoo.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH] mm: cma: split cma-reserved in dmesg log
In-Reply-To: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
Organization: http://mina86.com/
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141020:cpgs@samsung.com::jntrHqAioS6BoB0p:00lGE
X-Hashcash: 1:20:141020:nasa4836@gmail.com::5M0Bup4droUDwb0A:00000000000000000000000000000000000000000000f9R
X-Hashcash: 1:20:141020:ddstreet@ieee.org::0xmQsNfjAAO8xPzC:0000000000000000000000000000000000000000000010qp
X-Hashcash: 1:20:141020:linux-mm@kvack.org::RQC6NX8PLsza88I6:00000000000000000000000000000000000000000000+vw
X-Hashcash: 1:20:141020:pintu.k@samsung.com::GqWCs2k7toBOqCsf:00000000000000000000000000000000000000000016Cw
X-Hashcash: 1:20:141020:pintu_agarwal@yahoo.com::0Wx6XfhE7H2NT/Cg:000000000000000000000000000000000000001PjS
X-Hashcash: 1:20:141020:riel@redhat.com::bg3BMITE14Nd/zqE:001kOZ
X-Hashcash: 1:20:141020:pintu.k@samsung.com::HgsFH1ywcv3ogR69:0000000000000000000000000000000000000000001g9D
X-Hashcash: 1:20:141020:rohit.kr@samsung.com::X0b2VKsgoyDrutGN:000000000000000000000000000000000000000001d2P
X-Hashcash: 1:20:141020:ed.savinay@samsung.com::UmCLwAQG4XEa4I2L:0000000000000000000000000000000000000001hu6
X-Hashcash: 1:20:141020:iamjoonsoo.kim@lge.com::Sb8jXwX0kUCO+xBu:0000000000000000000000000000000000000002FeA
X-Hashcash: 1:20:141020:vbabka@suse.cz::9CCapVEypGrFtgYT:0002r+4
X-Hashcash: 1:20:141020:rientjes@google.com::IyHdi9gMmRTf3FRd:0000000000000000000000000000000000000000002tfD
X-Hashcash: 1:20:141020:sasha.levin@oracle.com::VfLdWj19yL7gieCb:0000000000000000000000000000000000000002sXz
X-Hashcash: 1:20:141020:aneesh.kumar@linux.vnet.ibm.com::IS+/Nm+8czozeBQO:0000000000000000000000000000002yvH
X-Hashcash: 1:20:141020:akpm@linux-foundation.org::2I/Wuyq+nRlAZRt3:000000000000000000000000000000000000427h
X-Hashcash: 1:20:141020:vdavydov@parallels.com::45cqlRQgfbwPc0RJ:0000000000000000000000000000000000000004IX2
X-Hashcash: 1:20:141020:mgorman@suse.de::3C8BVC0fy20wzd9E:004Ynr
X-Hashcash: 1:20:141020:vishnu.ps@samsung.com::BXa1meymayvQ7HPh:00000000000000000000000000000000000000004R4K
X-Hashcash: 1:20:141020:linux-kernel@vger.kernel.org::Nu2btGuRu3E/2iad:0000000000000000000000000000000004J3t
X-Hashcash: 1:20:141020:gioh.kim@lge.com::3A6GVIkErGQ2ZrAX:07NIQ
X-Hashcash: 1:20:141020:m.szyprowski@samsung.com::mcN8+B6t4d9QcJC1:00000000000000000000000000000000000008N2G
X-Hashcash: 1:20:141020:lauraa@codeaurora.org::Hy7J2JQOeOj1uawu:0000000000000000000000000000000000000000C0rt
X-Hashcash: 1:20:141020:hannes@cmpxchg.org::oIbg801VB5Y7VbQA:0000000000000000000000000000000000000000000DQUf
Date: Mon, 20 Oct 2014 11:35:36 +0200
Message-ID: <xa1tppdnnkwn.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20 2014, Pintu Kumar <pintu.k@samsung.com> wrote:
> When the system boots up, in the dmesg logs we can see
> the memory statistics along with total reserved as below.
> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>
> When CMA is enabled, still the total reserved memory remains the same.
> However, the CMA memory is not considered as reserved.
> But, when we see /proc/meminfo, the CMA memory is part of free memory.
> This creates confusion.
> This patch corrects the problem by properly substracting the CMA reserved
> memory from the total reserved memory in dmesg logs.
>
> Below is the dmesg snaphot from an arm based device with 512MB RAM and
> 12MB single CMA region.
>
> Before this change:
> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>
> After this change:
> Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K highmem
>
> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/swap.h | 3 +++
>  mm/cma.c             | 2 ++
>  mm/page_alloc.c      | 8 ++++++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 37a585b..beb84be 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -295,6 +295,9 @@ static inline void workingset_node_shadows_dec(struct radix_tree_node *node)
>  /* linux/mm/page_alloc.c */
>  extern unsigned long totalram_pages;
>  extern unsigned long totalreserve_pages;
> +#ifdef CONFIG_CMA
> +extern unsigned long totalcma_pages;
> +#endif
>  extern unsigned long dirty_balance_reserve;
>  extern unsigned long nr_free_buffer_pages(void);
>  extern unsigned long nr_free_pagecache_pages(void);
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..73fe7be 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -45,6 +45,7 @@ struct cma {
>  static struct cma cma_areas[MAX_CMA_AREAS];
>  static unsigned cma_area_count;
>  static DEFINE_MUTEX(cma_mutex);
> +unsigned long totalcma_pages __read_mostly;

It's not __read_mostly.

>  
>  phys_addr_t cma_get_base(struct cma *cma)
>  {
> @@ -288,6 +289,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	if (ret)
>  		goto err;
>  
> +	totalcma_pages += (size / PAGE_SIZE);
>  	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>  		(unsigned long)base);
>  	return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd73f9a..c6165ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5521,6 +5521,9 @@ void __init mem_init_print_info(const char *str)
>  	pr_info("Memory: %luK/%luK available "
>  	       "(%luK kernel code, %luK rwdata, %luK rodata, "
>  	       "%luK init, %luK bss, %luK reserved"
> +#ifdef CONFIG_CMA
> +		", %luK cma-reserved"
> +#endif
>  #ifdef	CONFIG_HIGHMEM
>  	       ", %luK highmem"
>  #endif
> @@ -5528,7 +5531,12 @@ void __init mem_init_print_info(const char *str)
>  	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
>  	       codesize >> 10, datasize >> 10, rosize >> 10,
>  	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
> +#ifdef CONFIG_CMA
> +	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
> +	       totalcma_pages << (PAGE_SHIFT-10),
> +#else
>  	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
> +#endif
>  #ifdef	CONFIG_HIGHMEM
>  	       totalhigh_pages << (PAGE_SHIFT-10),
>  #endif
> -- 
> 1.8.3.2
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
