Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDPEew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:34:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41810 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbaDPEdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:23 -0400
X-AuditID: cbfee68f-b7f156d00000276c-fd-534e0812b140
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 4/7] arm64: Add a description on 48-bit address space with
 4KB pages
Date: Wed, 16 Apr 2014 13:33:22 +0900
Message-id: <004401cf592c$ffcea6c0$ff6bf440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZK1QkdPn2OPyGRe2yIuH/xskgSA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI10hDr9ggxVnhSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	zaR5LAUXVCqaP85namDsl+li5OSQEDCROPxoCxOELSZx4d56ti5GLg4hgWWMEkc7vjHBFD05
	u4gVIjGdUeLs8QMsEM4foKq3j1lAqtgENCUe3e1hB0mICOxglJi8FqKFWeAho8TPt/uZuxg5
	OIQFIiV2TE0GaWARUJU4eeMwWDOvgKXE5GXHGCFsQYkfk++BxZkFtCTW7zzOBGHLS2xe85YZ
	4iQFiR1nX4PViwjoSTxrO8cKUSMise/FO0aQvRICvRwSx/7dYIRYJiDxbfIhFpAbJARkJTYd
	gJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4m
	Rkhc9+9gvHvA+hBjMtD6icxSosn5wLSQVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoYJ74/uenxpMWr5pVF3EzbsuCP5u07UyzXTVVdkOF0Y5ex
	+RwtnV1HRBaKT9io83P2v4h0V2EvQ67J5yL8w5vLK6yir7x0nFNru3X/7Jp7t0JnTf+XcsJB
	xOXRLxc/w0v5PxqMbvyaeevrrFUZ7M22cY0yfK87A4w/vcp/+jCMt/WJ0eTpZYlRjkosxRmJ
	hlrMRcWJAGr5xysBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV0hDr9gg2X3eC3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxppJ81gKLqhUNH+cz9TA2C/TxcjJISFgIvHk7CJWCFtM
	4sK99WxdjFwcQgLTGSXOHj/AAuH8YZQ4+vYxC0gVm4CmxKO7PewgCRGBHYwSk9eCtHNxMAs8
	ZJT4+XY/cxcjB4ewQKTEjqnJIA0sAqoSJ28cBmvmFbCUmLzsGCOELSjxY/I9sDizgJbE+p3H
	mSBseYnNa94yQ5ykILHj7GuwehEBPYlnbedYIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsY
	WVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeNZ9I7GFc1WBxiFOBgVOLhnZnjGyzEmlhW
	XJl7iFGCg1lJhPfLF6AQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wMTWl5JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MHpsLqtxiJI1KxM6XMhSWl8ioPom
	YOWtX16a/c+1/v35a/Q1d5r9U9c9r7YdbA5cq3jbSyk+9bLNNbFD4Ud4/BecCY68nZewpWRr
	qMuDtc2Xm3ZNf7M/v6M+LL1mkTD/zn9zfr99f0wqLX2lrpDh11uPzLd03dW5c7N0+td3CWc3
	uTNxfH7QVKDEUpyRaKjFXFScCABX8h9iXgMAAA==
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


