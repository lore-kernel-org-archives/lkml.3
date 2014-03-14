Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaCNFDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:03:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55877 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaCNFDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:03:08 -0400
X-AuditID: cbfee68e-b7f566d000002344-93-53228d8ae2e6
Date: Fri, 14 Mar 2014 14:03:05 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v11 05/27] iommu/exynos: remove prefetch buffer setting
Message-id: <20140314140305.f95a18dbef5fbccaa3f97b94@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zY92uXqVgg78LlSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mr4duonU8E2vorZOzrZGhifc3cxcnJICJhItJ+/zQhh
	i0lcuLeerYuRi0NIYBmjxNI1p1hhipad/cICkZjOKPF363EmCGcyk8SW1U/AqlgEVCX+7NvO
	DmKzCWhJrJ57nBGkSESgjUnia+MhsHZmgbnMEs/WPgXrEBZwl5i69B+YzSvgKPHk6DeoQywk
	LjR1sEPEBSV+TL7HAmIzA03dvK2JFcKWl9i85i0zyFAJgV4OiX2fVkOdISDxbTLINg6ghKzE
	pgPMEDMlJQ6uuMEygVFkFpKxs5CMnYVk7AJG5lWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsY
	IRHct4Px5gHrQ4zJQCsnMkuJJucDE0BeSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBUSlx71Kmh3vlDVqPjKfNwycyg5C8C709slfCYMjWwoLX1
	j2G0u5THP8nw/wGs3+XWqxSd0XqzTIUvY+GmTYohS35NvxQ/aYLXu61cEXcV33WkHZK4Zper
	unDO9s6dt/dsvXNl4eo1F9SD5kxgM+CL7l114ZqmyAqnwgk+FXc+6U0X0jTMPzpJiaU4I9FQ
	i7moOBEAmNmQl/YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jQd2uXqVgg4WvZSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8e3UT6aCbXwV
	s3d0sjUwPufuYuTkkBAwkVh29gsLhC0mceHeerYuRi4OIYHpjBJ/tx5ngnAmM0lsWf2EFaSK
	RUBV4s++7ewgNpuAlsTquccZQYpEBNqYJL42HmIBcZgF5jJLPFv7FKxDWMBdYurSf2A2r4Cj
	xJOj3xgh9llIXGjqYIeIC0r8mHwP7A5moKmbtzWxQtjyEpvXvGWewMg3C0nZLCRls5CULWBk
	XsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnB6eSe1gXNlgcYhRgINRiYfX4bBisBBrYllx
	Ze4hRgkOZiUR3qoIpWAh3pTEyqrUovz4otKc1OJDjMlAf09klhJNzgemrrySeENjEzMjSyMz
	CyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYMxMXVkXGrSuY8qsV1xWTk6Nezcu
	1hB/IfnngcfhdR3/7+3LkvsUJf6RXeZWodWqu9JTji92br1wYHHxo6n/lr7uNc/RFlr8IvCp
	55LNvkLJLKp1b1efuN1/u/m885RjnNMU/nXeeqaxX+pPr7Ld+a+7XslYVnZcSGT9zsj/ieXE
	YcVJ/6s2hX9XYinOSDTUYi4qTgQAtb7PM1MDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefetch buffer is a cache of System MMU 3.x and caches a block of
page table entries to make effect of larger page with small pages.
However, how to control prefetch buffers and the specifications of
prefetch buffers different from minor versions of System MMU v3.
Prefetch buffers must be controled with care because there are some
restrictions in H/W design.

The interface and implementation to initiate prefetch buffers will
be prepared later.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0d26aeb..647fc46 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -244,13 +244,6 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
-{
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
-}
-
 static void __set_fault_handler(struct sysmmu_drvdata *data,
 					sysmmu_fault_handler_t handler)
 {
@@ -424,15 +417,6 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	for (i = 0; i < data->nsfrs; i++) {
 		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
-		}
-
 		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
 
-- 
1.7.9.5

