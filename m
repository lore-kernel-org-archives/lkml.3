Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3B1Ki7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:38:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11193 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3B1Ki5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:38:57 -0500
X-AuditID: cbfee690-b7f6b6d000004563-3a-512f33c05058
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 4/7] rtc: rtc-imxdi: add __init/__exit annotation
Date: Thu, 28 Feb 2013 19:38:56 +0900
Message-id: <000c01ce159f$cf729760$6e57c620$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAACmGw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA90DxvqBBkdfa1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcWnbAbaCfq6KCfP6WBoYl3N0MXJySAiYSCxes4IZwhaTuHBvPRuILSSwjFHiyJ06
	mJoXd28ydTFyAcWnM0psaf4N5fxilLi5ZyMrSBWbgJrEly+H2bsYOThEBPQl2lo0QGqYBXoZ
	Jc707maHmGorsaq7FayeU8BOYs/8SWC2sICjxN22dYwgNouAqsTVX5fBruAFqr+7YCY7hC0o
	8WPyPRYQm1lAS2LztiZWCFteYvOat8wgeyUE1CUe/dWFOMFI4uB+AYgKEYl9L94xQvzyiF1i
	6yReiE0CEt8mH2KB6JSV2HQAGgySEgdX3GCZwCgxC8neWUj2zkKydxaSDQsYWVYxiqYWJBcU
	J6UXmegVJ+YWl+al6yXn525ihETphB2M9w5YH2JMBlo/kVlKNDkfGOV5JfGGxsYmZiamJuaW
	puampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAYZyO+w/+N9/zLH5NqItRj
	5PY9Prqmq33XmlsCN/id3z68VF4tdz/8cX+/nNB7a09rptUuvunx3//rfZhisI/T2X1dg5n7
	9YVr+W2O5tyfvWtdQu3qOwe+vTg18aRqoITW1SmZ/WuOCs1Mdq+54nRExn2+xIV/NwKEDuxZ
	4lr7I/Tj5obzO6avUWIpzkg01GIuKk4EAA9HMGXoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd0DxvqBBr+WqFksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHFp2wG2gn6uignz+lgaGJdzdDFyckgImEi8
	uHuTCcIWk7hwbz1bFyMXh5DAdEaJLc2/mSCcX4wSN/dsZAWpYhNQk/jy5TB7FyMHh4iAvkRb
	iwZIDbNAL6PEmd7d7CA1QgK2Equ6W8HqOQXsJPbMnwRmCws4StxtW8cIYrMIqEpc/XWZDcTm
	Baq/u2AmO4QtKPFj8j0WEJtZQEti87YmVghbXmLzmrfMIHslBNQlHv3VhTjBSOLgfgGIChGJ
	fS/eMU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBaeCZ
	9A7GVQ0WhxgFOBiVeHg7TPQChVgTy4orcw8xSnAwK4nwuvDrBwrxpiRWVqUW5ccXleakFh9i
	TAb6cyKzlGhyPjBF5ZXEGxqbmBlZGplZGJmYm5MmrCTOy3jqSYCQQHpiSWp2ampBahHMFiYO
	TqkGRoMNe94sTOC6a7Bn4rKKiH+HxJWnhPPY+fNzr7kS+m3m3OlLi35fLZ1S9VLpjOpLs6RF
	N/fPVxVYmvzG+tWBIxlefRMYTl+alrguxtcjT1ebV/xFUecDyTP/JweIdC/+ellQRyp7Vcnp
	9U/7FqmW2dgFxj44q/PGTXKX7KxZF5YtDFRdcvrzuT9KLMUZiYZazEXFiQB2HfBRRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-imxdi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 82aad69..73cf81c 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -369,7 +369,7 @@ static void dryice_work(struct work_struct *work)
 /*
  * probe for dryice rtc device
  */
-static int dryice_rtc_probe(struct platform_device *pdev)
+static int __init dryice_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct imxdi_dev *imxdi;
@@ -479,7 +479,7 @@ err:
 	return rc;
 }
 
-static int dryice_rtc_remove(struct platform_device *pdev)
+static int __exit dryice_rtc_remove(struct platform_device *pdev)
 {
 	struct imxdi_dev *imxdi = platform_get_drvdata(pdev);
 
@@ -510,7 +510,7 @@ static struct platform_driver dryice_rtc_driver = {
 		   .owner = THIS_MODULE,
 		   .of_match_table = of_match_ptr(dryice_dt_ids),
 		   },
-	.remove = dryice_rtc_remove,
+	.remove = __exit_p(dryice_rtc_remove),
 };
 
 static int __init dryice_rtc_init(void)
-- 
1.7.2.5


