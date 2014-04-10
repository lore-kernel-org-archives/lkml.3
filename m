Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbaDJKGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:06:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15012 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676AbaDJKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:34 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-ae-53466d275ddb
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 26/27] ARM: dts: exynos3250: Add power domain dt nodes
Date: Thu, 10 Apr 2014 19:06:16 +0900
Message-id: <1397124377-16969-18-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSoque6xZs8GGilcXGGetZLa5/ec5q
	8flDC7vFpPsTWCx6F1xlszjb9IbdYtPja6wWl3fNYbOYcX4fk8WMyS/ZLNbPeM1isXfnZEYH
	Ho/NS+o9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PnrqqCPp6KY2eb2RoYJ3F1MXJySAiY
	SCz7sZINwhaTuHBvPZDNxSEksJRRouXbbxaYoudr/zOD2EICixglNl+JgShqYpK4tXcyE0iC
	TUBLYv+LG2CTRAQCJH4cfwc2iVlgIpPEwjczgSZxcAgLuEkcvRcLUsMioCrxfH4rK4jNCxQ+
	u3I3M8QyOYkPex6xg9icQPGZi06yQSx2leh5dJEZZKaEwDp2iWnrlrJADBKQ+Db5ENh8CQFZ
	iU0HoOZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiBEXD637OJOxjv
	H7A+xJgMNG4is5Rocj4wgvJK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgXFfiveNsztenL2Wk2MQe2y5w1rj5j7/JlbJyRdfrPtZ+aL9rnehzc9T
	XRM6uWweb5E4XH9zxSKFCx95HN7z/o7b/NXHfb65wu7wsgMM6zXcmpb3sZwtzD1s9PDOeR2X
	Y8t1g4Tmyk056hGpIM9zonc2f/+l6uCN7CtqFop8NK1cYZnayJt8TFWJpTgj0VCLuag4EQAh
	yyQvlgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAV31XLdgg7ffDS02zljPanH9y3NW
	i88fWtgtJt2fwGLRu+Aqm8XZpjfsFpseX2O1uLxrDpvFjPP7mCxmTH7JZrF+xmsWi707JzM6
	8HhsXlLv0bdlFaPH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koK
	eYm5qbZKLj4Bum6ZOUBXKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz
	fu6qKujjqTh2tpmtgXESVxcjJ4eEgInE87X/mSFsMYkL99azgdhCAosYJTZfieli5AKym5gk
	bu2dzASSYBPQktj/4gZYkYhAgMSP4+/YQIqYBSYySSx8M5Oli5GDQ1jATeLovViQGhYBVYnn
	81tZQWxeoPDZlbuhlslJfNjziB3E5gSKz1x0Emqxq0TPo4vMExh5FzAyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIjq9n0jsYVzVYHGIU4GBU4uE9sMw1WIg1say4MvcQowQHs5II7+5M
	t2Ah3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgfGfl5JvKGxiZmRpZG5oYWRsTlpwkrivAdb
	rQOFBNITS1KzU1MLUotgtjBxcEo1MOr11vHe1nvo21Dc92GfVvTGhY63rxwQKp2ivTA3xGxh
	4aVF61MNMuZN65zSn1xbLLpox5pdomdmTFL92/NgXwqjWYrFo8dc2+fLe3xiuX3g7qYQ/YXz
	ey3anBXb2q+8V8w5kHMxJcO+wGfNwvultwXjtosqMs51S1lbF8ba1xbVtcpx80qzLUosxRmJ
	hlrMRcWJAILIFv/zAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inki Dae <inki.dae@samsung.com>

This patch add CAM/MFC/G3D/LCD0/ISP power domain nodes for Exynos3250.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
[add CAM/MFC power domain node by Bartlomiej Zolnierkiewicz]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
[add ISP power domain node by Bartlomiej Zolnierkiewicz]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index a61940f..192770a 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -82,6 +82,31 @@
 		reg = <0x10010000 0x400>;
 	};
 
+	pd_cam: cam-power-domain@10023C00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C00 0x20>;
+	};
+
+	pd_mfc: mfc-power-domain@10023C40 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C40 0x20>;
+	};
+
+	pd_g3d: g3d-power-domain@10023C60 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C60 0x20>;
+	};
+
+	pd_lcd0: lcd0-power-domain@10023C80 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023C80 0x20>;
+	};
+
+	pd_isp: isp-power-domain@10023CA0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023CA0 0x20>;
+	};
+
 	cmu: clock-controller@10030000 {
 		compatible = "samsung,exynos3250-cmu";
 		reg = <0x10030000 0x20000>;
-- 
1.8.0

