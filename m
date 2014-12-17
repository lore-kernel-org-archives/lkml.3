Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLQDgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:36:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43779 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaLQDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:35:17 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-1d-5490f9f1f2ff
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v7 3/3] ARM: dts: exynos3250-monk: Add regulator-haptic node
 for haptics
Date: Wed, 17 Dec 2014 12:35:08 +0900
Message-id: <1418787308-29019-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkQPfjzwkhBodfCltc//Kc1eLwoheM
	FjsajrBa9C64ymZx89M3VovLu+awWcw4v4/Jgd1j56y77B59W1YxenzeJBfAHMVlk5Kak1mW
	WqRvl8CV0fd2KXvBbNaK5e+OMDcwLmTpYuTgkBAwkbh3RraLkRPIFJO4cG89WxcjF4eQwFJG
	iXUNZ1ghEiYSH7/9YAKxhQQWMUp83a4PYbcxScx4Fw1iswloS3xfvxisXkQgVOLzhVnMIIOY
	BTYySvx6dBksISwQJTGlfSvYIBYBVYkbUycwg9i8Ah4SLfP+s0EcpCAxZ5INSJhTwFPiwa/H
	rBC7PCTW/PvJAjJTQqCbXeLu5ZmMEHMEJL5NPgT1jKzEpgPMEDdLShxccYNlAqPwAkaGVYyi
	qQXJBcVJ6UUmesWJucWleel6yfm5mxiB4Xz637MJOxjvHbA+xCjAwajEw/vi+oQQIdbEsuLK
	3EOMpkAbJjJLiSbnA6MmryTe0NjMyMLUxNTYyNzSTEmc97XUz2AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjBWM62J6xTJNwxVetTy7xt0ab8D/g/Enx8zw/qy78wrF0j8YSrb0dQnVHXyf
	Hex7+fgryWnyLluePjpXOse/zM84ZP6nfz9WLGDqvWW6+ZWxzLTdr29kqJr0eEz7fHDryoaQ
	rabLmtXtbz3dqlfNO+etXUd5ifV9/Zop25eXMH+uWJibl6i5W4mlOCPRUIu5qDgRAAtxTy1i	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jAd2PPyeEGNz+w2Nx/ctzVovDi14w
	WuxoOMJq0bvgKpvFzU/fWC0u75rDZjHj/D4mB3aPnbPusnv0bVnF6PF5k1wAc1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bf26XsBbNZK5a/O8LcwLiQpYuRk0NCwETi
	47cfTBC2mMSFe+vZQGwhgUWMEl+360PYbUwSM95Fg9hsAtoS39cvZgWxRQRCJT5fmMXcxcjF
	wSywkVHi16PLYAlhgSiJKe1bwYayCKhK3Jg6gRnE5hXwkGiZ9x9oAQfQMgWJOZNsQMKcAp4S
	D349ZoXY5SGx5t9PlgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfLM+kdjKsa
	LA4xCnAwKvHwvrw+IUSINbGsuDL3EKMEB7OSCK/FIqAQb0piZVVqUX58UWlOavEhRlOgoyYy
	S4km5wNjOa8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgbHXRDRC
	6Iv4Sb+SPeXqDtviLONe/DjZ6BUiGfeFNfpyKMvDhzf1GeqM9Djblh9t2v38mf+LW2lv705+
	MusZo4vjf42y9UKT4t2vP2dZqlxkuVrF02HKsoMvH7z+uCo3n9t04vlTLo/1OcSyvxfu3/U4
	Nv9V1TP/Zsk/G4WzuPikkzJP3ROdrqDEUpyRaKjFXFScCAAclQtbrQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..7102d88 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -109,6 +109,13 @@
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

