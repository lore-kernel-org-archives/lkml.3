Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936503AbaH1JC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:02:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11784 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934737AbaH1JCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:02:49 -0400
X-AuditID: cbfee690-f79ce6d00000115a-b8-53fef034f34f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, akpm@linux-foundation.org,
        kyungmin.park@samsung.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 5/5] ARM: dts: Fix wrong compatible string of Exynos3250 RTC
 dt node
Date: Thu, 28 Aug 2014 18:02:39 +0900
Message-id: <1409216559-22402-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
References: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkRNfkw79gg+5vYhZLLl5lt5izfg2b
	xfUvz1ktehdcZbM42/SG3eLyrjlsFjPO72Oy2N/ZwejA4bFn4kk2jxMzfrN49G1Zxegxfd5P
	Jo/Pm+QCWKO4bFJSczLLUov07RK4MmZd3sxcsJK94uXdOYwNjD1sXYycHBICJhJLLtxlhLDF
	JC7cWw8U5+IQEljKKNH87DozTNGOxzOgEtMZJT52XGKFcJqYJHqmbwGrYhPQktj/4gbYWBEB
	CYklc+6AjWUWuMEo8WJbDIgtLBAhcfXlJnYQm0VAVeLg3ClgNbwCrhLXF3xjgtgmJ/FhzyOg
	Gg4OTgE3iYdrq0DCQkAl33+egrp0EbvErgkaEGMEJL5NPsQCUi4hICux6QDUzZISB1fcYJnA
	KLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmC4n/73bMIOxnsHrA8xCnAwKvHwzkj4
	FyzEmlhWXJl7iNEUaMNEZinR5HxgVOWVxBsamxlZmJqYGhuZW5opifO+lvoZLCSQnliSmp2a
	WpBaFF9UmpNafIiRiYNTqoFxQh733zeWicJs57PE8gwKl+mxH5V5JCI91aewgePS8u8hC6Ze
	4WrO2Bmpu+pRuZTXhtUfzWUETkcHMcvyzbScZZ456XvvPLETjh+KrJSEZpiziLS5xh5peeu6
	7f6p5r3/9CQFTqefWJvY2XAqaOrsXUeXGfEI6j14vmr/TfbII/37l/BPX2mjxFKckWioxVxU
	nAgAte2/RXICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQV2TD/+CDa495rdYcvEqu8Wc9WvY
	LK5/ec5q0bvgKpvF2aY37BaXd81hs5hxfh+Txf7ODkYHDo89E0+yeZyY8ZvFo2/LKkaP6fN+
	Mnl83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj1uXNzAUr2Ste
	3p3D2MDYw9bFyMkhIWAisePxDChbTOLCvfVANheHkMB0RomPHZdYIZwmJome6VuYQarYBLQk
	9r+4AdYhIiAhsWTOHUYQm1ngBqPEi20xILawQITE1Zeb2EFsFgFViYNzp4DV8Aq4Slxf8I0J
	YpucxIc9j4BqODg4BdwkHq6tAgkLAZV8/3mKcQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwfH0TGoH48oGi0OMAhyMSjy8DnH/goVYE8uKK3MPMUpwMCuJ8B49DhTiTUmsrEot
	yo8vKs1JLT7EaAp01ERmKdHkfGCs55XEGxqbmBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0t
	SC2C6WPi4JRqYFye2/mOb/68q06fmE9pbjFYtC/P/0Tpmd+ODr3/j6tOXLEza4cjD0vdy7gd
	dwTYxGacmNTs2HsyX9czQLDsy5IFty7lT/MNbY0y0FrAPU1Ar+7E6ZR5jqtezlotfex3Qu+1
	7tgtCT5BtRfefrt35I1Q7PVNQdHHM10sdF5xNN44asiu0CaoaqDEUpyRaKjFXFScCADFeiq5
	vQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix wrong compatible string of Exynos3250 RTC (Real-Time Clock) dt
node. The RTC of Exynos3250 must need additional source clock (XrtcXTI).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 1d52de6..429a6c6 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -164,7 +164,7 @@
 		};
 
 		rtc: rtc@10070000 {
-			compatible = "samsung,s3c6410-rtc";
+			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
 			interrupts = <0 73 0>, <0 74 0>;
 			status = "disabled";
-- 
1.8.0

