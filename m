Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3IBAUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:20:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3IBAU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:20:28 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-cc-5223d9c9f55f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/3] extcon: Simplify extcon_dev_register() prototype by
 removing unnecessary parameter
Date: Mon, 02 Sep 2013 09:20:08 +0900
Message-id: <1378081208-20274-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSrHvypnKQwa3XchZTHz5hs/g35Qa7
	xfUvz1kt+re4WDQvXs9mceFpD5vF2aY37BaXd81hs7jduILNgdNj06pONo/9c9ewe7yc+JvN
	o2/LKkaPqVP+Mnocv7GdyePzJrkA9igum5TUnMyy1CJ9uwSujBdXp7IXvHWqWHSombWB8Z55
	FyMnh4SAicT2ve/YIGwxiQv31gPZXBxCAksZJc7M7GCDKdowsZkdIjGdUaLp234WCKeRSWLK
	2dssIFVsAloS+1/cAOsQEVCQ2Nz7jBWkiFlgKZPEpObPzCAJYYFMifszVoI1sAioSszsPcwE
	YvMKuEo827KVCWKdnMSHPY/YQWxOATeJqbMOMILYQkA1M/p3M0PU7GKXWLcvA2KOgMS3yYeA
	ZnIAxWUlNh2AKpGUOLjiBssERuEFjAyrGEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MQLj4fS/
	ZxN2MN47YH2IMRlo3ERmKdHkfGA85ZXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6qB0YhvSpvxkwmCuXMieje5v12w+LtzWpTZ6i9TM73TV/Ro/X4Y
	seh+u+iKpM3HQg/svxIdlvZl2s/MHWraHwN7e35u/+r+2i1ycUniwitXnrp9fjA34KWV/Y0X
	5flBboKXnts5VfXVriv9tWCXwpW7Pi9Sm4OPPN1fPXX+Avd3YrE651XDZ9Sv61FiKc5INNRi
	LipOBAAYLM1+nQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQd2TN5WDDLY9FbGY+vAJm8W/KTfY
	La5/ec5q0b/FxaJ58Xo2iwtPe9gszja9Ybe4vGsOm8XtxhVsDpwem1Z1snnsn7uG3ePlxN9s
	Hn1bVjF6TJ3yl9Hj+I3tTB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAJ2mpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gA
	DSSsYcx4cXUqe8Fbp4pFh5pZGxjvmXcxcnJICJhIbJjYzA5hi0lcuLeerYuRi0NIYDqjRNO3
	/SwQTiOTxJSzt1lAqtgEtCT2v7jBBmKLCChIbO59xgpSxCywlEliUvNnZpCEsECmxP0ZK8Ea
	WARUJWb2HmYCsXkFXCWebdnKBLFOTuLDnkdgqzkF3CSmzjrACGILAdXM6N/NPIGRdwEjwypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Hh7Jr2DcVWDxSFGAQ5GJR5ehWXKQUKsiWXFlbmH
	GCU4mJVEeOOA0SrEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cBUkFcSb2hsYmZkaWRuaGFk
	bE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjEKCN7K3/GTq4hC86bA810MxzvVBeMDf
	CF5DLgv36Ki79lv4bHXu3diiuOvoxcyuzoiWc3vKrvy763ejze6Kz/lr0/IerHI8Gxnbvnnl
	+Vcffyz4VfaeOUGF02tPxHY7+3qtCHZ9VS6FWynfOxpePvw6bdlJteOBG9b1zm2Y/l2iiXd5
	vAT3ZCWW4oxEQy3mouJEAEgRHPL7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove extcon_dev_register()'s second parameter which means
the pointer of parent device to simplify prototype of this function.
So, if extcon device has the parent device, it should set the pointer of
parent device to edev.dev.parent in extcon device driver instead of in
extcon_dev_register().

Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 Documentation/extcon/porting-android-switch-class |  6 ++++--
 drivers/extcon/extcon-adc-jack.c                  |  3 ++-
 drivers/extcon/extcon-arizona.c                   |  3 ++-
 drivers/extcon/extcon-class.c                     | 11 +++++++----
 drivers/extcon/extcon-gpio.c                      |  3 ++-
 drivers/extcon/extcon-max77693.c                  |  3 ++-
 drivers/extcon/extcon-max8997.c                   |  3 ++-
 drivers/extcon/extcon-palmas.c                    |  3 ++-
 include/linux/extcon.h                            |  5 ++---
 9 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/Documentation/extcon/porting-android-switch-class b/Documentation/extcon/porting-android-switch-class
index eb0fa5f..5377f63 100644
--- a/Documentation/extcon/porting-android-switch-class
+++ b/Documentation/extcon/porting-android-switch-class
@@ -25,8 +25,10 @@ MyungJoo Ham <myungjoo.ham@samsung.com>
     @print_state: no change but type change (switch_dev->extcon_dev)
 
 - switch_dev_register(sdev, dev)
-	=> extcon_dev_register(edev, dev)
-	: no change but type change (sdev->edev)
+	=> extcon_dev_register(edev)
+	: type change (sdev->edev)
+	: remove second param('dev'). if edev has parent device, should store
+	  'dev' to 'edev.dev.parent' before registering extcon device
 - switch_dev_unregister(sdev)
 	=> extcon_dev_unregister(edev)
 	: no change but type change (sdev->edev)
diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 90346d6..7f7f930 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -110,6 +110,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	data->edev.dev.parent = &pdev->dev;
 	data->edev.supported_cable = pdata->cable_names;
 
 	/* Check the length of array and set num_cables */
@@ -148,7 +149,7 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	err = extcon_dev_register(&data->edev, &pdev->dev);
+	err = extcon_dev_register(&data->edev);
 	if (err)
 		goto out;
 
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 72fc28e..f639f2a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1132,9 +1132,10 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	}
 
 	info->edev.name = "Headset Jack";
+	info->edev.dev.parent = arizona->dev;
 	info->edev.supported_cable = arizona_cable;
 
-	ret = extcon_dev_register(&info->edev, arizona->dev);
+	ret = extcon_dev_register(&info->edev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 8bc43e6..b096db8 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -567,14 +567,13 @@ static void dummy_sysfs_dev_release(struct device *dev)
 /**
  * extcon_dev_register() - Register a new extcon device
  * @edev	: the new extcon device (should be allocated before calling)
- * @dev		: the parent device for this extcon device.
  *
  * Among the members of edev struct, please set the "user initializing data"
  * in any case and set the "optional callbacks" if required. However, please
  * do not set the values of "internal data", which are initialized by
  * this function.
  */
-int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
+int extcon_dev_register(struct extcon_dev *edev)
 {
 	int ret, index = 0;
 
@@ -599,11 +598,15 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 		return -EINVAL;
 	}
 
-	edev->dev.parent = dev;
 	edev->dev.class = extcon_class;
 	edev->dev.release = extcon_dev_release;
 
-	edev->name = edev->name ? edev->name : dev_name(dev);
+	edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
+	if (IS_ERR_OR_NULL(edev->name)) {
+		dev_err(&edev->dev,
+			"extcon device name is null\n");
+		return -EINVAL;
+	}
 	dev_set_name(&edev->dev, "%s", edev->name);
 
 	if (edev->max_supported) {
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index f874c30..1a83e33 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -95,6 +95,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	extcon_data->edev.name = pdata->name;
+	extcon_data->edev.dev.parent = &pdev->dev;
 	extcon_data->gpio = pdata->gpio;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
@@ -102,7 +103,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		extcon_data->edev.print_state = extcon_gpio_print_state;
 	extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
 
-	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
+	ret = extcon_dev_register(&extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 15437d4..da268fb 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1183,8 +1183,9 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
+	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max77693_extcon_cable;
-	ret = extcon_dev_register(info->edev, NULL);
+	ret = extcon_dev_register(info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 83e3a27..6a00464 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -707,8 +707,9 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
+	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max8997_extcon_cable;
-	ret = extcon_dev_register(info->edev, NULL);
+	ret = extcon_dev_register(info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 89fdd05..ac28281 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -178,9 +178,10 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, palmas_usb);
 
 	palmas_usb->edev.supported_cable = palmas_extcon_cable;
+	palmas_usb->edev.dev.parent = palmas_usb->dev;
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
-	status = extcon_dev_register(&palmas_usb->edev, palmas_usb->dev);
+	status = extcon_dev_register(&palmas_usb->edev);
 	if (status) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		return status;
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 0269baf..21c59af 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -183,7 +183,7 @@ struct extcon_specific_cable_nb {
  * Following APIs are for notifiers or configurations.
  * Notifiers are the external port and connection devices.
  */
-extern int extcon_dev_register(struct extcon_dev *edev, struct device *dev);
+extern int extcon_dev_register(struct extcon_dev *edev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
@@ -241,8 +241,7 @@ extern int extcon_register_notifier(struct extcon_dev *edev,
 extern int extcon_unregister_notifier(struct extcon_dev *edev,
 				      struct notifier_block *nb);
 #else /* CONFIG_EXTCON */
-static inline int extcon_dev_register(struct extcon_dev *edev,
-				      struct device *dev)
+static inline int extcon_dev_register(struct extcon_dev *edev)
 {
 	return 0;
 }
-- 
1.8.0

