Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaKLJsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:48:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31193 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaKLJsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:48:25 -0500
X-AuditID: cbfee68f-f791c6d000004834-8e-54632ce3d1f8
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kgene.kim@samsung.com, seanpaul@google.com,
        ajaykumar.rs@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v3 RESEND 1/2] drm/exynos: dp: Remove support for unused
 dptx-phy
Date: Wed, 12 Nov 2014 15:12:10 +0530
Message-id: <1415785330-28123-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <000001cffe5c3df5500$%han@samsung.com>
References: <000001cffe5c3df5500$%han@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkSvexTnKIwZu11hYH3h9ksbjy9T2b
	RduVg+wWk+5PYLHoXXCVzeLyrjlsFjPO72OymHsw14HDY8GmUo/73ceZPPq2rGL0+LxJLoAl
	issmJTUnsyy1SN8ugSvj7+TbrAUn5So2PG1nb2D8INHFyMkhIWAi8WjbVyYIW0ziwr31bF2M
	XBxCAksZJc6vX8wKU/TqYRMTRGI6o8Tj/TdZIZwJTBKHVpwEa2cT0JVoeruLEcQWEXCTaDo8
	E6yIWWALo8Tn/i/sIAlhgWCJt/uego1lEVCVuL1rDlgzr4CHxMFjv1i6GDmA1ilIzJlkAxLm
	FDCW6Nv3gA0kLCRgJPH3ejTISAmBeewS6xfNYYQYIyDxbfIhqFZZiU0HmCGOlpQ4uOIGywRG
	4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAkP89L9n/TsY7x6wPsQowMGoxMObsTkp
	RIg1say4MvcQoynQhonMUqLJ+cBIyiuJNzQ2M7IwNTE1NjK3NFMS510o9TNYSCA9sSQ1OzW1
	ILUovqg0J7X4ECMTB6dUA2P2/Xvu8X/Kl3vW5P/aXfa1JOXNHXWRLBf+byFPvlbmpCUu4p77
	dKnmlgNM+kxaO/c8sd3/bMKKWaHSZjHLxI/LnRTqdste1bVy6aKV+o67dAw7Zy3luXoyRC3s
	w8zVD6/+TzBh+qP4g33x45nVCVXCEesu+p+benxB39mfFocfR865rsRcP0VMiaU4I9FQi7mo
	OBEAtQ8v+GwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQd3HOskhBv8eGFoceH+QxeLK1/ds
	Fm1XDrJbTLo/gcWid8FVNovLu+awWcw4v4/JYu7BXAcOjwWbSj3udx9n8ujbsorR4/MmuQCW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGX8n32YtOClXseFpO3sD4weJ
	LkZODgkBE4lXD5uYIGwxiQv31rN1MXJxCAlMZ5R4vP8mK4QzgUni0IqTYFVsAroSTW93MYLY
	IgJuEk2HZ4IVMQtsYZT43P+FHSQhLBAs8XbfU1YQm0VAVeL2rjlgzbwCHhIHj/1i6WLkAFqn
	IDFnkg1ImFPAWKJv3wM2kLCQgJHE3+vRExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjqBnUjsYVzZYHGIU4GBU4uFNXJMUIsSaWFZcmXuIUYKDWUmE99NXoBBvSmJlVWpRfnxR
	aU5q8SFGU6CbJjJLiSbnA6M7ryTe0NjE3NTY1NLEwsTMUkmc90CrdaCQQHpiSWp2ampBahFM
	HxMHp1QDo4ztzsPlj49HTDW7P3HjuU9hc09xBugH7Jp1zOW+a//c4Ecffk2311aY19KqfNvy
	9I1lO9vP9ga+37FkMdOm1+lvMpetWivLdl9S6sOKQ1P/W87a1JudvFBmaUa6boGJncHGGykv
	vnPt/FMk483vV8vDV7D/49dojm//N1l7rcz6szLBOnbelVNKLMUZiYZazEXFiQDlp3xDtgIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have moved to generic phy based bindings,
we don't need to have any code related to older dptx-phy.
Nobody is using this dptx-phy anymore, so removing the
same.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
---

Problem with my mail client caused change in author's mail id.
So resending it with authorship under my Samsung id.

 drivers/gpu/drm/exynos/exynos_dp_core.c |   74 +++++++------------------------
 drivers/gpu/drm/exynos/exynos_dp_core.h |    2 -
 2 files changed, 17 insertions(+), 59 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
index cd50ece..dbe9add 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.c
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
@@ -1052,28 +1052,14 @@ static int exynos_dp_create_connector(struct exynos_drm_display *display,
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
 {
-	if (dp->phy) {
+	if (dp->phy)
 		phy_power_on(dp->phy);
-	} else if (dp->phy_addr) {
-		u32 reg;
-
-		reg = __raw_readl(dp->phy_addr);
-		reg |= dp->enable_mask;
-		__raw_writel(reg, dp->phy_addr);
-	}
 }
 
 static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
 {
-	if (dp->phy) {
+	if (dp->phy)
 		phy_power_off(dp->phy);
-	} else if (dp->phy_addr) {
-		u32 reg;
-
-		reg = __raw_readl(dp->phy_addr);
-		reg &= ~(dp->enable_mask);
-		__raw_writel(reg, dp->phy_addr);
-	}
 }
 
 static void exynos_dp_poweron(struct exynos_drm_display *display)
@@ -1210,44 +1196,6 @@ static struct video_info *exynos_dp_dt_parse_pdata(struct device *dev)
 	return dp_video_config;
 }
 
-static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
-{
-	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
-	u32 phy_base;
-	int ret = 0;
-
-	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
-	if (!dp_phy_node) {
-		dp->phy = devm_phy_get(dp->dev, "dp");
-		return PTR_ERR_OR_ZERO(dp->phy);
-	}
-
-	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
-		dev_err(dp->dev, "failed to get reg for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
-				&dp->enable_mask)) {
-		dev_err(dp->dev, "failed to get enable-mask for dptx-phy\n");
-		ret = -EINVAL;
-		goto err;
-	}
-
-	dp->phy_addr = ioremap(phy_base, SZ_4);
-	if (!dp->phy_addr) {
-		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		ret = -ENOMEM;
-		goto err;
-	}
-
-err:
-	of_node_put(dp_phy_node);
-
-	return ret;
-}
-
 static int exynos_dp_dt_parse_panel(struct exynos_dp_device *dp)
 {
 	int ret;
@@ -1277,9 +1225,21 @@ static int exynos_dp_bind(struct device *dev, struct device *master, void *data)
 	if (IS_ERR(dp->video_info))
 		return PTR_ERR(dp->video_info);
 
-	ret = exynos_dp_dt_parse_phydata(dp);
-	if (ret)
-		return ret;
+	dp->phy = devm_phy_get(dp->dev, "dp");
+	if (IS_ERR(dp->phy)) {
+		dev_err(dp->dev, "no DP phy configured\n");
+		ret = PTR_ERR(dp->phy);
+		if (ret) {
+			/*
+			 * phy itself is not enabled, so we can move forward
+			 * assigning NULL to phy pointer.
+			 */
+			if (ret == -ENOSYS || ret == -ENODEV)
+				dp->phy = NULL;
+			else
+				return ret;
+		}
+	}
 
 	if (!dp->panel) {
 		ret = exynos_dp_dt_parse_panel(dp);
diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.h b/drivers/gpu/drm/exynos/exynos_dp_core.h
index a1aee69..6426201 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.h
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.h
@@ -153,8 +153,6 @@ struct exynos_dp_device {
 	struct clk		*clock;
 	unsigned int		irq;
 	void __iomem		*reg_base;
-	void __iomem		*phy_addr;
-	unsigned int		enable_mask;
 
 	struct video_info	*video_info;
 	struct link_train	link_train;
-- 
1.7.9.5

