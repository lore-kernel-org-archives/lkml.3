Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaLQDfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:35:22 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43779 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLQDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:35:15 -0500
X-AuditID: cbfee68e-f79b46d000002b74-f5-5490f9f1f376
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v7 2/3] ARM: dts: exynos3250-rinato: Add regulator-haptic node
 for haptics
Date: Wed, 17 Dec 2014 12:35:07 +0900
Message-id: <1418787308-29019-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
References: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkWPfjzwkhBvMe81hc//Kc1eLwoheM
	FjsajrBa9C64ymZx89M3VovLu+awWcw4v4/Jgd1j56y77B59W1YxenzeJBfAHMVlk5Kak1mW
	WqRvl8CVcaBvKXPBDdaKpzf1GhhvsnQxcnJICJhIfLt3kRHCFpO4cG89WxcjF4eQwFJGiYXn
	frHCFDU1NLBCJBYxStxaNJUJJCEk0MYkMeNdNIjNJqAt8X39YrAGEYFQic8XZjGDNDALbGSU
	+PXoMlCCg0NYIEbi6PoiEJNFQFXi8/cCkHJeAQ+J1evnM4KEJQQUJOZMsgEJcwp4Sjz49ZgV
	YpOHxJp/P1lAJkoI9LNLLJj3lg0kwSIgIPFt8iEWiF5ZiU0HmCFOlpQ4uOIGywRG4QWMDKsY
	RVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAoP59L9nfTsYbx6wPsQowMGoxMP74vqEECHWxLLi
	ytxDjKZAGyYyS4km5wNjJq8k3tDYzMjC1MTU2Mjc0kxJnDdB6mewkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBkbDpnrJ2yrtKUJZTUYzVF9EZ6xXjI0JnM+7pn/5vt1qrKfDrY0PqZ1ekL+n
	L2FZycXkFK053892qLPp/Q++yFdx+7OpuGgz5wTvvgafZ5snPZjwge/9zQC/vQei3izgqp8Z
	s+YT/1als6ferZ01dV9lWrf5cgX/kOl8G+7biAmuvj1lTb3seRUlluKMREMt5qLiRAD33n1U
	YQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd2PPyeEGKw6xmpx/ctzVovDi14w
	WuxoOMJq0bvgKpvFzU/fWC0u75rDZjHj/D4mB3aPnbPusnv0bVnF6PF5k1wAc1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aBvqXMBTdYK57e1GtgvMnSxcjJISFgItHU
	0MAKYYtJXLi3nq2LkYtDSGARo8StRVOZQBJCAm1MEjPeRYPYbALaEt/XLwZrEBEIlfh8YRYz
	SAOzwEZGiV+PLgMlODiEBWIkjq4vAjFZBFQlPn8vACnnFfCQWL1+PiNIWEJAQWLOJBuQMKeA
	p8SDX49ZITZ5SKz595NlAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsfJMegfj
	qgaLQ4wCHIxKPLwvr08IEWJNLCuuzD3EKMHBrCTCa7EIKMSbklhZlVqUH19UmpNafIjRFOim
	icxSosn5wDjOK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgzH48
	efFvfS+Vv9JPrZkf3bnydqm+xdqrkz6uEVHzmM5/QJuz+vDSv2YNl7ZOF1pd8y//YapX+7Sz
	ebx3punV3fq1RGcl38RejjVuL1QnRPNeb7x01sHkwYyKmNlRM58bP/pn6Fuz3nXWT/G2gpx7
	d/747TzHf6/3Teyy1AvfXwW9CgjRZ/+V1abEUpyRaKjFXFScCAAnsWI2qwIAAA==
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
index 80aa8b4..0e3d499 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -100,6 +100,13 @@
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

