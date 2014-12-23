Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaLWLpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:45:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56422 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaLWLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:44:45 -0500
X-AuditID: cbfee691-f79b86d000004a5a-4a-549955a6ea28
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCH 4/4] ARM: dts: Add memory bus node for Exynos3250-based
 Rinato board
Date: Tue, 23 Dec 2014 20:44:37 +0900
Message-id: <1419335077-31020-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
References: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSrLssdGaIwbpFOhaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MNU03mQvmc1a0fljG1MD4mr2LkZNDQsBE4u+WVkYIW0ziwr31bF2MXBxCAksZ
	JaYv3soIU3T4+BR2iMR0RonNUz8zQzhNTBKTbl5kAqliE9CS2P/iBhuILSIgI3F143YWkCJm
	gUZmiS/L/oMVCQtESaze+pgVxGYRUJU4dv0oM4jNK+AqMXXzAxaIdQoSy5bPBKvhFHCT+Pfj
	HVhcCKjmzK8bYJslBG6xSxzYsIsRYpCAxLfJh4CKOIASshKbDjBDzJGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MQIj6PS/ZxN3MN4/YH2IUYCDUYmHd8GZGSFCrIll
	xZW5hxhNgTZMZJYSTc4HxmleSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2Mi9609528V5WTKsC9uzYiInPOKYm3GVOfyU3f/EKgXlj2ntKGgLd6+xVs
	83dNys64zrO+27K3gH3btXfro0u9zOWdmuQ+77KbpqDt8fnLrt4IxRbm73fuO2lJWp8I0OEs
	LLkseN+pYmmTh+PPfWfM3aOmVU1XLS5LkrTd2H4sNGJCn2F9Po8SS3FGoqEWc1FxIgBbtLbU
	mwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd1loTNDDBomqlg8XrOYyeL6l+es
	FvOPnGO1mHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2Lyk3qNvyypGj8+b5ALYohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZqxpuslcMJ+zovXDMqYGxtfsXYycHBIC
	JhKHj0+BssUkLtxbz9bFyMUhJDCdUWLz1M/MEE4Tk8SkmxeZQKrYBLQk9r+4wQZiiwjISFzd
	uJ0FpIhZoJFZ4suy/2BFwgJREqu3PmYFsVkEVCWOXT/KDGLzCrhKTN38gAVinYLEsuUzwWo4
	Bdwk/v14BxYXAqo58+sG8wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguPzmdQO
	xpUNFocYBTgYlXh4F5yZESLEmlhWXJl7iFGCg1lJhFc5cGaIEG9KYmVValF+fFFpTmrxIUZT
	oKsmMkuJJucDU0deSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAMj
	65yg3Ngt39nDnpnkX3y9ebGLtfTcmRpPdgV9OnC38WyGzYSZljzOm1adD4s9fefL2wSxeumc
	x1lrvsm5rFnmt/Dzh/qPYq6n7xTck8iS2lQodVMomrlzawrrr7wbn+LVF680n2m3+PT3DF+F
	H2u17yve2ntw6VHt70sc6+dyXbv0zmtO/51gHSWW4oxEQy3mouJEAHje38blAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the exynos memory-bus node which includes the regulator and
devfreq-event phandle. The devfreq-event phandle is used for the governor
of devfreq device and provide the current usage state of DMC/Internal
memory bus group.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 60948ae..6722555 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -564,6 +564,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

