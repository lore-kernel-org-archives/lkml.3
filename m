Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaKXK6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:58:18 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbaKXK56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:57:58 -0500
X-AuditID: cbfee68f-f791c6d000004834-f3-54730f31ad0a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com
Cc: jh80.chung@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        yj44.cho@samsung.com, geunsik.lim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 3/3] ARM: dts: Remove unused command line from
 Exynos3250-based Rinato board
Date: Mon, 24 Nov 2014 19:57:50 +0900
Message-id: <1416826670-29438-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
References: <1416826670-29438-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSqGvIXxxi8KeD2+L6l+esFvOPnGO1
	+DOhlc1i0v0JLBY3frWxWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi6XXLzJZTJi+lsWi
	de8RdosZk1+yWezdOZnRgd9jzbw1jB6bVnWyeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6
	dglcGefu7GYrWMBWse/QY/YGxvmsXYwcHBICJhK37tp2MXICmWISF+6tZ+ti5OIQEljKKPH4
	/gZGiISJxINvrcwQiemMEr8u7oCqamKSeH2gnxWkik1AS2L/ixtsILaIQKTEynU/WEGKmAW2
	MEk8mvgDrEhYIEHi571XYGNZBFQlbn37ywZyBq+Aq8Td+/UQ2xQkli2fCVbOKeAmsXLmK3YQ
	WwioZM+FOewgMyUErrFLrL4KM0dA4tvkQywQ78hKbDrADDFHUuLgihssExiFFzAyrGIUTS1I
	LihOSi8y1itOzC0uzUvXS87P3cQIjJrT/57172C8e8D6EKMAB6MSD++M9UUhQqyJZcWVuYcY
	TYE2TGSWEk3OB8ZmXkm8obGZkYWpiamxkbmlmZI470Kpn8FCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGK3Xie55++dCRM+U2oKdb/vMHE1zT7Od5PWvDLzNplYxJ+NfSH6rp6Mw71zGYHbF
	Wx+8p8yMfbxX2aD72GfG4J32HWILpr7/KLl+vXyg4GxTsctHNjWq3jnKFn9d8LWElHL58/kb
	Nglp7br+tHmL6cbJG0x2H+b0nK31RcLe/pX6k0+9HneZZJVYijMSDbWYi4oTATD30B+VAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQV1D/uIQg54uZovrX56zWsw/co7V
	4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWmx5fY7W4vGsOm8WM8/uYLJZev8hkMWH6WhaL
	1r1H2C1mTH7JZrF352RGB36PNfPWMHpsWtXJ5rF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYp
	pOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2rpFCWmFMKFApILC5W
	0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4d2c3W8ECtop9hx6zNzDOZ+1i5OSQEDCRePCt
	lRnCFpO4cG89WxcjF4eQwHRGiV8Xd0A5TUwSrw/0g3WwCWhJ7H9xgw3EFhGIlFi57gcrSBGz
	wBYmiUcTf4AVCQskSPy894oRxGYRUJW49e0vUAMHB6+Aq8Td+/UQ2xQkli2fCVbOKeAmsXLm
	K3YQWwioZM+FOewTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOymdSOxhXNlgc
	YhTgYFTi4f2wsShEiDWxrLgy9xCjBAezkgjvPsbiECHelMTKqtSi/Pii0pzU4kOMpkBHTWSW
	Ek3OByaMvJJ4Q2MTMyNLI3NDCyNjcyVx3hs3c0OEBNITS1KzU1MLUotg+pg4OKUaGBX2l59I
	bX9/6G+8j7B4ep9T14TZeTMttVtPNV2VcA9hPr7jZuOh/Ws+OvuseDKvP7O1+LHNHzn1NMP2
	c3nzZ/vMi2TJudG1rmXr/1NFck/ZD668vXHxz4mycY9O6V98GDf5SzSv95zHUgLCqec0OiT+
	b27cMHfJPIWKOoE6/1D9m5MutbYeOKfEUpyRaKjFXFScCABEQu+e4AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused dt node of command line from Exynos3250-based
Rinato board because kernel use the command line from bootloader.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 84380fa..80aa8b4 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -28,10 +28,6 @@
 		reg =  <0x40000000 0x1ff00000>;
 	};
 
-	chosen {
-		bootargs = "console=ttySAC1,115200N8 root=/dev/mmcblk0p15 rootwait earlyprintk panic=5";
-	};
-
 	firmware@0205F000 {
 		compatible = "samsung,secure-firmware";
 		reg = <0x0205F000 0x1000>;
-- 
1.8.5.5

