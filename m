Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaHLCBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:01:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46021 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaHLCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:01:23 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b1-53e9756eb388
From: y@samsung.com
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 5/5] ARM: dts: Fix wrong compatible string of Exynos3250 RTC
 dt node
Date: Tue, 12 Aug 2014 11:01:11 +0900
Message-id: <1407808871-6046-6-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407808871-6046-1-git-send-email-y@samsung.com>
References: <y@samsung.com> <1407808871-6046-1-git-send-email-y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgG5e6ctgg/7nahZLLl5lt7j+5Tmr
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFvs7Oxgd2D32TDzJ5tG3ZRWjx/R5P5k8Pm+SC2CJ4rJJ
	Sc3JLEst0rdL4Mpo+jeXseAyW0XjuV/sDYz7WLsYOTkkBEwkVpy8zARhi0lcuLeerYuRi0NI
	YBGjxMeTv5khnCYmicWPZwNlODjYBIQlph7QAmkQEZCQWDLnDiNIDbPAbkaJyWtesoAkhAUi
	JG7teQI2lUVAVWLF9f9gcV4BG4kndyaxQGyTk/iw5xE7iM0pYCvxa8kKsLiQgI/Evck3WCcw
	8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxMz6R2MK5ssDjEKMDBqMTDO+Pvi2Ah
	1sSy4srcQ4wSHMxKIrzHZF8GC/GmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2a
	WpBaBJNl4uCUamCcdskveu+veq+/Dn796ZarPFZ8u8qmsebSp+1/KrI3b9aPzJ6/qbU6UPsr
	u771rsv1x04aedlP+jjvgG72410huTWX/JL6O8v8zxs4n/TuXZuVtyL+Fb9/zMXjizVlHhcY
	XuuaMXnzvQkXf+ZWTvDea/2suUPyzfm4+oDdM089yDDStSrcuDZOiaU4I9FQi7moOBEAvCaR
	niICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt
node. The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index cd6a69a..1be5ef8 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -192,7 +192,7 @@
 		};
 
 		rtc: rtc@10070000 {
-			compatible = "samsung,s3c6410-rtc";
+			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
 			interrupts = <0 73 0>, <0 74 0>;
 			status = "disabled";
-- 
1.8.0

