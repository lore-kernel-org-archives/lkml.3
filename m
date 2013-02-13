Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3BMJfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab3BMJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:13 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-a6-511b5e4da992
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/9] extcon: max77693: Remove unnecessary goto statement to
 improve readability
Date: Wed, 13 Feb 2013 18:35:08 +0900
Message-id: <1360748108-21875-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zTV3fOOlAg+9npS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvrlH2Qqum1fMfbCWpYFxoU4XIyeHhICJxL73G5khbDGJC/fW
	s3UxcnEICSxjlHjffY0dpmjj7b9MEIlFjBJ/tr5lhHAWMEms/3aBBaSKTUBLYv+LG2wgtoiA
	nMST23/AxjIL1EqcvnwXzBYWSJRYfOkbWD2LgKrEhvXXGUFsXgFXiav71rNBbJOT+LDnEdTm
	HWwSh9fyQNQLSHybfAiolwMoLiux6QDU1ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRkhISe1gXNlgcYhRgINRiYfXIUQqUIg1say4MvcQowQHs5IIr6O/dKAQb0pi
	ZVVqUX58UWlOavEhxmSg5ROZpUST84HhnlcSb2hsYGxoaGloZmppakCasJI4L+OpJwFCAumJ
	JanZqakFqUUwW5g4OKUaGDuULONfxZjOXp3zJXRf2l9LvdQ93OwhgTffJ0o1G5041df9XLgn
	0M9wMtvVv4pTj3ZNmnptq97f/3L8bfKrvjRyxl72uF86c6757HerZPUkN1T65hlJzNmmvW53
	SEFr9slbZULn53XFpk3aWPff3aH+21u7FW0arz44PVOcoilZIHH5NlNWmRJLcUaioRZzUXEi
	ABrCSB1tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgK5vnHSgwYFOXovLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsW/uUbaC6+YVcx+sZWlg
	XKjTxcjJISFgIrHx9l8mCFtM4sK99WxdjFwcQgKLGCX+bH3LCOEsYJJY/+0CC0gVm4CWxP4X
	N9hAbBEBOYknt/8wg9jMArUSpy/fBbOFBRIlFl/6BlbPIqAqsWH9dUYQm1fAVeLqvvVsENvk
	JD7secQ+gZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgkH0mtYNxZYPFIUYBDkYl
	Hl6HEKlAIdbEsuLK3EOMEhzMSiK8jv7SgUK8KYmVValF+fFFpTmpxYcYk4G2T2SWEk3OB8ZT
	Xkm8obGJmZGlkZmxibmxMWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpgNIhZs3XPbI11
	ai+fTeyvLLNsOKSem1jvN8f7PHtFc+ZuBcHajE1vv5uo1juETfqy6/Mu33Ot1l6ejy6uqC7q
	PHso/eDdiIsWh57UJMpequkTjJ6zQfL7T/H+0K2HMtZeULCpfHeIb+GCi9b9JWZ2SoeKJ315
	eb148mODrx/TLX0Oy3j5M8cEKbEUZyQaajEXFScCAOJmU7ydAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 77 ++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 3b1f238..b70e381 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -224,16 +224,17 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 					  MAX77693_MUIC_REG_CTRL3,
 					  time << CONTROL3_ADCDBSET_SHIFT,
 					  CONTROL3_ADCDBSET_MASK);
-		if (ret)
+		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
+			return -EAGAIN;
+		}
 		break;
 	default:
 		dev_err(info->dev, "invalid ADC debounce time\n");
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 };
 
 /*
@@ -261,7 +262,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		goto out;
+		return -EAGAIN;
 	}
 
 	if (attached)
@@ -274,14 +275,14 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
-		goto out;
+		return -EAGAIN;
 	}
 
 	dev_info(info->dev,
 		"CONTROL1 : 0x%02x, CONTROL2 : 0x%02x, state : %s\n",
 		ctrl1, ctrl2, attached ? "attached" : "detached");
-out:
-	return ret;
+
+	return 0;
 }
 
 /*
@@ -503,6 +504,10 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 		if (!attached)
 			extcon_set_cable_state(info->edev, "USB", false);
 		break;
+	default:
+		dev_err(info->dev, "failed to detect %s dock device\n",
+			attached ? "attached" : "detached");
+		return -EINVAL;
 	}
 
 	/* Dock-Car/Desk/Audio, PATH:AUDIO */
@@ -520,7 +525,6 @@ static int max77693_muic_dock_button_handler(struct max77693_muic_info *info,
 {
 	struct input_dev *dock = info->dock;
 	unsigned int code;
-	int ret = 0;
 
 	switch (button_type) {
 	case MAX77693_MUIC_ADC_REMOTE_S3_BUTTON-1
@@ -550,14 +554,12 @@ static int max77693_muic_dock_button_handler(struct max77693_muic_info *info,
 		dev_err(info->dev,
 			"failed to detect %s key (adc:0x%x)\n",
 			attached ? "pressed" : "released", button_type);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	input_event(dock, EV_KEY, code, attached);
 	input_sync(dock);
 
-out:
 	return 0;
 }
 
@@ -576,14 +578,14 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info)
 		/* USB_OTG, PATH: AP_USB */
 		ret = max77693_muic_set_path(info, CONTROL1_SW_USB, attached);
 		if (ret < 0)
-			goto out;
+			return ret;
 		extcon_set_cable_state(info->edev, "USB-Host", attached);
 		break;
 	case MAX77693_MUIC_GND_AV_CABLE_LOAD:
 		/* Audio Video Cable with load, PATH:AUDIO */
 		ret = max77693_muic_set_path(info, CONTROL1_SW_AUDIO, attached);
 		if (ret < 0)
-			goto out;
+			return ret;
 		extcon_set_cable_state(info->edev,
 				"Audio-video-load", attached);
 		break;
@@ -593,14 +595,12 @@ static int max77693_muic_adc_ground_handler(struct max77693_muic_info *info)
 		extcon_set_cable_state(info->edev, "MHL", attached);
 		break;
 	default:
-		dev_err(info->dev, "failed to detect %s accessory\n",
+		dev_err(info->dev, "failed to detect %s cable of gnd type\n",
 			attached ? "attached" : "detached");
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 static int max77693_muic_jig_handler(struct max77693_muic_info *info,
@@ -630,15 +630,19 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 		strcpy(cable_name, "JIG-UART-OFF");
 		path = CONTROL1_SW_UART;
 		break;
+	default:
+		dev_err(info->dev, "failed to detect %s jig cable\n",
+			attached ? "attached" : "detached");
+		return -EINVAL;
 	}
 
 	ret = max77693_muic_set_path(info, path, attached);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	extcon_set_cable_state(info->edev, cable_name, attached);
-out:
-	return ret;
+
+	return 0;
 }
 
 static int max77693_muic_adc_handler(struct max77693_muic_info *info)
@@ -668,7 +672,7 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 		/* JIG */
 		ret = max77693_muic_jig_handler(info, cable_type, attached);
 		if (ret < 0)
-			goto out;
+			return ret;
 		break;
 	case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
 	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
@@ -685,7 +689,7 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 		 */
 		ret = max77693_muic_dock_handler(info, cable_type, attached);
 		if (ret < 0)
-			goto out;
+			return ret;
 		break;
 	case MAX77693_MUIC_ADC_REMOTE_S3_BUTTON:	/* DOCK_KEY_PREV */
 	case MAX77693_MUIC_ADC_REMOTE_S7_BUTTON:	/* DOCK_KEY_NEXT */
@@ -710,7 +714,7 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 		ret = max77693_muic_dock_button_handler(info, button_type,
 							attached);
 		if (ret < 0)
-			goto out;
+			return ret;
 		break;
 	case MAX77693_MUIC_ADC_SEND_END_BUTTON:
 	case MAX77693_MUIC_ADC_REMOTE_S1_BUTTON:
@@ -738,17 +742,15 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 		dev_info(info->dev,
 			"accessory is %s but it isn't used (adc:0x%x)\n",
 			attached ? "attached" : "detached", cable_type);
-		goto out;
+		return -EAGAIN;
 	default:
 		dev_err(info->dev,
 			"failed to detect %s accessory (adc:0x%x)\n",
 			attached ? "attached" : "detached", cable_type);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 static int max77693_muic_chg_handler(struct max77693_muic_info *info)
@@ -959,7 +961,8 @@ static void max77693_muic_irq_work(struct work_struct *work)
 	default:
 		dev_err(info->dev, "muic interrupt: irq %d occurred\n",
 				irq_type);
-		break;
+		mutex_unlock(&info->mutex);
+		return;
 	}
 
 	if (ret < 0)
@@ -1007,21 +1010,27 @@ static int max77693_muic_detect_accessory(struct max77693_muic_info *info)
 					&attached);
 	if (attached && adc != MAX77693_MUIC_ADC_OPEN) {
 		ret = max77693_muic_adc_handler(info);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(info->dev, "Cannot detect accessory\n");
+			mutex_unlock(&info->mutex);
+			return ret;
+		}
 	}
 
 	chg_type = max77693_muic_get_cable_type(info, MAX77693_CABLE_GROUP_CHG,
 					&attached);
 	if (attached && chg_type != MAX77693_CHARGER_TYPE_NONE) {
 		ret = max77693_muic_chg_handler(info);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(info->dev, "Cannot detect charger accessory\n");
+			mutex_unlock(&info->mutex);
+			return ret;
+		}
 	}
 
 	mutex_unlock(&info->mutex);
 
-	return ret;
+	return 0;
 }
 
 static void max77693_muic_detect_cable_wq(struct work_struct *work)
-- 
1.8.0

