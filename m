Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaKTO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:26:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32473 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbaKTO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:26:27 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-33-546dfa11e0b1
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 2/2] ARM: dts: Add max77693-haptic node for exynos4412-trats2
Date: Thu, 20 Nov 2014 23:26:16 +0900
Message-id: <1416493576-10129-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416493576-10129-1-git-send-email-jaewon02.kim@samsung.com>
References: <1416493576-10129-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWyRsSkQFfwV26IweslvBbXvzxntdjRcITV
	onfBVTaLy7vmsFnMOL+PyYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDLuPfrKXHCYtWLu
	5r2sDYzbWLoYOTkkBEwkfp4+wQZhi0lcuLceyObiEBJYyiix6l0bM0zR/CvHmSAS0xkl1iyd
	ww7htDFJvDryhQmkik1AW+L7+sWsILaIgJpEz+KtjCBFzAKTGCW+P30ANkpYwFdi3fV9YA0s
	AqoSTf0bwO7gFfCQ2H7hBVANB9A6BYk5k2xAwpwCnhKrGy8wgthCQCUP+7Yzg8yUEPjOJnFg
	byMzxBwBiW+TD7FA9MpKbDoAdbWkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSiV5yYW1yal66X
	nJ+7iREYtqf/PZuwg/HeAetDjAIcjEo8vAkWuSFCrIllxZW5hxhNgTZMZJYSTc4HRkdeSbyh
	sZmRhamJqbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY6zc1f2++6J3n
	JcR7Otdsol/G4cOxnz7p/zvLcFBC4Gz8P5Z5rq9/Xv6c95LR5/3VTX0Kc25KdAjWb/nsUxiS
	ffm1zh/m692B1nK8TLvP+/anHldf4a396yHLh12euSk/q17XvbXr1F+kvnmW1XWtc3EvD+W6
	df9gusBxduUj+UWeGpOfp+yarcRSnJFoqMVcVJwIAOBkzfRWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoK7gr9wQg8ajbBbXvzxntdjRcITV
	onfBVTaLy7vmsFnMOL+PyYHVo2/LKkaPz5vkApiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgz7j36ylxwmLVi7ua9rA2M21i6GDk5JARMJOZfOc4EYYtJXLi3nq2LkYtD
	SGA6o8SapXPYIZw2JolXR76AVbEJaEt8X7+YFcQWEVCT6Fm8lRGkiFlgEqPE96cPmEESwgK+
	Euuu7wNrYBFQlWjq3wC2jlfAQ2L7hRdANRxA6xQk5kyyAQlzCnhKrG68wAhiCwGVPOzbzjyB
	kXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCoeCa9g3FVg8UhRgEORiUe3gSL3BAh
	1sSy4srcQ4wSHMxKIrwL3wOFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR8YsXkl8YbGJmZG
	lkbmhhZGxuZK4rw3bgI1CaQnlqRmp6YWpBbB9DFxcEo1MIZPDt0/edu9rRf7WkLy7acEfViT
	8WDpHNdvglo3zIS8hO8+mp1Ufjzc9tfrWXb6sV9WaS6uPOjfG7btSOIK5k3HjyVnztX7wf3z
	YfXFKrttN8ocG1+eCVrOF3ZBqsNj7e87rr8WOtrfdfXVndbMm9aQOMNs24Y0f4HMwC+8d07u
	rPzsW3Fveq4SS3FGoqEWc1FxIgCetnUZoAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds max77693-haptic node to support for haptic motor driver.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 72462e8..8ddebbc 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -543,6 +543,12 @@
 					regulator-max-microamp = <2580000>;
 				};
 			};
+
+			max77693_haptic {
+				compatible = "maxim,max77693-haptic";
+				haptic-supply = <&ldo26_reg>;
+				pwms = <&pwm 0 38022 0>;
+			};
 		};
 	};
 
-- 
1.7.9.5

