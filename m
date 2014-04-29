Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaD2E7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:59:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64289 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbaD2E73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:59:29 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-30-535f31b0c728
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 4/7] arm64: Add a description on 48-bit address space with
 4KB pages
Date: Tue, 29 Apr 2014 13:59:27 +0900
Message-id: <000401cf6367$cc461500$64d23f00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZW2eAbGFg8AXTa+lWwFTtlSmrA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zA90NhvHBBn82sFj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAldG
	y7n57AWrVStOP13N2sD4QKaLkZNDQsBEonvNDjYIW0ziwr31QDYXh5DAMkaJjR2/mGCKTm+b
	ygSRWMQo8WjdZGYI5w+jxKLl91lBqtgENCUe3e1hB0mICOxglJi8dhEriMMs8JBR4ufb/cwg
	VcICkRLn9lxhAbFZBFQlXi25B9bNK2Ap0XX3IxuELSjxY/I9sBpmAS2J9TuPM0HY8hKb17xl
	hrhJQWLH2deMXYwcQNv0JC4s4oAoEZHY9+IdI8heCYFeDokTH84zQewSkPg2+RALSL2EgKzE
	pgNQYyQlDq64wTKBUWwWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P
	3cQIieu+HYw3D1gfYkwGWj+RWUo0OR+YFvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Mrw5JXjmf1Juz5V3Gx43JGaa5x9b2W2P/J37KC1yz0
	5mE61TJ/kfrFX9M6J83LXZa59ENazPd1LuvfhP3RSt7VEHTIuiH94dPyKpXJ525e0Z3HrH1h
	j0ik4blyn8L+t9m9j/MWCMw8as3nWzvh5tcwxkM9Z5REfnYG7w84rCJ+IP9XmubVI0uUWIoz
	Eg21mIuKEwFGdSRzAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAd31hvHBBn1XbCz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jRsu5+ewFq1UrTj9dzdrA+ECmi5GTQ0LAROL0tqlMELaY
	xIV769m6GLk4hAQWMUo8WjeZGcL5wyixaPl9VpAqNgFNiUd3e9hBEiICOxglJq9dxAriMAs8
	ZJT4+XY/M0iVsECkxLk9V1hAbBYBVYlXS+6BdfMKWEp03f3IBmELSvyYfA+shllAS2L9zuNM
	ELa8xOY1b5khblKQ2HH2NWMXIwfQNj2JC4s4IEpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsY
	WVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeNZ1I7GFc2WBxiFOBgVOLhNYiKCxZiTSwr
	rsw9xCjBwawkwsuhGR8sxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAhJZXEm9obGJmZGlk
	ZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYydX5ZUz2P+zyj+3aD2Z0luT87c
	rKsProQwhLIZnf3tVzI1x2j30w63Fp+VaQwcijqXmpdymm3JeZm54rKsz87zIVecP+yd27JV
	2TLt4BxrNY6v6w5vK7wh9OsC20H5mytr1QunHcwyWN2lK7qqmOv341eP1GJPttgrrd0X7Tm5
	97u3lPApdRElluKMREMt5qLiRADO7OqKXgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds memory layout and translation lookup information
about 48-bit address space with 4K pages. The description is based
on 4 levels of translation tables.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>
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


