Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaAQJys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:54:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19417 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQJyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:54:44 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-3e-52d8fde276b2
From: =?ks_c_5601-1987?B?wMzBpL3C?= <js07.lee@samsung.com>
To: catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [Q] L1_CACHE_BYTES on flush_pfn_alias function.
Date: Fri, 17 Jan 2014 18:54:42 +0900
Message-id: <00d501cf136a$24ec49c0$6ec4dd40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8Tahj5OEqxX1EZTsyyOeqFYBqOHw==
Content-language: ko
X-OriginalArrivalTime: 17 Jan 2014 09:54:42.0425 (UTC)
 FILETIME=[24F0B690:01CF136A]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkQPfR3xtBBhsPmFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtoXr2ArOc1c8ONjI2sC4j7OLkZNDQsBE4uCR7ewQtpjEhXvr
	2UBsIYGljBKfGrNhatoe32aEiC9ilDi2J7SLkQvI3s8k8ej5IVYIB6jh2tQTYN1sAlYSH3+d
	ArNFBBwlnpxcwQpiMwtYSOycvp0JxBYGslumzmMBsVkEVCUOTFoLVsMrYCmx8N1EJghbUOLH
	5HssEL0GEu9n9UHN0ZZ48u4CK8R1ChI7zr5mhNilJ3Hq6zJ2iBoRiX0v3kFdrSzx+XQvI0R9
	qMTSNpA4F5C9jF3i7sRjzBBHCEh8m3wIaBkHUEJWYtMBZoh6SYmDK26wTGCUnIXkpFlITpqF
	5KRZSFYvYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYc6f/PevdwXj7gPUhxmSg9ROZ
	pUST84Exm1cSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjHb7/VJz7k5aK+n7aP+P5EdBJ25JeST+OHzG5l341yXFio3Lrc6+9Xr66jYrN8OswvID
	Hx56HBZk8el/HcGttjWqv5T90dkXzSIurNnLggLbcz33/by+bf85MeZ7D5+taj8ZZfTH7f/2
	jKnrdnMuWWEwacG+sodu8sphTkrrz3A3m2ZvvaXu5aDEUpyRaKjFXFScCADwQwhlzwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAd1Hf28EGTy4p2txedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM9oWrmMrOM9d8eBgI2sD
	4z7OLkZODgkBE4m2x7cZIWwxiQv31rOB2EICixglju0J7WLkArL3M0k8en6IFcJZyihxbeoJ
	sCo2ASuJj79OgdkiAo4ST06uYAWxmQUsJHZO384EYgsD2S1T57GA2CwCqhIHJq0Fq+EVsJRY
	+G4iE4QtKPFj8j0WiF4Difez+qDmaEs8eXeBFeI6BYkdZ18zQuzSkzj1dRk7RI2IxL4X7xgh
	rlaW+Hy6F+qbUImlbe8YJzAKz0KyYhaSFbOQrJiFZNQCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMEx/UxqB+PKBotDjAIcjEo8vBLiN4KEWBPLiitzDzFKcDArifBuvQkU4k1JrKxK
	LcqPLyrNSS0+xJgMDIGJzFKiyfnAdJNXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU
	7NTUgtQimC1MHJxSDYxzk04dZNg38aSmXhHTQpuYn7zLVs8zv1Di25x+T/pDhJG10KUjHU+D
	Lp/3dJmQXpfJFPb/ztTL8mqvU555zu9pshdytr4/+/B1pfiPSan5s4qXbW9nn7ZuVfDc4yHn
	c3ccO/JtMsPEl3/61tcG292afUo58vmrqm/72Ze9FbxzZP8L0wfdi1pUlViKMxINtZiLihMB
	vHPwGy0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Follow the mailing-list
http://comments.gmane.org/gmane.linux.ports.arm.omap/31686

>>Setting the L1 cache line size larger than it actually is should be safe.

the written code expected as L1_CACHE_BYTES should be real cache line size
has bug.
It looks like that flush_pfn_alias function should be fixed.

Anybody to have another opinion?

Cheers,
JS

-----Original Message-----
From: ÀÌÁ¤½Â [mailto:js07.lee@samsung.com] 
Sent: Tuesday, January 14, 2014 10:43 PM
To: 'catalin.marinas@arm.com'; 'linux-arm-kernel@lists.infradead.org'
Cc: 'linux@arm.linux.org.uk'
Subject: Question on flush_pfn_alias function.

Dear Catalin,

I found below function and that clean and invalidate data cache range with
"mcrr"
The end address is end of page - L1_CACHE_BYTES (e.g. 32 , 64)

+static void flush_pfn_alias(unsigned long pfn, unsigned long vaddr) {
+	unsigned long to = ALIAS_FLUSH_START + (CACHE_COLOUR(vaddr) << 
+PAGE_SHIFT);
+
+	set_pte(TOP_PTE(to), pfn_pte(pfn, PAGE_KERNEL));
+	flush_tlb_kernel_page(to);
+
+	asm(	"mcrr	p15, 0, %1, %0, c14\n"
+	"	mcrr	p15, 0, %1, %0, c5\n"
+	    :
+	    : "r" (to), "r" (to + PAGE_SIZE - L1_CACHE_BYTES)
+	    : "cc");
+}

However, follow the mail and current setting in vanilla kernel,
L1_CACHE_BYTES of Cortex A9 will be 64 not 32.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183316.html
I think that could be problem.

What is your opinion?


