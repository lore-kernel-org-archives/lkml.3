Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaEACeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:34:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38132 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaEACeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:34:07 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-f3-5361b29e85bc
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 3/6] arm64: Add a description on 48-bit address space with
 4KB pages
Date: Thu, 01 May 2014 11:34:05 +0900
Message-id: <000301cf64e5$d27f9a20$777ece60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4fuUN9DBd72LRKqODu5hYk+6SA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zY915mxKDDd6/5bD4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M
	lnPz2QtWq1acfrqatYHxgUwXIyeHhICJxNp171ghbDGJC/fWs3UxcnEICSxjlNj0eQ8zTFHz
	hkWMEInpjBKt/a0sEM4fRolPU2axgVSxCWhKPLrbww6SEBHYwSgxee0iVhCHWeAho8TPt/vB
	ZgkLREr8nHgCrINFQFVi097PYMt5BSwlvh48yQhhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1b
	qJsUJHacfQ1WLyKgJ7G/8yszRI2IxL4X78BulRDo5JCYsOIxE8QyAYlvkw8BDeUASshKbDoA
	NUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	kMiesIPx3gHrQ4zJQOsnMkuJJucDE0NeSbyhsZmRhamJqbGRuaUZacJK4rxqj5KChATSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTAmuH8zMQwq0mefOenfl/i75+4KzFHekbfGs69AOqPYYbtN
	qvnreYYpIRdFdvyV23DwmYPX/5IbjH/zPkoncPO8u6nIb2nFlqJidqnpv1J8x+oTuxP+9f/5
	un/yzIV/9p44kGTsx1fE7skZqr91wvmPfKFnjAVSDr1n1rBP5WRhO7hsks93NQYlluKMREMt
	5qLiRABvD9r7AgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd15mxKDDZ73s1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjJZz89kLVqtWnH66mrWB8YFMFyMnh4SAiUTzhkWMELaY
	xIV769m6GLk4hASmM0q09reyQDh/GCU+TZnFBlLFJqAp8ehuDztIQkRgB6PE5LWLWEEcZoGH
	jBI/3+5nBqkSFoiU+DnxBFgHi4CqxKa9n1lBbF4BS4mvB08yQtiCEj8m32MBsZkFtCTW7zzO
	BGHLS2xe85YZ4iYFiR1nX4PViwjoSezv/MoMUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOG08k97BuKrB4hCjAAejEg/vBLbEYCHWxLLi
	ytxDjBIczEoivMFrgEK8KYmVValF+fFFpTmpxYcYk4E+ncgsJZqcD0xpeSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqOJQkd2of/j/rqB83rz3Qgyn5Wtn
	fcjUZ2Sd8lszXjSpNao8on3+dWWZ2E9513dvTF68ckPstkU/LH6+03Zf9/qbJ8/v41Nkf93V
	UZO7823CD74EDg292zzGlU8tqgO8pkqbMLbxSArJMDv6M57gjU0MKL0UrnCp70XYL6MTxhEH
	TjvaOO1RYinOSDTUYi4qTgQAJqLeaF8DAAA=
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


