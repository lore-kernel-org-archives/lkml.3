Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3BRFYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:24:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58473 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3BRFYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:24:11 -0500
X-AuditID: cbfee68f-b7f656d000000d78-ac-5121bafae461
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2 RESEND] video: exynos_dp: add missing of_node_put()
Date: Mon, 18 Feb 2013 14:24:09 +0900
Message-id: <000801ce0d98$2e103fd0$8a30bf70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4NmC3wY06s4orcQzuu4vTFFedQgA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zQ91fuxQDDX6e57E40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0rVjPWtAkULHtbCNbA+MC3i5GTg4JAROJNW+mMkPY
	YhIX7q1nA7GFBJYxSkw9HwBTc/76JaAaLqD4IkaJV/1/GSGcX4wSX5f+ZwepYhNQk/jy5TCQ
	zcEhIqAv0daiAVLDLDCXUeLSmiMsIDXCAu4Sq9bOZAWxWQRUJeZefgEW5xWwlZh47xIThC0o
	8WPyPbA4s4CWxPqdx5kgbHmJzWveMoPMlxBQl3j0VxckLCKgJ9H36RdUuYjEvhfvwG6TEOhn
	l2ict4YNYpeAxLfJh1ggemUlNh2AelhS4uCKGywTGMVmIdk8C8nmWUg2z0KyYgEjyypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MkJjp38F494D1IcZkoPUTmaVEk/OBMZdXEm9obGxiZmJq
	Ym5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxO9lNSHmm+qfz2dscs
	sYnKFQs3f5MPP7WzrI5n5gmJiJLNavtVNnOLlitO6tGd+MAy6R+HkIWllLZl242/bgcezky0
	3ft5d4zZ4ucyn/9Jh5/mKZG4W/z/yPz1+/K5o+7eVMxsF73W1/fyxVavksruy1M+bTdTqHi2
	I+rjo1Czi106h77MEN6oxFKckWioxVxUnAgAKUOZh68CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd1fuxQDDd6cZbU40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm9K1Yz1rQJFCx
	7WwjWwPjAt4uRk4OCQETifPXLzFD2GISF+6tZ+ti5OIQEljEKPGq/y8jhPOLUeLr0v/sIFVs
	AmoSX74cBrI5OEQE9CXaWjRAapgF5jJKXFpzhAWkRljAXWLV2pmsIDaLgKrE3MsvwOK8ArYS
	E+9dYoKwBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVtmkPkSAuoSj/7qgoRFBPQk+j79gioXkdj3
	4h3jBEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERyTz6R3
	MK5qsDjEKMDBqMTDy5CvGCjEmlhWXJl7iFGCg1lJhHeTCFCINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84HpIq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MFbdtFr4LLvz+SYHp7XNC0+6df3TnbZOrI01aerC3+YCjqeqDn45e9mSrWC1cUaFT56/8rtr
	bBPNmVUdHpz3XKeUw2lundwgc0Ay6ppYx+Ja1u0Pl750jJfgVRB0a+O8dvF4IH8o6zkZjbYr
	p/tfFSXutT+b7fGU3ebpuyDTTsEJfbf3HN29S4mlOCPRUIu5qDgRAOYFwfINAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() returns a node pointer with refcount
incremented, use of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against
the node pass to from parameter, thus we also need to call
of_node_get(from) before calling of_find_node_by_name().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/exynos/exynos_dp_core.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index 2ed9776..c7374c0 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -965,10 +965,11 @@ static struct exynos_dp_platdata *exynos_dp_dt_parse_pdata(struct device *dev)
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 {
-	struct device_node *dp_phy_node;
+	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
 	u32 phy_base;
+	int ret = 0;
 
-	dp_phy_node = of_find_node_by_name(dp->dev->of_node, "dptx-phy");
+	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
 	if (!dp_phy_node) {
 		dev_err(dp->dev, "could not find dptx-phy node\n");
 		return -ENODEV;
@@ -976,22 +977,28 @@ static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 
 	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
 		dev_err(dp->dev, "faild to get reg for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
 				&dp->enable_mask)) {
 		dev_err(dp->dev, "faild to get enable-mask for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	dp->phy_addr = ioremap(phy_base, SZ_4);
 	if (!dp->phy_addr) {
 		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	return 0;
+err:
+	of_node_put(dp_phy_node);
+
+	return ret;
 }
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
-- 
1.7.2.5


