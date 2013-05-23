Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3EWKf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:35:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57798 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3EWKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:35:25 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-82-519df0ebb291
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] misc: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:35:23 +0900
Message-id: <002d01ce57a1$3b0fb780$b12f2680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XoS5IWE6HljCcQQKBgXIoqdY19w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zA93XH+YGGkzdKGnRvHg9m8XlhZdY
	LS7vmsPmwOyxf+4ado++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK6Fj/j7HgiXzFn6n3mRoY
	H0h1MXJwSAiYSCw8k9rFyAlkiklcuLeerYuRi0NIYBmjxP+GySwwNfNfaUHEpzNKtC/6wwrh
	/GKUWP1xETNIN5uAmsSXL4fZQWwRAVOJje+nMII0Mwu4SBydJgISFhYwl3ix6T0riM0ioCqx
	eeZTsFZeAUuJo382QdmCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4lAFiR1nXzNCrNKTOLru
	FjtEjYjEvhfvGEFukxBYxS5x+e8UJohlAhLfJh+CekZWYtMBqDmSEgdX3GCZwCg2C8nqWUhW
	z0KyehaSFQsYWVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525ihMRT7w7G2wesDzEmA62fyCwl
	mpwPjMe8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTC287/wWZK0vL/1Tvyz01+mdNkeenDjZJ6E8ouNIQeD+G4XWcYvfNFwb43ydic3wUjDHy05
	/45e563cJdAVlTXdfYfv53VHDx/4XptTuevWO+9CM9GmVayBHZXJWy9wfNZZvrKl3GvRhtuP
	PuY9W/7pTzfvpB3cgqK3DvuE2ubvY+iy7/miGzRZiaU4I9FQi7moOBEAxZX6o70CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO7rD3MDDZoOilo0L17PZnF54SVW
	i8u75rA5MHvsn7uG3aNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYMzrW/2MseCJf8WfqfaYGxgdSXYwcHBICJhLzX2l1MXICmWISF+6tZ+ti5OIQEpjO
	KNG+6A8rhPOLUWL1x0XMIFVsAmoSX74cZgexRQRMJTa+n8IIMohZwEXi6DQRkLCwgLnEi03v
	WUFsFgFVic0zn4K18gpYShz9swnKFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBAHKUjsOPua
	EWKVnsTRdbfYIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBMfrM+kdjKsaLA4xCnAwKvHwStyeEyjEmlhWXJl7iFGCg1lJhHdzz9xAId6U
	xMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HppK8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamCc397wKU75uVWtoJfZy4QHEsseKua8vfbW2i9vf+FVLX+Wxcv3
	3JqrcGzi1CjmGLFor/d3+0svKfFc1rrj0dh+9FzG0sAd6xfK6gml6z9N+/TVbsKe1ab8Mb+Y
	1fhPnbJZNmltol5P9rZ6i68HHzdJBi7/9YbPrdjt0doFBivcvh78Nev8Qo1GJZbijERDLeai
	4kQATucefxsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/carma/carma-fpga-program.c |    4 ++--
 drivers/misc/carma/carma-fpga.c         |    4 ++--
 drivers/misc/spear13xx_pcie_gadget.c    |    4 ++--
 drivers/misc/ti-st/st_kim.c             |    6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index 736c771..fa017cf 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -919,7 +919,7 @@ static bool dma_filter(struct dma_chan *chan, void *data)
 
 static int fpga_of_remove(struct platform_device *op)
 {
-	struct fpga_dev *priv = dev_get_drvdata(&op->dev);
+	struct fpga_dev *priv = platform_get_drvdata(op);
 	struct device *this_device = priv->miscdev.this_device;
 
 	sysfs_remove_group(&this_device->kobj, &fpga_attr_group);
@@ -969,7 +969,7 @@ static int fpga_of_probe(struct platform_device *op)
 
 	kref_init(&priv->ref);
 
-	dev_set_drvdata(&op->dev, priv);
+	platform_set_drvdata(op, priv);
 	priv->dev = &op->dev;
 	mutex_init(&priv->lock);
 	init_completion(&priv->completion);
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 7508caf..a2128af 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -1296,7 +1296,7 @@ static int data_of_probe(struct platform_device *op)
 		goto out_return;
 	}
 
-	dev_set_drvdata(&op->dev, priv);
+	platform_set_drvdata(op, priv);
 	priv->dev = &op->dev;
 	kref_init(&priv->ref);
 	mutex_init(&priv->mutex);
@@ -1400,7 +1400,7 @@ out_return:
 
 static int data_of_remove(struct platform_device *op)
 {
-	struct fpga_device *priv = dev_get_drvdata(&op->dev);
+	struct fpga_device *priv = platform_get_drvdata(op);
 	struct device *this_device = priv->miscdev.this_device;
 
 	/* remove all sysfs files, now the device cannot be re-enabled */
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 7deb25d..84a8dab 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -776,7 +776,7 @@ static int spear_pcie_gadget_probe(struct platform_device *pdev)
 		goto err_iounmap_app;
 	}
 
-	dev_set_drvdata(&pdev->dev, target);
+	platform_set_drvdata(pdev, target);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
@@ -863,7 +863,7 @@ static int spear_pcie_gadget_remove(struct platform_device *pdev)
 	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	irq = platform_get_irq(pdev, 0);
-	target = dev_get_drvdata(&pdev->dev);
+	target = platform_get_drvdata(pdev);
 	config = &target->config;
 
 	free_irq(irq, NULL);
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 83269f1..83907c7 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -680,7 +680,7 @@ void st_kim_ref(struct st_data_s **core_data, int id)
 		*core_data = NULL;
 		return;
 	}
-	kim_gdata = dev_get_drvdata(&pdev->dev);
+	kim_gdata = platform_get_drvdata(pdev);
 	*core_data = kim_gdata->core_data;
 }
 
@@ -735,7 +735,7 @@ static int kim_probe(struct platform_device *pdev)
 		pr_err("no mem to allocate");
 		return -ENOMEM;
 	}
-	dev_set_drvdata(&pdev->dev, kim_gdata);
+	platform_set_drvdata(pdev, kim_gdata);
 
 	err = st_core_init(&kim_gdata->core_data);
 	if (err != 0) {
@@ -810,7 +810,7 @@ static int kim_remove(struct platform_device *pdev)
 	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
 	struct kim_data_s	*kim_gdata;
 
-	kim_gdata = dev_get_drvdata(&pdev->dev);
+	kim_gdata = platform_get_drvdata(pdev);
 
 	/* Free the Bluetooth/FM/GPIO
 	 * nShutdown gpio from the system
-- 
1.7.10.4


