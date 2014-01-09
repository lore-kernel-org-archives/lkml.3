Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaAIFAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:00:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62426 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIFAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:00:04 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-b5-52ce2cd31881
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 5/6 v2] ARM: dts: exynos5420: add dt node for sss module
Date: Thu, 09 Jan 2014 10:30:21 +0530
Message-id: <1389243621-13245-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkWveyzrkgg6Y2dYuXhzQtul/JWPQu
	uMpmcf/eTyaLy7vmsFnMOL+PyWLRtv/MFqt2/WG0ODvnEJMDp8fOWXfZPbYdUPXo27KK0ePz
	JrkAligum5TUnMyy1CJ9uwSujH1bQgpusVcc/fiHvYFxPVsXIyeHhICJxM2Gr1C2mMSFeyBx
	Lg4hgaWMEj1flzDBFDU87GaFSExnlJi++isLhNPPJPHg6VJmkCo2ATOJg4tWs4PYIgLOEr+b
	14B1MAscYJRYN/0U2A5hAQ+J5sVrwYpYBFQlzr16CdTMwcEr4Crx6JQRiCkhoCAxZ5INSAWn
	gJvErK5/rCBhIaCKGefTQSZKCMxjl2i+Op8RYoqAxLfJh1ggWmUlNh1ghrhZUuLgihssExiF
	FzAyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIDPPT/5717mC8fcD6EGMy0LiJzFKiyfnA
	OMkriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaY
	p4y+/R+5V14q/18v/P5jm1m6fb1hw7YbeRfepxbzfLgm415TxLDd1GEFd+eBS/KLJLovLDp4
	Ul+a+ZHAl8d2O1P3pxjV7q3WmSFUGc8+T2yxjeWeaMnUpY8KvOWerHE9I2ubeJ3xXxVj6z3f
	slqTzasktyyc58ivnNyR/uqD1R/DV7v/qimxFGckGmoxFxUnAgBdMYdFiQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jQd3LOueCDN7OlLd4eUjTovuVjEXv
	gqtsFvfv/WSyuLxrDpvFjPP7mCwWbfvPbLFq1x9Gi7NzDjE5cHrsnHWX3WPbAVWPvi2rGD0+
	b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixb0tIwS32iqMf/7A3
	MK5n62Lk5JAQMJFoeNjNCmGLSVy4BxLn4hASmM4oMX31VxYIp59J4sHTpcwgVWwCZhIHF61m
	B7FFBJwlfjevYQUpYhY4wCixbvopsLHCAh4SzYvXghWxCKhKnHv1EqiZg4NXwFXi0SkjEFNC
	QEFiziQbkApOATeJWV3/WEHCQkAVM86nT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOIqeSe9gXNVgcYhRgINRiYd3RfHZICHWxLLiytxDjBIczEoivH9VzwUJ8aYkVlalFuXH
	F5XmpBYfYkwGOmkis5Rocj4wwvNK4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCeWJKanZpa
	kFoEs4WJg1OqgdGD6bq78E13S/9zAk35sZtSO0OaddfHnrgUJTx18k6bwwnxMh+Vuw3m3W3Q
	U4oOPMVZOFH8649m7XPLlmqfPXH0/Bq/sL9Nb5Y/mbnI86nNAbta/pReWc8jV/w3M7JJicZ4
	76hZvuKMbkpnN++70vxVen+Wr1dm3pC9YHk9W5v5tmvSolJhqkosxRmJhlrMRcWJAL7pfpLm	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v1:
Modified dt node name from sss to sss@10830000

 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..0b27902 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5

