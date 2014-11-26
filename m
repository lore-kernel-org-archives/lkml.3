Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaKZNaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:30:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40670 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaKZNaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:30:09 -0500
X-AuditID: cbfee68e-f79b46d000002b74-2b-5475d5dd83af
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 2/2] ARM: dts: Add regulator-haptic device node for
 exynos3250-rinato
Date: Wed, 26 Nov 2014 22:30:02 +0900
Message-id: <1417008602-22841-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417008602-22841-1-git-send-email-jaewon02.kim@samsung.com>
References: <1417008602-22841-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkWPfu1dIQg3+96hbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72OyWLT1C7sDh8fOWXfZPfq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugSvj4RWxghusFWt6WtkbGG+ydDFycEgImEic2MvdxcgJZIpJXLi3nq2LkYtD
	SGApo8TvS5OZIBImEnOPbWWCSCxilDh4eyUzhNPGJDFp5Q52kCo2AW2J7+sXs4LYIgKhEp8v
	zAIrYha4xSix+dlusCJhgSiJi7f7GEFsFgFViWmLPzOD2LwCHhLrZi9jgzhJQWLOJBuQMKeA
	p8Sm04fASoSASrbuvQB2noTAZHaJJacPMUHMEZD4NvkQ1DuyEpsOMENcLSlxcMUNlgmMwgsY
	GVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBIb26X/P+nYw3jxgfYhRgINRiYc3Qqo0RIg1
	say4MvcQoynQhonMUqLJ+cAIyiuJNzQ2M7IwNTE1NjK3NFMS502Q+hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgbHkXveF0JWKlw1Ln2XM584+J/wgM+/2leO6B5NTjH9JVT9eKsglsmRG
	h6nCJO6rmy599bdMXCzpO5H/dOGFVg3DOycn65X6nSq13ikj/8Y/3J6dlfXgoe93Gn53R9zM
	1dlkmhbfaKRn9GryYr/0xR6Wjw5Pk0noXWg2u+BAu5GLsZBAstZDQSWW4oxEQy3mouJEACvW
	w1NoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd27V0tDDG4tULC4/uU5q8XhRS8Y
	LXY0HGG16F1wlc3i5qdvrBaXd81hs5hxfh+TxaKtX9gdODx2zrrL7tG3ZRWjx+dNcgHMUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMx5eESu4wVqxpqeVvYHxJksXIyeH
	hICJxNxjW5kgbDGJC/fWs3UxcnEICSxilDh4eyUzhNPGJDFp5Q52kCo2AW2J7+sXs4LYIgKh
	Ep8vzAIrYha4xSix+dlusCJhgSiJi7f7GEFsFgFViWmLPzOD2LwCHhLrZi8DWsEBtE5BYs4k
	G5Awp4CnxKbTh8BKhIBKtu69wDaBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODY
	eSa1g3Flg8UhRgEORiUe3gip0hAh1sSy4srcQ4wSHMxKIrxfNwCFeFMSK6tSi/Lji0pzUosP
	MZoCHTWRWUo0OR8Y13kl8YbGJmZGlkbmhhZGxuZK4rw3buaGCAmkJ5akZqemFqQWwfQxcXBK
	NTBatRrktW//7C517uSt+H13ez7LOx9eMm2uTDrj97LyxtUiSSfmVdluN59bHS2Z+UNqTQuL
	mv4jrjWtdnFCTy0/Xr+1wzT89Sf1OA/fXoGdx7PYWL5s0pWWnnlwvWz0y+Ifi689XnVg05+D
	tmv27hN59apz4YQNT7Mmqv4xWeD9bmlpzaGvnBsWKrEUZyQaajEXFScCAKoqJkSzAgAA
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

