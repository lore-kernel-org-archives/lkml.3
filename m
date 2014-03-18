Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaCRMEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:04:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37569 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaCRMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:04:45 -0400
X-AuditID: cbfee690-b7f266d00000287c-c5-5328365c605c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, balbi@ti.com, myungjoo.ham@samsung.com
Cc: kishon@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] extcon: of: Remove unnecessary function call by using the
 name of device_node
Date: Tue, 18 Mar 2014 21:04:39 +0900
Message-id: <1395144280-23240-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
References: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkRDfGTCPY4OcHAYuD9+strn95zmrR
	vHg9m8WFpz1sFpd3zWGzmL2kn8Vi0bJWZovbjSvYHDg89s9dw+7Rt2UVo8fxG9uZPD5vkgtg
	ieKySUnNySxLLdK3S+DKODbjAXvBF66Ke33TWRsYezi7GDk5JARMJO5s2skOYYtJXLi3nq2L
	kYtDSGApo8SKjWuZYIomLlrEDJFYxAjkdEJVNTJJdO96wQpSxSagJbH/xQ02EFtEwE1iT8Nx
	sA5mgT6gjsdrwEYJC6RIzFhyHKyBRUBVonP1TrA4r4CrxMoPk6HukJP4sOcRmM0JNOjA+kdg
	NUJANftut7CCDJUQmMwusaytnRFikIDEt8mHWLoYOYASshKbDjBDzJGUOLjiBssERuEFjAyr
	GEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQID/fS/ZxN2MN47YH2IMRlo3ERmKdHkfGCk5JXE
	GxqbGVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo6re040m
	74Sv8yWrWalwntmRc96rqofp5E+7tWtPH2s3CHk6gb9PKDv2Ye8/Y+nskOoiRY65cUbdrW47
	xAOPZzRES5ddtGo7OU/mT+atmjUnuxY/za+0XLmzKae9/u+r0tTfTR+9cpT/sHG+WXT0xg3d
	UMePp3yEpk5v/HVGqzT6tVXj21oRJZbijERDLeai4kQAvegzP4oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd0YM41gg0MvOCwO3q+3uP7lOatF
	8+L1bBYXnvawWVzeNYfNYvaSfhaLRctamS1uN65gc+Dw2D93DbtH35ZVjB7Hb2xn8vi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8axGQ/YC75wVdzrm87awNjD
	2cXIySEhYCIxcdEiZghbTOLCvfVsXYxcHEICixiBEp1QTiOTRPeuF6wgVWwCWhL7X9xgA7FF
	BNwk9jQcZwYpYhboA+p4vIYJJCEskCIxY8lxsAYWAVWJztU7weK8Aq4SKz9MZodYJyfxYc8j
	MJsTaNCB9Y/AaoSAavbdbmGdwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwHD2T
	3sG4qsHiEKMAB6MSD+8LNvVgIdbEsuLK3EOMEhzMSiK8+3U0goV4UxIrq1KL8uOLSnNSiw8x
	JgNdNZFZSjQ5HxjjeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAaHfnR0YPuzaTZPrTmqr03cdOh1+dK1ZcYsGeISL2hnuV6r+fJwxnZHAYPMi2ddipWcBs
	3tT78s6H/c/qGHtOGTDOk5sd3sq5zWTaiudldhoXHRceeeua4LqufieLO+da1ge3G/f+as2+
	qhn7tvxSjpF+2+4TRTxN6nMvXv/j8NWn6sOuOYXnlFiKMxINtZiLihMB/GnFr+cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary function call in of_extcon_get_extcon_dev()
by using the name of device_node structure.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/of_extcon.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
index 72173ec..0a29f82 100644
--- a/drivers/extcon/of_extcon.c
+++ b/drivers/extcon/of_extcon.c
@@ -32,7 +32,6 @@ struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
 {
 	struct device_node *node;
 	struct extcon_dev *edev;
-	struct platform_device *extcon_parent_dev;
 
 	if (!dev->of_node) {
 		dev_dbg(dev, "device does not have a device node entry\n");
@@ -46,16 +45,9 @@ struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
 		return ERR_PTR(-ENODEV);
 	}
 
-	extcon_parent_dev = of_find_device_by_node(node);
-	if (!extcon_parent_dev) {
-		dev_dbg(dev, "unable to find device by node\n");
-		return ERR_PTR(-EPROBE_DEFER);
-	}
-
-	edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
+	edev = extcon_get_extcon_dev(node->name);
 	if (!edev) {
-		dev_dbg(dev, "unable to get extcon device : %s\n",
-				dev_name(&extcon_parent_dev->dev));
+		dev_dbg(dev, "unable to get extcon device : %s\n", node->name);
 		return ERR_PTR(-ENODEV);
 	}
 
-- 
1.8.0

