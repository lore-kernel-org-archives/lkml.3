Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaF0EaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:30:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12745 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaF0EaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:30:16 -0400
X-AuditID: cbfee690-b7fb56d000003439-f1-53acf35654b9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 4/4] ARM: dts: Fix wrong compatible string for Exynos3250 ADC
Date: Fri, 27 Jun 2014 13:30:06 +0900
Message-id: <1403843406-28229-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkSDfs85pgg64rXBZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZnG16w24x78g7FovLu+awWcw4v4/JYun1i0wW
	E6avZbF4e2c6i0Xr3iPsFif/9DJarJ/xmsVB0GPNvDWMHpf7epk8Vi7/wuaxeYWWx6ZVnWwe
	d67tYfPo27KK0ePzJrkAjigum5TUnMyy1CJ9uwSujOML8wqecFT8ffWMpYFxPnsXIyeHhICJ
	REfrYxYIW0ziwr31bF2MXBxCAksZJZrX/2eBKdp3aAIzRGI6o8TSCW1MEE4Tk0Rr5xpmkCo2
	AS2J/S9usIHYIgIREvM37wArYhZ4BlT0oo8RJCEs4C9x8Mw5VhCbRUBVYt+/JiYQm1fAVaL5
	+UI2iHVyEh/2PAK6j4ODU8BNYuKTApCwEFDJi+9bWEFmSgj8ZJc4vOoCI8QcAYlvkw+xgNRL
	CMhKbDrADDFGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjLPT/55N
	2MF474D1IcZkoHETmaVEk/OBcZpXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTU
	gtSi+KLSnNTiQ4xMHJxSDYzFQTtt1thOO+Elu35y0Ofjn9ybTCXZMn68LHk12aOqqdi147GB
	xWaR2qufjxzmuPw2Tf331jkPovuTWA5opLosqmn6feuCl8bZ2dri3S/5+EWWSgrNWLTdzuLC
	9wUshSErzm2dfvPMjAWxPcempZ8yXBG3IlOJ4bWT8fpDJtODo1kaTijPmzRJiaU4I9FQi7mo
	OBEAGsHkI8kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd2wz2uCDZ4uYLK4+/wwo8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXN4mzTG3aLeUfesVhc3jWHzWLG+X1MFkuvX2Sy
	mDB9LYvF2zvTWSxa9x5htzj5p5fRYv2M1ywOgh5r5q1h9Ljc18vksXL5FzaPzSu0PDat6mTz
	uHNtD5tH35ZVjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAP2hpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4
	vjCv4AlHxd9Xz1gaGOezdzFyckgImEjsOzSBGcIWk7hwbz1bFyMXh5DAdEaJpRPamCCcJiaJ
	1s41YFVsAloS+1/cYAOxRQQiJOZv3gFWxCzwDKjoRR8jSEJYwF/i4JlzrCA2i4CqxL5/TUwg
	Nq+Aq0Tz84VsEOvkJD7seQR0BgcHp4CbxMQnBSBhIaCSF9+3sE5g5F3AyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIziKn0ntYFzZYHGIUYCDUYmH18BjTbAQa2JZcWXuIUYJDmYlEd6X
	94BCvCmJlVWpRfnxRaU5qcWHGE2BjprILCWanA9MMHkl8YbGJmZGlkbmhhZGxuZK4rwHWq0D
	hQTSE0tSs1NTC1KLYPqYODilGhhr/VZmPGJa/kojqnXX1p51utpRc+bwL7l6v+f2fTm1bser
	m49a8jsX+6+e0/zv1DLb08zNdxac23jU4vK6Z5ar7l6bEfju2vZ5qfUbdF37zE818B5dc/ml
	X0DEjkd/bMRcXoaGLtR6eP+A547NqmcPiKeoS3nP9j2++P+7VyFLYjx1w7KrXZpuK7EUZyQa
	ajEXFScCAGeD3Gr4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fix wrong compatible string for Exynos3250 ADC. Exynos3250 SoC
need to control only special clock for ADC. Exynos SoC except for Exynos3250
has not included special clock for ADC. The exynos ADC driver can control
special clock if compatible string is 'exynos3250-adc-v2'.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 1a62a5a..57b1b95 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -404,10 +404,10 @@
 		};
 
 		adc: adc@126C0000 {
-			compatible = "samsung,exynos-adc-v3";
+			compatible = "samsung,exynos3250-adc-v2";
 			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
 			interrupts = <0 137 0>;
-			clock-names = "adc", "sclk_tsadc";
+			clock-names = "adc", "sclk_adc";
 			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
 			#io-channel-cells = <1>;
 			io-channel-ranges;
-- 
1.8.0

