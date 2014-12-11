Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaLKMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:13:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23053 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaLKMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:13:27 -0500
X-AuditID: cbfee691-f79b86d000004a5a-6a-54898a65f8fd
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, kishon@ti.com, k.debski@samsung.com, kgene@kernel.org,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 4/4] arm: dts: exynos5250: Remove vbus gpio property from usb
 2.0 host
Date: Thu, 11 Dec 2014 17:32:47 +0530
Message-id: <1418299367-2412-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
References: <1418299367-2412-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkWje1qzPEoGORocX8I+dYLdquHGS3
	uLzwEqvFj9cX2Cz6H79mtrjwtIfN4vKuOWwWM87vY7JYtKyV2aJ17xF2By6PTas62Tz6tqxi
	9Dh+YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZ+99zFxzjrDh25ydTA+NH9i5GTg4JAROJzhuT
	oWwxiQv31rN1MXJxCAksZZS40tnJAlPU1/6UFSKxiFFidWsDO4QzgUli7exJzCBVbAK6Ek1v
	dzGC2CICNRJTbl0BK2IW6GWU+PfhHCtIQlggQqJ/wkewsSwCqhJbF04F280r4C4xfepTqHVy
	EltuPQKLcwp4SCzq+QkU5wDa5i5xtVcTZKaEwDJ2ic63s5gg5ghIfJt8CKxGQkBWYtMBZogx
	khIHV9xgmcAovICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGYOif/vds4g7G+wesDzEK
	cDAq8fBmxHeGCLEmlhVX5h5iNAXaMJFZSjQ5HxhheSXxhsZmRhamJqbGRuaWZkrivDrSP4OF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MNazvrm4wqthx8Opf1KuWi1O6NL3v7vr/Jvw+dHe
	m/x5Ntqap+/bsn3pXZ7599t4BOt1Kmr/fczwuX454m6+2fu1jrJ2a9m4Vu+8N9MplqVX8k1H
	RaXSzISkh9/5444nJ+p+4pjZdL5/S0mM92+9+MhE+5Q8TtbIqduqrztLiRjFaWlP0NA5r8RS
	nJFoqMVcVJwIAM0v/3h4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAd3Urs4Qg3mrNC3mHznHatF25SC7
	xeWFl1gtfry+wGbR//g1s8WFpz1sFpd3zWGzmHF+H5PFomWtzBate4+wO3B5bFrVyebRt2UV
	o8fxG9uZPD5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
	VXLxCdB1y8wBukhJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLH/PXfB
	Mc6KY3d+MjUwfmTvYuTkkBAwkehrf8oKYYtJXLi3nq2LkYtDSGARo8Tq1gZ2CGcCk8Ta2ZOY
	QarYBHQlmt7uYgSxRQRqJKbcugJWxCzQyyjx78M5sFHCAhES/RM+soDYLAKqElsXTgVbxyvg
	LjF96lMWiHVyEltuPQKLcwp4SCzq+QkU5wDa5i5xtVdzAiPvAkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBkfVMegfjqgaLQ4wCHIxKPLwZ8Z0hQqyJZcWVuYcYJTiYlUR4rSKAQrwp
	iZVVqUX58UWlOanFhxhNgY6ayCwlmpwPjPq8knhDYxNzU2NTSxMLEzNLJXFeJfu2ECGB9MSS
	1OzU1ILUIpg+Jg5OqQbGbLvdtr6x68KM9j6aWD7pw/mNuy89nTJ9W9A93bRvPIv5rORfbI/p
	iv0xd3GfQ6cZQ18c5yFLafGtvsc+ZT2LvDItx/DzU4H66umeNQazErJstkpseWUgfWDJuue7
	7CzYXFafEnJq0HeZZbrw9nZldXb9Buf9cz5zhJ497p/UGXFdc2bUVAZ3JZbijERDLeai4kQA
	0TdlscICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can use the VBUS regulator for USB 2.0 phy, we can
remove the vbus-gpio property from usb 2.0 host to avoid
duplicate gpio settings.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |    4 ----
 arch/arm/boot/dts/exynos5250-snow.dts     |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 85e74df..281b962 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -372,10 +372,6 @@
 		enable-active-high;
 	};
 
-	usb@12110000 {
-		samsung,vbus-gpio = <&gpx2 6 0>;
-	};
-
 	dp-controller@145B0000 {
 		samsung,color-space = <0>;
 		samsung,dynamic-range = <0>;
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index 8085750..ee966c3 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -296,10 +296,6 @@
 		enable-active-high;
 	};
 
-	usb@12110000 {
-		samsung,vbus-gpio = <&gpx1 1 0>;
-	};
-
 	fixed-rate-clocks {
 		xxti {
 			compatible = "samsung,clock-xxti";
-- 
1.7.10.4

