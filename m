Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaGJEXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:23:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaGJEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:23:49 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-bb-53be15534cc1
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, broonie@linaro.org,
        tobetter@gmail.com, jy0922.shim@samsung.com
Subject: [PATCH 2/3] usb: usb3503: add PM functions
Date: Thu, 10 Jul 2014 13:23:47 +0900
Message-id: <1404966228-29133-2-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
References: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkUDdYdF+wwb23Ohabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBkf705mKljDX3Hi5AvWBsZ7PF2MHBwSAiYSe69odjFyApliEhfu
	rWfrYuTiEBJYyijR3DSNHSJhInHh3yN2iMQiRokrnf9YIJxWJokXK96wgFSxCehJ3Nl2nAlk
	qoiAtUTfwSCQMLNAtcT/9feYQGxhAWOJrgPPmUFsFgFViTVvX4Et4BVwl+jadI4VYpmCxM/L
	J9hAbE4BD4nbG36CjRcCqllxvgXsCAmBeewSN5Z/ZYIYJCDxbfIhFohvZCU2HWCGmCMpcXDF
	DZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgQG+el/zybuYLx/wPoQYzLQuInM
	UqLJ+cAoySuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGxhmB0w5P1ffYERV64AG3S5dhRkVMT8q2ggeMN8I/HdD1Vmz3SxT+onDj6PfD5VUGjiYq
	j2I6eD/opn3uCpbSMZ6xjIfL2/tP4KM3nXcFxeQ25t31TvyV8uDgR+P9R0sZN/q/iQt/y7O9
	Me74Y4Gdtbq7OurfeyUtzeqOzZ69fMmdzLMpRx5eVGIpzkg01GIuKk4EAPrt7G+IAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jAd1g0X3BBnOXqFpsun6d1aJ58Xo2
	ixf3LrJYXN41h81i0bJWZou1R+6yW+x7vIbZgd1j56y77B53ru1h89g/dw27R9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+Hh3MlPBGv6KEydfsDYw
	3uPpYuTkkBAwkbjw7xE7hC0mceHeerYuRi4OIYFFjBJXOv+xQDitTBIvVrxhAaliE9CTuLPt
	OFMXIweHiIC1RN/BIJAws0C1xP/195hAbGEBY4muA8+ZQWwWAVWJNW9fgS3gFXCX6Np0jhVi
	mYLEz8sn2EBsTgEPidsbfoKNFwKqWXG+hX0CI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMFR9Ex6B+OqBotDjAIcjEo8vA09e4OFWBPLiitzDzFKcDArifB6/AcK8aYkVlalFuXH
	F5XmpBYfYjQFumois5Rocj4wwvNK4g2NTcyMLI3MDS2MjM2VxHkPtloHCgmkJ5akZqemFqQW
	wfQxcXBKNTA673G5nmr3VnIZz9s1/3o/+TzRdb/s+v/p2nX7UuvXT3Flf889ofzP0auzblwq
	LMhxVPK6N3U77+ROe+mKIu2rv65+t5qyvPzZzRUdzhfdH0r58sku5JHx27WNWcLieVm5ittX
	toXPJd+u0QsJ0W+4FTFz7rXlPa7aLMeVrrkZSgvW7OhVXzRTiaU4I9FQi7moOBEAviyPPrgC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb3503 needs to switch to standby mode while suspending and should
switch to hub mode when resumed. Also we can control clock on PM
function.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/usb/misc/usb3503.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index 652855b..47cb143 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -149,8 +149,6 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
 
 	case USB3503_MODE_STANDBY:
 		usb3503_reset(hub, 0);
-
-		hub->mode = mode;
 		dev_info(dev, "switched to STANDBY mode\n");
 		break;
 
@@ -347,6 +345,37 @@ static int usb3503_platform_probe(struct platform_device *pdev)
 	return usb3503_probe(hub);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int usb3503_i2c_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct usb3503 *hub = i2c_get_clientdata(client);
+
+	usb3503_switch_mode(hub, USB3503_MODE_STANDBY);
+
+	if (hub->clk)
+		clk_disable_unprepare(hub->clk);
+
+	return 0;
+}
+
+static int usb3503_i2c_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct usb3503 *hub = i2c_get_clientdata(client);
+
+	if (hub->clk)
+		clk_prepare_enable(hub->clk);
+
+	usb3503_switch_mode(hub, hub->mode);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(usb3503_i2c_pm_ops, usb3503_i2c_suspend,
+		usb3503_i2c_resume);
+
 static const struct i2c_device_id usb3503_id[] = {
 	{ USB3503_I2C_NAME, 0 },
 	{ }
@@ -365,6 +394,7 @@ MODULE_DEVICE_TABLE(of, usb3503_of_match);
 static struct i2c_driver usb3503_i2c_driver = {
 	.driver = {
 		.name = USB3503_I2C_NAME,
+		.pm = &usb3503_i2c_pm_ops,
 		.of_match_table = of_match_ptr(usb3503_of_match),
 	},
 	.probe		= usb3503_i2c_probe,
-- 
1.8.1.2

