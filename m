Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117AbaKLCvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:51:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55320 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaKLCud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:50:33 -0500
X-AuditID: cbfee68f-f791c6d000004834-35-5462caf6c1cf
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/2] ARM: dts: Fix the number of DMA channels for Exynos3250
Date: Wed, 12 Nov 2014 11:50:28 +0900
Message-id: <1415760629-1531-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
References: <1415760629-1531-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkWPfbqaQQg++POC0mrTvAZHH9y3NW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38fkwO7xd9ULZo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK+PsrEfsBVPZKz4u+MTYwHictYuRg0NCwETi8trKLkZOIFNM4sK99WxdjFwc
	QgJLGSWWPFrDCpEwkTjxaSkrRGIRo8SN742MEE4Tk8SZfX3MIFVsAloS+1/cYAOxRQQkJZoa
	/jCDFDELbGGU+L7/MDtIQljAT+LE/6NgRSwCqhJ7VnSD2bwCLhLrH85gglinILFs+Uyw1ZwC
	rhLdKycxgthCQDUXj69gARkqIdDPLrHrdwcLxCABiW+TD7FA/CMrsekAM8QcSYmDK26wTGAU
	XsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMLhP/3vWv4Px7gHrQ4wCHIxKPLwZm5NC
	hFgTy4orcw8xmgJtmMgsJZqcD4yhvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNITS1KzU1ML
	Uovii0pzUosPMTJxcEo1MLb9bhDjvvx3wo9lkw9Oe/626Y5T2oI/2yed6ure5eP8WJs98xbz
	myMf9Ksc74frvV/78YE4W8Tkf3u8lr40EVt/ZolujmaP02yfwpURMbwPkk+K2e81i/Q4asPx
	xuAV700lx1xXj5h1V/lzv+5x/yQy8bHBpa92U+8/l3iQ0WS09vXTwCXb/m9WYinOSDTUYi4q
	TgQAMVj9UmkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd1vp5JCDNY/Z7KYtO4Ak8X1L89Z
	LXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+TA7vH31UvmD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZZ2c9Yi+Yyl7xccEnxgbG46xdjJwc
	EgImEic+LYWyxSQu3FvP1sXIxSEksIhR4sb3RkYIp4lJ4sy+PmaQKjYBLYn9L26wgdgiApIS
	TQ1/mEGKmAW2MEp833+YHSQhLOAnceL/UbAiFgFViT0rusFsXgEXifUPZzBBrFOQWLZ8Jthq
	TgFXie6VkxhBbCGgmovHV7BMYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4ep5J
	72Bc1WBxiFGAg1GJhzdjc1KIEGtiWXFl7iFGCQ5mJRHeB0uBQrwpiZVVqUX58UWlOanFhxhN
	ga6ayCwlmpwPjOy8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2M
	2jPOe1jLVJ9bf/B2qsnlhgtRxyeUL3zU8LH862bmKbnmfHryq9+mpk6aJL915eTfn8+e3rG7
	jSHRuv5IpGiFfN3BHw+U7nQ1emRHN2guuLdSIvrqpu2sXvw7spyszCXNVqZom3l/nPp+e31y
	ftftkqTyayaGzC/ZuT593bVEfNvr+MMh99IvK7EUZyQaajEXFScCAB5lpnO0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the numer for DMA channels for Exynos3250 because DMA controller
of Exynos3250 can support 16 channels simultaneously.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 242ddda..5c14e3e 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -292,7 +292,7 @@
 				clocks = <&cmu CLK_PDMA0>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16>;
 				#dma-requests = <32>;
 			};
 
@@ -303,7 +303,7 @@
 				clocks = <&cmu CLK_PDMA1>;
 				clock-names = "apb_pclk";
 				#dma-cells = <1>;
-				#dma-channels = <8>;
+				#dma-channels = <16;
 				#dma-requests = <32>;
 			};
 		};
-- 
1.8.5.5

