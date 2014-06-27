Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaF0GLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:11:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29651 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaF0GLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:11:24 -0400
X-AuditID: cbfee690-b7fb56d000003439-24-53ad0b0ae340
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, cpgs@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 1/2] ARM: DTS: use new compatible string for thermistors in
 trats2
Date: Fri, 27 Jun 2014 11:38:14 +0530
Message-id: <1403849295-29538-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1403849295-29538-1-git-send-email-ch.naveen@samsung.com>
References: <1403849295-29538-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkTpeLe22wwY4NEhYvD2laXP/ynNVi
	/pFzrBZnlx1ks2hevJ7NYt6RdywWl3fNYbOYcX4fk8Wibf+ZHTg9ZjdcZPHYOesuu8f+uWvY
	Pfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj8z6DgtucFS/Wf2FrYPzO3sXIySEhYCKx7+Ji
	NghbTOLCvfVANheHkMBSRokr14+zwhR1n1nEBJGYziixeM11qKp+Jol701+BtbMJmEkcXLQa
	bKyIgKPEjjn/wDqYBY4xSuybN58RJCEsEC7xavFtJhCbRUBV4nf/cRYQm1fAVWLKg/1A6ziA
	1ilIzJlkAxLmFHCTeNf2gRnEFgIq+fl+JwvITAmBVewSm6dfY4GYIyDxbfIhFoheWYlNB5gh
	rpaUOLjiBssERuEFjAyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQID//S/ZxN2MN47YH2I
	MRlo3ERmKdHkfGDk5JXEGxqbGVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDYwYDc2+s1t8nbC5F3A/nhG5kzj14y/zVoQUXvku4m/Zu3RaQ76r/o2qjZTnr
	gcree+Urq5dOkdTc+8zZvHPnxmtrq9+2SW9kzCnnslIzWecif2bG7Wmu4uEn03q+vH07bSYD
	c6rZhFdc590rHVItHc9rnbo18/llNmbOrP1xnVFL9S84BqwWVWIpzkg01GIuKk4EAPo/uG2S	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jQV0u7rXBBste8Vu8PKRpcf3Lc1aL
	+UfOsVqcXXaQzaJ58Xo2i3lH3rFYXN41h81ixvl9TBaLtv1nduD0mN1wkcVj56y77B77565h
	9+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGZv3GRTc
	5qx4sf4LWwPjd/YuRk4OCQETie4zi5ggbDGJC/fWs3UxcnEICUxnlFi85jqU088kcW/6KzaQ
	KjYBM4mDi1aDdYsIOErsmPOPCaSIWeAYo8S+efMZQRLCAuESrxbfBhvLIqAq8bv/OAuIzSvg
	KjHlwX7WLkYOoHUKEnMm2YCEOQXcJN61fWAGsYWASn6+38kygZF3ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzguHomtYNxZYPFIUYBDkYlHl4DjzXBQqyJZcWVuYcYJTiYlUR4X94D
	CvGmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MObzSuINjU3MTY1NLU0sTMwslcR5D7RaBwoJ
	pCeWpGanphakFsH0MXFwSjUwOgts65T2ZJaLCGBPqOrVjO/5pzXl0mppuWze7mTHnsC53q/3
	LN0YHOcQ0fj56zv+ttAcPx/NcvkT4pn/+IX5WlYWudpyRa2eYOES4s+29zPfKVVRL8ZVBVOE
	rjx+M8vqA5/0nPyYDe+Wmm5YwfB+0/XQiVUKTZ0Gx7LSugsOrLldyap16Z0SS3FGoqEWc1Fx
	IgBTNOH7wQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Murata Manufactures the NTC based thermistors. The vendor
name in the compatibility is preposed to change to "murata"

This patch uses the new compatibility string in exynos4412 based
Trats2 board.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
---
Changes since v1: None

 arch/arm/boot/dts/exynos4412-trats2.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 11967f4..d35755a 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -771,7 +771,7 @@
 	};
 
 	thermistor-ap@0 {
-		compatible = "ntc,ncp15wb473";
+		compatible = "murata,ncp15wb473";
 		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
 		pullup-ohm = <100000>;	 /* 100K */
 		pulldown-ohm = <100000>; /* 100K */
@@ -779,7 +779,7 @@
 	};
 
 	thermistor-battery@1 {
-		compatible = "ntc,ncp15wb473";
+		compatible = "murata,ncp15wb473";
 		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
 		pullup-ohm = <100000>;	 /* 100K */
 		pulldown-ohm = <100000>; /* 100K */
-- 
1.7.9.5

