Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965664AbaDJKGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15003 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935283AbaDJKG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:29 -0400
X-AuditID: cbfee68f-b7f156d00000276c-84-53466d24321a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 21/27] ARM: dts: exynos3250: Add PMU dt data
Date: Thu, 10 Apr 2014 19:06:11 +0900
Message-id: <1397124377-16969-13-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkQFcl1y3Y4OFMCYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpY3dTKWrCIreL2jMvsDYyTWbsYOTkkBEwk/t/9
	AGWLSVy4t56ti5GLQ0hgKaPE3iOPGLsYOcCKls0LhIgvYpR43/ucEcJpYpJ43TKBEaSbTUBL
	Yv+LG2wgtohAgMSP4+/AbGaBm4wSx96HgdjCAjYSm+efZgKxWQRUJSY9bgHr5RVwk7j6dAIT
	xBVyEh/2PGIHsTmB4jMXnQSbIyTgKtHz6CIzyGIJgXXsEm/6ehghBglIfJt8iAXiUlmJTQeY
	IeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBgX/637P+HYx3D1gf
	YkwGGjeRWUo0OR8YOXkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sa
	k1p8iJGJg1OqgdE7nHM/Y9vkeMcHr2Rv9pks1apI82J1EUwRPl5xeZ7W2XlqC71TqlIuXel1
	nN/9RP+8j/mFs3YbL9fy1/f8llPolG+s4/b/LJz6vOfY+u2xjfu0t+cdcubhWyn0r/OZM/cC
	S5aF0ofnbLw4Z9d1myN75mgzzrMOnBLtZDOv5rA879Qnrnt/rlZiKc5INNRiLipOBAADmdSy
	kgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2VXLdgg53/BSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxuqmVtaC
	RWwVt2dcZm9gnMzaxcjBISFgIrFsXmAXIyeQKSZx4d56ti5GLg4hgUWMEu97nzNCOE1MEq9b
	JjCCVLEJaEnsf3GDDcQWEQiQ+HH8HZjNLHCTUeLY+zAQW1jARmLz/NNMIDaLgKrEpMctYL28
	Am4SV59OYILYJifxYc8jdhCbEyg+c9FJsDlCAq4SPY8uMk9g5F3AyLCKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIziunknvYFzVYHGIUYCDUYmH98Ay12Ah1sSy4srcQ4wSHMxKIry7M92C
	hXhTEiurUovy44tKc1KLDzEmA101kVlKNDkfGPN5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cC4lf/E//RU/U8Jk83T1pwMExH/e2GvyjOzPac37dq1tnNR
	mU9mxr2NCptFWHoLP2yc+VHgP0uVuPLmqJ64e1cTMz9tm6dbenTmMatUvyKLuQ5v71WFsjnq
	vZzv+Lyq5dLpgOstjnL5fyp+LBW0+qyYmVPUFD8x86PrDJnMZ9M/xmQK9t/hMLVUYinOSDTU
	Yi4qTgQAxjjmNu8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyunhee Kim <hyunhee.kim@samsung.com>

ARM CPU has its own PMU (Performance Monitoring Unit). This patch add PMU dt
data to support PMU for CPU. Exynos3250 has four PMU interrupts.

Signed-off-by: Hyunhee Kim <hyunhee.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index ceed761..2f0ca32 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -280,4 +280,9 @@
 		pinctrl-0 = <&i2c7_bus>;
 		status = "disabled";
 	};
+
+	pmu {
+		compatible = "arm,cortex-a7-pmu";
+		interrupts = <0 18 0>, <0 19 0>, <0 20 0>, <0 21 0>;
+	};
 };
-- 
1.8.0

