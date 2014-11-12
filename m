Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaKLCuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:50:39 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53194 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaKLCuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:50:32 -0500
X-AuditID: cbfee68d-f79296d000004278-32-5462caf6b3b6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 2/2] ARM: dts: Fix the number of DMA channels for Exynos4
Date: Wed, 12 Nov 2014 11:50:29 +0900
Message-id: <1415760629-1531-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
References: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkQPfbqaQQg+U7BC0mrTvAZHH9y3NW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38fkwO7xd9ULZo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK2N3fyNzwSaeio1XZ7I3MF7k7GLk5JAQMJHY93AfC4QtJnHh3nq2LkYuDiGB
	pYwS5298YYcpunbsFztEYhGjxO7Fy6GqmpgkzuzrYwapYhPQktj/4gYbiC0iICnR1PCHGaSI
	WWALo8T3/YeB2jk4hAW8JfbNYwUxWQRUJc78EwMp5xVwkXh2dDfUFQoSy5bPZAWxOQVcJbpX
	TmIEsYWAai4eX8ECMlJCoJ9d4ua+NWC7WAQEJL5NPsQCMlNCQFZi0wFmiDmSEgdX3GCZwCi8
	gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgaJ/+96x3B+PtA9aHGAU4GJV4eBPWJIUI
	sSaWFVfmHmI0BdowkVlKNDkfGEF5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwrvzzSiOr68e/XJWQoiVRU9wOzWVcX9LOEPc3LJZH+c+8xOkvCgIU
	T+R8deSY+6FzG2/pwduCJk+nzJ8slNkuyrvi3XufS8cuX652fd6wTXXOsYIPQlOfbC/oE/9r
	3CHz57/nX6X0F6dO8EducE29uLKpsz7teXl3l/LL5A/e0ftXrNuWdGGigxJLcUaioRZzUXEi
	ALjbxvZoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd1vp5JCDNYs4LKYtO4Ak8X1L89Z
	LXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+TA7vH31UvmD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZu/sbmQs28VRsvDqTvYHxImcXIyeH
	hICJxLVjv9ghbDGJC/fWs3UxcnEICSxilNi9eDmU08QkcWZfHzNIFZuAlsT+FzfYQGwRAUmJ
	poY/zCBFzAJbGCW+7z8MNIqDQ1jAW2LfPFYQk0VAVeLMPzGQcl4BF4lnR3ezQCxTkFi2fCYr
	iM0p4CrRvXISI4gtBFRz8fgKlgmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfO
	M+kdjKsaLA4xCnAwKvHwZmxOChFiTSwrrsw9xCjBwawkwvtgKVCINyWxsiq1KD++qDQntfgQ
	oynQUROZpUST84FRnVcSb2hsYmZkaWRuaGFkbK4kznuw1TpQSCA9sSQ1OzW1ILUIpo+Jg1Oq
	gVFYWEQ4kU0ooGH33jyfS4lVRrEqnc5/1Zj6U3Q67Xbrl13u7s/Xeqthc+b5Xv5/wkKS1l2P
	XxUE2qtIfp/WuOuwVYoDj8aN4Jq0rdyapZ5WPH62+Vc5d9zk2z5TJaWR/Zvf3i4+iZLOig+x
	b+Vsiu5I3S+ace3fuSkc701si7eb79x+5N0mJZbijERDLeai4kQAoytvLrICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the numer for DMA channels for Exynos4210/Exynos4212/Exynos4412
/Exynos4415 because DMA controller of Exynos4 series can support 16 channels
simultaneously.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    | 4 ++--
 arch/arm/boot/dts/exynos4415.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
 
diff --git a/arch/arm/boot/dts/exynos4415.dtsi b/arch/arm/boot/dts/exynos4415.dtsi
index c1c9b37..a097332 100644
--- a/arch/arm/boot/dts/exynos4415.dtsi
+++ b/arch/arm/boot/dts/exynos4415.dtsi
@@ -348,7 +348,7 @@
 				clocks = <&cmu CLK_PDMA0>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16>;
 				#dma-requests = <32>;
 			};
 
@@ -359,7 +359,7 @@
 				clocks = <&cmu CLK_PDMA1>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16>;
 				#dma-requests = <32>;
 			};
 		};
-- 
1.8.5.5

