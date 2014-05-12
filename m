Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbaELJlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:41:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaELJkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:40:53 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-5b-5370971caa3f
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v6 3/7] arm64: Add a description on 48-bit address space with
 4KB pages
Date: Mon, 12 May 2014 18:40:44 +0900
Message-id: <000201cf6dc6$3ed91500$bc8b3f00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9twy4x5T/oP+D3T6W2CYQtjtfEfQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zA12Z6QXBBo3fRS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	356DLAVNahUH195lbmBcI9vFyMkhIWAiMenDL1YIW0ziwr31bF2MXBxCAssYJRZ8n8IIUzTh
	xxx2iMR0RokH7XeYIJw/jBKLjk5hA6liE9CUeHS3B6xKRGAHo8TktYtYQRxmgYeMEj/f7mcG
	qRIWiJR4uOYaO4jNIqAqca9lJROIzStgKfHs1S92CFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r
	3jJD3KQgsePsa7D7RAT0JN5OWs8MUSMise/FO6i7Ozkkrm7WgNglIPFt8iGgmRxAcVmJTQeg
	xkhKHFxxg2UCo9gsJJtnIdk8C8nmWUg2LGBkWcUomlqQXFCclF5krFecmFtcmpeul5yfu4kR
	Etf9OxjvHrA+xJgMtH4is5Rocj4wLeSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkb9pQ/vT1uzeDefYltyiPj946ph0td2PD4quV7stJF/bAvj
	Wi81Tin1L+V+v5bYPi1Q6+nmWhuTxMa6x76x6OHRtRsbgu8k6HiuqP9gnDDXL+OgxPbTC/7P
	fL1H8IdOQ8/uqH2ufDmWt1znLtL/rKGeYXLFor7Ue7HNH3W/ndua9u7d5+/auk6JpTgj0VCL
	uag4EQBuqk87AQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQV2Z6QXBBsvnCVj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjH97DrIUNKlVHFx7l7mBcY1sFyMnh4SAicSEH3PYIWwx
	iQv31rN1MXJxCAlMZ5R40H6HCcL5wyix6OgUNpAqNgFNiUd3e9hBEiICOxglJq9dxAriMAs8
	ZJT4+XY/M0iVsECkxMM118DmsgioStxrWckEYvMKWEo8e/WLHcIWlPgx+R4LiM0soCWxfudx
	JghbXmLzmrfMEDcpSOw4+5oRxBYR0JN4O2k9M0SNiMS+F+8YJzAKzEIyahaSUbOQjJqFpGUB
	I8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC08UxqB+PKBotDjAIcjEo8vB8YCoKFWBPL
	iitzDzFKcDArifCKdAKFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y0vJK4g2NTcyMLI3M
	LIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTFgre7MqA0bmyb45N84HJLiVMg8
	X89vCyPP14LOeS8uv2+4dT4zZ2+3rhObWvo8/wflS64+5wn8a/GLjz2yw0Zzw7Ui2cVXleNy
	HVycanas62X9L/uoe2J9Uvf1n/Ur6xM2ZSVPVQ4OUPv6wUjywI3QaGUvZbl5qT/ny804l35H
	KpbxBnONpBJLcUaioRZzUXEiAFpB76VfAwAA
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
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 Documentation/arm64/memory.txt |   59 ++++++++++++++++++++++++++++++++++------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index d50fa61..4c720d6 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -8,10 +8,11 @@ This document describes the virtual memory layout used by the AArch64
 Linux kernel. The architecture allows up to 4 levels of translation
 tables with a 4KB page size and up to 3 levels with a 64KB page size.
 
-AArch64 Linux uses 3 levels of translation tables with the 4KB page
-configuration, allowing 39-bit (512GB) virtual addresses for both user
-and kernel. With 64KB pages, only 2 levels of translation tables are
-used but the memory layout is the same.
+AArch64 Linux uses either 3 levels or 4 levels of translation tables with
+the 4KB page configuration, allowing 39-bit (512GB) or 48-bit (256TB)
+virtual addresses, respectively, for both user and kernel. With 64KB
+pages, only 2 levels of translation tables, allowing 42-bit (4TB)
+virtual address, are used but the memory layout is the same.
 
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
+ffff7ffffbc00000	ffff7ffffbdfffff	   2MB		fixed mappings
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


