Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3EBIAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:00:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23372 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EBIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:00:49 -0400
X-AuditID: cbfee690-b7f136d000000fea-ca-51821d2c9f19
Date: Thu, 02 May 2013 08:00:35 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] MIPS: Fix build error crash_dump.c file.
To: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130502075832647@eunb.song
Msgkey: 20130502075832647@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130502075832647@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <21270808.191281367481634509.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+Ztq6ObFOgwf4rLBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj9rQ9jAXz2CoOPTnH1MDYwtbFyMkhJKAi0fL/OyOILSFgIrG5
	eSY7hC0mceHeeqAaLqCaZYwS/442MsMUXV9xnREiMZ9RonfdMqYuRg4OFqBJM34ngNSwCWhL
	vP3ygBXEFhawlFjVOxXMFhHIkti7ZRHYHGYBR4lHl+8wQxwhLzH59GWwxbwCghInZz5hARkp
	IaAksXRxHYjJK6AscWciD8QFEhKzpl9ghbB5JWa0P2WBsOUkpn1dA3WltMT5WRsYYV5Z/P0x
	VJxf4tjtHUwQ03klntwPhhmze/MXNghbQGLqmYNQreoSR2b+gRrPJ7Fm4VsWmDG7Ti1nhum9
	v2UuE8RTihJTuh+yQ9haEl9+7GND9RQ7kO0i0VozgVF5FpLELCTNs5A0I6tZwMiyilE0tSC5
	oDgpvchErzgxt7g0L10vOT93EyMkHUzYwXjvgPUhxmRgbExklhJNzgemk7ySeENjMyMLUxNT
	YyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MFqrVz14ed7iqd/sf/vq
	Du5491Lj+IY5axrbTv34eperhe9OSM25kxobN8w9prZ0s2DD7ec/D7uFfL8o3Ln63CLrwOgH
	fRy3IuvD/HPkNq9/x7psgptsIk+DnI6jXtTcfd1fjm4/yexqqCHBOKfB5Prvo4savhTwqq9v
	75JLWf1qX1zx/uOBxReUWIozEg21mIuKEwGurGQsHQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsVy+t/t6brKsk2BBv8XaFtc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jNnT9jAWzGOrOPTkHFMDYwtbFyMnh5CAikTL/++MILaEgInE9RXXoWwxiQv31gPVcAHVzGeU
	6F23jKmLkYODBahhxu8EkBo2AW2Jt18esILYwgKWEqt6p4LZIgJZEnu3LGIGsZkFHCUeXb7D
	DLFLXmLy6cvsIDavgKDEyZlPWEBGSggoSSxdXAdi8gooS9yZyANxgYTErOkXWCFsXokZ7U9Z
	IGw5iWlf1zBD2NIS52dtgLt48ffHUHF+iWO3dzBBTOeVeHI/GGbM7s1f2CBsAYmpZw5CtapL
	HJn5B2o8n8SahW9ZYMbsOrWcGab3/pa5TBBPKUpM6X7IDmFrSXz5sY8N1VPsQLaLRGvNBEa5
	WUgSs5A0z0LSjKxmASPLKkbR1ILkguKk9AoTveLE3OLSvHS95PzcTYzgxPRsyQ7GhgvWhxgF
	OBiVeHg/6DYGCrEmlhVX5h5ilOBgVhLhXfAaKMSbklhZlVqUH19UmpNafIgxGRh3E5mlRJPz
	gUkzryTe0NjA2NDQ0tzA1NDIgjRhJXHeZ63WgUIC6YklqdmpqQWpRTBbmDg4pRoYc8/W+t3p
	+2IcV8pg2/f26so7d70e+J7bdi+NpSdQWqvcQivja6v/5udBq/9bT1t00v857w/du6ueHL5a
	f8Dm1on53yryeM2mppZpzuu8cPsWS2zAh2kmnSltIQtfxKm43mYoSdj3S7ZCjuFO9HGd6HPn
	TjIU3zu9rPDo2sO7OA4fDvovbTBjlRJLcUaioRZzUXEiAIfw+rSQAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4280v39002586


This patch fixes crash_dump.c build error.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/kernel/crash_dump.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
index 35bed0d..3be9e7b 100644
--- a/arch/mips/kernel/crash_dump.c
+++ b/arch/mips/kernel/crash_dump.c
@@ -2,6 +2,7 @@
 #include <linux/bootmem.h>
 #include <linux/crash_dump.h>
 #include <asm/uaccess.h>
+#include <linux/slab.h>
 
 static int __init parse_savemaxmem(char *p)
 {
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
