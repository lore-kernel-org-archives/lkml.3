Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967511Ab3DRWvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:51:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36450 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3DRWuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:50:55 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-5a-517078cd19ca
Date: Thu, 18 Apr 2013 22:50:52 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix invalid interrupt name in cavium-octeon
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130418224829249@eunb.song
Msgkey: 20130418224829249@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130418224829249@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2202498.1401366325451851.JavaMail.weblogic@epv6ml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Zju7ZioJAg8UtrBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvjxtHXLAVrhCtWNX9kbWB8IdTFyMkhJKAi0fL/OyOILSFgInFz
	yzw2CFtM4sK99WwQNcsYJe5/K4KpaW3ewd7FyAUUn88ocb7vIHMXIwcHi4CqxI32IJAaNgFt
	ibdfHrCChIUFnCR6ZxSChEUEZCSWfroCtopZwF3i7afjzBDj5SUmn77MDmLzCghKnJz5hAVi
	lZJEw8N9LBBxZYlDk25DnSYhMWv6BVYIm1diRvtTqHo5iWlf1zBD2NIS52dtYIR5ZfH3x1Bx
	foljt3cwgZwG0vvkfjDMmN2bv0CNF5CYeuYgVKu6xLw5p6HifBJrFr5lgRmz69RyZpje+1vm
	MkG8pSgxpfshO4StJfHlxz42dG/xCjhKbNh3nWkCo/IsJKlZSNpnIWlHVrOAkWUVo2hqQXJB
	cVJ6kbFecWJucWleul5yfu4mRkhK6N/BePeA9SHGZGCETGSWEk3OB6aUvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw2tasZi8XveK75ax+sBiT
	SNHzrRmnd+eFrvqbbLaiTEmiO2aNzGyx3Z86dZ2CYjn6n2orh7+aeSpZ8F2F2KWmSdHnlprZ
	7HoTmajJoPWiwk3jq5Txppc9xrtduh5nfVx0T+nzf7/TRs0CGpJBSWK73TL3nZ7OP7e28DuD
	yYyJf40Wse4y9GNRYinOSDTUYi4qTgQAnG/vlR8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TN2zFQWBBs+OMFpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jBtHX7MUrBGuWNX8kbWB8YVQFyMnh5CAikTL/++MILaEgIlEa/MOdghbTOLCvfVsXYxcQDXz
	GSXO9x1k7mLk4GARUJW40R4EUsMmoC3x9ssDVpCwsICTRO+MQpCwiICMxNJPV8BGMgu4S7z9
	dJwZYpW8xOTTl8HG8woISpyc+YQFYpWSRMPDfSwQcWWJQ5Nus0HEJSRmTb/ACmHzSsxofwpV
	Lycx7esaZghbWuL8rA2MMCcv/v4YKs4vcez2DiaQ00B6n9wPhhmze/MXqPECElPPHIRqVZeY
	N+c0VJxPYs3CtywwY3adWs4M03t/y1wmiLcUJaZ0P2SHsLUkvvzYx4buLV4BR4kN+64zTWCU
	m4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w1CtOzC0uzUvXS87P3cQITk/PFu5g/HLe+hCj
	AAejEg/vDamCQCHWxLLiytxDjBIczEoivNOTgEK8KYmVValF+fFFpTmpxYcYk4HRN5FZSjQ5
	H5g680riDY0NjA0NLc0NTA2NLEgTVhLnfdpqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMezd1ai8
	wN8SRVe3rtjyw372grMM9i4pJrM/f2GufmvoPk3n2ufyOVvWZbyOF+Tf3PxZecvatqWTN789
	/6PgKVcmz1qx1yWTfutPN9rjsPzMs5Tskn828499af58+X21+7t919n1H6/Y8vjWHgOZs6GZ
	Tmc7BAxr9+sZtrm23yoLfSVuXbvE7ZQSS3FGoqEWc1FxIgACT0SnkwMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3IMp6jl020460


Change interrupt name from "RML/RSL" to "RMLRSL".
This fixes following warning message.

[   24.938793] WARNING: at fs/proc/generic.c:307 __xlate_proc_name+0x124/0x160()
[   24.945926] name 'RML/RSL'
[   24.948642] Modules linked in:
[   24.951707] Call Trace:
[   24.954157] [<ffffffff8069fe18>] dump_stack+0x8/0x34
[   24.959136] [<ffffffff80290d90>] warn_slowpath_common+0x78/0xa8
[   24.965056] [<ffffffff80290e60>] warn_slowpath_fmt+0x38/0x48
[   24.970723] [<ffffffff803cbc8c>] __xlate_proc_name+0x124/0x160
[   24.976556] [<ffffffff803cbe78>] __proc_create+0x78/0x128
[   24.981963] [<ffffffff803cd044>] proc_mkdir_mode+0x2c/0x70
[   24.987451] [<ffffffff80302418>] register_handler_proc+0x108/0x130
[   24.993642] [<ffffffff802fd078>] __setup_irq+0x210/0x540
[   24.998963] [<ffffffff802fd67c>] request_threaded_irq+0x114/0x1a0
[   25.005060] [<ffffffff80262e0c>] prom_free_prom_memory+0xd4/0x588
[   25.011164] [<ffffffff80691820>] free_initmem+0x10/0xc0
[   25.016390] [<ffffffff80691720>] kernel_init+0x20/0x100
[   25.021624] [<ffffffff8026c7e0>] ret_from_kernel_thread+0x10/0x18

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/cavium-octeon/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index b0baa29..92c3150 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -1066,7 +1066,7 @@ void prom_free_prom_memory(void)
 
 	/* Add an interrupt handler for general failures. */
 	if (request_irq(OCTEON_IRQ_RML, octeon_rlm_interrupt, IRQF_SHARED,
-			"RML/RSL", octeon_rlm_interrupt)) {
+			"RMLRSL", octeon_rlm_interrupt)) {
 		panic("Unable to request_irq(OCTEON_IRQ_RML)");
 	}
 #endif
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
