Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaJWRBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:01:16 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:35980 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaJWRBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:01:09 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Pintu Kumar <pintu.k@samsung.com>, akpm@linux-foundation.org,
        riel@redhat.com, pintu.k@samsung.com, aquini@redhat.com,
        paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, lauraa@codeaurora.org, gioh.kim@lge.com,
        mgorman@suse.de, rientjes@google.com, hannes@cmpxchg.org,
        vbabka@suse.cz, sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
In-Reply-To: <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
Organization: http://mina86.com/
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com> <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141023:iamjoonsoo.kim@lge.com::VSz7zPXMtlqcJeJd:00000000000000000000000000000000000000001I5
X-Hashcash: 1:20:141023:linux-mm@kvack.org::Cv7Hfy1HOp6PRULx:00000000000000000000000000000000000000000000izn
X-Hashcash: 1:20:141023:gioh.kim@lge.com::Bths+CGzQX7DMith:00kxo
X-Hashcash: 1:20:141023:paul.gortmaker@windriver.com::NeMudEnc8RQLHvHL:0000000000000000000000000000000000kiN
X-Hashcash: 1:20:141023:kirill.shutemov@linux.intel.com::1mJrqnS0bzTGEEjR:00000000000000000000000000000011/v
X-Hashcash: 1:20:141023:linux-kernel@vger.kernel.org::1GvRivaRrJskPZBq:0000000000000000000000000000000001E+8
X-Hashcash: 1:20:141023:rientjes@google.com::szJfNM6V0LJ5R02u:0000000000000000000000000000000000000000001sxh
X-Hashcash: 1:20:141023:vishnu.ps@samsung.com::U3CloAdtjNJKOpWw:00000000000000000000000000000000000000001rDR
X-Hashcash: 1:20:141023:rohit.kr@samsung.com::46uAorPkB/2d//4k:000000000000000000000000000000000000000002GS+
X-Hashcash: 1:20:141023:pintu_agarwal@yahoo.com::b0JpLd3cyF39Gciy:000000000000000000000000000000000000002gwO
X-Hashcash: 1:20:141023:aquini@redhat.com::Nqhp8pv93TU+EntZ:000000000000000000000000000000000000000000002h1V
X-Hashcash: 1:20:141023:riel@redhat.com::rsNYJKoCOwWao0sk:0031mZ
X-Hashcash: 1:20:141023:pintu.k@samsung.com::/zuRiT8TMTU+zxiX:0000000000000000000000000000000000000000002vMA
X-Hashcash: 1:20:141023:aneesh.kumar@linux.vnet.ibm.com::B5LOxhUYFFpWIrRF:00000000000000000000000000000032Ng
X-Hashcash: 1:20:141023:mgorman@suse.de::LnAxh28XuWoXI6xQ:003czb
X-Hashcash: 1:20:141023:ed.savinay@samsung.com::+zKvuOibyxK72D5N:0000000000000000000000000000000000000003Dkz
X-Hashcash: 1:20:141023:cpgs@samsung.com::Ekbzcpbuhl6CNFIJ:03m9o
X-Hashcash: 1:20:141023:hannes@cmpxchg.org::ON+saDlZWbJXmYN1:00000000000000000000000000000000000000000003S61
X-Hashcash: 1:20:141023:m.szyprowski@samsung.com::YH5RnCDlkxrOFao2:00000000000000000000000000000000000003+Cm
X-Hashcash: 1:20:141023:pintu.k@samsung.com::qAyrO9aaiIKK7DwB:0000000000000000000000000000000000000000004B81
X-Hashcash: 1:20:141023:vbabka@suse.cz::hb3/d9/JyUKe2feK:0004mbJ
X-Hashcash: 1:20:141023:akpm@linux-foundation.org::ybikSn+fCzQtHUgh:0000000000000000000000000000000000004v6+
X-Hashcash: 1:20:141023:jmarchan@redhat.com::SaVbkH3QXFYNpmqw:0000000000000000000000000000000000000000005xUR
X-Hashcash: 1:20:141023:sasha.levin@oracle.com::ue87K/G67gwSBD5L:00000000000000000000000000000000000000066yG
X-Hashcash: 1:20:141023:lauraa@codeaurora.org::/fWGfNNN2NzBF91L:00000000000000000000000000000000000000006dlx
X-Hashcash: 1:20:141023:lcapitulino@redhat.com::2HX0GJywKHuOuo7J:000000000000000000000000000000000000000HHVJ
Date: Thu, 23 Oct 2014 19:01:02 +0200
Message-ID: <xa1tegtylnzl.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2014, Pintu Kumar wrote:
> When the system boots up, in the dmesg logs we can see
> the memory statistics along with total reserved as below.
> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>
> When CMA is enabled, still the total reserved memory remains the same.
> However, the CMA memory is not considered as reserved.
> But, when we see /proc/meminfo, the CMA memory is part of free memory.
> This creates confusion.
> This patch corrects the problem by properly subtracting the CMA reserved
> memory from the total reserved memory in dmesg logs.
>
> Below is the dmesg snapshot from an arm based device with 512MB RAM and
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


I'm not sure how Andrew would think about it, and I don't have strong
feelings, but I would consider a few changes:

> ---
> v2: Moved totalcma_pages extern declaration to linux/cma.h
>     Removed CONFIG_CMA while show cma-reserved, from page_alloc.c
>     Moved totalcma_pages declaration to page_alloc.c, so that if will be visible 
>     in non-CMA cases.
>  include/linux/cma.h |    1 +
>  mm/cma.c            |    1 +
>  mm/page_alloc.c     |    6 ++++--
>  3 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 0430ed0..0b75896 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -15,6 +15,7 @@
>  
>  struct cma;
>  
> +extern unsigned long totalcma_pages;

+#ifdef CONFIG_CMA
+extern unsigned long totalcma_pages;
+#else
+#  define totalcma_pages 0UL
+#endif

>  extern phys_addr_t cma_get_base(struct cma *cma);
>  extern unsigned long cma_get_size(struct cma *cma);
>  
> diff --git a/mm/cma.c b/mm/cma.c
> index 963bc4a..8435762 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	if (ret)
>  		goto err;
>  
> +	totalcma_pages += (size / PAGE_SIZE);
>  	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
>  		(unsigned long)base);
>  	return 0;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dd73f9a..ababbd8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
>  
>  unsigned long totalram_pages __read_mostly;
>  unsigned long totalreserve_pages __read_mostly;
> +unsigned long totalcma_pages __read_mostly;

Move this to cma.c.

>  /*
>   * When calculating the number of globally allowed dirty pages, there
>   * is a certain number of per-zone reserves that should not be
> @@ -5520,7 +5521,7 @@ void __init mem_init_print_info(const char *str)
>  
>  	pr_info("Memory: %luK/%luK available "
>  	       "(%luK kernel code, %luK rwdata, %luK rodata, "
> -	       "%luK init, %luK bss, %luK reserved"
> +	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
>  #ifdef	CONFIG_HIGHMEM
>  	       ", %luK highmem"
>  #endif
> @@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const char *str)
>  	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
>  	       codesize >> 10, datasize >> 10, rosize >> 10,
>  	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
> -	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
> +	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
> +	       totalcma_pages << (PAGE_SHIFT-10),
>  #ifdef	CONFIG_HIGHMEM
>  	       totalhigh_pages << (PAGE_SHIFT-10),
>  #endif
> -- 
> 1.7.9.5
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
