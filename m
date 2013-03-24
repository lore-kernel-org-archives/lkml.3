Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3CXXSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:18:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3CXXSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:18:38 -0400
X-AuditID: cbfee68d-b7f786d000005188-42-514f89cc2e74
Date: Sun, 24 Mar 2013 23:18:36 +0000 (GMT)
From: =?euc-kr?B?vNvAurrA?= <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix build error cavium-octeon without CONFIG_SMP
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130324231407936@eunb.song
Msgkey: 20130324231407936@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130324231407936@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26870919.16191364167114826.JavaMail.weblogic@epml15>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Ztu6ZTv9Ag7ln2Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpatv2QousVe0XOljamDcwt7FyMkhJKAi0fL/OyOILSFgIrFy
	ZhszhC0mceHeerYuRi6gmmWMEpe/7GOFKZr/dxoTRPN8Rolll027GDk4WARUJY6+4AYJswGV
	bPgxAWy+sIC7xIRLz1lAbBEBGYmln66A7WIWSJY49PcEK8QYeYnJpy+D1fMKCEqcnPmEBWKV
	ksTfEzvZIOLKEk3X29kh4hISs6ZfgDqHV2JG+1OoejmJaV/XQN0vLXF+1gZGmF8Wf38MFeeX
	OHZ7BxPIySC9T+4Hw4zZvfkLG4QtIDH1zEGoVnWJzTsaodbySaxZ+JYFZsyuU8uZYXrvb5nL
	BPGWosSU7ofsELaWxJcf+9jQvcUr4Cgx7fhe9gmMyrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXF
	SelFhnrFibnFpXnpesn5uZsYIUmhdwfj7QPWhxiTgTEykVlKNDkfmFTySuINjc2MLExNTI2N
	zC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCoKyFe2aJnyrPq5JH7Tqk+
	W3qXHIrmuz+/wGqPCGtt6I6XnlEtZWsX9cdIbAqTny4WH8We4iuiUWs7+83tvds7HyWwb/hX
	t/AiV6m5qtZL8YwPqbFJ4Ud3vvYUX3p2yV7NILkFXHrcE8JUltcGe88qPZYbx+2culq95LzE
	t7gbNwM9Lm9I/KLEUpyRaKjFXFScCACASEnIIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN0znf6BBvfmMFlc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jEtX37IVXGKvaLnSx9TAuIW9i5GTQ0hARaLl/3dGEFtCwERi/t9pTBC2mMSFe+vZIGrmM0os
	u2zaxcjBwSKgKnH0BTdImA2ofMOPCWBjhAXcJSZces4CYosIyEgs/XQFbCSzQLLEob8nWCHG
	yEtMPn0ZrJ5XQFDi5MwnLBCrlCT+ntjJBhFXlmi63s4OEZeQmDX9AiuEzSsxo/0pVL2cxLSv
	a5ghbGmJ87M2MMKcvPj7Y6g4v8Sx2zuYQE4G6X1yPxhmzO7NX9ggbAGJqWcOQrWqS2ze0Qi1
	lk9izcK3LDBjdp1azgzTe3/LXCaItxQlpnQ/ZIewtSS+/NjHhu4tXgFHiWnH97JPYJSbhSQ1
	C0n7LCTtyGoWMLKsYhRNLUguKE5KrzDWK07MLS7NS9dLzs/dxAhOT88W72D8f976EKMAB6MS
	D69AjX+gEGtiWXFl7iFGCQ5mJRHeZX5AId6UxMqq1KL8+KLSnNTiQ4zJwPibyCwlmpwPTJ15
	JfGGxgbGhoaW5gamhkYWpAkrifM+a7UOFBJITyxJzU5NLUgtgtnCxMEp1cBo+Hjnt988vi/n
	qC1xX9InX2vTOMXwxtpm38nKCiFzP25773r84LHGB3XLHpUp5QlNkVdd8vRlYlqFecGpOcyG
	l6/evZL/dZPvA+cgo51reg9+mFqZonuylYllseAz4f4Il4Rs7j1B4WlugotNuoyXzE2747fw
	bp2f7sXk3dOnOtVaXz3+uN5LiaU4I9FQi7moOBEAcL/YIJMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2ONIxIw023911


This patch fixes build error cavium-octeon without CONFIG_SMP

Singed-off-by: EunBong Song<eunb.song@samsung.com>

---
 arch/mips/cavium-octeon/setup.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index c594a3d..b0baa29 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -174,7 +174,10 @@ static int octeon_kexec_prepare(struct kimage *image)
 
 static void octeon_generic_shutdown(void)
 {
-	int cpu, i;
+	int i;
+#ifdef CONFIG_SMP
+	int cpu;
+#endif
 	struct cvmx_bootmem_desc *bootmem_desc;
 	void *named_block_array_ptr;
 
-- 
1.7.0.1

Thanks.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
