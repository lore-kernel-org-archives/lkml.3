Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaHVQ7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:59:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17008 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbaHVQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:59:51 -0400
X-AuditID: cbfee61a-f79e46d00000134f-04-53f77705ad3f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 1/5] ARM: dts: remove old USB2 PHY node hook for Arndale
Date: Fri, 22 Aug 2014 18:59:01 +0200
Message-id: <1408726745-31135-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
References: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t9jAV3W8u/BBgvmWlhsnLGe1eLg/XqL
	Tdevs1q0XTnIbvHj9QU2i94FV9ksLjztYbM42/SG3eLyrjlsFjPO72OyWLSsldmB2+POtT1s
	Hn1bVjF6HL+xncnj8ya5AJYoLpuU1JzMstQifbsEroxdkx+yFuxmr1h97ilbA+MGti5GDg4J
	AROJjj7VLkZOIFNM4sK99UBhLg4hgUWMEi3bepkgnC4miTtPf7OBVLEJWElMbF/FCGKLCKhJ
	9CzeyghSxCxwn0li88PTrCAJYQFvifPP34DZLAKqEjPn3AKzeQU8JI6+ec0CsU5RovvZBLAr
	OAU8Ja4f1QExhYBKLi+NnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcLg9k9rB
	uLLB4hCjAAejEg+vgcf3YCHWxLLiytxDjBIczEoivNKFQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Mk5mqI/fy3T1tkvvByi9jwaZHHfqFUgu8mbMq
	/8mc3eYzd1enrXWY3ozO5NTjh6N50r1PzTt8y9TVSi3BeNHK37JRD74eP9x+hatp79mj/ySr
	2W04tuvVyRlO/rn+t0BPneuKhcedqmYHM8eG75+4Mv3tu82vjq0s/dlfwPPnnv+pyA9VPBOv
	K7EUZyQaajEXFScCAEtYszczAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/phy/phy-samsung-usb2 driver got replaced by
drivers/phy/phy-samsung-usb2 one.  Remove the leftover hook
from Arndale dts file.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
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

