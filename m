Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3EKHoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 03:44:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14467 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3EKHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 03:43:58 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-af-518df6bc4823
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: Document DP clock in samsung,exynos5-dp binding
Date: Sat, 11 May 2013 16:43:56 +0900
Message-id: <003101ce4e1b$4acc0050$e06400f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5OGzfswwcdIIipQr+zi66G/brL4g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zA90933oDDabeN7A4u+wgm8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHHq+mc2i2MzljA6cHjMbrjI4nHn2h42j81L6j2unGhi
	9ejbsorR4/MmuQC2KC6blNSczLLUIn27BK6MZX+2MxX856ho7bvC0sC4ir2LkZNDQsBE4sLX
	XawQtpjEhXvr2boYuTiEBJYxSrzf38UCU3To+AuwBiGB6YwSE9qyIIp+MUos/nODDSTBJqAm
	8eXLYbAiEQENiae7jzCCFDELdDNJHD2yFaxIWMBPYlHXB7AiFgFViat774Gt5hWwlHjT+5sN
	whaU+DH5HthmZgEtifU7jzNB2PISm9e8ZYa4SEFix9nXjBDL9CSuzFzPDFEjIrHvxTuwxRIC
	t9glZhxbDbVMQOLb5ENAQzmAErISmw5AzZGUOLjiBssERrFZSFbPQrJ6FpLVs5CsWMDIsopR
	NLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJEb7djDePGB9iDEZaP1EZinR5HxgjOeVxBsamxlZ
	mJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbEsfeWNxEb7CRcf
	KKQlOh5Re6QUtmNfp2FA0Z8L82R/ayycsOfFHY37EcwLc5oNnCQlH9herth6oOixwYkaxonP
	Cp+9tvkk5SXtI/PA87CHn11C+MzFZ9est59g6KOUlJtx9apBHcOs7vw0W+W1j+bJXloy9ZWu
	RoSf38GQ4OYUTQvrXIa5P5RYijMSDbWYi4oTAZk2WKnnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd0933oDDdYs1LE4u+wgm8XlhZdY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHHq+mc2i2MzljA6cHjMbrjI4nHn2h42j81L6j2unGhi
	9ejbsorR4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGcv+bGcq
	+M9R0dp3haWBcRV7FyMnh4SAicSh4y+gbDGJC/fWs4HYQgLTGSUmtGV1MXIB2b8YJRb/uQGW
	YBNQk/jy5TBYg4iAhsTT3UcYQYqYBbqZJI4e2QpWJCzgJ7Go6wNYEYuAqsTVvfdYQWxeAUuJ
	N72/2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIZbpSVyZuZ4ZokZEYt+L
	d4wTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcAJ4JrWD
	cWWDxSFGAQ5GJR5eBYHeQCHWxLLiytxDjBIczEoivM8eAIV4UxIrq1KL8uOLSnNSiw8xJgN9
	OpFZSjQ5H5ic8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	sf/dX8v6ho0Na1y5r7pP5HZaX8MX9YTHQYh139fFVQdu50lbGBYpMu5puDV5haI+y63L/09+
	mB7wuUWSL+SIsOHpjZ6KYn7//j/O1lrO8CBhldrmjnuvxSeHXX1XbWjnX6z0+yrb9uVhuvPu
	zo7l3LXMX7LGmjl4/degX721+WHtpQ9YnE/0KLEUZyQaajEXFScCALFUGjVEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos5-dp node needs a clock specified using the common clock
framework.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5250

 .../devicetree/bindings/video/exynos_dp.txt        |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
index c60da67..84f10c1 100644
--- a/Documentation/devicetree/bindings/video/exynos_dp.txt
+++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
@@ -21,6 +21,10 @@ Required properties for dp-controller:
 		of memory mapped region.
 	-interrupts:
 		interrupt combiner values.
+	-clocks:
+		from common clock binding: handle to dp clock.
+	-clock-names:
+		from common clock binding: Shall be "dp".
 	-interrupt-parent:
 		phandle to Interrupt combiner node.
 	-samsung,color-space:
@@ -61,6 +65,8 @@ SOC specific portion:
 		reg = <0x145b0000 0x10000>;
 		interrupts = <10 3>;
 		interrupt-parent = <&combiner>;
+		clocks = <&clock 342>;
+		clock-names = "dp";
 
 		dptx-phy {
 			reg = <0x10040720>;
-- 
1.7.2.5


