Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHKJXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:23:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50674 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaHKJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:23:11 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-79-53e88b7de9fd
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/2] extcon: rt8973a: Add Richtek RT8973A extcon driver
Date: Mon, 11 Aug 2014 18:23:02 +0900
Message-id: <1407748983-15539-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407748983-15539-1-git-send-email-cw00.choi@samsung.com>
References: <1407748983-15539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkWLe2+0WwwaJL6hbXvzxntTjb9Ibd
	4vKuOWwWtxtXsFnMmPySzYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDK+fdnBVrCikani
	2Ay5BsbfNxi7GDk5JARMJCbuesIEYYtJXLi3nq2LkYtDSGApo8SbqTeBEuxgRRedIcLTGSUm
	PbnFDOE0MUlMaJwONohNQEti/4sbbCC2iICCxObeZ6wgNrNAucTKI/uAGjg4hAXcJX51G4OE
	WQRUJW5/fwbWyivgKrFndyszxA1yEh/2PGIHsTkF3CSm3T8FZgsB1by83M0KsldC4DubxMTG
	M0wQgwQkvk0+xAIyX0JAVmLTAag5khIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66
	XnJ+7iZGYMie/vesdwfj7QPWhxiTgcZNZJYSTc4HhnxeSbyhsZmRhamJqbGRuaUZacJK4rxJ
	D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTA2T53Wklr/b8/dIyGBFgkq8wuCTaUr1jhJ
	x+W9PzC/0d1vXmvYpSy/0g/TguqWefMavby8ZXbxVnlHD42qFPE7SQ6TM9QOnXgVfj4m0fnu
	42C/Z6Vzp6xvi1RL+Jhj515x7v7bNXPW75FQOPaETeb9tdzSTZZrfKu+NfkWBOouavy65P/n
	4O9KLMUZiYZazEXFiQCrXYrLbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e+xoG5t94tgg8ObJC2uf3nOanG26Q27
	xeVdc9gsbjeuYLOYMfklmwOrR9+WVYwenzfJBTBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmfPuyg61gRSNTxbEZcg2Mv28wdjGyc0gImEhcdO5i5ASyxCQu3FvP1sXI
	xSEkMJ1RYtKTW8wQThOTxITG6YwgVWwCWhL7X9xgA7FFBBQkNvc+YwWxmQXKJVYe2QfUwMEh
	LOAu8avbGCTMIqAqcfv7M7BWXgFXiT27W5khlslJfNjziB3E5hRwk5h2/xSYLQRU8/JyN+sE
	Rt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj4pn0DsZVDRaHGAU4GJV4eA9+eR4s
	xJpYVlyZe4hRgoNZSYT3p8WLYCHelMTKqtSi/Pii0pzU4kOMpkBXTWSWEk3OB0ZrXkm8obGJ
	mZGlkbmhhZGxuZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGxgmc+Y/3NCuGrQ0N8l3Jqx3S
	7Rn5xD5fIn7WxXfCxvMu+Lh8bfzVsNeQr6f4yZNJ+9Y/SdqUej3H/0ztA9bFKloaCWwHrFNO
	y1bOXPh6x0uhc17qfkwzfoXxTq6OE28S2S5/922wm7OVX4yt0g+GX6/VFIL+t61+pl7/f0LI
	RTUr7aXWWdYrlFiKMxINtZiLihMBBgVzEZ4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for Richtek RT8973A which is Micro USB Switch OVP
and i2c interface. The RT8973A is a USB port accessory detector and switch
that is optimized to protect low voltage system from abnormal high input
voltage (up to 28V) and supports high speed USB operation. Also, RT8973A
support 'auto-configuration' mode. If auto-configuration mode is enabled,
RT8973A would control internal h/w patch for USB D-/D+ switching.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/Kconfig          |  11 +
 drivers/extcon/Makefile         |   1 +
 drivers/extcon/extcon-rt8973a.c | 742 ++++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-rt8973a.h | 203 +++++++++++
 4 files changed, 957 insertions(+)
 create mode 100644 drivers/extcon/extcon-rt8973a.c
 create mode 100644 drivers/extcon/extcon-rt8973a.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6f2f472..4864212 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -70,6 +70,17 @@ config EXTCON_PALMAS
 	  Say Y here to enable support for USB peripheral and USB host
 	  detection by palmas usb.
 
+config EXTCON_RT8973A
+	tristate "RT8973A EXTCON support"
+	select IRQ_DOMAIN
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	help
+	  If you say yes here you get support for the MUIC device of
+	  Richtek RT8973A. The RT8973A is a USB port accessory detector
+	  and switch that is optimized to protect low voltage system
+	  from abnormal high input voltage (up to 28V).
+
 config EXTCON_SM5502
 	tristate "SM5502 EXTCON support"
 	select IRQ_DOMAIN
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index b38546e..0370b42 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_EXTCON_MAX14577)	+= extcon-max14577.o
 obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
+obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
 obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
diff --git a/drivers/extcon/extcon-rt8973a.c b/drivers/extcon/extcon-rt8973a.c
new file mode 100644
index 0000000..2224f68
--- /dev/null
+++ b/drivers/extcon/extcon-rt8973a.c
@@ -0,0 +1,742 @@
+/*
+ * extcon-rt8973a.c - Richtek RT8973A extcon drvier to support USB switches
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Author: Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/extcon.h>
+
+#include "extcon-rt8973a.h"
+
+#define	DELAY_MS_DEFAULT		20000	/* unit: millisecond */
+
+struct muic_irq {
+	unsigned int irq;
+	const char *name;
+	unsigned int virq;
+};
+
+struct reg_data {
+	u8 reg;
+	u8 mask;
+	u8 val;
+	bool invert;
+};
+
+struct rt8973a_muic_info {
+	struct device *dev;
+	struct extcon_dev *edev;
+
+	struct i2c_client *i2c;
+	struct regmap *regmap;
+
+	struct regmap_irq_chip_data *irq_data;
+	struct muic_irq *muic_irqs;
+	unsigned int num_muic_irqs;
+	int irq;
+	bool irq_attach;
+	bool irq_detach;
+	bool irq_ovp;
+	bool irq_otp;
+	struct work_struct irq_work;
+
+	struct reg_data *reg_data;
+	unsigned int num_reg_data;
+	bool auto_config;
+
+	struct mutex mutex;
+
+	/*
+	 * Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	struct delayed_work wq_detcable;
+};
+
+/* Default value of RT8973A register to bring up MUIC device. */
+static struct reg_data rt8973a_reg_data[] = {
+	{
+		.reg = RT8973A_REG_CONTROL1,
+		.mask = RT8973A_REG_CONTROL1_ADC_EN_MASK
+			| RT8973A_REG_CONTROL1_USB_CHD_EN_MASK
+			| RT8973A_REG_CONTROL1_CHGTYP_MASK
+			| RT8973A_REG_CONTROL1_SWITCH_OPEN_MASK
+			| RT8973A_REG_CONTROL1_AUTO_CONFIG_MASK
+			| RT8973A_REG_CONTROL1_INTM_MASK,
+		.val = RT8973A_REG_CONTROL1_ADC_EN_MASK
+			| RT8973A_REG_CONTROL1_USB_CHD_EN_MASK
+			| RT8973A_REG_CONTROL1_CHGTYP_MASK,
+		.invert = false,
+	},
+	{ /* sentinel */ }
+};
+
+/* List of detectable cables */
+enum {
+	EXTCON_CABLE_USB = 0,
+	EXTCON_CABLE_USB_HOST,
+	EXTCON_CABLE_TA,
+	EXTCON_CABLE_JIG_OFF_USB,
+	EXTCON_CABLE_JIG_ON_USB,
+	EXTCON_CABLE_JIG_OFF_UART,
+	EXTCON_CABLE_JIG_ON_UART,
+
+	EXTCON_CABLE_END,
+};
+
+static const char *rt8973a_extcon_cable[] = {
+	[EXTCON_CABLE_USB]		= "USB",
+	[EXTCON_CABLE_USB_HOST]		= "USB-Host",
+	[EXTCON_CABLE_TA]		= "TA",
+	[EXTCON_CABLE_JIG_OFF_USB]	= "JIG-USB-OFF",
+	[EXTCON_CABLE_JIG_ON_USB]	= "JIG-USB-ON",
+	[EXTCON_CABLE_JIG_OFF_UART]	= "JIG-UART-OFF",
+	[EXTCON_CABLE_JIG_ON_UART]	= "JIG-UART-ON",
+	NULL,
+};
+
+/* Define OVP (Over Voltage Protection), OTP (Over Temperature Protection) */
+enum rt8973a_event_type {
+	RT8973A_EVENT_ATTACH = 1,
+	RT8973A_EVENT_DETACH,
+	RT8973A_EVENT_OVP,
+	RT8973A_EVENT_OTP,
+};
+
+/* Define supported accessory type */
+enum rt8973a_muic_acc_type {
+	RT8973A_MUIC_ADC_OTG = 0x0,
+	RT8973A_MUIC_ADC_AUDIO_SEND_END_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S1_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S2_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S3_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S4_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S5_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S6_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S7_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S8_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S9_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S10_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S11_BUTTON,
+	RT8973A_MUIC_ADC_AUDIO_REMOTE_S12_BUTTON,
+	RT8973A_MUIC_ADC_RESERVED_ACC_1,
+	RT8973A_MUIC_ADC_RESERVED_ACC_2,
+	RT8973A_MUIC_ADC_RESERVED_ACC_3,
+	RT8973A_MUIC_ADC_RESERVED_ACC_4,
+	RT8973A_MUIC_ADC_RESERVED_ACC_5,
+	RT8973A_MUIC_ADC_AUDIO_TYPE2,
+	RT8973A_MUIC_ADC_PHONE_POWERED_DEV,
+	RT8973A_MUIC_ADC_UNKNOWN_ACC_1,
+	RT8973A_MUIC_ADC_UNKNOWN_ACC_2,
+	RT8973A_MUIC_ADC_TA,
+	RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_OFF_USB,
+	RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_ON_USB,
+	RT8973A_MUIC_ADC_UNKNOWN_ACC_3,
+	RT8973A_MUIC_ADC_UNKNOWN_ACC_4,
+	RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_OFF_UART,
+	RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_ON_UART,
+	RT8973A_MUIC_ADC_UNKNOWN_ACC_5,
+	RT8973A_MUIC_ADC_OPEN = 0x1f,
+
+	/* The below accessories has same ADC value (0x1f).
+	   So, Device type1 is used to separate specific accessory. */
+					/* |---------|--ADC| */
+					/* |    [7:5]|[4:0]| */
+	RT8973A_MUIC_ADC_USB = 0x3f,	/* |      001|11111| */
+};
+
+/* List of supported interrupt for RT8973A */
+static struct muic_irq rt8973a_muic_irqs[] = {
+	{ RT8973A_INT1_ATTACH,		"muic-attach" },
+	{ RT8973A_INT1_DETACH,		"muic-detach" },
+	{ RT8973A_INT1_CHGDET,		"muic-chgdet" },
+	{ RT8973A_INT1_DCD_T,		"muic-dcd-t" },
+	{ RT8973A_INT1_OVP,		"muic-ovp" },
+	{ RT8973A_INT1_CONNECT,		"muic-connect" },
+	{ RT8973A_INT1_ADC_CHG,		"muic-adc-chg" },
+	{ RT8973A_INT1_OTP,		"muic-otp" },
+	{ RT8973A_INT2_UVLO,		"muic-uvlo" },
+	{ RT8973A_INT2_POR,		"muic-por" },
+	{ RT8973A_INT2_OTP_FET,		"muic-otp-fet" },
+	{ RT8973A_INT2_OVP_FET,		"muic-ovp-fet" },
+	{ RT8973A_INT2_OCP_LATCH,	"muic-ocp-latch" },
+	{ RT8973A_INT2_OCP,		"muic-ocp" },
+	{ RT8973A_INT2_OVP_OCP,		"muic-ovp-ocp" },
+};
+
+/* Define interrupt list of RT8973A to register regmap_irq */
+static const struct regmap_irq rt8973a_irqs[] = {
+	/* INT1 interrupts */
+	{ .reg_offset = 0, .mask = RT8973A_INT1_ATTACH_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_DETACH_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_CHGDET_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_DCD_T_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_OVP_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_CONNECT_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_ADC_CHG_MASK, },
+	{ .reg_offset = 0, .mask = RT8973A_INT1_OTP_MASK, },
+
+	/* INT2 interrupts */
+	{ .reg_offset = 1, .mask = RT8973A_INT2_UVLOT_MASK,},
+	{ .reg_offset = 1, .mask = RT8973A_INT2_POR_MASK, },
+	{ .reg_offset = 1, .mask = RT8973A_INT2_OTP_FET_MASK, },
+	{ .reg_offset = 1, .mask = RT8973A_INT2_OVP_FET_MASK, },
+	{ .reg_offset = 1, .mask = RT8973A_INT2_OCP_LATCH_MASK, },
+	{ .reg_offset = 1, .mask = RT8973A_INT2_OCP_MASK, },
+	{ .reg_offset = 1, .mask = RT8973A_INT2_OVP_OCP_MASK, },
+};
+
+static const struct regmap_irq_chip rt8973a_muic_irq_chip = {
+	.name			= "rt8973a",
+	.status_base		= RT8973A_REG_INT1,
+	.mask_base		= RT8973A_REG_INTM1,
+	.mask_invert		= false,
+	.num_regs		= 2,
+	.irqs			= rt8973a_irqs,
+	.num_irqs		= ARRAY_SIZE(rt8973a_irqs),
+};
+
+/* Define regmap configuration of RT8973A for I2C communication  */
+static bool rt8973a_muic_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case RT8973A_REG_INTM1:
+	case RT8973A_REG_INTM2:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static const struct regmap_config rt8973a_muic_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.volatile_reg	= rt8973a_muic_volatile_reg,
+	.max_register	= RT8973A_REG_END,
+};
+
+/* Change DM_CON/DP_CON/VBUSIN switch according to cable type */
+static int rt8973a_muic_set_path(struct rt8973a_muic_info *info,
+				unsigned int con_sw, bool attached)
+{
+	int ret;
+
+	/*
+	 * Don't need to set h/w path according to cable type
+	 * if Auto-configuration mode of CONTROL1 register is true.
+	 */
+	if (info->auto_config)
+		return 0;
+
+	if (!attached) {
+		con_sw	= DM_DP_SWITCH_UART;
+	}
+
+	switch (con_sw) {
+	case DM_DP_SWITCH_OPEN:
+	case DM_DP_SWITCH_USB:
+	case DM_DP_SWITCH_UART:
+		ret = regmap_update_bits(info->regmap, RT8973A_REG_MANUAL_SW1,
+					RT8973A_REG_MANUAL_SW1_DP_MASK |
+					RT8973A_REG_MANUAL_SW1_DM_MASK,
+					con_sw);
+		if (ret < 0) {
+			dev_err(info->dev,
+				"cannot update DM_CON/DP_CON switch\n");
+			return ret;
+		}
+		break;
+	default:
+		dev_err(info->dev, "Unknown DM_CON/DP_CON switch type (%d)\n",
+				con_sw);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rt8973a_muic_get_cable_type(struct rt8973a_muic_info *info)
+{
+	unsigned int adc, dev1;
+	int ret, cable_type;
+
+	/* Read ADC value according to external cable or button */
+	ret = regmap_read(info->regmap, RT8973A_REG_ADC, &adc);
+	if (ret) {
+		dev_err(info->dev, "failed to read ADC register\n");
+		return ret;
+	}
+	cable_type = adc & RT8973A_REG_ADC_MASK;
+
+	/* Read Device 1 reigster to identify correct cable type */
+	ret = regmap_read(info->regmap, RT8973A_REG_DEV1, &dev1);
+	if (ret) {
+		dev_err(info->dev, "failed to read DEV1 register\n");
+		return ret;
+	}
+
+	switch (adc) {
+	case RT8973A_MUIC_ADC_OPEN:
+		if (dev1 & RT8973A_REG_DEV1_USB_MASK)
+			cable_type = RT8973A_MUIC_ADC_USB;
+		else if (dev1 & RT8973A_REG_DEV1_DCPORT_MASK)
+			cable_type = RT8973A_MUIC_ADC_TA;
+		else
+			cable_type = RT8973A_MUIC_ADC_OPEN;
+		break;
+	default:
+		break;
+	}
+
+	return cable_type;
+}
+
+static int rt8973a_muic_cable_handler(struct rt8973a_muic_info *info,
+					enum rt8973a_event_type event)
+{
+	static unsigned int prev_cable_type;
+	const char **cable_names = info->edev->supported_cable;
+	unsigned int con_sw = DM_DP_SWITCH_UART;
+	int ret, idx = 0, cable_type;
+	bool attached = false;
+
+	if (!cable_names)
+		return 0;
+
+	switch (event) {
+	case RT8973A_EVENT_ATTACH:
+		cable_type = rt8973a_muic_get_cable_type(info);
+		attached = true;
+		break;
+	case RT8973A_EVENT_DETACH:
+		cable_type = prev_cable_type;
+		attached = false;
+		break;
+	case RT8973A_EVENT_OVP:
+	case RT8973A_EVENT_OTP:
+		dev_warn(info->dev,
+			"happen Over %s issue. Need to disconnect all cables\n",
+			event == RT8973A_EVENT_OVP ? "Voltage" : "Temperature");
+		cable_type = prev_cable_type;
+		attached = false;
+		break;
+	default:
+		dev_err(info->dev,
+			"Cannot handle this event (event:%d)\n", event);
+		return -EINVAL;
+	}
+	prev_cable_type = cable_type;
+
+	switch (cable_type) {
+	case RT8973A_MUIC_ADC_OTG:
+		idx = EXTCON_CABLE_USB_HOST;
+		con_sw = DM_DP_SWITCH_USB;
+		break;
+	case RT8973A_MUIC_ADC_TA:
+		idx = EXTCON_CABLE_TA;
+		con_sw = DM_DP_SWITCH_OPEN;
+		break;
+	case RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_OFF_USB:
+		idx = EXTCON_CABLE_JIG_OFF_USB;
+		con_sw = DM_DP_SWITCH_UART;
+		break;
+	case RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_ON_USB:
+		idx = EXTCON_CABLE_JIG_ON_USB;
+		con_sw = DM_DP_SWITCH_UART;
+		break;
+	case RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_OFF_UART:
+		idx = EXTCON_CABLE_JIG_OFF_UART;
+		con_sw = DM_DP_SWITCH_UART;
+		break;
+	case RT8973A_MUIC_ADC_FACTORY_MODE_BOOT_ON_UART:
+		idx = EXTCON_CABLE_JIG_ON_UART;
+		con_sw = DM_DP_SWITCH_UART;
+		break;
+	case RT8973A_MUIC_ADC_USB:
+		idx = EXTCON_CABLE_USB;
+		con_sw = DM_DP_SWITCH_USB;
+		break;
+	case RT8973A_MUIC_ADC_OPEN:
+		return 0;
+	case RT8973A_MUIC_ADC_UNKNOWN_ACC_1:
+	case RT8973A_MUIC_ADC_UNKNOWN_ACC_2:
+	case RT8973A_MUIC_ADC_UNKNOWN_ACC_3:
+	case RT8973A_MUIC_ADC_UNKNOWN_ACC_4:
+	case RT8973A_MUIC_ADC_UNKNOWN_ACC_5:
+		dev_warn(info->dev,
+			"Unknown accessory type (adc:0x%x)\n", cable_type);
+		return 0;
+	case RT8973A_MUIC_ADC_AUDIO_SEND_END_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S1_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S2_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S3_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S4_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S5_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S6_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S7_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S8_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S9_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S10_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S11_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_REMOTE_S12_BUTTON:
+	case RT8973A_MUIC_ADC_AUDIO_TYPE2:
+		dev_warn(info->dev,
+			"Audio device/button type (adc:0x%x)\n", cable_type);
+		return 0;
+	case RT8973A_MUIC_ADC_RESERVED_ACC_1:
+	case RT8973A_MUIC_ADC_RESERVED_ACC_2:
+	case RT8973A_MUIC_ADC_RESERVED_ACC_3:
+	case RT8973A_MUIC_ADC_RESERVED_ACC_4:
+	case RT8973A_MUIC_ADC_RESERVED_ACC_5:
+	case RT8973A_MUIC_ADC_PHONE_POWERED_DEV:
+		return 0;
+	default:
+		dev_err(info->dev,
+			"Cannot handle this cable_type (adc:0x%x)\n",
+			cable_type);
+		return -EINVAL;
+	}
+
+	/* Change internal hardware path(DM_CON/DP_CON) */
+	ret = rt8973a_muic_set_path(info, con_sw, attached);
+	if (ret < 0)
+		return ret;
+
+	/* Change the state of external accessory */
+	extcon_set_cable_state(info->edev, cable_names[idx], attached);
+
+	return 0;
+}
+
+static void rt8973a_muic_irq_work(struct work_struct *work)
+{
+	struct rt8973a_muic_info *info = container_of(work,
+			struct rt8973a_muic_info, irq_work);
+	int ret = 0;
+
+	if (!info->edev)
+		return;
+
+	mutex_lock(&info->mutex);
+
+	/* Detect attached or detached cables */
+	if (info->irq_attach) {
+		ret = rt8973a_muic_cable_handler(info, RT8973A_EVENT_ATTACH);
+		info->irq_attach = false;
+	}
+
+	if (info->irq_detach) {
+		ret = rt8973a_muic_cable_handler(info, RT8973A_EVENT_DETACH);
+		info->irq_detach = false;
+	}
+
+	if (info->irq_ovp) {
+		ret = rt8973a_muic_cable_handler(info, RT8973A_EVENT_OVP);
+		info->irq_ovp = false;
+	}
+
+	if (info->irq_otp) {
+		ret = rt8973a_muic_cable_handler(info, RT8973A_EVENT_OTP);
+		info->irq_otp = false;
+	}
+
+	if (ret < 0)
+		dev_err(info->dev, "failed to handle MUIC interrupt\n");
+
+	mutex_unlock(&info->mutex);
+
+	return;
+}
+
+static irqreturn_t rt8973a_muic_irq_handler(int irq, void *data)
+{
+	struct rt8973a_muic_info *info = data;
+	int i, irq_type = -1;
+
+	for (i = 0; i < info->num_muic_irqs; i++)
+		if (irq == info->muic_irqs[i].virq)
+			irq_type = info->muic_irqs[i].irq;
+
+	switch (irq_type) {
+	case RT8973A_INT1_ATTACH:
+		info->irq_attach = true;
+		break;
+	case RT8973A_INT1_DETACH:
+		info->irq_detach = true;
+		break;
+	case RT8973A_INT1_OVP:
+		info->irq_ovp = true;
+		break;
+	case RT8973A_INT1_OTP:
+		info->irq_otp = true;
+		break;
+	case RT8973A_INT1_CHGDET:
+	case RT8973A_INT1_DCD_T:
+	case RT8973A_INT1_CONNECT:
+	case RT8973A_INT1_ADC_CHG:
+	case RT8973A_INT2_UVLO:
+	case RT8973A_INT2_POR:
+	case RT8973A_INT2_OTP_FET:
+	case RT8973A_INT2_OVP_FET:
+	case RT8973A_INT2_OCP_LATCH:
+	case RT8973A_INT2_OCP:
+	case RT8973A_INT2_OVP_OCP:
+	default:
+		dev_dbg(info->dev,
+			"Cannot handle this interrupt (%d)\n", irq_type);
+		break;
+	}
+
+	schedule_work(&info->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rt8973a_muic_detect_cable_wq(struct work_struct *work)
+{
+	struct rt8973a_muic_info *info = container_of(to_delayed_work(work),
+				struct rt8973a_muic_info, wq_detcable);
+	int ret;
+
+	/* Notify the state of connector cable or not  */
+	ret = rt8973a_muic_cable_handler(info, RT8973A_EVENT_ATTACH);
+	if (ret < 0)
+		dev_warn(info->dev, "failed to detect cable state\n");
+}
+
+static void rt8973a_init_dev_type(struct rt8973a_muic_info *info)
+{
+	unsigned int data, vendor_id, version_id;
+	int i, ret;
+
+	/* To test I2C, Print version_id and vendor_id of RT8973A */
+	ret = regmap_read(info->regmap, RT8973A_REG_DEVICE_ID, &data);
+	if (ret) {
+		dev_err(info->dev,
+			"failed to read DEVICE_ID register: %d\n", ret);
+		return;
+	}
+
+	vendor_id = ((data & RT8973A_REG_DEVICE_ID_VENDOR_MASK) >>
+				RT8973A_REG_DEVICE_ID_VENDOR_SHIFT);
+	version_id = ((data & RT8973A_REG_DEVICE_ID_VERSION_MASK) >>
+				RT8973A_REG_DEVICE_ID_VERSION_SHIFT);
+
+	dev_info(info->dev, "Device type: version: 0x%x, vendor: 0x%x\n",
+			    version_id, vendor_id);
+
+	/* Initiazle the register of RT8973A device to bring-up */
+	for (i = 0; i < info->num_reg_data; i++) {
+		u8 reg = info->reg_data[i].reg;
+		u8 mask = info->reg_data[i].mask;
+		u8 val = 0;
+
+		if (info->reg_data[i].invert)
+			val = ~info->reg_data[i].val;
+		else
+			val = info->reg_data[i].val;
+
+		regmap_update_bits(info->regmap, reg, mask, val);
+	}
+
+	/* Check whether RT8973A is auto swithcing mode or not */
+	ret = regmap_read(info->regmap, RT8973A_REG_CONTROL1, &data);
+	if (ret) {
+		dev_err(info->dev,
+			"failed to read CONTROL1 register: %d\n", ret);
+		return;
+	}
+
+	data &= RT8973A_REG_CONTROL1_AUTO_CONFIG_MASK;
+	if (data) {
+		info->auto_config = true;
+		dev_info(info->dev,
+			"Enable Auto-configuration for internal path\n");
+	}
+}
+
+static int rt8973a_muic_i2c_probe(struct i2c_client *i2c,
+				 const struct i2c_device_id *id)
+{
+	struct device_node *np = i2c->dev.of_node;
+	struct rt8973a_muic_info *info;
+	int i, ret, irq_flags;
+
+	if (!np)
+		return -EINVAL;
+
+	info = devm_kzalloc(&i2c->dev, sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(&i2c->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	i2c_set_clientdata(i2c, info);
+
+	info->dev = &i2c->dev;
+	info->i2c = i2c;
+	info->irq = i2c->irq;
+	info->muic_irqs = rt8973a_muic_irqs;
+	info->num_muic_irqs = ARRAY_SIZE(rt8973a_muic_irqs);
+	info->reg_data = rt8973a_reg_data;
+	info->num_reg_data = ARRAY_SIZE(rt8973a_reg_data);
+
+	mutex_init(&info->mutex);
+
+	INIT_WORK(&info->irq_work, rt8973a_muic_irq_work);
+
+	info->regmap = devm_regmap_init_i2c(i2c, &rt8973a_muic_regmap_config);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(info->dev, "failed to allocate register map: %d\n",
+				   ret);
+		return ret;
+	}
+
+	/* Support irq domain for RT8973A MUIC device */
+	irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT | IRQF_SHARED;
+	ret = regmap_add_irq_chip(info->regmap, info->irq, irq_flags, 0,
+				  &rt8973a_muic_irq_chip, &info->irq_data);
+	if (ret != 0) {
+		dev_err(info->dev, "failed to add irq_chip (irq:%d, err:%d)\n",
+				    info->irq, ret);
+		return ret;
+	}
+
+	for (i = 0; i < info->num_muic_irqs; i++) {
+		struct muic_irq *muic_irq = &info->muic_irqs[i];
+		unsigned int virq = 0;
+
+		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
+		if (virq <= 0)
+			return -EINVAL;
+		muic_irq->virq = virq;
+
+		ret = devm_request_threaded_irq(info->dev, virq, NULL,
+						rt8973a_muic_irq_handler,
+						IRQF_NO_SUSPEND,
+						muic_irq->name, info);
+		if (ret) {
+			dev_err(info->dev, "failed: irq request (IRQ: %d,"
+				" error :%d)\n", muic_irq->irq, ret);
+			return ret;
+		}
+	}
+
+	/* Allocate extcon device */
+	info->edev = devm_extcon_dev_allocate(info->dev, rt8973a_extcon_cable);
+	if (IS_ERR(info->edev)) {
+		dev_err(info->dev, "failed to allocate memory for extcon\n");
+		return -ENOMEM;
+	}
+	info->edev->name = np->name;
+
+	/* Register extcon device */
+	ret = devm_extcon_dev_register(info->dev, info->edev);
+	if (ret) {
+		dev_err(info->dev, "failed to register extcon device\n");
+		return ret;
+	}
+
+	/*
+	 * Detect accessory after completing the initialization of platform
+	 *
+	 * - Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	INIT_DELAYED_WORK(&info->wq_detcable, rt8973a_muic_detect_cable_wq);
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+			msecs_to_jiffies(DELAY_MS_DEFAULT));
+
+	/* Initialize RT8973A device and print vendor id and version id */
+	rt8973a_init_dev_type(info);
+
+	return 0;
+}
+
+static int rt8973a_muic_i2c_remove(struct i2c_client *i2c)
+{
+	struct rt8973a_muic_info *info = i2c_get_clientdata(i2c);
+
+	regmap_del_irq_chip(info->irq, info->irq_data);
+
+	return 0;
+}
+
+static struct of_device_id rt8973a_dt_match[] = {
+	{ .compatible = "richtek,rt8973a-muic" },
+	{ },
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int rt8973a_muic_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct rt8973a_muic_info *info = i2c_get_clientdata(i2c);
+
+	enable_irq_wake(info->irq);
+
+	return 0;
+}
+
+static int rt8973a_muic_resume(struct device *dev)
+{
+	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
+	struct rt8973a_muic_info *info = i2c_get_clientdata(i2c);
+
+	disable_irq_wake(info->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rt8973a_muic_pm_ops,
+			 rt8973a_muic_suspend, rt8973a_muic_resume);
+
+static const struct i2c_device_id rt8973a_i2c_id[] = {
+	{ "rt8973a", TYPE_RT8973A },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rt8973a_i2c_id);
+
+static struct i2c_driver rt8973a_muic_i2c_driver = {
+	.driver		= {
+		.name	= "rt8973a",
+		.owner	= THIS_MODULE,
+		.pm	= &rt8973a_muic_pm_ops,
+		.of_match_table = rt8973a_dt_match,
+	},
+	.probe	= rt8973a_muic_i2c_probe,
+	.remove	= rt8973a_muic_i2c_remove,
+	.id_table = rt8973a_i2c_id,
+};
+
+static int __init rt8973a_muic_i2c_init(void)
+{
+	return i2c_add_driver(&rt8973a_muic_i2c_driver);
+}
+subsys_initcall(rt8973a_muic_i2c_init);
+
+MODULE_DESCRIPTION("Richtek RT8973A Extcon driver");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/extcon/extcon-rt8973a.h b/drivers/extcon/extcon-rt8973a.h
new file mode 100644
index 0000000..ccc740a
--- /dev/null
+++ b/drivers/extcon/extcon-rt8973a.h
@@ -0,0 +1,203 @@
+/*
+ * rt8973a.h
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_EXTCON_RT8973A_H
+#define __LINUX_EXTCON_RT8973A_H
+
+enum rt8973a_types {
+	TYPE_RT8973A,
+};
+
+/* RT8973A registers */
+enum rt8973A_reg {
+	RT8973A_REG_DEVICE_ID = 0x1,
+	RT8973A_REG_CONTROL1,
+	RT8973A_REG_INT1,
+	RT8973A_REG_INT2,
+	RT8973A_REG_INTM1,
+	RT8973A_REG_INTM2,
+	RT8973A_REG_ADC,
+	RT8973A_REG_RSVD_1,
+	RT8973A_REG_RSVD_2,
+	RT8973A_REG_DEV1,
+	RT8973A_REG_DEV2,
+	RT8973A_REG_RSVD_3,
+	RT8973A_REG_RSVD_4,
+	RT8973A_REG_RSVD_5,
+	RT8973A_REG_RSVD_6,
+	RT8973A_REG_RSVD_7,
+	RT8973A_REG_RSVD_8,
+	RT8973A_REG_RSVD_9,
+	RT8973A_REG_MANUAL_SW1,
+	RT8973A_REG_MANUAL_SW2,
+	RT8973A_REG_RSVD_10,
+	RT8973A_REG_RSVD_11,
+	RT8973A_REG_RSVD_12,
+	RT8973A_REG_RSVD_13,
+	RT8973A_REG_RSVD_14,
+	RT8973A_REG_RSVD_15,
+	RT8973A_REG_RESET,
+
+	RT8973A_REG_END,
+};
+
+/* Define RT8973A MASK/SHIFT constant */
+#define RT8973A_REG_DEVICE_ID_VENDOR_SHIFT	0
+#define RT8973A_REG_DEVICE_ID_VERSION_SHIFT	3
+#define RT8973A_REG_DEVICE_ID_VENDOR_MASK	(0x7 << RT8973A_REG_DEVICE_ID_VENDOR_SHIFT)
+#define RT8973A_REG_DEVICE_ID_VERSION_MASK	(0x1f << RT8973A_REG_DEVICE_ID_VERSION_SHIFT)
+
+#define RT8973A_REG_CONTROL1_INTM_SHIFT	0
+#define RT8973A_REG_CONTROL1_AUTO_CONFIG_SHIFT	2
+#define RT8973A_REG_CONTROL1_I2C_RST_EN_SHIFT	3
+#define RT8973A_REG_CONTROL1_SWITCH_OPEN_SHIFT	4
+#define RT8973A_REG_CONTROL1_CHGTYP_SHIFT	5
+#define RT8973A_REG_CONTROL1_USB_CHD_EN_SHIFT	6
+#define RT8973A_REG_CONTROL1_ADC_EN_SHIFT	7
+#define RT8973A_REG_CONTROL1_INTM_MASK		(0x1 << RT8973A_REG_CONTROL1_INTM_SHIFT)
+#define RT8973A_REG_CONTROL1_AUTO_CONFIG_MASK	(0x1 << RT8973A_REG_CONTROL1_AUTO_CONFIG_SHIFT)
+#define RT8973A_REG_CONTROL1_I2C_RST_EN_MASK	(0x1 << RT8973A_REG_CONTROL1_I2C_RST_EN_SHIFT)
+#define RT8973A_REG_CONTROL1_SWITCH_OPEN_MASK	(0x1 << RT8973A_REG_CONTROL1_SWITCH_OPEN_SHIFT)
+#define RT8973A_REG_CONTROL1_CHGTYP_MASK	(0x1 << RT8973A_REG_CONTROL1_CHGTYP_SHIFT)
+#define RT8973A_REG_CONTROL1_USB_CHD_EN_MASK	(0x1 << RT8973A_REG_CONTROL1_USB_CHD_EN_SHIFT)
+#define RT8973A_REG_CONTROL1_ADC_EN_MASK	(0x1 << RT8973A_REG_CONTROL1_ADC_EN_SHIFT)
+
+#define RT9873A_REG_INTM1_ATTACH_SHIFT		0
+#define RT9873A_REG_INTM1_DETACH_SHIFT		1
+#define RT9873A_REG_INTM1_CHGDET_SHIFT		2
+#define RT9873A_REG_INTM1_DCD_T_SHIFT		3
+#define RT9873A_REG_INTM1_OVP_SHIFT		4
+#define RT9873A_REG_INTM1_CONNECT_SHIFT		5
+#define RT9873A_REG_INTM1_ADC_CHG_SHIFT		6
+#define RT9873A_REG_INTM1_OTP_SHIFT		7
+#define RT9873A_REG_INTM1_ATTACH_MASK		(0x1 << RT9873A_REG_INTM1_ATTACH_SHIFT)
+#define RT9873A_REG_INTM1_DETACH_MASK		(0x1 <<  RT9873A_REG_INTM1_DETACH_SHIFT)
+#define RT9873A_REG_INTM1_CHGDET_MASK		(0x1 <<  RT9873A_REG_INTM1_CHGDET_SHIFT)
+#define RT9873A_REG_INTM1_DCD_T_MASK		(0x1 <<  RT9873A_REG_INTM1_DCD_T_SHIFT)
+#define RT9873A_REG_INTM1_OVP_MASK		(0x1 <<  RT9873A_REG_INTM1_OVP_SHIFT)
+#define RT9873A_REG_INTM1_CONNECT_MASK		(0x1 <<  RT9873A_REG_INTM1_CONNECT_SHIFT)
+#define RT9873A_REG_INTM1_ADC_CHG_MASK		(0x1 <<  RT9873A_REG_INTM1_ADC_CHG_SHIFT)
+#define RT9873A_REG_INTM1_OTP_MASK		(0x1 <<  RT9873A_REG_INTM1_OTP_SHIFT)
+
+#define RT9873A_REG_INTM2_UVLO_SHIFT		1
+#define RT9873A_REG_INTM2_POR_SHIFT		2
+#define RT9873A_REG_INTM2_OTP_FET_SHIFT		3
+#define RT9873A_REG_INTM2_OVP_FET_SHIFT		4
+#define RT9873A_REG_INTM2_OCP_LATCH_SHIFT	5
+#define RT9873A_REG_INTM2_OCP_SHIFT		6
+#define RT9873A_REG_INTM2_OVP_OCP_SHIFT		7
+#define RT9873A_REG_INTM2_UVLO_MASK		(0x1 << RT9873A_REG_INTM2_UVLO_SHIFT)
+#define RT9873A_REG_INTM2_POR_MASK		(0x1 <<  RT9873A_REG_INTM2_POR_SHIFT)
+#define RT9873A_REG_INTM2_OTP_FET_MASK		(0x1 <<  RT9873A_REG_INTM2_OTP_FET_SHIFT)
+#define RT9873A_REG_INTM2_OVP_FET_MASK		(0x1 <<  RT9873A_REG_INTM2_OVP_FET_SHIFT)
+#define RT9873A_REG_INTM2_OCP_LATCH_MASK	(0x1 <<  RT9873A_REG_INTM2_OCP_LATCH_SHIFT)
+#define RT9873A_REG_INTM2_OCP_MASK		(0x1 <<  RT9873A_REG_INTM2_OCP_SHIFT)
+#define RT9873A_REG_INTM2_OVP_OCP_MASK		(0x1 <<  RT9873A_REG_INTM2_OVP_OCP_SHIFT)
+
+#define RT8973A_REG_ADC_SHIFT			0
+#define RT8973A_REG_ADC_MASK			(0x1f << RT8973A_REG_ADC_SHIFT)
+
+#define RT8973A_REG_DEV1_OTG_SHIFT		0
+#define RT8973A_REG_DEV1_SDP_SHIFT		2
+#define RT8973A_REG_DEV1_UART_SHIFT		3
+#define RT8973A_REG_DEV1_CAR_KIT_TYPE1_SHIFT	4
+#define RT8973A_REG_DEV1_CDPORT_SHIFT		5
+#define RT8973A_REG_DEV1_DCPORT_SHIFT		6
+#define RT8973A_REG_DEV1_OTG_MASK		(0x1 << RT8973A_REG_DEV1_OTG_SHIFT)
+#define RT8973A_REG_DEV1_SDP_MASK		(0x1 << RT8973A_REG_DEV1_SDP_SHIFT)
+#define RT8973A_REG_DEV1_UART_MASK		(0x1 << RT8973A_REG_DEV1_UART_SHIFT)
+#define RT8973A_REG_DEV1_CAR_KIT_TYPE1_MASK	(0x1 << RT8973A_REG_DEV1_CAR_KIT_TYPE1_SHIFT)
+#define RT8973A_REG_DEV1_CDPORT_MASK		(0x1 << RT8973A_REG_DEV1_CDPORT_SHIFT)
+#define RT8973A_REG_DEV1_DCPORT_MASK		(0x1 << RT8973A_REG_DEV1_DCPORT_SHIFT)
+#define RT8973A_REG_DEV1_USB_MASK		(RT8973A_REG_DEV1_SDP_MASK \
+						| RT8973A_REG_DEV1_CDPORT_MASK)
+
+#define RT8973A_REG_DEV2_JIG_USB_ON_SHIFT	0
+#define RT8973A_REG_DEV2_JIG_USB_OFF_SHIFT	1
+#define RT8973A_REG_DEV2_JIG_UART_ON_SHIFT	2
+#define RT8973A_REG_DEV2_JIG_UART_OFF_SHIFT	3
+#define RT8973A_REG_DEV2_JIG_USB_ON_MASK	(0x1 << RT8973A_REG_DEV2_JIG_USB_ON_SHIFT)
+#define RT8973A_REG_DEV2_JIG_USB_OFF_MASK	(0x1 << RT8973A_REG_DEV2_JIG_USB_OFF_SHIFT)
+#define RT8973A_REG_DEV2_JIG_UART_ON_MASK	(0x1 << RT8973A_REG_DEV2_JIG_UART_ON_SHIFT)
+#define RT8973A_REG_DEV2_JIG_UART_OFF_MASK	(0x1 << RT8973A_REG_DEV2_JIG_UART_OFF_SHIFT)
+
+#define RT8973A_REG_MANUAL_SW1_DP_SHIFT		2
+#define RT8973A_REG_MANUAL_SW1_DM_SHIFT		5
+#define RT8973A_REG_MANUAL_SW1_DP_MASK		(0x7 << RT8973A_REG_MANUAL_SW1_DP_SHIFT)
+#define RT8973A_REG_MANUAL_SW1_DM_MASK		(0x7 << RT8973A_REG_MANUAL_SW1_DM_SHIFT)
+#define DM_DP_CON_SWITCH_OPEN			0x0
+#define DM_DP_CON_SWITCH_USB			0x1
+#define DM_DP_CON_SWITCH_UART			0x3
+#define DM_DP_SWITCH_OPEN			((DM_DP_CON_SWITCH_OPEN <<RT8973A_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_OPEN <<RT8973A_REG_MANUAL_SW1_DM_SHIFT))
+#define DM_DP_SWITCH_USB			((DM_DP_CON_SWITCH_USB <<RT8973A_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_USB <<RT8973A_REG_MANUAL_SW1_DM_SHIFT))
+#define DM_DP_SWITCH_UART			((DM_DP_CON_SWITCH_UART <<RT8973A_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_UART <<RT8973A_REG_MANUAL_SW1_DM_SHIFT))
+
+#define RT8973A_REG_MANUAL_SW2_FET_ON_SHIFT	0
+#define RT8973A_REG_MANUAL_SW2_JIG_ON_SHIFT	2
+#define RT8973A_REG_MANUAL_SW2_BOOT_SW_SHIFT	3
+#define RT8973A_REG_MANUAL_SW2_FET_ON_MASK	(0x1 << RT8973A_REG_MANUAL_SW2_FET_ON_SHIFT)
+#define RT8973A_REG_MANUAL_SW2_JIG_ON_MASK	(0x1 << RT8973A_REG_MANUAL_SW2_JIG_ON_SHIFT)
+#define RT8973A_REG_MANUAL_SW2_BOOT_SW_MASK	(0x1 << RT8973A_REG_MANUAL_SW2_BOOT_SW_SHIFT)
+#define RT8973A_REG_MANUAL_SW2_FET_ON		0
+#define RT8973A_REG_MANUAL_SW2_FET_OFF		0x1
+#define RT8973A_REG_MANUAL_SW2_JIG_OFF		0
+#define RT8973A_REG_MANUAL_SW2_JIG_ON		0x1
+#define RT8973A_REG_MANUAL_SW2_BOOT_SW_ON	0
+#define RT8973A_REG_MANUAL_SW2_BOOT_SW_OFF	0x1
+
+#define RT8973A_REG_RESET_SHIFT			0
+#define RT8973A_REG_RESET_MASK			(0x1 << RT8973A_REG_RESET_SHIFT)
+#define RT8973A_REG_RESET			0x1
+
+/* RT8973A Interrupts */
+enum rt8973a_irq {
+	/* Interrupt1*/
+	RT8973A_INT1_ATTACH,
+	RT8973A_INT1_DETACH,
+	RT8973A_INT1_CHGDET,
+	RT8973A_INT1_DCD_T,
+	RT8973A_INT1_OVP,
+	RT8973A_INT1_CONNECT,
+	RT8973A_INT1_ADC_CHG,
+	RT8973A_INT1_OTP,
+
+	/* Interrupt2*/
+	RT8973A_INT2_UVLO,
+	RT8973A_INT2_POR,
+	RT8973A_INT2_OTP_FET,
+	RT8973A_INT2_OVP_FET,
+	RT8973A_INT2_OCP_LATCH,
+	RT8973A_INT2_OCP,
+	RT8973A_INT2_OVP_OCP,
+
+	RT8973A_NUM,
+};
+
+#define RT8973A_INT1_ATTACH_MASK		BIT(0)
+#define RT8973A_INT1_DETACH_MASK		BIT(1)
+#define RT8973A_INT1_CHGDET_MASK		BIT(2)
+#define RT8973A_INT1_DCD_T_MASK			BIT(3)
+#define RT8973A_INT1_OVP_MASK			BIT(4)
+#define RT8973A_INT1_CONNECT_MASK		BIT(5)
+#define RT8973A_INT1_ADC_CHG_MASK		BIT(6)
+#define RT8973A_INT1_OTP_MASK			BIT(7)
+#define RT8973A_INT2_UVLOT_MASK			BIT(0)
+#define RT8973A_INT2_POR_MASK			BIT(1)
+#define RT8973A_INT2_OTP_FET_MASK		BIT(2)
+#define RT8973A_INT2_OVP_FET_MASK		BIT(3)
+#define RT8973A_INT2_OCP_LATCH_MASK		BIT(4)
+#define RT8973A_INT2_OCP_MASK			BIT(5)
+#define RT8973A_INT2_OVP_OCP_MASK		BIT(6)
+
+#endif /*  __LINUX_EXTCON_RT8973A_H */
-- 
1.8.0

