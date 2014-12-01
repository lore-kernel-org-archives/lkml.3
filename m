Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaLACMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:12:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbaLACLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:11:48 -0500
X-AuditID: cbfee691-f79b86d000004a5a-8a-547bce60fc4c
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 2/2] ARM: dts: Add regulator-haptic device node for
 exynos3250-rinato
Date: Mon, 01 Dec 2014 11:11:13 +0900
Message-id: <1417399873-19575-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417399873-19575-1-git-send-email-jaewon02.kim@samsung.com>
References: <1417399873-19575-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkRDfhXHWIwZozVhaHF71gtNjRcITV
	onfBVTaLm5++sVpc3jWHzWLG+X1MDmweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
	jIdXxApusFas6Wllb2C8ydLFyMkhIWAisf34QShbTOLCvfVsXYxcHEICSxklnu9ezg5T1Plh
	KzNEYjqjRN+u40wgCSGBNiaJ1TONQGw2AW2J7+sXs4LYIgKhEp8vzAJrYBboZJQ4e/UeWIOw
	QJTEh9+X2UBsFgFVie9H/zKD2LwCHhKdf9YANXMAbVOQmDPJBiTMKeApsXXidxaIXR4SS9s2
	M4HMlBBoZpc4ObkPao6AxLfJh1ggemUlNh1ghjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y
	1StOzC0uzUvXS87P3cQIDOPT/55N3MF4/4D1IUYBDkYlHl6J+dUhQqyJZcWVuYcYTYE2TGSW
	Ek3OB0ZLXkm8obGZkYWpiamxkbmlmZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jEzKNs3cC4umW996OvuR890Eaw32DY2X5hvsiTyw1FSqU/3WnJtLDt2ZJrq+e0Vg5k2hk1P9
	HgRIb49Md2/mXHPe2rTYJas/bI7+pNcKlVa/dNlnPjnybs69fJ95LWGsTkw/4idtMzsY0sUx
	LWmZvryN+oO+U+yzLM4tXireu9PDkK2M3+2coBJLcUaioRZzUXEiAMxxSnleAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd2Ec9UhBq0PjC0OL3rBaLGj4Qir
	Re+Cq2wWNz99Y7W4vGsOm8WM8/uYHNg8ds66y+7Rt2UVo8fnTXIBzFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBkPr4gV3GCtWNPTyt7AeJOli5GTQ0LARKLzw1ZmCFtM
	4sK99WxdjFwcQgLTGSX6dh1nAkkICbQxSayeaQRiswloS3xfv5gVxBYRCJX4fGEWM0gDs0An
	o8TZq/fAGoQFoiQ+/L7MBmKzCKhKfD/6F2wDr4CHROefNUDNHEDbFCTmTLIBCXMKeEpsnfid
	BWKXh8TSts1MExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjpJnUjsYVzZYHGIU
	4GBU4uE9OKc6RIg1say4MvcQowQHs5II7zkPoBBvSmJlVWpRfnxRaU5q8SFGU6CjJjJLiSbn
	AyM4ryTe0NjEzMjSyNzQwsjYXEmc98bN3BAhgfTEktTs1NSC1CKYPiYOTqkGRpNg241cfCbW
	ESxM8v1hsqm18ycJmWXXPnM133vZNuJgDT9D7orK3Tu5g9bdYP7m8V/g98WvgcFHn/VK/zQ0
	LnCP2XG0zeLnlgk75rC0nrxceM5xueja5x/3dd3ui8tzj/z73s5cOqOodTa7fY2k4oGzqYYN
	Pwq2+1wXCrsrZvFm/m6RpwEvlFiKMxINtZiLihMBPBSPYqgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 84380fa..da03005 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -104,6 +104,13 @@
 			};
 		};
 	};
+
+	haptics {
+		compatible = "regulator-haptic";
+		haptic-supply = <&motor_reg>;
+		min-microvolt = <1100000>;
+		max-microvolt = <2700000>;
+	};
 };
 
 &adc {
-- 
1.7.9.5

