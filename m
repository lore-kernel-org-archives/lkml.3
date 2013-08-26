Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3HZI5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:57:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26447 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3HZI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:57:36 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-d9-521b187fe26c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        "'devicetree'" <devicetree@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
In-reply-to: <003e01cea23a$03aac850$0b0058f0$%han@samsung.com>
Subject: [PATCH 3/3] video: exynos_dp: Use the generic PHY driver
Date: Mon, 26 Aug 2013 17:57:34 +0900
Message-id: <004201cea23a$4e2c44d0$ea84ce70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6iOgN7MgvkoL3hRgS3gzfXOa2c2AAADlHg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+ZgW69hHSQwbeDXBYH79dbvDykaTH/
	yDlWi+bF69ksLi+8xGrRu+Aqm8WFpz1sFif6PrBaXN41h81ixvl9TBbrHr5gsjj8pp3VYv2M
	1ywW6+ffYnPg83h14Q6Lx/65a9g9+rasYvQ4fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGR0X
	1zIWfJSpeHY2voHxtHgXIyeHhICJxNsFf9khbDGJC/fWs3UxcnEICSxjlGg/e4QdpmjVw8Us
	EIlFjBKX+3YyQji/GCUm/z3LClLFJqAm8eXLYbAOEQEdiYWn1zODFDELvGOWuHV8NTNIQkjA
	VqJ162KwBk4BO4k/B1qZQGxhAUeJ1XOfsIDYLAKqEhdXbQGL8wLVP3i4lxHCFpT4MfkeWA2z
	gJbE5m1NrBC2vMTmNW+B5nMAnaou8eivLsQNRhIzTj6GKheR2PfiHdjREgJzOSReP58KtUtA
	4tvkQywQvbISmw4wQ3wsKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kale
	cWJucWleul5yfu4mRkgCmLiD8f4B60OMyUDrJzJLiSbnAxNIXkm8obGZkYWpiamxkbmlGWnC
	SuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYBTp+vl45PWfr5fznB24dXiLw0KyV
	V5Ldc9OM8qwlQgGvlqbK5+sZ66ioMS+4u0oif9ZM9tufr3WEnPlmPj3Xr8uC5bJDy2/BWh35
	54s3ia+WPXFwRrTc2VW3w/2sJt9YNm2CyZLLv//+OncuaPE7leeZHf5bo0o+mDoaP1aaO0Og
	e03dTFtTRyWW4oxEQy3mouJEANE2/6gWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jAd16Cekgg08fWSwO3q+3eHlI02L+
	kXOsFs2L17NZXF54idWid8FVNosLT3vYLE70fWC1uLxrDpvFjPP7mCzWPXzBZHH4TTurxfoZ
	r1ks1s+/xebA5/Hqwh0Wj/1z17B79G1Zxehx/MZ2Jo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMWZ0XFzLWPBRpuLZ2fgGxtPiXYycHBICJhKrHi5mgbDFJC7c
	W8/WxcjFISSwiFHict9ORgjnF6PE5L9nWUGq2ATUJL58OcwOYosI6EgsPL2eGaSIWeAds8St
	46uZQRJCArYSrVsXgzVwCthJ/DnQygRiCws4Sqye+wRsHYuAqsTFVVvA4rxA9Q8e7mWEsAUl
	fky+B1bDLKAlsXlbEyuELS+xec1boPkcQKeqSzz6qwtxg5HEjJOPocpFJPa9eMc4gVFoFpJJ
	s5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeXZ1I7GFc2WBxiFOBg
	VOLhDSyQChJiTSwrrsw9xCjBwawkwmsuKh0kxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA
	1JdXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYw+3urHTmQ4
	uIn9fh+Quc8tlHHV7odmMrNfNPuttXNva9rxSGr9sX8xdqqC84/vctqwwFg4vvfqXunLr9Wn
	/tvo2D2rPSqazz3rToNsibGO5ZNsm/2uiaxzX4v/VNpZ9cXUizdWu0X1vXTr99s/5yltK7jL
	ZDLrwxI1Vr/UA//fezlMrzMy3arEUpyRaKjFXFScCAAVSQVjcwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic PHY API to control the DP PHY.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 Documentation/devicetree/bindings/video/exynos_dp.txt |   17 +++++++++--------
 drivers/video/exynos/exynos_dp_core.c                 |   16 ++++++++++++----
 drivers/video/exynos/exynos_dp_core.h                 |    1 +
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
index 84f10c1..3289d76 100644
--- a/Documentation/devicetree/bindings/video/exynos_dp.txt
+++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
@@ -6,10 +6,10 @@ We use two nodes:
 	-dptx-phy node(defined inside dp-controller node)
 
 For the DP-PHY initialization, we use the dptx-phy node.
-Required properties for dptx-phy:
-	-reg:
+Required properties for dptx-phy: deprecated, use phys and phy-names
+	-reg: deprecated
 		Base address of DP PHY register.
-	-samsung,enable-mask:
+	-samsung,enable-mask: deprecated
 		The bit-mask used to enable/disable DP PHY.
 
 For the Panel initialization, we read data from dp-controller node.
@@ -27,6 +27,10 @@ Required properties for dp-controller:
 		from common clock binding: Shall be "dp".
 	-interrupt-parent:
 		phandle to Interrupt combiner node.
+	-phys:
+		from general PHY binding: the phandle for the PHY device.
+	-phy-names:
+		from general PHY binding: Should be "dp".
 	-samsung,color-space:
 		input video data format.
 			COLOR_RGB = 0, COLOR_YCBCR422 = 1, COLOR_YCBCR444 = 2
@@ -68,11 +72,8 @@ SOC specific portion:
 		clocks = <&clock 342>;
 		clock-names = "dp";
 
-		dptx-phy {
-			reg = <0x10040720>;
-			samsung,enable-mask = <1>;
-		};
-
+		phys = <&dp_phy>;
+		phy-names = "dp";
 	};
 
 Board Specific portion:
diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 05fed7d..5e1a715 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/of.h>
+#include <linux/phy/phy.h>
 
 #include "exynos_dp_core.h"
 
@@ -960,8 +961,11 @@ static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 
 	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
 	if (!dp_phy_node) {
-		dev_err(dp->dev, "could not find dptx-phy node\n");
-		return -ENODEV;
+		dp->phy = devm_phy_get(dp->dev, "dp");
+		if (IS_ERR(dp->phy))
+			return PTR_ERR(dp->phy);
+		else
+			return 0;
 	}
 
 	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
@@ -992,7 +996,9 @@ err:
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	if (dp->phy_addr) {
+	if (dp->phy) {
+		phy_power_on(dp->phy);
+	} else if (dp->phy_addr) {
 		u32 reg;
 
 		reg = __raw_readl(dp->phy_addr);
@@ -1003,7 +1009,9 @@ static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	if (dp->phy_addr) {
+	if (dp->phy) {
+		phy_power_off(dp->phy);
+	} else if (dp->phy_addr) {
 		u32 reg;
 
 		reg = __raw_readl(dp->phy_addr);
diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
index 56cfec8..607e36d 100644
--- a/drivers/video/exynos/exynos_dp_core.h
+++ b/drivers/video/exynos/exynos_dp_core.h
@@ -151,6 +151,7 @@ struct exynos_dp_device {
 	struct video_info	*video_info;
 	struct link_train	link_train;
 	struct work_struct	hotplug_work;
+	struct phy		*phy;
 };
 
 /* exynos_dp_reg.c */
-- 
1.7.10.4


