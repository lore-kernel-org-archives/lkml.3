Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965873AbaDJKHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbaDJKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:51 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-54-53466d1bb59d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/27] ARM: dts: exynos3250: Add GIC dt node for Exynos3250
Date: Thu, 10 Apr 2014 19:06:01 +0900
Message-id: <1397124377-16969-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFc61y3Y4NhULYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MqY/+84a8F29or7D94xNTA2s3UxcnJICJhIvNi/
	nBHCFpO4cG89WFxIYCmjxL6fZjA1v/c3M3cxcgHFFzFKzHzyig3CaWKSOLmkiQWkik1AS2L/
	ixtg3SICARI/jr8Ds5kFbjJKHHsfBmILC3hLHLm/kxXEZhFQlXh1bgJYL6+Aq8TtnltMENvk
	JD7secQOYnMKuEnMXHQS6iJXiZ5HF8GukBBYxi4xfd4BdohBAhLfJh8CGsQBlJCV2HSAGWKO
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqFecmFtcmpeul5yfu4kRGPin/z3r3cF4+4D1IcZk
	oHETmaVEk/OBkZNXEm9obGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwBOnMKedh93rdv1WS21o1Z+Onh/Su9Lv2qCzKjI+sfxkz6t+9bT8a8xGNn606u
	1F6l+vk19wFlFde4na0WxzIf/9Vh2vjaZHXMdXtROZE/k6uOWDlsS1qkn5+2gXey8EedV6VJ
	B6oP+T2LyO/Jn/RF3El52UvricZ/Nwp+2rxTlaGtSvnyTy8lluKMREMt5qLiRABJzmH2kgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAV3pXLdgg03PFCyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvx/x1kL
	trNX3H/wjqmBsZmti5GTQ0LAROL3/mZmCFtM4sK99UBxLg4hgUWMEjOfvIJympgkTi5pYgGp
	YhPQktj/4gZYt4hAgMSP4+/AbGaBm4wSx96HgdjCAt4SR+7vZAWxWQRUJV6dmwDWyyvgKnG7
	5xYTxDY5iQ97HrGD2JwCbhIzF50EmyMEVNPz6CLzBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCI+uZ1A7GlQ0WhxgFOBiVeHgPLHMNFmJNLCuuzD3EKMHBrCTCuzvTLViINyWx
	siq1KD++qDQntfgQYzLQVROZpUST84FRn1cSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjD0azE+dn67is9z/aO3u6OKfBulvnyVu7mEKtmrg8m1JktJ4tFNu
	Y2pddJyyzlvr2y5MPkXJ/zW+m2w/suwm/5VLEiZfHDi9izVSld//d6w3ntxQ8/+rdjN7+/p0
	c7n8vUr30mZavpeMThY4nPxr8lMtC6FiJsktFn8f5nX+Fniv6We/RuOPEktxRqKhFnNRcSIA
	W6bzo/ACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch adds device tree node for GIC interrupt controller
on Exynos3250.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 3c8cee6..fe8960e 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -31,4 +31,15 @@
 		compatible = "samsung,exynos3-sysreg", "syscon";
 		reg = <0x10010000 0x400>;
 	};
+
+	gic: interrupt-controller@10481000 {
+		compatible = "arm,cortex-a7-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0x10481000 0x1000>,
+		      <0x10482000 0x1000>,
+		      <0x10484000 0x2000>,
+		      <0x10486000 0x2000>;
+		      interrupts = <1 9 0xf04>;
+	};
 };
-- 
1.8.0

