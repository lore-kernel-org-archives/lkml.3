Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaKLClR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:41:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14759 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaKLClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:41:14 -0500
X-AuditID: cbfee68e-f79b46d000002b74-51-5462c8c719a7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] ARM: dts: Fix the number of DMA channels for Exynos4
Date: Wed, 12 Nov 2014 11:41:08 +0900
Message-id: <1415760068-765-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1415760068-765-1-git-send-email-cw00.choi@samsung.com>
References: <1415760068-765-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkQPf4iaQQg01dNhaT1h1gsrj+5Tmr
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72NyYPf4u+oFs8fmJfUefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlbG//TJLwWT2inlzbrE1MF5h7WLk5JAQMJFY8XIJC4QtJnHh3nq2LkYuDiGB
	pYwS09ZfZoMp2n99IVRiOqPEp1lNrBBOE5PEwp6nTCBVbAJaEvtf3ADrEBGQlGhq+MMMUsQs
	sIVR4vv+w+wgCWEBT4n1r28zgtgsAqoSvx/OAbuDV8BZ4mf3BXaIdQoSy5bPBItzCrhIPNxw
	CmyBEFDNoq7XYGdICPSzSxy9CTNIQOLb5ENAT3AAJWQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpRcZ6RUn5haX5qXrJefnbmIEhvfpf8/6djDePGB9iFGAg1GJhzdjc1KIEGtiWXFl
	7iFGU6ANE5mlRJPzgVGUVxJvaGxmZGFqYmpsZG5ppiTOmyD1M1hIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDo+Rj0QbWdf+zXkzfk7j+0IH8zHqV+Znsb27VsxWFqjoHF14/xXA5/HRFpbbu
	yrUBOR/t12w9v1pa/rfahSBFud1u8wPWKMncl9YTEDj0fbq1gVXRocNs+g7R23uPHvh7vnm1
	s7S1VaPAxUv7jE7PzNhYe08xRXj7namXZYN8dTg2WFirm4tFKLEUZyQaajEXFScCAKY9HQ5q	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd3jJ5JCDH4sNLWYtO4Ak8X1L89Z
	LXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+TA7vH31UvmD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ+9svsxRMZq+YN+cWWwPjFdYuRk4O
	CQETif3XF7JB2GISF+6tB7K5OIQEpjNKfJrVxArhNDFJLOx5ygRSxSagJbH/xQ2wDhEBSYmm
	hj/MIEXMAlsYJb7vP8wOkhAW8JRY//o2I4jNIqAq8fvhHLB1vALOEj+7L7BDrFOQWLZ8Jlic
	U8BF4uGGU2ALhIBqFnW9ZpvAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnD0PJPe
	wbiqweIQowAHoxIPb8bmpBAh1sSy4srcQ4wSHMxKIrwPlgKFeFMSK6tSi/Lji0pzUosPMZoC
	XTWRWUo0OR8Y2Xkl8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhiX
	BThoeR6fP3P6yai2jTLznc8nm1kJb553iDN8Tl3oyT72m10btmz/t2aBmc6vlkvvzr+UOud1
	5hLL/qpSVf1Dmsmz/LJNfGaLaH9ekH9zozGPSdgCK7lMpgoXtoNCGQtNa6bWHuJc92C6Sg0H
	l6Ix10bBRo6pm09LXflmZyz7acbdPev3dyoqsRRnJBpqMRcVJwIAarVcMrQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the numer for DMA channels for Exynos4210/Exynos4212/Exynos4412
because DMA controller of Exynos4 series can support 16 channels simultaneously.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e0278ec..3b2c3dd 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -606,7 +606,7 @@
 			clocks = <&clock CLK_PDMA0>;
 			clock-names = "apb_pclk";
 			#dma-cells = <1>;
-			#dma-channels = <8>;
+			#dma-channels = <16>;
 			#dma-requests = <32>;
 		};
 
@@ -617,7 +617,7 @@
 			clocks = <&clock CLK_PDMA1>;
 			clock-names = "apb_pclk";
 			#dma-cells = <1>;
-			#dma-channels = <8>;
+			#dma-channels = <16>;
 			#dma-requests = <32>;
 		};
 
-- 
1.8.5.5

