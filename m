Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbaJXNNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:13:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21629 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458AbaJXNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:12:50 -0400
X-AuditID: cbfee691-f79b86d000004a5a-ab-544a504fb44b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        k.kozlowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 2/3] ARM: dts: Add sleep mode pin configuration for
 exynos3250-rinato
Date: Fri, 24 Oct 2014 22:12:41 +0900
Message-id: <1414156362-5752-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSohsQ4BVi8Ocum8XfScfYLa5/ec5q
	8WdCK5vFpPsTWCxevzC06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWS69fZLI4df0zkDv5
	JZvFql1/GB34PNbMW8Po8fvXJEaPnbPusntsXlLvceVEE6tH35ZVjB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZTzr+clScEu34tjVTywNjLtVuxg5OSQETCS+v9nLAmGLSVy4t54NxBYSWMooMfGL
	AkzN08drgWq4gOKLGCXaX21hg3CamCR+fpoM1sEmoCWx/8UNMFtEQFKiqeEPM0gRs8B5JonG
	kzuBEhwcwgKREvum+oPUsAioSqy5dZ8FJMwr4CLxZpUrxDIFiWXLZ7KC2JwCrhLL322EOshF
	YvvXfUwgIyUErrFLLJ2+nxVijoDEt8mHwOZICMhKbDrADDFHUuLgihssExiFFzAyrGIUTS1I
	LihOSi8y1StOzC0uzUvXS87P3cQIjJ3T/55N3MF4/4D1IUYBDkYlHt4bMzxDhFgTy4orcw8x
	mgJtmMgsJZqcD4zQvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGA/FfY/sl/AV5Mn9k2rJe+e8AZtYxEmr6LyGk9muEybsPBk7y87oj2OEU2NVYscV
	B401G5Xviq5+qNKaPSmv0dev6s+TVaf1j6XunJnffHztvPIs2dgnxwymmJx7HZ1/faagoemf
	g3d3682pKdi1nW3u03bb5SWaqqKOk7SueSZZHA1VNvcKUmIpzkg01GIuKk4EAOky3HKYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAV3/AK8Qg7XzrSz+TjrGbnH9y3NW
	iz8TWtksJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyWHr9IpPFqeufgdzJ
	L9ksVu36w+jA57Fm3hpGj9+/JjF67Jx1l91j85J6jysnmlg9+rasYvT4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hkJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGs56fLAW3dCuOXf3E0sC4W7WLkZNDQsBE
	4unjtSwQtpjEhXvr2boYuTiEBBYxSrS/2gLlNDFJ/Pw0mQ2kik1AS2L/ixtgtoiApERTwx9m
	kCJmgfNMEo0ndwIlODiEBSIl9k31B6lhEVCVWHPrPgtImFfAReLNKleIZQoSy5bPZAWxOQVc
	JZa/2wg2UgioZPvXfUwTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOzWdSOxhX
	NlgcYhTgYFTi4b0xwzNEiDWxrLgy9xCjBAezkgivv79XiBBvSmJlVWpRfnxRaU5q8SFGU6Cj
	JjJLiSbnA9NGXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGxnqF
	u9fXfAzi2DZfR9AoId/o74kk5tkbrPclXDJ21dDwdRB3WybsJafO3Sj5lGfyok37c+5M+PZE
	W2Pz79iU0+cnFHFuWeTYyaQ27WHrSv3VF1z9tOZfn50xd25q9I3dpwrafv2tdVo6Z5ZFRq2C
	6mwTpbbfCXrbd31qvW0jpH9NICBKmdGVRYmlOCPRUIu5qDgRANIa35PjAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sleep mode pin configuration using pinctrl subsystem
to reduce leakage power-consumption of gpio pin in sleep state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-pinctrl.dtsi |  16 ++++
 arch/arm/boot/dts/exynos3250-rinato.dts   | 154 ++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
index 47b92c1..5ab81c3 100644
--- a/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos3250-pinctrl.dtsi
@@ -12,6 +12,22 @@
  * published by the Free Software Foundation.
 */
 
+#define PIN_PULL_NONE		0
+#define PIN_PULL_DOWN		1
+#define PIN_PULL_UP		3
+
+#define PIN_PDN_OUT0		0
+#define PIN_PDN_OUT1		1
+#define PIN_PDN_INPUT		2
+#define PIN_PDN_PREV		3
+
+#define PIN_SLP(_pin, _mode, _pull)				\
+	_pin {							\
+		samsung,pins = #_pin;				\
+		samsung,pin-con-pdn = <PIN_PDN_ ##_mode>;	\
+		samsung,pin-pud-pdn = <PIN_PULL_ ##_pull>;	\
+	}
+
 &pinctrl_0 {
 	gpa0: gpa0 {
 		gpio-controller;
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 8a18e68..8ad9808 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -422,3 +422,157 @@
 &xusbxti {
 	clock-frequency = <24000000>;
 };
+
+&pinctrl_0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep0>;
+
+	sleep0: sleep-state {
+		PIN_SLP(gpa0-0, INPUT, DOWN);
+		PIN_SLP(gpa0-1, INPUT, DOWN);
+		PIN_SLP(gpa0-2, INPUT, DOWN);
+		PIN_SLP(gpa0-3, INPUT, DOWN);
+		PIN_SLP(gpa0-4, INPUT, DOWN);
+		PIN_SLP(gpa0-5, INPUT, DOWN);
+		PIN_SLP(gpa0-6, INPUT, DOWN);
+		PIN_SLP(gpa0-7, INPUT, DOWN);
+
+		PIN_SLP(gpa1-0, INPUT, DOWN);
+		PIN_SLP(gpa1-1, INPUT, DOWN);
+		PIN_SLP(gpa1-2, INPUT, DOWN);
+		PIN_SLP(gpa1-3, INPUT, DOWN);
+		PIN_SLP(gpa1-4, INPUT, DOWN);
+		PIN_SLP(gpa1-5, INPUT, DOWN);
+
+		PIN_SLP(gpb-0, PREV, NONE);
+		PIN_SLP(gpb-1, PREV, NONE);
+		PIN_SLP(gpb-2, PREV, NONE);
+		PIN_SLP(gpb-3, PREV, NONE);
+		PIN_SLP(gpb-4, INPUT, DOWN);
+		PIN_SLP(gpb-5, INPUT, DOWN);
+		PIN_SLP(gpb-6, INPUT, DOWN);
+		PIN_SLP(gpb-7, INPUT, DOWN);
+
+		PIN_SLP(gpc0-0, INPUT, DOWN);
+		PIN_SLP(gpc0-1, INPUT, DOWN);
+		PIN_SLP(gpc0-2, INPUT, DOWN);
+		PIN_SLP(gpc0-3, INPUT, DOWN);
+		PIN_SLP(gpc0-4, INPUT, DOWN);
+
+		PIN_SLP(gpc1-0, INPUT, DOWN);
+		PIN_SLP(gpc1-1, INPUT, DOWN);
+		PIN_SLP(gpc1-2, INPUT, DOWN);
+		PIN_SLP(gpc1-3, INPUT, DOWN);
+		PIN_SLP(gpc1-4, INPUT, DOWN);
+
+		PIN_SLP(gpd0-0, INPUT, DOWN);
+		PIN_SLP(gpd0-1, INPUT, DOWN);
+		PIN_SLP(gpd0-2, INPUT, NONE);
+		PIN_SLP(gpd0-3, INPUT, NONE);
+
+		PIN_SLP(gpd1-0, INPUT, NONE);
+		PIN_SLP(gpd1-1, INPUT, NONE);
+		PIN_SLP(gpd1-2, INPUT, NONE);
+		PIN_SLP(gpd1-3, INPUT, NONE);
+	};
+};
+
+&pinctrl_1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sleep1>;
+
+	sleep1: sleep-state {
+		PIN_SLP(gpe0-0, PREV, NONE);
+		PIN_SLP(gpe0-1, PREV, NONE);
+		PIN_SLP(gpe0-2, INPUT, DOWN);
+		PIN_SLP(gpe0-3, INPUT, UP);
+		PIN_SLP(gpe0-4, INPUT, DOWN);
+		PIN_SLP(gpe0-5, INPUT, DOWN);
+		PIN_SLP(gpe0-6, INPUT, DOWN);
+		PIN_SLP(gpe0-7, INPUT, DOWN);
+
+		PIN_SLP(gpe1-0, INPUT, DOWN);
+		PIN_SLP(gpe1-1, PREV, NONE);
+		PIN_SLP(gpe1-2, INPUT, DOWN);
+		PIN_SLP(gpe1-3, INPUT, DOWN);
+		PIN_SLP(gpe1-4, INPUT, DOWN);
+		PIN_SLP(gpe1-5, INPUT, DOWN);
+		PIN_SLP(gpe1-6, INPUT, DOWN);
+		PIN_SLP(gpe1-7, INPUT, NONE);
+
+		PIN_SLP(gpe2-0, INPUT, NONE);
+		PIN_SLP(gpe2-1, INPUT, NONE);
+		PIN_SLP(gpe2-2, INPUT, NONE);
+
+		PIN_SLP(gpk0-0, INPUT, DOWN);
+		PIN_SLP(gpk0-1, INPUT, DOWN);
+		PIN_SLP(gpk0-2, OUT0, NONE);
+		PIN_SLP(gpk0-3, INPUT, DOWN);
+		PIN_SLP(gpk0-4, INPUT, DOWN);
+		PIN_SLP(gpk0-5, INPUT, DOWN);
+		PIN_SLP(gpk0-6, INPUT, DOWN);
+		PIN_SLP(gpk0-7, INPUT, DOWN);
+
+		PIN_SLP(gpk1-0, INPUT, DOWN);
+		PIN_SLP(gpk1-1, INPUT, DOWN);
+		PIN_SLP(gpk1-2, INPUT, DOWN);
+		PIN_SLP(gpk1-3, INPUT, DOWN);
+		PIN_SLP(gpk1-4, INPUT, DOWN);
+		PIN_SLP(gpk1-5, INPUT, DOWN);
+		PIN_SLP(gpk1-6, INPUT, DOWN);
+
+		PIN_SLP(gpk2-0, INPUT, DOWN);
+		PIN_SLP(gpk2-1, INPUT, DOWN);
+		PIN_SLP(gpk2-2, INPUT, DOWN);
+		PIN_SLP(gpk2-3, INPUT, DOWN);
+		PIN_SLP(gpk2-4, INPUT, DOWN);
+		PIN_SLP(gpk2-5, INPUT, DOWN);
+		PIN_SLP(gpk2-6, INPUT, DOWN);
+
+		PIN_SLP(gpl0-0, INPUT, DOWN);
+		PIN_SLP(gpl0-1, INPUT, DOWN);
+		PIN_SLP(gpl0-2, INPUT, DOWN);
+		PIN_SLP(gpl0-3, INPUT, DOWN);
+
+		PIN_SLP(gpm0-0, INPUT, DOWN);
+		PIN_SLP(gpm0-1, INPUT, DOWN);
+		PIN_SLP(gpm0-2, INPUT, DOWN);
+		PIN_SLP(gpm0-3, INPUT, DOWN);
+		PIN_SLP(gpm0-4, INPUT, DOWN);
+		PIN_SLP(gpm0-5, INPUT, DOWN);
+		PIN_SLP(gpm0-6, INPUT, DOWN);
+		PIN_SLP(gpm0-7, INPUT, DOWN);
+
+		PIN_SLP(gpm1-0, INPUT, DOWN);
+		PIN_SLP(gpm1-1, INPUT, DOWN);
+		PIN_SLP(gpm1-2, INPUT, DOWN);
+		PIN_SLP(gpm1-3, INPUT, DOWN);
+		PIN_SLP(gpm1-4, INPUT, DOWN);
+		PIN_SLP(gpm1-5, INPUT, DOWN);
+		PIN_SLP(gpm1-6, INPUT, DOWN);
+
+		PIN_SLP(gpm2-0, INPUT, DOWN);
+		PIN_SLP(gpm2-1, INPUT, DOWN);
+		PIN_SLP(gpm2-2, INPUT, DOWN);
+		PIN_SLP(gpm2-3, INPUT, DOWN);
+		PIN_SLP(gpm2-4, INPUT, DOWN);
+
+		PIN_SLP(gpm3-0, INPUT, DOWN);
+		PIN_SLP(gpm3-1, INPUT, DOWN);
+		PIN_SLP(gpm3-2, INPUT, DOWN);
+		PIN_SLP(gpm3-3, INPUT, DOWN);
+		PIN_SLP(gpm3-4, INPUT, DOWN);
+		PIN_SLP(gpm3-5, INPUT, DOWN);
+		PIN_SLP(gpm3-6, INPUT, DOWN);
+		PIN_SLP(gpm3-7, INPUT, DOWN);
+
+		PIN_SLP(gpm4-0, INPUT, DOWN);
+		PIN_SLP(gpm4-1, INPUT, DOWN);
+		PIN_SLP(gpm4-2, INPUT, DOWN);
+		PIN_SLP(gpm4-3, INPUT, DOWN);
+		PIN_SLP(gpm4-4, INPUT, DOWN);
+		PIN_SLP(gpm4-5, INPUT, DOWN);
+		PIN_SLP(gpm4-6, INPUT, DOWN);
+		PIN_SLP(gpm4-7, INPUT, DOWN);
+	};
+};
-- 
1.8.5.5

