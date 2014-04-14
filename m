Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaDNHoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:44:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39312 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaDNHk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:58 -0400
X-AuditID: cbfee68f-b7f156d00000276c-76-534b91084bed
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 5/8] arm64: Add a description on 48-bit address space with 4KB
 pages
Date: Mon, 14 Apr 2014 16:40:55 +0900
Message-id: <000301cf57b4$de8ff5a0$9bafe0e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrWAnog1B0tGOQbOovQyIBlUzDA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zA12Oid7BBvP6uSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzeLDjJWMDtwea+at
	YfT4/WsSo8eda3vYPM5vWsPssXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlrJk0j6Xg
	gkpF88f5TA2M/TJdjJwcEgImEs9mTGGCsMUkLtxbz9bFyMUhJLCMUeLsg/WsMEVTT+5kgUhM
	Z5TYs+I7VNUfRolT+7tYQKrYBDQlHt3tYQdJiAjsYJSYvHYRK4jDLHCCUWLpnbVgs4QFwiQa
	JqxkBLFZBFQldvQcBLN5BSwlJizsZ4OwBSV+TL4HNpVZQEti/c7jTBC2vMTmNW+ZIW5SkNhx
	9jVYr4iAnsSeX93sEDUiEvtevGMEWSwh0MghcXjnTSaIZQIS3yYfAhrKAZSQldh0AGqOpMTB
	FTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCHx3L+D
	8e4B60OMyUDrJzJLiSbnA9NBXkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpgVNxeU1/Q9HqHj57DBvGEubZrXvgKWzrl33jWmCf7f1Huxqbn0Vbr
	f77Ll9sksqphUZ68mxuboJD3i58brPjnLn5qlFE5WW7j1jb/FW/2TJofbDCjN9MoPl90F/ex
	m2dTJ3nOU01Z3Rv/wO36+QbHjb/uBLVJyu495Xrf1vvMz2d+VuK7L10QUGIpzkg01GIuKk4E
	AAVQtdD9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQV2Oid7BBjMPsFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLFm0jyWggsqFc0f5zM1MPbLdDFyckgImEhMPbmTBcIWk7hwbz1b
	FyMXh5DAdEaJPSu+Qzl/GCVO7e8Cq2IT0JR4dLeHHSQhIrCDUWLy2kWsIA6zwAlGiaV31rKC
	VAkLhEk0TFjJCGKzCKhK7Og5CGbzClhKTFjYzwZhC0r8mHwPbCqzgJbE+p3HmSBseYnNa94y
	Q9ykILHj7GuwXhEBPYk9v7rZIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBCeLZ1I7GFc2WBxiFOBgVOLhTdjuGSzEmlhWXJl7iFGCg1lJ
	hHdbhlewEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDE1leSbyhsYmZkaWRmYWRibk5acJK
	4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCmrf8wWf9LaoR/zrbEUOatfwsX8xS4iqQUS8yL
	1PQ55shuLy2uPXuJubKPzYKlgvZVIpP9lkS231PlelJ+60uMudKzJ+ZGeloLjfVfFAWc/jpn
	x8LGutWOz95em7k2MS55ffOeAEblDpe4WO7k05tlRa88r/Kc8SX90beI2kW6uwpWfby1JkiJ
	pTgj0VCLuag4EQDIVUg/WgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds memory layout and translation lookup information
about 48-bit address space with 4K pages. The description is based
on 4 levels of translation tables.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 Documentation/arm64/memory.txt |   59 ++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index d50fa61..8142709 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -8,10 +8,11 @@ This document describes the virtual memory layout used by the AArch64
 Linux kernel. The architecture allows up to 4 levels of translation
 tables with a 4KB page size and up to 3 levels with a 64KB page size.
 
-AArch64 Linux uses 3 levels of translation tables with the 4KB page
-configuration, allowing 39-bit (512GB) virtual addresses for both user
-and kernel. With 64KB pages, only 2 levels of translation tables are
-used but the memory layout is the same.
+AArch64 Linux uses 3 levels and 4 levels of translation tables with
+the 4KB page configuration, allowing 39-bit (512GB) and 48-bit (256TB)
+virtual addresses, respectively, for both user and kernel. With 64KB
+pages, only 2 levels of translation tables are used but the memory layout
+is the same.
 
 User addresses have bits 63:39 set to 0 while the kernel addresses have
 the same bits set to 1. TTBRx selection is given by bit 63 of the
@@ -21,7 +22,7 @@ The swapper_pgd_dir address is written to TTBR1 and never written to
 TTBR0.
 
 
-AArch64 Linux memory layout with 4KB pages:
+AArch64 Linux memory layout with 4KB pages + 3 levels:
 
 Start			End			Size		Use
 -----------------------------------------------------------------------
@@ -48,7 +49,34 @@ ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 ffffffc000000000	ffffffffffffffff	 256GB		kernel logical memory map
 
 
-AArch64 Linux memory layout with 64KB pages:
+AArch64 Linux memory layout with 4KB pages + 4 levels:
+
+Start			End			Size		Use
+-----------------------------------------------------------------------
+0000000000000000	0000ffffffffffff	 256TB		user
+
+ffff000000000000	ffff7bfffffeffff	~124TB		vmalloc
+
+ffff7bffffff0000	ffff7bffffffffff	  64KB		[guard page]
+
+ffff7c0000000000	ffff7dffffffffff	   2TB		vmemmap
+
+ffff7e0000000000	ffff7ffffbbfffff	  ~2TB		[guard, future vmmemap]
+
+ffff7ffffa000000	ffff7ffffaffffff	  16MB		PCI I/O space
+
+ffff7ffffb000000	ffff7ffffbbfffff	  12MB		[guard]
+
+ffff7ffffbc00000	ffff7ffffbdfffff	   2MB		earlyprintk device
+
+ffff7ffffbe00000	ffff7ffffbffffff	   2MB		[guard]
+
+ffff7ffffc000000	ffff7fffffffffff	  64MB		modules
+
+ffff800000000000	ffffffffffffffff	 128TB		kernel logical memory map
+
+
+AArch64 Linux memory layout with 64KB pages + 2 levels:
 
 Start			End			Size		Use
 -----------------------------------------------------------------------
@@ -75,7 +103,7 @@ fffffdfffc000000	fffffdffffffffff	  64MB		modules
 fffffe0000000000	ffffffffffffffff	   2TB		kernel logical memory map
 
 
-Translation table lookup with 4KB pages:
+Translation table lookup with 4KB pages + 3 levels:
 
 +--------+--------+--------+--------+--------+--------+--------+--------+
 |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
@@ -90,7 +118,22 @@ Translation table lookup with 4KB pages:
  +-------------------------------------------------> [63] TTBR0/1
 
 
-Translation table lookup with 64KB pages:
+Translation table lookup with 4KB pages + 4 levels:
+
++--------+--------+--------+--------+--------+--------+--------+--------+
+|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
++--------+--------+--------+--------+--------+--------+--------+--------+
+ |                 |         |         |         |         |
+ |                 |         |         |         |         v
+ |                 |         |         |         |   [11:0]  in-page offset
+ |                 |         |         |         +-> [20:12] L3 index
+ |                 |         |         +-----------> [29:21] L2 index
+ |                 |         +---------------------> [38:30] L1 index
+ |                 +-------------------------------> [47:39] L0 index
+ +-------------------------------------------------> [63] TTBR0/1
+
+
+Translation table lookup with 64KB pages + 2 levels:
 
 +--------+--------+--------+--------+--------+--------+--------+--------+
 |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
-- 
1.7.10.4


