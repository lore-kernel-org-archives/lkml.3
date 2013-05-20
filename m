Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3ETKJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:09:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60837 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3ETKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:09:32 -0400
X-AuditID: cbfee68f-b7f436d000000f81-b0-5199f65ae090
Date: Mon, 20 May 2013 09:53:25 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix compilation warning
To: "david.daney@cavium.com" <david.daney@cavium.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130520095141724@eunb.song
Msgkey: 20130520095141724@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130520095141724@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28060028.150781369043604705.JavaMail.weblogic@epml03>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zlm7Ut5mBBtteWVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M87teMhW84qxo6VrG2sB4hLOLkZNDSEBFouX/d0YQW0LARKK1
	aQqULSZx4d56ti5GLqCaZYwS615fY4cpmnfzKQtE83xGifOXXLoYOThYBFQlpk3nAgmzCWhL
	vP3ygBXEFhbQl/h+aw4TiC0ikCLReHIl2HxmgRqJb1f3sUKMkZeYfPoy2HheAUGJkzOfsECs
	UpKY+20GE8h4XgFliU0dPhBhCYlZ0y+wQti8EjPan0KVy0lM+7qGGcKWljg/awPcK4u/P4aK
	80scu70DbCRI75P7wTBjdm/+wgZhC0hMPXMQqlVd4s+NY1CtfBJrFr5lgRmz69RyZpje+1vm
	MkF8pSgxpfshO4StJfHlxz42dF/xCjhJ3Jy9jXUCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJB
	cVJ6kbFecWJucWleul5yfu4mRkhK6N/BePeA9SHGZGCETGSWEk3OB6aUvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwqqT47hFLy7kyS8r8a9kC
	o1nHJUPSjO33t+9Rk/R4WSQ79+3COJnlG6w5l5YWx1nzRM6Om/zf6sJv4XxmJz+2SfxV/6qv
	HNGafp8vSOLnZuulfZbLJh3UXCdv3ZrJPtEg9NoD2YoDpgrO2ozfvp0OvcUs9/MA46f2rEwX
	Xd297q33g+XiYkqUWIozEg21mIuKEwFUJsezHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tGbpR32YGGnTONbW4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Ged3vWQqeMVZ0dK1jLWB8QhnFyMnh5CAikTL/++MILaEgInEvJtPWSBsMYkL99azQdTMZ5Q4
	f8mli5GDg0VAVWLadC6QMJuAtsTbLw9YQWxhAX2J77fmMIHYIgIpEo0nV4KNZBaokfh2dR8r
	xBh5icmnL7OD2LwCghInZz6BWqUkMffbDCaQ8bwCyhKbOnwgwhISs6ZfYIWweSVmtMNcJicx
	7esaZghbWuL8rA2MMBcv/v4YKs4vcez2DrCRIL1P7gfDjNm9+QsbhC0gMfXMQahWdYk/N45B
	tfJJrFn4lgVmzK5Ty5lheu9vmcsE8ZWixJTuh+wQtpbElx/72NB9xSvgJHFz9jbWCYxys5Ck
	ZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6RUmesWJucWleel6yfm5mxjByenZkh2MDResDzEKcDAq
	8fAKBMwMFGJNLCuuzD3EKMHBrCTCu/QLUIg3JbGyKrUoP76oNCe1+BBjMjD6JjJLiSbnAxNn
	Xkm8obGBsaGhpbmBqaGRBWnCSuK8z1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwur7oV125ace3
	9+LLJi05eHfT+wv+obd4Zbs8opa9unmgtPurouineZvZL18/+eiC1SfjM0rhMl5b+VMYfOUd
	TjocfvzmT9G9kyVCtatubJq5a5mY6I/Fr3lebpz9y/beyWcqJp90E4J7V3gIbF6xc82flSdi
	ftVXJCszfr82m9Xp+eE9Khl10T1KLMUZiYZazEXFiQApQ8XqkgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4KA9cZG010969


Fix the following compilation warning:

mm/page_alloc.c: In function 'free_reserved_area':
mm/page_alloc.c:5162: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/include/asm/page.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index ec1ca53..41640f1 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -197,7 +197,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #endif
 
-#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
+#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys((const volatile void *)(kaddr))))
 
 extern int __virt_addr_valid(const volatile void *kaddr);
 #define virt_addr_valid(kaddr)						\
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
