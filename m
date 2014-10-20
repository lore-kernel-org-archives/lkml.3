Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaJTHl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:41:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13612 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaJTHlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:41:24 -0400
X-AuditID: cbfee691-f79b86d000004a5a-70-5444bc91fbc0
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, riel@redhat.com,
        mgorman@suse.de, vdavydov@parallels.com, nasa4836@gmail.com,
        ddstreet@ieee.org, m.szyprowski@samsung.com, pintu.k@samsung.com,
        mina86@mina86.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, lauraa@codeaurora.org,
        gioh.kim@lge.com, rientjes@google.com, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: cpgs@samsung.com, pintu_agarwal@yahoo.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: [PATCH] mm: cma: split cma-reserved in dmesg log
Date: Mon, 20 Oct 2014 13:03:10 +0530
Message-id: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTYRjHe3fOzo7S4LS0XhVDzIqkLC/TV7SIFHm/WEHiB/ugax1UvLJN
	SfSDZa1mOqYz0hIbXsj7dFpahukUVEwypqUOzTJn5q3rVGarudG338P/z///wPPQhGCMdKeT
	02WsJF2U6k05k80uQbknS15Gxpz+KPdFldpmCi2sVJFoWX8cjct7SFTdo+Eg081fADXpolHD
	vQIKdSnKecjwopJCc81/uahlcJaH1OsmgDRDt7hI/kZFIeXmAA+Z14w89GdCSyJ5bTsHLRXc
	JlHNoJFAj24oATI8rSBQmXIWnIN4YHWDwAZlMQc/fzjLwxpdFl5U9XOw7kcpDxeuTXDwcLmF
	xPP6DhK37nzl4O+LMyQeqdqm8EbvJIWVnY0Av9YM8nDHaO4lQZxz+DU2NTmblZw6m+CcNNau
	A5kzbtenPu2AfLDiUgicaMgEwTJTJ+XgA3B8TmtjZ1rA1AE48uo977+pylTLdQjVAN4fKgeO
	oYgD7/zcArsuijkGt1YtdsGF0RJQW7dlzyUYGVwyDtp5PxMK5cZ+O5PMEbhgsXJ3mc9EQNVI
	m41pW50XrCwN382BzDANp59NEA4/A81qPenweEJdH+HYzg3210+RKrBPA/Y0Alc2U5wpvZoo
	EfpJRWnSrPREP3FGmg7YrjxqNZV0gw99YXrA0MB7L787ODJGwBVlS3PS9EBoaygh3F3FGbbH
	SJfF+wcGByBhkDAwICQ02Psg/4TH9mUBkyiSsSksm8lK4iVZqaxUDzi0k3s+aKCUZzSPI8wL
	fI8vzIMAmu0yoAoz1eFecWEbj6VEtw1xf3up571c7l6cyDpfMx9V3xSrSrSYrbdTxetrBeJh
	vmeeYWpzUqk4FKcOSpOxRdNHr8R+e2INaTRYD7cOfPaJKlUkSGLfFbfk+SiXa8Pe5nYrmp2C
	e3PFxaIcBdeblCaJ/H0JiVT0D5ZZ0pXgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAd2Je1xCDHra5C3mrF/DZvH49TwW
	i5eHNC0utO1msVi0ewGTxbOmL4wWqzf5Wqzsbmaz2N45g93i8q45bBb31vxntVh75C67xeR3
	zxgtFhxvYbVoOz+BzaLv+2F2i29vb7Nb/L2ynsWibclGJovnza0sFouP3Ga2mN3Yx2hxeetM
	ZospfXcZHSQ8Dr95z+xxua+XyWPnrLvsHgs2lXo8nXCQyWPTp0nsHl1vrzB5nJjxm8XjwaHN
	LB7r/rxi8vj49BaLx8l5P9k83u+7yubRt2UVo8eZBUfYPTafrg4QimpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBBoiSQlliTilQKCCxuFhJ3w7T
	hNAQN10LmMYIXd+QILgeIwM0kLCGMePsxk2MBbckK248+sPYwPhapIuRk0NCwERi3rMlrBC2
	mMSFe+vZuhi5OIQEFjFKTD0+gxHC6WGSaP/8gxGkik1AXeLHm99gCRGB9cwS65f+YANJMAuU
	SDy/fQTMFhawlGi7fRDMZhFQlXj8+x/YCl4BZ4kJJzcA2RxA6xQk5kyymcDIvYCRYRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcKJ4JrWDcWWDxSFGAQ5GJR7eHWYuIUKsiWXFlbmHGCU4
	mJVEeP9lAIV4UxIrq1KL8uOLSnNSiw8xmgItn8gsJZqcD0xieSXxhsYm5qbGppYmFiZmlkri
	vAdarQOFBNITS1KzU1MLUotg+pg4OKUaGKWq/N4cfZ+3hqHy5etVM3WO+99rk2lnKtEt9PlS
	9GVGVajzwUpFz3dud5PXT/Drn/2urCRbfuWiK+avG7aYv3zXZ/x15u1pIaolW/Z/Mj/afLdr
	YfXxyivROsI1a44/Dyj59kHguljTPUYHybU1gRx9XsncXm1bzXuZ7LlUrlWx/dV/eTolQoml
	OCPRUIu5qDgRAGztki0qAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system boots up, in the dmesg logs we can see
the memory statistics along with total reserved as below.
Memory: 458840k/458840k available, 65448k reserved, 0K highmem

When CMA is enabled, still the total reserved memory remains the same.
However, the CMA memory is not considered as reserved.
But, when we see /proc/meminfo, the CMA memory is part of free memory.
This creates confusion.
This patch corrects the problem by properly substracting the CMA reserved
memory from the total reserved memory in dmesg logs.

Below is the dmesg snaphot from an arm based device with 512MB RAM and
12MB single CMA region.

Before this change:
Memory: 458840k/458840k available, 65448k reserved, 0K highmem

After this change:
Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K highmem

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 include/linux/swap.h | 3 +++
 mm/cma.c             | 2 ++
 mm/page_alloc.c      | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 37a585b..beb84be 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -295,6 +295,9 @@ static inline void workingset_node_shadows_dec(struct radix_tree_node *node)
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
+#ifdef CONFIG_CMA
+extern unsigned long totalcma_pages;
+#endif
 extern unsigned long dirty_balance_reserve;
 extern unsigned long nr_free_buffer_pages(void);
 extern unsigned long nr_free_pagecache_pages(void);
diff --git a/mm/cma.c b/mm/cma.c
index 963bc4a..73fe7be 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -45,6 +45,7 @@ struct cma {
 static struct cma cma_areas[MAX_CMA_AREAS];
 static unsigned cma_area_count;
 static DEFINE_MUTEX(cma_mutex);
+unsigned long totalcma_pages __read_mostly;
 
 phys_addr_t cma_get_base(struct cma *cma)
 {
@@ -288,6 +289,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	if (ret)
 		goto err;
 
+	totalcma_pages += (size / PAGE_SIZE);
 	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
 	return 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd73f9a..c6165ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5521,6 +5521,9 @@ void __init mem_init_print_info(const char *str)
 	pr_info("Memory: %luK/%luK available "
 	       "(%luK kernel code, %luK rwdata, %luK rodata, "
 	       "%luK init, %luK bss, %luK reserved"
+#ifdef CONFIG_CMA
+		", %luK cma-reserved"
+#endif
 #ifdef	CONFIG_HIGHMEM
 	       ", %luK highmem"
 #endif
@@ -5528,7 +5531,12 @@ void __init mem_init_print_info(const char *str)
 	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
 	       codesize >> 10, datasize >> 10, rosize >> 10,
 	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
+#ifdef CONFIG_CMA
+	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
+	       totalcma_pages << (PAGE_SHIFT-10),
+#else
 	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
+#endif
 #ifdef	CONFIG_HIGHMEM
 	       totalhigh_pages << (PAGE_SHIFT-10),
 #endif
-- 
1.8.3.2

