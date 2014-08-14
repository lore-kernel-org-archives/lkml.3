Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaHNO0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:26:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55880 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaHNO0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:26:30 -0400
X-AuditID: cbfee61b-f79f86d00000144c-f1-53ecc6ed5ac0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 1/5] ARM: dts: remove old USB2 PHY node hook for Arndale
Date: Thu, 14 Aug 2014 16:25:23 +0200
Message-id: <1408026327-31437-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd23x94EG8y8L2ixccZ6VouD9+st
	Nl2/zmrRduUgu8WP1xfYLHoXXGWzuPC0h83ibNMbdovLu+awWcw4v4/JYtGyVmYHbo871/aw
	efRtWcXocfzGdiaPz5vkAliiuGxSUnMyy1KL9O0SuDKObtrKVnCRreLa2dMsDYyXWLsYOTkk
	BEwkrtzZygxhi0lcuLeerYuRi0NIYDqjxOcnKxkhnC4mifnvv4N1sAlYSUxsX8UIYosIqEn0
	LN4KVsQscJ9JYvPD02BFwgIeEhcmvgCzWQRUJU6sPgxm8wLFZ7+5DrVOUaL72QQ2EJtTwFPi
	8JxlYHEhoJqDh3exT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOOieSe9gXNVg
	cYhRgINRiYe3YfubYCHWxLLiytxDjBIczEoivNN3A4V4UxIrq1KL8uOLSnNSiw8xSnOwKInz
	Hmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwLuh78OGvYP63mzsFD31inB+za7Njt4EP+5LzWz3c
	13IdfWC+5c1b7WrZEl2DyMtxs4Jf6uk9dVK2Wv5Sf/mi//tuv5cscHus1y8Yy9loq9XdqtD0
	ST5axnDznAS1s5HaWxcKnjI7G7l0xuONlQr8lX+efl9QXWvFZ534rvNDfU9glc6Dg2nTlViK
	MxINtZiLihMBj+S+KTYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb2 driver got replaced by
drivers/phy/phy-samsung-usb2 one.  Remove the leftover hook
from Arndale dts file.

Cc: Mark Brown <broonie@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos5250-arndale.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index d0de1f5..dad8f9b 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -570,8 +570,4 @@
 			connect-gpios = <&gpd1 7 1>;
 		};
 	};
-
-	usb@12110000 {
-		usb-phy = <&usb2_phy>;
-	};
 };
-- 
1.8.2.3

