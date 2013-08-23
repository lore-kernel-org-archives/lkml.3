Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3HWBVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:21:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11001 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3HWBVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:21:46 -0400
X-AuditID: cbfee68e-b7f756d000004512-ee-5216b928b215
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        gregkh@linuxfoundation.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/3] extcon: Fix up 80 column coding style issues
Date: Fri, 23 Aug 2013 10:21:37 +0900
Message-id: <1377220899-4367-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkUFdjp1iQwd7XEhZTHz5hs/g35Qa7
	xfUvz1ktmhevZ7M42/SG3eLyrjlsFrcbV7A5sHtsWtXJ5rF/7hp2j5cTf7N59G1ZxejxeZNc
	AGsUl01Kak5mWWqRvl0CV8aBbw+YCt6VVexec5u1gfFOTBcjJ4eEgInE/cUdzBC2mMSFe+vZ
	uhi5OIQEljJKfNvfxwRTNHtlHytEYjqjxJXvW5khnEYmiY2nlrKAVLEJaEnsf3GDDcQWEVCQ
	2Nz7DKyDWeAao8TFJcvYQRLCAo4SC/r2AiU4OFgEVCVeXeMGCfMKuEjM/dbKCLFNTuLDnkfs
	IL0SAs3sEv+eXAC7j0VAQOLb5EMsIL0SArISmw5AnS0pcXDFDZYJjIILGBlWMYqmFiQXFCel
	FxnpFSfmFpfmpesl5+duYgQG7ul/z/p2MN48YH2IMRlo3ERmKdHkfGDg55XEGxqbGVmYmpga
	G5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUSj83rE55T4HF4idq3/0
	WrDeuDssflGq08ZdQWdrGL+WCJac9st81yQfNX2Sd1qB+OqLW6RKPhnO9D/odTXxwHvzawc3
	y9xdzm0cvnXngmnKxz/aHNOwfJiS+fWojMmvV62KDzJCf7I23j9Q8H75N70jxbp92xYVbTcM
	vfduZdq+8BWTNicckFViKc5INNRiLipOBAC8hWrXcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQV2NnWJBBr1reC2mPnzCZvFvyg12
	i+tfnrNaNC9ez2ZxtukNu8XlXXPYLG43rmBzYPfYtKqTzWP/3DXsHi8n/mbz6NuyitHj8ya5
	ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZB749YCp4V1axe81t1gbG
	OzFdjJwcEgImErNX9rFC2GISF+6tZ+ti5OIQEpjOKHHl+1ZmCKeRSWLjqaUsIFVsAloS+1/c
	YAOxRQQUJDb3PmMFKWIWuMYocXHJMnaQhLCAo8SCvr1ACQ4OFgFViVfXuEHCvAIuEnO/tTJC
	bJOT+LDnEfsERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj4pn0DsZVDRaHGAU4
	GJV4eCc4iwUJsSaWFVfmHmKU4GBWEuG1WQUU4k1JrKxKLcqPLyrNSS0+xJgMtHwis5Rocj4w
	ZvNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgdHSYPIKzcSm
	wzbR6tsfzvR48DlB92bg56+RZ6J+nF2s1F/ElbRki6AZ48tP2px8XTF8B+XS8yao8H16Xut9
	Ua9biuXutue5P881z18oUrymWHeliq5nxOwwq41lfSw3RY9HMm4I6LsdFX1hi7R8+5776fHi
	Ph/u3LSZMPNSfp5AuGzGkun5/EosxRmJhlrMRcWJABpwYDfPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix 80 column coding sytle issues by using checkpatch script.

Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-arizona.c  |  25 +++++---
 drivers/extcon/extcon-class.c    |   6 +-
 drivers/extcon/extcon-max77693.c | 129 +++++++++++++++++++++------------------
 drivers/extcon/extcon-max8997.c  |   6 +-
 4 files changed, 94 insertions(+), 72 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 2064eac..08c4590 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -738,8 +738,8 @@ err:
 static void arizona_micd_timeout_work(struct work_struct *work)
 {
 	struct arizona_extcon_info *info = container_of(work,
-							struct arizona_extcon_info,
-							micd_timeout_work.work);
+						struct arizona_extcon_info,
+						micd_timeout_work.work);
 
 	mutex_lock(&info->lock);
 
@@ -756,8 +756,8 @@ static void arizona_micd_timeout_work(struct work_struct *work)
 static void arizona_micd_detect(struct work_struct *work)
 {
 	struct arizona_extcon_info *info = container_of(work,
-							struct arizona_extcon_info,
-							micd_detect_work.work);
+						struct arizona_extcon_info,
+						micd_detect_work.work);
 	struct arizona *arizona = info->arizona;
 	unsigned int val = 0, lvl;
 	int ret, i, key;
@@ -769,7 +769,8 @@ static void arizona_micd_detect(struct work_struct *work)
 	for (i = 0; i < 10 && !(val & 0x7fc); i++) {
 		ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 		if (ret != 0) {
-			dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
+			dev_err(arizona->dev,
+				"Failed to read MICDET: %d\n", ret);
 			mutex_unlock(&info->lock);
 			return;
 		}
@@ -777,7 +778,8 @@ static void arizona_micd_detect(struct work_struct *work)
 		dev_dbg(arizona->dev, "MICDET: %x\n", val);
 
 		if (!(val & ARIZONA_MICD_VALID)) {
-			dev_warn(arizona->dev, "Microphone detection state invalid\n");
+			dev_warn(arizona->dev,
+				 "Microphone detection state invalid\n");
 			mutex_unlock(&info->lock);
 			return;
 		}
@@ -925,8 +927,8 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 static void arizona_hpdet_work(struct work_struct *work)
 {
 	struct arizona_extcon_info *info = container_of(work,
-							struct arizona_extcon_info,
-							hpdet_work.work);
+						struct arizona_extcon_info,
+						hpdet_work.work);
 
 	mutex_lock(&info->lock);
 	arizona_start_hpdet_acc_id(info);
@@ -973,10 +975,13 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 					   &info->hpdet_work,
 					   msecs_to_jiffies(HPDET_DEBOUNCE));
 
-		if (cancelled_mic)
+		if (cancelled_mic) {
+			int micd_timeout = info->micd_timeout;
+
 			queue_delayed_work(system_power_efficient_wq,
 					   &info->micd_timeout_work,
-					   msecs_to_jiffies(info->micd_timeout));
+					   msecs_to_jiffies(micd_timeout));
+		}
 
 		goto out;
 	}
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 1446152..7704a3d 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -450,7 +450,8 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 		if (!obj->edev)
 			return -ENODEV;
 
-		obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
+		obj->cable_index = extcon_find_cable_index(obj->edev,
+							  cable_name);
 		if (obj->cable_index < 0)
 			return obj->cable_index;
 
@@ -458,7 +459,8 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
 
 		obj->internal_nb.notifier_call = _call_per_cable;
 
-		return raw_notifier_chain_register(&obj->edev->nh, &obj->internal_nb);
+		return raw_notifier_chain_register(&obj->edev->nh,
+						  &obj->internal_nb);
 	} else {
 		struct class_dev_iter iter;
 		struct extcon_dev *extd;
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 4849ea1..15437d4 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -189,14 +189,17 @@ enum max77693_muic_acc_type {
 
 	/* The below accessories have same ADC value so ADCLow and
 	   ADC1K bit is used to separate specific accessory */
-	MAX77693_MUIC_GND_USB_OTG = 0x100,	/* ADC:0x0, VBVolot:0, ADCLow:0, ADC1K:0 */
-	MAX77693_MUIC_GND_USB_OTG_VB = 0x104,	/* ADC:0x0, VBVolot:1, ADCLow:0, ADC1K:0 */
-	MAX77693_MUIC_GND_AV_CABLE_LOAD = 0x102,/* ADC:0x0, VBVolot:0, ADCLow:1, ADC1K:0 */
-	MAX77693_MUIC_GND_MHL = 0x103,		/* ADC:0x0, VBVolot:0, ADCLow:1, ADC1K:1 */
-	MAX77693_MUIC_GND_MHL_VB = 0x107,	/* ADC:0x0, VBVolot:1, ADCLow:1, ADC1K:1 */
+						/* ADC|VBVolot|ADCLow|ADC1K| */
+	MAX77693_MUIC_GND_USB_OTG = 0x100,	/* 0x0|      0|     0|    0| */
+	MAX77693_MUIC_GND_USB_OTG_VB = 0x104,	/* 0x0|      1|     0|    0| */
+	MAX77693_MUIC_GND_AV_CABLE_LOAD = 0x102,/* 0x0|      0|     1|    0| */
+	MAX77693_MUIC_GND_MHL = 0x103,		/* 0x0|      0|     1|    1| */
+	MAX77693_MUIC_GND_MHL_VB = 0x107,	/* 0x0|      1|     1|    1| */
 };
 
-/* MAX77693 MUIC device support below list of accessories(external connector) */
+/*
+ * MAX77693 MUIC device support below list of accessories(external connector)
+ */
 enum {
 	EXTCON_CABLE_USB = 0,
 	EXTCON_CABLE_USB_HOST,
@@ -395,12 +398,12 @@ static int max77693_muic_get_cable_type(struct max77693_muic_info *info,
 			vbvolt >>= STATUS2_VBVOLT_SHIFT;
 
 			/**
-			 * [0x1][VBVolt][ADCLow][ADC1K]
-			 * [0x1    0	   0       0  ]	: USB_OTG
-			 * [0x1    1	   0       0  ]	: USB_OTG_VB
-			 * [0x1    0       1       0  ] : Audio Video Cable with load
-			 * [0x1    0       1       1  ] : MHL without charging connector
-			 * [0x1    1       1       1  ] : MHL with charging connector
+			 * [0x1|VBVolt|ADCLow|ADC1K]
+			 * [0x1|     0|     0|    0] USB_OTG
+			 * [0x1|     1|     0|    0] USB_OTG_VB
+			 * [0x1|     0|     1|    0] Audio Video cable with load
+			 * [0x1|     0|     1|    1] MHL without charging cable
+			 * [0x1|     1|     1|    1] MHL with charging cable
 			 */
 			cable_type = ((0x1 << 8)
 					| (vbvolt << 2)
@@ -723,11 +726,11 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 		if (ret < 0)
 			return ret;
 		break;
-	case MAX77693_MUIC_ADC_REMOTE_S3_BUTTON:	/* DOCK_KEY_PREV */
-	case MAX77693_MUIC_ADC_REMOTE_S7_BUTTON:	/* DOCK_KEY_NEXT */
-	case MAX77693_MUIC_ADC_REMOTE_S9_BUTTON:	/* DOCK_VOL_DOWN */
-	case MAX77693_MUIC_ADC_REMOTE_S10_BUTTON:	/* DOCK_VOL_UP */
-	case MAX77693_MUIC_ADC_REMOTE_S12_BUTTON:	/* DOCK_KEY_PLAY_PAUSE */
+	case MAX77693_MUIC_ADC_REMOTE_S3_BUTTON:      /* DOCK_KEY_PREV */
+	case MAX77693_MUIC_ADC_REMOTE_S7_BUTTON:      /* DOCK_KEY_NEXT */
+	case MAX77693_MUIC_ADC_REMOTE_S9_BUTTON:      /* DOCK_VOL_DOWN */
+	case MAX77693_MUIC_ADC_REMOTE_S10_BUTTON:     /* DOCK_VOL_UP */
+	case MAX77693_MUIC_ADC_REMOTE_S12_BUTTON:     /* DOCK_KEY_PLAY_PAUSE */
 		/*
 		 * Button of DOCK device
 		 * - the Prev/Next/Volume Up/Volume Down/Play-Pause button
@@ -815,19 +818,21 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 		case MAX77693_MUIC_GND_MHL_VB:
 			/*
 			 * MHL cable with MHL_TA(USB/TA) cable
-			 * - MHL cable include two port(HDMI line and separate micro-
-			 * usb port. When the target connect MHL cable, extcon driver
-			 * check whether MHL_TA(USB/TA) cable is connected. If MHL_TA
-			 * cable is connected, extcon driver notify state to notifiee
-			 * for charging battery.
+			 * - MHL cable include two port(HDMI line and separate
+			 * micro-usb port. When the target connect MHL cable,
+			 * extcon driver check whether MHL_TA(USB/TA) cable is
+			 * connected. If MHL_TA cable is connected, extcon
+			 * driver notify state to notifiee for charging battery.
 			 *
 			 * Features of 'MHL_TA(USB/TA) with MHL cable'
 			 * - Support MHL
-			 * - Support charging through micro-usb port without data connection
+			 * - Support charging through micro-usb port without
+			 *   data connection
 			 */
 			extcon_set_cable_state(info->edev, "MHL_TA", attached);
 			if (!cable_attached)
-				extcon_set_cable_state(info->edev, "MHL", cable_attached);
+				extcon_set_cable_state(info->edev,
+						      "MHL", cable_attached);
 			break;
 		}
 
@@ -839,47 +844,51 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 		case MAX77693_MUIC_ADC_AV_CABLE_NOLOAD:		/* Dock-Audio */
 			/*
 			 * Dock-Audio device with USB/TA cable
-			 * - Dock device include two port(Dock-Audio and micro-usb
-			 * port). When the target connect Dock-Audio device, extcon
-			 * driver check whether USB/TA cable is connected. If USB/TA
-			 * cable is connected, extcon driver notify state to notifiee
-			 * for charging battery.
+			 * - Dock device include two port(Dock-Audio and micro-
+			 * usb port). When the target connect Dock-Audio device,
+			 * extcon driver check whether USB/TA cable is connected
+			 * or not. If USB/TA cable is connected, extcon driver
+			 * notify state to notifiee for charging battery.
 			 *
 			 * Features of 'USB/TA cable with Dock-Audio device'
 			 * - Support external output feature of audio.
-			 * - Support charging through micro-usb port without data
-			 *           connection.
+			 * - Support charging through micro-usb port without
+			 *   data connection.
 			 */
 			extcon_set_cable_state(info->edev, "USB", attached);
 
 			if (!cable_attached)
-				extcon_set_cable_state(info->edev, "Dock-Audio", cable_attached);
+				extcon_set_cable_state(info->edev, "Dock-Audio",
+						      cable_attached);
 			break;
 		case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
 			/*
 			 * Dock-Smart device with USB/TA cable
 			 * - Dock-Desk device include three type of cable which
 			 * are HDMI, USB for mouse/keyboard and micro-usb port
-			 * for USB/TA cable. Dock-Smart device need always exteranl
-			 * power supply(USB/TA cable through micro-usb cable). Dock-
-			 * Smart device support screen output of target to separate
-			 * monitor and mouse/keyboard for desktop mode.
+			 * for USB/TA cable. Dock-Smart device need always
+			 * exteranl power supply(USB/TA cable through micro-usb
+			 * cable). Dock-Smart device support screen output of
+			 * target to separate monitor and mouse/keyboard for
+			 * desktop mode.
 			 *
 			 * Features of 'USB/TA cable with Dock-Smart device'
 			 * - Support MHL
 			 * - Support external output feature of audio
-			 * - Support charging through micro-usb port without data
-			 *	     connection if TA cable is connected to target.
-			 * - Support charging and data connection through micro-usb port
-			 *           if USB cable is connected between target and host
-			 *	     device.
+			 * - Support charging through micro-usb port without
+			 *   data connection if TA cable is connected to target.
+			 * - Support charging and data connection through micro-
+			 *   usb port if USB cable is connected between target
+			 *   and host device
 			 * - Support OTG device (Mouse/Keyboard)
 			 */
-			ret = max77693_muic_set_path(info, info->path_usb, attached);
+			ret = max77693_muic_set_path(info, info->path_usb,
+						    attached);
 			if (ret < 0)
 				return ret;
 
-			extcon_set_cable_state(info->edev, "Dock-Smart", attached);
+			extcon_set_cable_state(info->edev, "Dock-Smart",
+					      attached);
 			extcon_set_cable_state(info->edev, "MHL", attached);
 
 			break;
@@ -889,25 +898,28 @@ static int max77693_muic_chg_handler(struct max77693_muic_info *info)
 		switch (chg_type) {
 		case MAX77693_CHARGER_TYPE_NONE:
 			/*
-			 * When MHL(with USB/TA cable) or Dock-Audio with USB/TA cable
-			 * is attached, muic device happen below two interrupt.
-			 * - 'MAX77693_MUIC_IRQ_INT1_ADC' for detecting MHL/Dock-Audio.
-			 * - 'MAX77693_MUIC_IRQ_INT2_CHGTYP' for detecting USB/TA cable
-			 *   connected to MHL or Dock-Audio.
-			 * Always, happen eariler MAX77693_MUIC_IRQ_INT1_ADC interrupt
-			 * than MAX77693_MUIC_IRQ_INT2_CHGTYP interrupt.
+			 * When MHL(with USB/TA cable) or Dock-Audio with USB/TA
+			 * cable is attached, muic device happen below two irq.
+			 * - 'MAX77693_MUIC_IRQ_INT1_ADC' for detecting
+			 *    MHL/Dock-Audio.
+			 * - 'MAX77693_MUIC_IRQ_INT2_CHGTYP' for detecting
+			 *    USB/TA cable connected to MHL or Dock-Audio.
+			 * Always, happen eariler MAX77693_MUIC_IRQ_INT1_ADC
+			 * irq than MAX77693_MUIC_IRQ_INT2_CHGTYP irq.
 			 *
-			 * If user attach MHL (with USB/TA cable and immediately detach
-			 * MHL with USB/TA cable before MAX77693_MUIC_IRQ_INT2_CHGTYP
-			 * interrupt is happened, USB/TA cable remain connected state to
-			 * target. But USB/TA cable isn't connected to target. The user
-			 * be face with unusual action. So, driver should check this
-			 * situation in spite of, that previous charger type is N/A.
+			 * If user attach MHL (with USB/TA cable and immediately
+			 * detach MHL with USB/TA cable before MAX77693_MUIC_IRQ
+			 * _INT2_CHGTYP irq is happened, USB/TA cable remain
+			 * connected state to target. But USB/TA cable isn't
+			 * connected to target. The user be face with unusual
+			 * action. So, driver should check this situation in
+			 * spite of, that previous charger type is N/A.
 			 */
 			break;
 		case MAX77693_CHARGER_TYPE_USB:
 			/* Only USB cable, PATH:AP_USB */
-			ret = max77693_muic_set_path(info, info->path_usb, attached);
+			ret = max77693_muic_set_path(info, info->path_usb,
+						    attached);
 			if (ret < 0)
 				return ret;
 
@@ -1214,7 +1226,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->muic_data) {
-		struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
+		struct max77693_muic_platform_data *muic_pdata
+						   = pdata->muic_data;
 
 		/*
 		 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index e55ec38..83e3a27 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -426,7 +426,8 @@ static int max8997_muic_adc_handler(struct max8997_muic_info *info)
 		break;
 	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_OFF:
 	case MAX8997_MUIC_ADC_FACTORY_MODE_USB_ON:
-		ret = max8997_muic_handle_usb(info, MAX8997_USB_DEVICE, attached);
+		ret = max8997_muic_handle_usb(info,
+					     MAX8997_USB_DEVICE, attached);
 		if (ret < 0)
 			return ret;
 		break;
@@ -504,7 +505,8 @@ static int max8997_muic_chg_handler(struct max8997_muic_info *info)
 		}
 		break;
 	case MAX8997_CHARGER_TYPE_DOWNSTREAM_PORT:
-		extcon_set_cable_state(info->edev, "Charge-downstream", attached);
+		extcon_set_cable_state(info->edev,
+				      "Charge-downstream", attached);
 		break;
 	case MAX8997_CHARGER_TYPE_DEDICATED_CHG:
 		extcon_set_cable_state(info->edev, "TA", attached);
-- 
1.8.0

