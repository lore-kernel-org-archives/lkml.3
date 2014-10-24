Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbaJXLkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:40:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60350 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbaJXLkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:40:04 -0400
X-AuditID: cbfee68d-f79296d000004278-74-544a3a92df01
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 2/3] ARM: dts: Add sleep mode pin configuration for
 exynos3250-rinato
Date: Fri, 24 Oct 2014 20:39:54 +0900
Message-id: <1414150795-31105-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSojvJyivEoOWzisXfScfYLa5/ec5q
	8WdCK5vFpPsTWCx6F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk8XS6xeZLE5d/wzkTn7JZrFq
	1x9GB16PNfPWMHr8/jWJ0WPnrLvsHpuX1HtcOdHE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2
	CVwZ7S1LmAtu6Vb8+PibtYFxl2oXIyeHhICJxJ/ZT9ghbDGJC/fWs3UxcnEICSxllFh8YDMz
	TNH1CztZIBLTGSWurbnHBOE0MUlc/3meFaSKTUBLYv+LG2wgtoiApERTwx+wbmaBbUwSbZOy
	QGxhgUiJ+ZPfgtWwCKhKXD33irGLkYODV8BVYt2BAohlChLLls9kBQlzCrhJtPdzgoSFgCo+
	H1vLCFFyjV1i74ZyiCkCEt8mH2IBKZcQkJXYdADqZEmJgytusExgFF7AyLCKUTS1ILmgOCm9
	yFCvODG3uDQvXS85P3cTIzBiTv971ruD8fYB60OMAhyMSjy8N2Z4hgixJpYVV+YeYjQF2jCR
	WUo0OR8Yl3kl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTDGvBBQe6S9f89fRfPnr2e0HfjSuPl4ZcfkTTsdfWby2vc+2c/APs/fotfpzkSf+hi2rk3u
	1e2ssysSmW4eS9v3qETw1QPb7S5PtvcuOfDljIuKdYfnBassdWZmNYMbBqKccucnLgpQVZFc
	crlDOqBi3ay34is8J9ReMeg90/XxmvJmp5+lIt+UWIozEg21mIuKEwEqEBy1kwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd1JVl4hBmeXS1v8nXSM3eL6l+es
	Fn8mtLJZTLo/gcWid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVksvX6RyeLU9c9A7uSXbBar
	dv1hdOD1WDNvDaPH71+TGD12zrrL7rF5Sb3HlRNNrB59W1YxenzeJBfAHtXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK6SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMaO9ZQlzwS3dih8ff7M2MO5S7WLk5JAQMJG4fmEn
	C4QtJnHh3nq2LkYuDiGB6YwS19bcY4Jwmpgkrv88zwpSxSagJbH/xQ02EFtEQFKiqeEPM4jN
	LLCNSaJtUhaILSwQKTF/8luwGhYBVYmr514xdjFycPAKuEqsO1AAsUxBYtnymawgYU4BN4n2
	fk6QsBBQxedjaxknMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREckc+kdjCubLA4
	xCjAwajEw3tjhmeIEGtiWXFl7iFGCQ5mJRFeLxOvECHelMTKqtSi/Pii0pzU4kOMpkA3TWSW
	Ek3OByaLvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjE3bVB6v
	4st/6VQh6LezpLzL4+Ty17dKLu4TurWUS3Z2+455WyT3lSeVeO29ryixR9grd85J88mrPx09
	0Wac2LL9lLPueosOeY/Xu63PJ1vLhfF+f3LUo1p1q5VMQ/KzjMrXeydc7uidpbrm+InmsyeX
	5Ftd3aqqnu4dLhu7e4mSldXW1fwvNiuxFGckGmoxFxUnAgCeb4pJ3gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sleep mode pin configuration using pinctrl subsystem
to reduce leakage power-consumption of gpio pin in sleep state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <Kyungmin Park@samsung.com>
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
index be0ba8d..7256eec 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -431,3 +431,157 @@
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

