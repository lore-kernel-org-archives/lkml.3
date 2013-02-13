Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab3BMJf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3BMJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:19 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-f4-511b5e565aa5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/9] extcon: max8997: Remove duplicate code related to set H/W
 line path
Date: Wed, 13 Feb 2013 18:35:16 +0900
Message-id: <1360748116-21943-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zTd2wOOlAg/3f+S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzaMfWQu61Stm3/vG1sC4UqGLkZNDQsBE4vTBPywQtpjEhXvr
	2boYuTiEBJYxSpxbfYYZpqjtSAMTRGI6o8TrlT+hqhYwSVw7Np0VpIpNQEti/4sbbCC2iICp
	xKmn19lBbGaBWonTl++CTRIWiJJYuno3mM0ioCqx7NZ2sNW8Aq4Sy64fZ4XYJifxYc8jdgh7
	B5vElxWqEPUCEt8mHwKq5wCKy0psOgB1nKTEwRU3WCYwCi5gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERJSUjsYVzZYHGIU4GBU4uF1CJEKFGJNLCuuzD3EKMHBrCTC6+gvHSjEm5JY
	WZValB9fVJqTWnyIMRlo+URmKdHkfGC455XEGxobGBsaWhqamVqaGpAmrCTOy3jqSYCQQHpi
	SWp2ampBahHMFiYOTqkGRnvpN7kZIfunVS6uri2VddzyOeaJ5wPp6QKvb7tv80hVYTwWV8W+
	L3vr16m/xWWeiK5evUO2sJB3dpfw3DznoxZvX5uf/MrgbeRe1PTLK3ayyb++V9rLPhhMWfuE
	6eeDSfslt3AKSxtqvH7HmspVmrH5+cSv0QfsJ4g4bhIM+J/pUs367InMfCWW4oxEQy3mouJE
	AFeGywFtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoG5YnHSgQcsURovLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfPoR9aCbvWK2fe+sTUw
	rlToYuTkkBAwkWg70sAEYYtJXLi3nq2LkYtDSGA6o8TrlT+hnAVMEteOTWcFqWIT0JLY/+IG
	G4gtImAqcerpdXYQm1mgVuL05bvMILawQJTE0tW7wWwWAVWJZbe2s4DYvAKuEsuuH2eF2CYn
	8WHPI/YJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH7DOpHYwrGywOMQpwMCrx
	8DqESAUKsSaWFVfmHmKU4GBWEuF19JcOFOJNSaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+MJ7y
	SuINjU3MjCyNzIxNzI2NSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwenVAPjac/rEnd+LGdd
	p/6JqSK+Zj17tP3EeTPqz4YH/Vj6896T5gsb2lXuv/IJuOzsJ5WpV+50oeuW8PLb8qsy/gZ5
	RM06yrr15UaZBhf//tLVui9aTsocnrajO+jxthOqW9NvcrppSXTaVLdzvor9e3yDduPLaWIi
	jSfsji/Md558/BXf8ue8m7t/K7EUZyQaajEXFScCAPthLLKdAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c     | 62 ++++++++++++++++++++++++++++++-------
 include/linux/mfd/max8997-private.h | 19 +++++++++++-
 2 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 0fb1d48..8739b50 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -94,16 +94,61 @@ static const char *max8997_extcon_cable[] = {
 	NULL,
 };
 
+/*
+ * max8997_muic_set_path - Set hardware line according to attached cable
+ * @info: the instance including private data of max8997 MUIC
+ * @value: the path according to attached cable
+ * @attached: the state of cable (true:attached, false:detached)
+ *
+ * The max8997 MUIC device share outside H/W line among a varity of cables,
+ * so this function set internal path of H/W line according to the type of
+ * attached cable.
+ */
+static int max8997_muic_set_path(struct max8997_muic_info *info,
+		u8 val, bool attached)
+{
+	int ret = 0;
+	u8 ctrl1, ctrl2 = 0;
+
+	if (attached)
+		ctrl1 = val;
+	else
+		ctrl1 = CONTROL1_SW_OPEN;
+
+	ret = max8997_update_reg(info->muic,
+			MAX8997_MUIC_REG_CONTROL1, ctrl1, COMP_SW_MASK);
+	if (ret < 0) {
+		dev_err(info->dev, "failed to update MUIC register\n");
+		return -EAGAIN;
+	}
+
+	if (attached)
+		ctrl2 |= CONTROL2_CPEN_MASK;	/* LowPwr=0, CPEn=1 */
+	else
+		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
+
+	ret = max8997_update_reg(info->muic,
+			MAX8997_MUIC_REG_CONTROL2, ctrl2,
+			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
+	if (ret < 0) {
+		dev_err(info->dev, "failed to update MUIC register\n");
+		return -EAGAIN;
+	}
+
+	dev_info(info->dev,
+		"CONTROL1 : 0x%02x, CONTROL2 : 0x%02x, state : %s\n",
+		ctrl1, ctrl2, attached ? "attached" : "detached");
+
+	return 0;
+}
+
 static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 			enum max8997_muic_usb_type usb_type, bool attached)
 {
 	int ret = 0;
 
 	if (usb_type == MAX8997_USB_HOST) {
-		/* switch to USB */
-		ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? CONTROL1_SW_USB : CONTROL1_SW_OPEN,
-				CONTROL1_SW_MASK);
+		ret = max8997_muic_set_path(info, CONTROL1_SW_USB, attached);
 		if (ret) {
 			dev_err(info->dev, "failed to update muic register\n");
 			goto out;
@@ -131,10 +176,7 @@ static int max8997_muic_handle_dock(struct max8997_muic_info *info,
 {
 	int ret = 0;
 
-	/* switch to AUDIO */
-	ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? CONTROL1_SW_AUDIO : CONTROL1_SW_OPEN,
-				CONTROL1_SW_MASK);
+	ret = max8997_muic_set_path(info, CONTROL1_SW_AUDIO, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
 		goto out;
@@ -161,9 +203,7 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 	int ret = 0;
 
 	/* switch to UART */
-	ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? CONTROL1_SW_UART : CONTROL1_SW_OPEN,
-				CONTROL1_SW_MASK);
+	ret = max8997_muic_set_path(info, CONTROL1_SW_UART, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
 		goto out;
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index acf42e9..010173a 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -223,7 +223,7 @@ enum max8997_muic_reg {
 #define COMP2SW_SHIFT			3
 #define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
 #define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
-#define CONTROL1_SW_MASK		(COMP2SW_MASK | COMN1SW_MASK)
+#define COMP_SW_MASK		(COMP2SW_MASK | COMN1SW_MASK)
 
 #define CONTROL1_SW_USB			((1 << COMP2SW_SHIFT) \
 						| (1 << COMN1SW_SHIFT))
@@ -234,6 +234,23 @@ enum max8997_muic_reg {
 #define CONTROL1_SW_OPEN		((0 << COMP2SW_SHIFT) \
 						| (0 << COMN1SW_SHIFT))
 
+#define CONTROL2_LOWPWR_SHIFT		(0)
+#define CONTROL2_ADCEN_SHIFT		(1)
+#define CONTROL2_CPEN_SHIFT		(2)
+#define CONTROL2_SFOUTASRT_SHIFT	(3)
+#define CONTROL2_SFOUTORD_SHIFT		(4)
+#define CONTROL2_ACCDET_SHIFT		(5)
+#define CONTROL2_USBCPINT_SHIFT		(6)
+#define CONTROL2_RCPS_SHIFT		(7)
+#define CONTROL2_LOWPWR_MASK		(0x1 << CONTROL2_LOWPWR_SHIFT)
+#define CONTROL2_ADCEN_MASK		(0x1 << CONTROL2_ADCEN_SHIFT)
+#define CONTROL2_CPEN_MASK		(0x1 << CONTROL2_CPEN_SHIFT)
+#define CONTROL2_SFOUTASRT_MASK		(0x1 << CONTROL2_SFOUTASRT_SHIFT)
+#define CONTROL2_SFOUTORD_MASK		(0x1 << CONTROL2_SFOUTORD_SHIFT)
+#define CONTROL2_ACCDET_MASK		(0x1 << CONTROL2_ACCDET_SHIFT)
+#define CONTROL2_USBCPINT_MASK		(0x1 << CONTROL2_USBCPINT_SHIFT)
+#define CONTROL2_RCPS_MASK		(0x1 << CONTROL2_RCPS_SHIFT)
+
 #define	MAX8997_ADC_GROUND		0x00
 #define	MAX8997_ADC_MHL			0x01
 #define	MAX8997_ADC_JIG_USB_1		0x18
-- 
1.8.0

