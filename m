Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3DLEtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 00:49:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57700 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3DLEtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 00:49:01 -0400
X-AuditID: cbfee68d-b7f786d000005188-5b-5167923cb270
Date: Fri, 12 Apr 2013 04:49:00 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix typo in cavium-octeon
To: ralf@linux-mips.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130412044003865@eunb.song
Msgkey: 20130412044003865@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130412044003865@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8832811.197761365742139632.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zrq7NpPRAg1t9whaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjzY1OtoIDfBXzf3QyNzD28HUxcnIICahItPz/zghiSwiYSDw/
	f5EJwhaTuHBvPVsXIxdQzTJGidfz1zHBFO25dZsJIjGfUWL9zmesIAkWAVWJyU/msoPYbALa
	Em+/PACLCwsYSEzeshysWURARmLppytg25gFkiX+vz3OBHGFvMTk05fBenkFBCVOznzCArFM
	SeLZ95MsEHFlibZ989gg4hISs6ZfYIWweSVmtD+FqpeTmPZ1DTOELS1xftYGRphvFn9/DBXn
	lzh2ewfQXg6w3if3g2HG7N78BWq8gMTUMwcZIUrUJTqWK0GE+STWLHzLAjNl16nlzDCt97fM
	ZYL4SlFiSvdDdghbS+LLj31s6L7iFXCUWLv9POMERuVZSFKzkLTPQtKOrGYBI8sqRtHUguSC
	4qT0IkO94sTc4tK8dL3k/NxNjJC00LuD8fYB60OMycAYmcgsJZqcD0wreSXxhsZmRhamJqbG
	RuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgnNIYymj9mbvwNvNDTa3n
	fdu2CJfqPC2P+9e7bdrMFy4M6VVeHL0/OL2VJP7vu5s2q8b8dHrtK63LLZzihgn/FHpFJ2Xy
	neI7L/ru/5bT2TMrU2fPOLXk2b6ZFzJql2+OdXi8kjHogq+O8OuEuxq8V/haXq4/U3/aZGK/
	p/4TB47lwcyu7iqtSizFGYmGWsxFxYkAE8nrgCEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DF2bSemBBo+XC1hc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jDU3OtkKDvBVzP/RydzA2MPXxcjJISSgItHy/zsjiC0hYCKx59ZtJghbTOLCvfVsXYxcQDXz
	GSXW73zGCpJgEVCVmPxkLjuIzSagLfH2ywOwuLCAgcTkLcvBmkUEZCSWfroCNpRZIFni/9vj
	TBDL5CUmn74M1ssrIChxcuYTFohlShLPvp9kgYgrS7Ttm8cGEZeQmDX9AiuEzSsxo/0pVL2c
	xLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuA9nKA9T65HwwzZvfmL1DjBSSmnjnICFGiLtGx
	XAkizCexZuFbFpgpu04tZ4Zpvb9lLhPEV4oSU7ofskPYWhJffuxjQ/cVr4CjxNrt5xknMMrN
	QpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjqFSfmFpfmpesl5+duYgQnqGcLdzB+OW99iFGA
	g1GJh/eFcHqgEGtiWXFl7iFGCQ5mJRHemL1pgUK8KYmVValF+fFFpTmpxYcYk4HxN5FZSjQ5
	H5g880riDY0NjA0NLc0NTA2NLEgTVhLnfdpqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUddux+6j
	d7lS2XZyT54n6CMhzxU8b9u/5E7ZXL361iMKa0UWem64cnjv7JyfX3p+hJ6yPFLF9NhphfaC
	V/lGt48bCVsJTZA5JF1cV/91qfOTr0KVDfJOb7e71P+8MT23PWy977ln7ue68g5NUmV6Gff+
	gX3qqXwDo0gj6QD5VsdPgcYP63amKbEUZyQaajEXFScCAHDpChiUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3C4n4Gj010517


I think "CUI2" should be changed to "CIU2", because CIU means Central Intrrupt Unit.

Singed-off-by: EunBong Song<eunb.song@samsung.com>

---
 arch/mips/cavium-octeon/octeon-irq.c           |    2 +-
 arch/mips/include/asm/mach-cavium-octeon/irq.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 156aa61..52aa9cf 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -1709,7 +1709,7 @@ static void __init octeon_irq_init_ciu2(void)
 	} else
 		panic("Cannot find device node for cavium,octeon-6880-ciu2.");
 
-	/* CUI2 */
+	/* CIU2 */
 	for (i = 0; i < 64; i++)
 		octeon_irq_force_ciu_mapping(ciu_domain, i + OCTEON_IRQ_WORKQ0, 0, i);
 
diff --git a/arch/mips/include/asm/mach-cavium-octeon/irq.h b/arch/mips/include/asm/mach-cavium-octeon/irq.h
index 60fc4c3..77fb610 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/irq.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/irq.h
@@ -15,7 +15,7 @@ enum octeon_irq {
 /* 1 - 8 represent the 8 MIPS standard interrupt sources */
 	OCTEON_IRQ_SW0 = 1,
 	OCTEON_IRQ_SW1,
-/* CIU0, CUI2, CIU4 are 3, 4, 5 */
+/* CIU0, CIU2, CIU4 are 3, 4, 5 */
 	OCTEON_IRQ_5 = 6,
 	OCTEON_IRQ_PERF,
 	OCTEON_IRQ_TIMER,
-- 
1.7.0.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
