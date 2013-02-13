Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab3BMJh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:37:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3BMJfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:15 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-c4-511b5e4f824a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/9] extcon: max8997: Move defined constant to header file
Date: Wed, 13 Feb 2013 18:35:10 +0900
Message-id: <1360748110-21909-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zTV3/OOlAg7vfNSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5HlvWQuOWVS8utrG0sC4QL+LkZNDQsBEYs/FaYwQtpjEhXvr
	2boYuTiEBJYxSkzoPs8CU3T+4DZ2iMR0Rond3+8wQzgLmCSm9+1hA6liE9CS2P/iBpgtImAq
	cerpdXYQm1mgVuL05bvMILawgJfE7JnXwGpYBFQlDl7/CBTn4OAVcJVY1KEKsUxO4sOeR2DL
	JAR2sEnsn7mWEaJeQOLb5EMsIPUSArISmw4wQ9RLShxccYNlAqPgAkaGVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxghISW1g3Flg8UhRgEORiUeXocQqUAh1sSy4srcQ4wSHMxKIryO/tKB
	QrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HhnteSbyhsYGxoaGloZmppakBacJK4ryMp54E
	CAmkJ5akZqemFqQWwWxh4uCUamBMWuB40se7+NLz/+yfciZyx7jdOPbug/2HDy8mTO/TaxJ0
	2GtremTeMa0rVsfvXzJIc9+sp3dgZ0bf5RyBn+uvhjzZLsYrc+P6H9lb3Hm3G3bNVuiWUvWu
	tuV9m3vljP6ti9snrxOJsfl8ZafNj7lvsy+cDg5la05Yc1tNmo3zQM33fTuKhP6dVGIpzkg0
	1GIuKk4EAPMvF+BtAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoK5/nHSgwesGGYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMXneW9aCYxYVr662sTQw
	LtDvYuTkkBAwkTh/cBs7hC0mceHeerYuRi4OIYHpjBK7v99hhnAWMElM79vDBlLFJqAlsf/F
	DTBbRMBU4tTT62DdzAK1Eqcv32UGsYUFvCRmz7wGVsMioCpx8PpHoDgHB6+Aq8SiDlWIZXIS
	H/Y8Yp/AyL2AkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDAPpPawbiyweIQowAHoxIP
	r0OIVKAQa2JZcWXuIUYJDmYlEV5Hf+lAId6UxMqq1KL8+KLSnNTiQ4zJQMsnMkuJJucDoymv
	JN7Q2MTMyNLIzNjE3NiYNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBKNTCa339fwJtqvsCT
	YfKOK2XHVnwUNZK7wb50yyIOxUWtV/O+T7N867k332Xf889anS2K15yDOmT+q2/49Hh2EmNj
	7gmTB3qSBo9v1+uc/KkaaG1+U07b52dCX9G3Y02y99ZUNQktmG0WLPj+0//Myxv/PnkYEbzb
	1WyJy7dlitOvrn/y+0iv1dwuJZbijERDLeai4kQArR6qTJwCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move defined constants to header file(max77693-private.h)
because of mask/unmask selectively interrupt of MUIC device according
to attribute of H/W board.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c     | 92 +++++++++++++------------------------
 include/linux/mfd/max8997-private.h | 49 ++++++++++++++++++++
 2 files changed, 80 insertions(+), 61 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index d16090d..0fb1d48 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -30,51 +30,6 @@
 
 #define	DEV_NAME			"max8997-muic"
 
-/* MAX8997-MUIC STATUS1 register */
-#define STATUS1_ADC_SHIFT		0
-#define STATUS1_ADCLOW_SHIFT		5
-#define STATUS1_ADCERR_SHIFT		6
-#define STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
-#define STATUS1_ADCLOW_MASK		(0x1 << STATUS1_ADCLOW_SHIFT)
-#define STATUS1_ADCERR_MASK		(0x1 << STATUS1_ADCERR_SHIFT)
-
-/* MAX8997-MUIC STATUS2 register */
-#define STATUS2_CHGTYP_SHIFT		0
-#define STATUS2_CHGDETRUN_SHIFT		3
-#define STATUS2_DCDTMR_SHIFT		4
-#define STATUS2_DBCHG_SHIFT		5
-#define STATUS2_VBVOLT_SHIFT		6
-#define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
-#define STATUS2_CHGDETRUN_MASK		(0x1 << STATUS2_CHGDETRUN_SHIFT)
-#define STATUS2_DCDTMR_MASK		(0x1 << STATUS2_DCDTMR_SHIFT)
-#define STATUS2_DBCHG_MASK		(0x1 << STATUS2_DBCHG_SHIFT)
-#define STATUS2_VBVOLT_MASK		(0x1 << STATUS2_VBVOLT_SHIFT)
-
-/* MAX8997-MUIC STATUS3 register */
-#define STATUS3_OVP_SHIFT		2
-#define STATUS3_OVP_MASK		(0x1 << STATUS3_OVP_SHIFT)
-
-/* MAX8997-MUIC CONTROL1 register */
-#define COMN1SW_SHIFT			0
-#define COMP2SW_SHIFT			3
-#define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
-#define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
-#define SW_MASK				(COMP2SW_MASK | COMN1SW_MASK)
-
-#define MAX8997_SW_USB		((1 << COMP2SW_SHIFT) | (1 << COMN1SW_SHIFT))
-#define MAX8997_SW_AUDIO	((2 << COMP2SW_SHIFT) | (2 << COMN1SW_SHIFT))
-#define MAX8997_SW_UART		((3 << COMP2SW_SHIFT) | (3 << COMN1SW_SHIFT))
-#define MAX8997_SW_OPEN		((0 << COMP2SW_SHIFT) | (0 << COMN1SW_SHIFT))
-
-#define	MAX8997_ADC_GROUND		0x00
-#define	MAX8997_ADC_MHL			0x01
-#define	MAX8997_ADC_JIG_USB_1		0x18
-#define	MAX8997_ADC_JIG_USB_2		0x19
-#define	MAX8997_ADC_DESKDOCK		0x1a
-#define	MAX8997_ADC_JIG_UART		0x1c
-#define	MAX8997_ADC_CARDOCK		0x1d
-#define	MAX8997_ADC_OPEN		0x1f
-
 struct max8997_muic_irq {
 	unsigned int irq;
 	const char *name;
@@ -109,17 +64,32 @@ struct max8997_muic_info {
 	struct extcon_dev	*edev;
 };
 
+enum {
+	EXTCON_CABLE_USB = 0,
+	EXTCON_CABLE_USB_HOST,
+	EXTCON_CABLE_TA,
+	EXTCON_CABLE_FAST_CHARGER,
+	EXTCON_CABLE_SLOW_CHARGER,
+	EXTCON_CABLE_CHARGE_DOWNSTREAM,
+	EXTCON_CABLE_MHL,
+	EXTCON_CABLE_DOCK_DESK,
+	EXTCON_CABLE_DOCK_CARD,
+	EXTCON_CABLE_JIG,
+
+	_EXTCON_CABLE_NUM,
+};
+
 static const char *max8997_extcon_cable[] = {
-	[0] = "USB",
-	[1] = "USB-Host",
-	[2] = "TA",
-	[3] = "Fast-charger",
-	[4] = "Slow-charger",
-	[5] = "Charge-downstream",
-	[6] = "MHL",
-	[7] = "Dock-desk",
-	[8] = "Dock-card",
-	[9] = "JIG",
+	[EXTCON_CABLE_USB]			= "USB",
+	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
+	[EXTCON_CABLE_TA]			= "TA",
+	[EXTCON_CABLE_FAST_CHARGER]		= "Fast-charger",
+	[EXTCON_CABLE_SLOW_CHARGER]		= "Slow-charger",
+	[EXTCON_CABLE_CHARGE_DOWNSTREAM]	= "Charge-downstream",
+	[EXTCON_CABLE_MHL]			= "MHL",
+	[EXTCON_CABLE_DOCK_DESK]		= "Dock-Desk",
+	[EXTCON_CABLE_DOCK_CARD]		= "Dock-Card",
+	[EXTCON_CABLE_JIG]			= "JIG",
 
 	NULL,
 };
@@ -132,8 +102,8 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 	if (usb_type == MAX8997_USB_HOST) {
 		/* switch to USB */
 		ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? MAX8997_SW_USB : MAX8997_SW_OPEN,
-				SW_MASK);
+				attached ? CONTROL1_SW_USB : CONTROL1_SW_OPEN,
+				CONTROL1_SW_MASK);
 		if (ret) {
 			dev_err(info->dev, "failed to update muic register\n");
 			goto out;
@@ -163,8 +133,8 @@ static int max8997_muic_handle_dock(struct max8997_muic_info *info,
 
 	/* switch to AUDIO */
 	ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? MAX8997_SW_AUDIO : MAX8997_SW_OPEN,
-				SW_MASK);
+				attached ? CONTROL1_SW_AUDIO : CONTROL1_SW_OPEN,
+				CONTROL1_SW_MASK);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
 		goto out;
@@ -192,8 +162,8 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 
 	/* switch to UART */
 	ret = max8997_update_reg(info->muic, MAX8997_MUIC_REG_CONTROL1,
-				attached ? MAX8997_SW_UART : MAX8997_SW_OPEN,
-				SW_MASK);
+				attached ? CONTROL1_SW_UART : CONTROL1_SW_OPEN,
+				CONTROL1_SW_MASK);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
 		goto out;
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 6ae21bf..acf42e9 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -194,6 +194,55 @@ enum max8997_muic_reg {
 	MAX8997_MUIC_REG_END		= 0xf,
 };
 
+/* MAX8997-MUIC STATUS1 register */
+#define STATUS1_ADC_SHIFT		0
+#define STATUS1_ADCLOW_SHIFT		5
+#define STATUS1_ADCERR_SHIFT		6
+#define STATUS1_ADC_MASK		(0x1f << STATUS1_ADC_SHIFT)
+#define STATUS1_ADCLOW_MASK		(0x1 << STATUS1_ADCLOW_SHIFT)
+#define STATUS1_ADCERR_MASK		(0x1 << STATUS1_ADCERR_SHIFT)
+
+/* MAX8997-MUIC STATUS2 register */
+#define STATUS2_CHGTYP_SHIFT		0
+#define STATUS2_CHGDETRUN_SHIFT		3
+#define STATUS2_DCDTMR_SHIFT		4
+#define STATUS2_DBCHG_SHIFT		5
+#define STATUS2_VBVOLT_SHIFT		6
+#define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
+#define STATUS2_CHGDETRUN_MASK		(0x1 << STATUS2_CHGDETRUN_SHIFT)
+#define STATUS2_DCDTMR_MASK		(0x1 << STATUS2_DCDTMR_SHIFT)
+#define STATUS2_DBCHG_MASK		(0x1 << STATUS2_DBCHG_SHIFT)
+#define STATUS2_VBVOLT_MASK		(0x1 << STATUS2_VBVOLT_SHIFT)
+
+/* MAX8997-MUIC STATUS3 register */
+#define STATUS3_OVP_SHIFT		2
+#define STATUS3_OVP_MASK		(0x1 << STATUS3_OVP_SHIFT)
+
+/* MAX8997-MUIC CONTROL1 register */
+#define COMN1SW_SHIFT			0
+#define COMP2SW_SHIFT			3
+#define COMN1SW_MASK			(0x7 << COMN1SW_SHIFT)
+#define COMP2SW_MASK			(0x7 << COMP2SW_SHIFT)
+#define CONTROL1_SW_MASK		(COMP2SW_MASK | COMN1SW_MASK)
+
+#define CONTROL1_SW_USB			((1 << COMP2SW_SHIFT) \
+						| (1 << COMN1SW_SHIFT))
+#define CONTROL1_SW_AUDIO		((2 << COMP2SW_SHIFT) \
+						| (2 << COMN1SW_SHIFT))
+#define CONTROL1_SW_UART		((3 << COMP2SW_SHIFT) \
+						| (3 << COMN1SW_SHIFT))
+#define CONTROL1_SW_OPEN		((0 << COMP2SW_SHIFT) \
+						| (0 << COMN1SW_SHIFT))
+
+#define	MAX8997_ADC_GROUND		0x00
+#define	MAX8997_ADC_MHL			0x01
+#define	MAX8997_ADC_JIG_USB_1		0x18
+#define	MAX8997_ADC_JIG_USB_2		0x19
+#define	MAX8997_ADC_DESKDOCK		0x1a
+#define	MAX8997_ADC_JIG_UART		0x1c
+#define	MAX8997_ADC_CARDOCK		0x1d
+#define	MAX8997_ADC_OPEN		0x1f
+
 enum max8997_haptic_reg {
 	MAX8997_HAPTIC_REG_GENERAL	= 0x00,
 	MAX8997_HAPTIC_REG_CONF1	= 0x01,
-- 
1.8.0

