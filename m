Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaHMHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:09:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15513 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaHMHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:09:55 -0400
X-AuditID: cbfee691-b7f306d000003d81-a3-53eb0f39a71a
From: "vishnu.ps" <vishnu.ps@samsung.com>
To: mgorman@suse.de, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, oleg@redhat.com, riel@redhat.com,
        walken@google.com, jmarchan@redhat.com, davidlohr@hp.com,
        sasha.levin@oracle.com, gorcunov@gmail.com, luto@amacapital.net,
        dh.herrmann@gmail.com, mitchelh@codeaurora.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: cpgs@samsung.com, pintu.k@samsung.com, vishu13285@gmail.com,
        "vishnu.ps" <vishnu.ps@samsung.com>
Subject: [PATCH] Fix checkpatch error's for mm/mmap.c
Date: Wed, 13 Aug 2014 12:38:48 +0530
Message-id: <1407913728-13095-1-git-send-email-vishnu.ps@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkWteS/3WwwYUjuhZz1q9hs3h5SNNi
	yX1hi3mtR1ksbt94zm5x6s91Joubz+ewWFzeNYfN4t6a/6wWq9c2sFpMfveM0WLt/G1sFlv3
	tzJa9H0/zG7x98p6FovFR24zW0zpu8tosWXFQ1aLf5NqHYQ97r/5y+Jxua+XyWPnrLvsHgs2
	lXrs2raTyWPTp0nsHidm/GbxmHcy0OPj01ssHu/3XWXz6NuyitFj8+lqj8+b5AJ4o7hsUlJz
	MstSi/TtErgy5t7tZSpYpF0xf1MfcwPjX8UuRk4OCQETiW+PmtghbDGJC/fWs3UxcnEICSxl
	lDjTvY0Vpmjqs/2sEInpjBJrb69iBEkICfxhlFizzxzEZhPQlFi54A4TSJGIwA0miRl/3wCN
	5eBgFkiT6P+TC1IjLGAqsXrTRrBeFgFViSvTTzKBlPAKuEqc+C0CsUtBYtmXtcwgYyQEJnJI
	9C05yQJRLyDxbfIhFpB6CQFZiU0HmCHqJSUOrrjBMoFRcAEjwypG0dSC5ILipPQiU73ixNzi
	0rx0veT83E2MwIg7/e/ZxB2M9w9YH2JMBho3kVlKNDkfGLF5JfGGxmZGFqYmpsZG5pZmpAkr
	ifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4p0Xqo6/2alFWzkUlW/b8dig1Tlc7
	Zby3YG52fXSSx9YZJT6pVwoWHXqlKXVRUbLLLUPk8hcd3pn33Q+rfPlxJPO0+MXztstdrI+1
	ykQdjTv4fh7n4qIrMxiehTcLXL+0J+TAlC8ui2ZxLtmuOGFNZ7D7i3pWHQ7Ohacj1G+mx7K5
	7n5W9KFMiaU4I9FQi7moOBEAQwnMg84CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQV1L/tfBBu+Wy1vMWb+GzeLlIU2L
	JfeFLea1HmWxuH3jObvFqT/XmSxuPp/DYnF51xw2i3tr/rNarF7bwGox+d0zRou187exWWzd
	38po0ff9MLvF3yvrWSwWH7nNbDGl7y6jxZYVD1kt/k2qdRD2uP/mL4vH5b5eJo+ds+6yeyzY
	VOqxa9tOJo9Nnyaxe5yY8ZvFY97JQI+PT2+xeLzfd5XNo2/LKkaPzaerPT5vkgvgjWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB+lJJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmDH3bi9TwSLtivmb+pgbGP8qdjFyckgI
	mEhMfbafFcIWk7hwbz1bFyMXh5DAdEaJtbdXMYIkhAT+MEqs2WcOYrMJaEqsXHCHCaRIROAG
	k8SMv2/Yuxg5OJgF0iT6/+SC1AgLmEqs3rQRrJdFQFXiyvSTTCAlvAKuEid+i0DsUpBY9mUt
	8wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP5mfQOxlUNFocYBTgYlXh4d7i+
	ChZiTSwrrsw9xCjBwawkwuuwBSjEm5JYWZValB9fVJqTWnyI0RRo+URmKdHkfGCqySuJNzQ2
	MTc1NrU0sTAxs1QS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwOh27bv295IP1ka14paTY/fN
	4Jb6UZf/xmRGw7OgWR7/55i8euCR9eoc96vdKzucT7dxmF38/s7P6IXHvP/bxGLzbBanJKX7
	TBCotxJ7Vz6rkWv1TPZbG28H7p+4+ElSfUrxiviD6hkz2GuC6p9FStaU/5wcIyff+Sf3QufT
	s/L7xW8dNP7KH6fEUpyRaKjFXFScCACSW95//QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "vishnu.ps" <vishnu.ps@samsung.com>

Signed-off-by: vishnu.ps <vishnu.ps@samsung.com>
---
 mm/mmap.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 80217c9..5cce169 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -70,7 +70,7 @@ static void unmap_region(struct mm_struct *mm,
  * MAP_SHARED	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
  *		w: (no) no	w: (no) no	w: (yes) yes	w: (no) no
  *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *		
+ *
  * MAP_PRIVATE	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
  *		w: (no) no	w: (no) no	w: (copy) copy	w: (no) no
  *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
@@ -741,7 +741,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 			 * split_vma inserting another: so it must be
 			 * mprotect case 4 shifting the boundary down.
 			 */
-			adjust_next = - ((vma->vm_end - end) >> PAGE_SHIFT);
+			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
 			exporter = vma;
 			importer = next;
 		}
@@ -1010,7 +1010,7 @@ can_vma_merge_after(struct vm_area_struct *vma, unsigned long vm_flags,
 struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
 			unsigned long end, unsigned long vm_flags,
-		     	struct anon_vma *anon_vma, struct file *file,
+			struct anon_vma *anon_vma, struct file *file,
 			pgoff_t pgoff, struct mempolicy *policy)
 {
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
@@ -1036,7 +1036,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	 * Can it merge with the predecessor?
 	 */
 	if (prev && prev->vm_end == addr &&
-  			mpol_equal(vma_policy(prev), policy) &&
+			mpol_equal(vma_policy(prev), policy) &&
 			can_vma_merge_after(prev, vm_flags,
 						anon_vma, file, pgoff)) {
 		/*
@@ -1064,7 +1064,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 	 * Can this new request be merged in front of next?
 	 */
 	if (next && end == next->vm_start &&
- 			mpol_equal(policy, vma_policy(next)) &&
+			mpol_equal(policy, vma_policy(next)) &&
 			can_vma_merge_before(next, vm_flags,
 					anon_vma, file, pgoff+pglen)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
@@ -1235,7 +1235,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long flags, unsigned long pgoff,
 			unsigned long *populate)
 {
-	struct mm_struct * mm = current->mm;
+	struct mm_struct *mm = current->mm;
 	vm_flags_t vm_flags;
 
 	*populate = 0;
@@ -1263,7 +1263,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 
 	/* offset overflow? */
 	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
-               return -EOVERFLOW;
+		return -EOVERFLOW;
 
 	/* Too many mappings? */
 	if (mm->map_count > sysctl_max_map_count)
@@ -1921,7 +1921,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.align_mask = 0;
 	return vm_unmapped_area(&info);
 }
-#endif	
+#endif
 
 /*
  * This mmap-allocator allocates new areas top-down from below the
@@ -2321,13 +2321,13 @@ int expand_stack(struct vm_area_struct *vma, unsigned long address)
 }
 
 struct vm_area_struct *
-find_extend_vma(struct mm_struct * mm, unsigned long addr)
+find_extend_vma(struct mm_struct *mm, unsigned long addr)
 {
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 	unsigned long start;
 
 	addr &= PAGE_MASK;
-	vma = find_vma(mm,addr);
+	vma = find_vma(mm, addr);
 	if (!vma)
 		return NULL;
 	if (vma->vm_start <= addr)
@@ -2376,7 +2376,7 @@ static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *next = prev? prev->vm_next: mm->mmap;
+	struct vm_area_struct *next = prev ? prev->vm_next : mm->mmap;
 	struct mmu_gather tlb;
 
 	lru_add_drain();
@@ -2423,7 +2423,7 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
  * munmap path where it doesn't make sense to fail.
  */
-static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
+static int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	      unsigned long addr, int new_below)
 {
 	struct vm_area_struct *new;
@@ -2512,7 +2512,8 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
 
-	if ((len = PAGE_ALIGN(len)) == 0)
+	len = PAGE_ALIGN(len);
+	if (len == 0)
 		return -EINVAL;
 
 	/* Find the first overlapping VMA */
@@ -2558,7 +2559,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 		if (error)
 			return error;
 	}
-	vma = prev? prev->vm_next: mm->mmap;
+	vma = prev ? prev->vm_next : mm->mmap;
 
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
@@ -2690,10 +2691,10 @@ static inline void verify_mm_writelocked(struct mm_struct *mm)
  */
 static unsigned long do_brk(unsigned long addr, unsigned long len)
 {
-	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * vma, * prev;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma, *prev;
 	unsigned long flags;
-	struct rb_node ** rb_link, * rb_parent;
+	struct rb_node **rb_link, *rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
 
-- 
1.8.3.2

