Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaDRICA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:02:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13915 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaDRH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:14 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-7e-5350db519ecf
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 4/7] arm64: Add a description on 48-bit address space with
 4KB pages
Date: Fri, 18 Apr 2014 16:59:13 +0900
Message-id: <000501cf5adc$169481d0$43bd8570$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a1KpVB7pp4fCcRlCvLn7QlnuhnQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI93A2wHBBkd+6ln8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	mknzWAouqFQ0f5zP1MDYL9PFyMkhIWAi8WTGTjYIW0ziwr31QDYXh5DAMkaJ+z9XM8MU7Wq+
	zAKRmM4o8ebnCijnD6PE2U+vwdrZBDQlHt3tYQdJiAjsYJSYvHYRK4jDLPCQUeLn2/1gs4QF
	IiUunJvOBGKzCKhKLN91HszmFbCUuHJ5EjOELSjxY/I9FhCbWUBLYv3O40wQtrzE5jVvoW5S
	kNhx9jVjFyMH0DY9if3N7hAlIhL7XrxjBNkrIdDJIfGuqw9ql4DEt8mHWEDqJQRkJTYdgBoj
	KXFwxQ2WCYxis5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkhc
	9+5gvH3A+hBjMtD6icxSosn5wLSQVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2M2i5Td+zpvrdANuD1xAt7tt543Dt7esutR/m3ozyZPy6dnHNJ
	Vr67eT2TeuEhdrlwiQrXFewnvnEd9Pw+5dDeWVN4hRoMVIUsZ8WzvpcrnmelWledOTMuboVI
	hfjduU9Py6hxiS9pfbTVQGjzBUaLuv/Pjq6du3Nax9y9qTH3ea1EuVm/ZeXOUmIpzkg01GIu
	Kk4EAGnpLSQBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQd3A2wHBBhP/aFr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjDWT5rEUXFCpaP44n6mBsV+mi5GTQ0LARGJX82UWCFtM
	4sK99WxdjFwcQgLTGSXe/FzBAuH8YZQ4++k1G0gVm4CmxKO7PewgCRGBHYwSk9cuYgVxmAUe
	Mkr8fLufGaRKWCBS4sK56UwgNouAqsTyXefBbF4BS4krlycxQ9iCEj8m3wPbzSygJbF+53Em
	CFteYvOat8wQNylI7Dj7mrGLkQNom57E/mZ3iBIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJG
	llWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwUnjmfQOxlUNFocYBTgYlXh4dxwMCBZiTSwr
	rsw9xCjBwawkwqtcChTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGBCyyuJNzQ2MTOyNDKz
	MDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRl/Gi+lFR3gDlP9ptCzeda6qNDpr
	UdadYxZOXXnz+VR9AubNkf50KOLVhopc0U9LZ3wsPtLf80Xm31mxiakR/2pXyFWJ3dk52Wbb
	k52Lc+/6NNY//CdxYr/Hke0aX4UuS9kHZdk8fHLAQYnpSfjOkGCJOuk9PGoxew8H5btVTHK1
	PPbxJYv4NiWW4oxEQy3mouJEAKvSGQReAwAA
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


